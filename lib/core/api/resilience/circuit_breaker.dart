import 'dart:async';

import 'package:part_catalog/core/api/exceptions.dart';
import 'package:part_catalog/core/utils/context_logger.dart';

/// Состояния circuit breaker
enum CircuitBreakerState {
  closed,    // Нормальная работа
  open,      // Заблокированное состояние
  halfOpen,  // Тестовое состояние
}

/// Конфигурация circuit breaker
class CircuitBreakerConfig {
  final int failureThreshold;
  final Duration timeout;
  final Duration healthCheckInterval;
  final int successThreshold;
  final Set<Type> monitoredExceptions;
  final bool Function(Exception)? shouldTrip;

  const CircuitBreakerConfig({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.healthCheckInterval = const Duration(seconds: 30),
    this.successThreshold = 3,
    this.monitoredExceptions = const {
      NetworkException,
      TimeoutException,
      ServiceUnavailableException,
    },
    this.shouldTrip,
  });

  /// Предустановленные конфигурации
  static const CircuitBreakerConfig conservative = CircuitBreakerConfig(
    failureThreshold: 3,
    timeout: Duration(minutes: 2),
    healthCheckInterval: Duration(minutes: 1),
    successThreshold: 2,
  );

  static const CircuitBreakerConfig aggressive = CircuitBreakerConfig(
    failureThreshold: 10,
    timeout: Duration(seconds: 30),
    healthCheckInterval: Duration(seconds: 15),
    successThreshold: 5,
  );

  static const CircuitBreakerConfig networkOptimized = CircuitBreakerConfig(
    failureThreshold: 5,
    timeout: Duration(seconds: 45),
    healthCheckInterval: Duration(seconds: 20),
    successThreshold: 3,
    monitoredExceptions: {
      NetworkException,
      TimeoutException,
      ServiceUnavailableException,
      RateLimitException,
    },
  );
}

/// Статистика circuit breaker
class CircuitBreakerStats {
  int totalRequests = 0;
  int successfulRequests = 0;
  int failedRequests = 0;
  int circuitOpenCount = 0;
  DateTime? lastFailure;
  DateTime? lastSuccess;
  DateTime? stateChangedAt;

  double get failureRate => 
      totalRequests > 0 ? failedRequests / totalRequests : 0.0;

  double get successRate => 
      totalRequests > 0 ? successfulRequests / totalRequests : 0.0;

  void recordSuccess() {
    totalRequests++;
    successfulRequests++;
    lastSuccess = DateTime.now();
  }

  void recordFailure() {
    totalRequests++;
    failedRequests++;
    lastFailure = DateTime.now();
  }

  void recordStateChange() {
    stateChangedAt = DateTime.now();
  }

  void recordCircuitOpen() {
    circuitOpenCount++;
  }

  void reset() {
    totalRequests = 0;
    successfulRequests = 0;
    failedRequests = 0;
    circuitOpenCount = 0;
    lastFailure = null;
    lastSuccess = null;
    stateChangedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRequests': totalRequests,
      'successfulRequests': successfulRequests,
      'failedRequests': failedRequests,
      'circuitOpenCount': circuitOpenCount,
      'failureRate': failureRate,
      'successRate': successRate,
      'lastFailure': lastFailure?.toIso8601String(),
      'lastSuccess': lastSuccess?.toIso8601String(),
      'stateChangedAt': stateChangedAt?.toIso8601String(),
    };
  }
}

/// Circuit breaker для защиты от каскадных сбоев
class CircuitBreaker {
  final String name;
  final CircuitBreakerConfig config;
  final ContextLogger _logger;
  final CircuitBreakerStats _stats = CircuitBreakerStats();

  CircuitBreakerState _state = CircuitBreakerState.closed;
  DateTime? _lastFailureTime;
  int _consecutiveFailures = 0;
  int _consecutiveSuccesses = 0;
  Timer? _healthCheckTimer;

  CircuitBreaker({
    required this.name,
    required this.config,
    ContextLogger? logger,
  }) : _logger = logger ?? ContextLogger(context: 'CircuitBreaker[$name]') {
    _startHealthCheck();
  }

  CircuitBreakerState get state => _state;
  CircuitBreakerStats get stats => _stats;

  /// Выполняет операцию с защитой circuit breaker
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = operationName ?? 'operation';

    // Проверяем состояние circuit breaker
    if (_state == CircuitBreakerState.open) {
      _stats.recordCircuitOpen();
      
      _logger.w('Circuit breaker is OPEN, rejecting $opName', metadata: {
        'circuitBreakerName': name,
        'state': _state.name,
        'consecutiveFailures': _consecutiveFailures,
        ...?metadata,
      });

      throw ServiceUnavailableException(
        'Circuit breaker is open for $name',
        metadata: {
          'circuitBreakerName': name,
          'state': _state.name,
          'retryAfter': _getRetryAfter(),
        },
      );
    }

