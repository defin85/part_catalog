import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Провайдер для GlobalApiSettingsService ---
final globalApiSettingsServiceProvider =
    Provider<GlobalApiSettingsService>((ref) {
  return locator<GlobalApiSettingsService>();
});
// --- Конец провайдера ---

class GlobalApiSettingsService {
  final _logger = AppLoggers.core;
  static const String _apiModeKey = 'api_connection_mode';
  static const String _proxyUrlKey = 'proxy_url';
  static const String _useOptimizedSystemKey = 'use_optimized_system';
  static const String _enableCachingKey = 'enable_caching';
  static const String _enableMetricsKey = 'enable_metrics';
  static const String _circuitBreakerEnabledKey = 'circuit_breaker_enabled';
  static const String _retryAttemptsKey = 'retry_attempts';
  static const String _requestTimeoutKey = 'request_timeout';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<ApiConnectionMode> getApiConnectionMode() async {
    try {
      final prefs = await _prefs;
      final modeName = prefs.getString(_apiModeKey);
      return ApiConnectionModeExtension.fromName(modeName);
    } catch (e, s) {
      _logger.e('Error getting API connection mode', error: e, stackTrace: s);
      return ApiConnectionMode.direct; // Значение по умолчанию при ошибке
    }
  }

  Future<void> setApiConnectionMode(ApiConnectionMode mode) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_apiModeKey, mode.name);
      _logger.i('API connection mode set to: ${mode.name}');
    } catch (e, s) {
      _logger.e('Error setting API connection mode', error: e, stackTrace: s);
    }
  }

  Future<String?> getProxyUrl() async {
    try {
      final prefs = await _prefs;
      return prefs.getString(_proxyUrlKey);
    } catch (e, s) {
      _logger.e('Error getting proxy URL', error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> setProxyUrl(String? url) async {
    try {
      final prefs = await _prefs;
      if (url == null || url.isEmpty) {
        await prefs.remove(_proxyUrlKey);
        _logger.i('Proxy URL removed');
      } else {
        await prefs.setString(_proxyUrlKey, url);
        _logger.i('Proxy URL set to: $url');
      }
    } catch (e, s) {
      _logger.e('Error setting proxy URL', error: e, stackTrace: s);
    }
  }

  // === Настройки оптимизированной системы ===

  /// Использовать оптимизированную систему API
  Future<bool> getUseOptimizedSystem() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_useOptimizedSystemKey) ?? true; // По умолчанию включена
    } catch (e, s) {
      _logger.e('Error getting optimized system setting', error: e, stackTrace: s);
      return true;
    }
  }

  Future<void> setUseOptimizedSystem(bool enabled) async {
    try {
      final prefs = await _prefs;
      await prefs.setBool(_useOptimizedSystemKey, enabled);
      _logger.i('Optimized system ${enabled ? 'enabled' : 'disabled'}');
    } catch (e, s) {
      _logger.e('Error setting optimized system', error: e, stackTrace: s);
    }
  }

  /// Включить кэширование
  Future<bool> getEnableCaching() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_enableCachingKey) ?? true; // По умолчанию включено
    } catch (e, s) {
      _logger.e('Error getting caching setting', error: e, stackTrace: s);
      return true;
    }
  }

  Future<void> setEnableCaching(bool enabled) async {
    try {
      final prefs = await _prefs;
      await prefs.setBool(_enableCachingKey, enabled);
      _logger.i('Caching ${enabled ? 'enabled' : 'disabled'}');
    } catch (e, s) {
      _logger.e('Error setting caching', error: e, stackTrace: s);
    }
  }

  /// Включить сбор метрик
  Future<bool> getEnableMetrics() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_enableMetricsKey) ?? true; // По умолчанию включено
    } catch (e, s) {
      _logger.e('Error getting metrics setting', error: e, stackTrace: s);
      return true;
    }
  }

  Future<void> setEnableMetrics(bool enabled) async {
    try {
      final prefs = await _prefs;
      await prefs.setBool(_enableMetricsKey, enabled);
      _logger.i('Metrics ${enabled ? 'enabled' : 'disabled'}');
    } catch (e, s) {
      _logger.e('Error setting metrics', error: e, stackTrace: s);
    }
  }

  /// Включить Circuit Breaker
  Future<bool> getCircuitBreakerEnabled() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_circuitBreakerEnabledKey) ?? true; // По умолчанию включен
    } catch (e, s) {
      _logger.e('Error getting circuit breaker setting', error: e, stackTrace: s);
      return true;
    }
  }

  Future<void> setCircuitBreakerEnabled(bool enabled) async {
    try {
      final prefs = await _prefs;
      await prefs.setBool(_circuitBreakerEnabledKey, enabled);
      _logger.i('Circuit breaker ${enabled ? 'enabled' : 'disabled'}');
    } catch (e, s) {
      _logger.e('Error setting circuit breaker', error: e, stackTrace: s);
    }
  }

  /// Количество попыток повтора
  Future<int> getRetryAttempts() async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(_retryAttemptsKey) ?? 3; // По умолчанию 3 попытки
    } catch (e, s) {
      _logger.e('Error getting retry attempts', error: e, stackTrace: s);
      return 3;
    }
  }

  Future<void> setRetryAttempts(int attempts) async {
    try {
      final prefs = await _prefs;
      await prefs.setInt(_retryAttemptsKey, attempts);
      _logger.i('Retry attempts set to: $attempts');
    } catch (e, s) {
      _logger.e('Error setting retry attempts', error: e, stackTrace: s);
    }
  }

  /// Таймаут запроса в миллисекундах
  Future<int> getRequestTimeout() async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(_requestTimeoutKey) ?? 30000; // По умолчанию 30 секунд
    } catch (e, s) {
      _logger.e('Error getting request timeout', error: e, stackTrace: s);
      return 30000;
    }
  }

  Future<void> setRequestTimeout(int timeoutMs) async {
    try {
      final prefs = await _prefs;
      await prefs.setInt(_requestTimeoutKey, timeoutMs);
      _logger.i('Request timeout set to: ${timeoutMs}ms');
    } catch (e, s) {
      _logger.e('Error setting request timeout', error: e, stackTrace: s);
    }
  }

  /// Получить все настройки оптимизированной системы
  Future<Map<String, dynamic>> getOptimizedSystemSettings() async {
    return {
      'useOptimizedSystem': await getUseOptimizedSystem(),
      'enableCaching': await getEnableCaching(),
      'enableMetrics': await getEnableMetrics(),
      'circuitBreakerEnabled': await getCircuitBreakerEnabled(),
      'retryAttempts': await getRetryAttempts(),
      'requestTimeout': await getRequestTimeout(),
    };
  }

  /// Сбросить настройки оптимизированной системы к значениям по умолчанию
  Future<void> resetOptimizedSystemSettings() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_useOptimizedSystemKey);
      await prefs.remove(_enableCachingKey);
      await prefs.remove(_enableMetricsKey);
      await prefs.remove(_circuitBreakerEnabledKey);
      await prefs.remove(_retryAttemptsKey);
      await prefs.remove(_requestTimeoutKey);
      _logger.i('Optimized system settings reset to defaults');
    } catch (e, s) {
      _logger.e('Error resetting optimized system settings', error: e, stackTrace: s);
    }
  }
}