    try {
      _logger.d('Executing $opName through circuit breaker', metadata: {
        'circuitBreakerName': name,
        'state': _state.name,
        ...?metadata,
      });

      final result = await operation();
      await _onSuccess(opName, metadata);
      return result;
    } catch (e) {
      await _onFailure(e, opName, metadata);
      rethrow;
    }
  }

  /// Выполняет health check для circuit breaker в состоянии OPEN
  Future<bool> healthCheck(Future<void> Function() healthCheckOperation) async {
    if (_state != CircuitBreakerState.open) {
      return true;
    }

    try {
      _logger.d('Performing health check', metadata: {
        'circuitBreakerName': name,
      });

      await healthCheckOperation();
      
      _logger.i('Health check passed, transitioning to HALF_OPEN', metadata: {
        'circuitBreakerName': name,
      });

      await _transitionTo(CircuitBreakerState.halfOpen);
      return true;
    } catch (e) {
      _logger.w('Health check failed', 
        metadata: {
          'circuitBreakerName': name,
        },
        error: e,
      );
      return false;
    }
  }

  /// Принудительно переводит circuit breaker в указанное состояние
  Future<void> forceState(CircuitBreakerState newState, {String? reason}) async {
    _logger.i('Force transitioning circuit breaker to ${newState.name}', 
      metadata: {
        'circuitBreakerName': name,
        'fromState': _state.name,
        'toState': newState.name,
        'reason': reason ?? 'manual',
      });

    await _transitionTo(newState);
  }

  /// Сбрасывает статистику circuit breaker
  void reset() {
    _logger.i('Resetting circuit breaker', metadata: {
      'circuitBreakerName': name,
    });

    _stats.reset();
    _consecutiveFailures = 0;
    _consecutiveSuccesses = 0;
    _lastFailureTime = null;
    _transitionTo(CircuitBreakerState.closed);
  }

  /// Получает подробную информацию о состоянии circuit breaker
  Map<String, dynamic> getStatus() {
    return {
      'name': name,
      'state': _state.name,
      'consecutiveFailures': _consecutiveFailures,
      'consecutiveSuccesses': _consecutiveSuccesses,
      'lastFailureTime': _lastFailureTime?.toIso8601String(),
      'retryAfter': _getRetryAfter()?.inSeconds,
      'config': {
        'failureThreshold': config.failureThreshold,
        'timeout': config.timeout.inSeconds,
        'successThreshold': config.successThreshold,
      },
      'stats': _stats.toJson(),
    };
  }

  Future<void> _onSuccess(String operationName, Map<String, dynamic>? metadata) async {
    _stats.recordSuccess();
    _consecutiveFailures = 0;
    _consecutiveSuccesses++;

    if (_state == CircuitBreakerState.halfOpen) {
      if (_consecutiveSuccesses >= config.successThreshold) {
        _logger.i('Circuit breaker recovery successful, transitioning to CLOSED', 
          metadata: {
            'circuitBreakerName': name,
            'consecutiveSuccesses': _consecutiveSuccesses,
            'requiredSuccesses': config.successThreshold,
          });

        await _transitionTo(CircuitBreakerState.closed);
      }
    }
  }

  Future<void> _onFailure(
    dynamic exception, 
    String operationName, 
    Map<String, dynamic>? metadata,
  ) async {
    if (!_shouldTripCircuit(exception)) {
      return;
    }

    _stats.recordFailure();
    _consecutiveSuccesses = 0;
    _consecutiveFailures++;
    _lastFailureTime = DateTime.now();

    _logger.w('Operation failed in circuit breaker', 
      metadata: {
        'circuitBreakerName': name,
        'operationName': operationName,
        'consecutiveFailures': _consecutiveFailures,
        'failureThreshold': config.failureThreshold,
        'state': _state.name,
        ...?metadata,
      },
      error: exception,
    );

    if (_state == CircuitBreakerState.closed && 
        _consecutiveFailures >= config.failureThreshold) {
      
      _logger.e('Circuit breaker tripped, transitioning to OPEN', 
        metadata: {
          'circuitBreakerName': name,
          'consecutiveFailures': _consecutiveFailures,
          'failureThreshold': config.failureThreshold,
        });

      await _transitionTo(CircuitBreakerState.open);
    } else if (_state == CircuitBreakerState.halfOpen) {
      _logger.w('Circuit breaker test failed, transitioning back to OPEN', 
        metadata: {
          'circuitBreakerName': name,
        });

      await _transitionTo(CircuitBreakerState.open);
    }
  }

  bool _shouldTripCircuit(dynamic exception) {
    // Пользовательская логика имеет приоритет
    if (config.shouldTrip != null && exception is Exception) {
      return config.shouldTrip!(exception);
    }

    // Проверяем мониторируемые типы исключений
    return config.monitoredExceptions.contains(exception.runtimeType);
  }

  Future<void> _transitionTo(CircuitBreakerState newState) async {
    if (_state == newState) return;

    final oldState = _state;
    _state = newState;
    _stats.recordStateChange();

    _logger.i('Circuit breaker state changed', metadata: {
      'circuitBreakerName': name,
      'fromState': oldState.name,
      'toState': newState.name,
    });

    // Запускаем/останавливаем таймер health check
    if (newState == CircuitBreakerState.open) {
      _startHealthCheck();
    } else if (oldState == CircuitBreakerState.open) {
      _stopHealthCheck();
    }
  }

  void _startHealthCheck() {
    _stopHealthCheck(); // Останавливаем предыдущий таймер если есть

    _healthCheckTimer = Timer.periodic(config.healthCheckInterval, (timer) {
      if (_state == CircuitBreakerState.open && _canAttemptHealthCheck()) {
        // Health check будет выполнен при следующем вызове execute
        // Здесь мы только проверяем, можно ли перейти в HALF_OPEN
        if (_canTransitionToHalfOpen()) {
          _transitionTo(CircuitBreakerState.halfOpen);
        }
      }
    });
  }

  void _stopHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
  }

  bool _canAttemptHealthCheck() {
    if (_lastFailureTime == null) return true;
    return DateTime.now().difference(_lastFailureTime!) >= config.timeout;
  }

  bool _canTransitionToHalfOpen() {
    return _canAttemptHealthCheck();
  }

  Duration? _getRetryAfter() {
    if (_state != CircuitBreakerState.open || _lastFailureTime == null) {
      return null;
    }

    final elapsed = DateTime.now().difference(_lastFailureTime!);
    final remaining = config.timeout - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Освобождает ресурсы circuit breaker
  void dispose() {
    _stopHealthCheck();
  }
}

/// Менеджер circuit breaker для управления несколькими инстансами
class CircuitBreakerManager {
  final Map<String, CircuitBreaker> _circuitBreakers = {};
  final ContextLogger _logger;

  CircuitBreakerManager({
    ContextLogger? logger,
  }) : _logger = logger ?? ContextLogger(context: 'CircuitBreakerManager');

  /// Создает или получает circuit breaker с указанным именем
  CircuitBreaker getOrCreate(
    String name, {
    CircuitBreakerConfig? config,
  }) {
    return _circuitBreakers.putIfAbsent(name, () {
      _logger.d('Creating new circuit breaker', metadata: {
        'name': name,
      });

      return CircuitBreaker(
        name: name,
        config: config ?? const CircuitBreakerConfig(),
        logger: _logger,
      );
    });
  }

  /// Получает существующий circuit breaker
  CircuitBreaker? get(String name) {
    return _circuitBreakers[name];
  }

  /// Удаляет circuit breaker
  void remove(String name) {
    final circuitBreaker = _circuitBreakers.remove(name);
    circuitBreaker?.dispose();
    
    _logger.d('Removed circuit breaker', metadata: {
      'name': name,
    });
  }

  /// Получает статус всех circuit breaker
  Map<String, Map<String, dynamic>> getAllStatus() {
    final result = <String, Map<String, dynamic>>{};
    
    for (final entry in _circuitBreakers.entries) {
      result[entry.key] = entry.value.getStatus();
    }
    
    return result;
  }

  /// Сбрасывает все circuit breaker
  void resetAll() {
    _logger.i('Resetting all circuit breakers');
    
    for (final circuitBreaker in _circuitBreakers.values) {
      circuitBreaker.reset();
    }
  }

  /// Принудительно закрывает все circuit breaker
  Future<void> closeAll() async {
    _logger.i('Closing all circuit breakers');
    
    for (final circuitBreaker in _circuitBreakers.values) {
      await circuitBreaker.forceState(CircuitBreakerState.closed, reason: 'manager_close_all');
    }
  }

  /// Освобождает ресурсы всех circuit breaker
  void dispose() {
    for (final circuitBreaker in _circuitBreakers.values) {
      circuitBreaker.dispose();
    }
    _circuitBreakers.clear();
  }
}

/// Декоратор для автоматического применения circuit breaker к функциям
class CircuitBreakerDecorator<T> {
  final CircuitBreaker circuitBreaker;
  final String operationName;

  CircuitBreakerDecorator({
    required this.circuitBreaker,
    required this.operationName,
  });

  Future<T> call(
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    return circuitBreaker.execute(
      operation,
      operationName: operationName,
      metadata: metadata,
    );
  }
}

/// Миксин для добавления поддержки circuit breaker к классам
mixin CircuitBreakerSupport {
  CircuitBreakerManager? _circuitBreakerManager;

  CircuitBreakerManager get circuitBreakerManager {
    return _circuitBreakerManager ??= CircuitBreakerManager();
  }

  CircuitBreaker getCircuitBreaker(
    String name, {
    CircuitBreakerConfig? config,
  }) {
    return circuitBreakerManager.getOrCreate(name, config: config);
  }

  Future<T> executeWithCircuitBreaker<T>(
    String circuitBreakerName,
    Future<T> Function() operation, {
    CircuitBreakerConfig? config,
    String? operationName,
    Map<String, dynamic>? metadata,
  }) {
    final circuitBreaker = getCircuitBreaker(circuitBreakerName, config: config);
    return circuitBreaker.execute(
      operation,
      operationName: operationName,
      metadata: metadata,
    );
  }

  void disposeCircuitBreakers() {
    _circuitBreakerManager?.dispose();
    _circuitBreakerManager = null;
  }
}