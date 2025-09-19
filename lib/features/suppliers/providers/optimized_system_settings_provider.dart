import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/config/global_api_settings_service.dart';

part 'optimized_system_settings_provider.g.dart';

/// Модель настроек оптимизированной системы
class OptimizedSystemSettings {
  final bool useOptimizedSystem;
  final bool enableCaching;
  final bool enableMetrics;
  final bool circuitBreakerEnabled;
  final int retryAttempts;
  final int requestTimeout;

  const OptimizedSystemSettings({
    required this.useOptimizedSystem,
    required this.enableCaching,
    required this.enableMetrics,
    required this.circuitBreakerEnabled,
    required this.retryAttempts,
    required this.requestTimeout,
  });

  OptimizedSystemSettings copyWith({
    bool? useOptimizedSystem,
    bool? enableCaching,
    bool? enableMetrics,
    bool? circuitBreakerEnabled,
    int? retryAttempts,
    int? requestTimeout,
  }) {
    return OptimizedSystemSettings(
      useOptimizedSystem: useOptimizedSystem ?? this.useOptimizedSystem,
      enableCaching: enableCaching ?? this.enableCaching,
      enableMetrics: enableMetrics ?? this.enableMetrics,
      circuitBreakerEnabled:
          circuitBreakerEnabled ?? this.circuitBreakerEnabled,
      retryAttempts: retryAttempts ?? this.retryAttempts,
      requestTimeout: requestTimeout ?? this.requestTimeout,
    );
  }

  factory OptimizedSystemSettings.defaults() {
    return const OptimizedSystemSettings(
      useOptimizedSystem: true,
      enableCaching: true,
      enableMetrics: true,
      circuitBreakerEnabled: true,
      retryAttempts: 3,
      requestTimeout: 30000,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimizedSystemSettings &&
          runtimeType == other.runtimeType &&
          useOptimizedSystem == other.useOptimizedSystem &&
          enableCaching == other.enableCaching &&
          enableMetrics == other.enableMetrics &&
          circuitBreakerEnabled == other.circuitBreakerEnabled &&
          retryAttempts == other.retryAttempts &&
          requestTimeout == other.requestTimeout;

  @override
  int get hashCode =>
      useOptimizedSystem.hashCode ^
      enableCaching.hashCode ^
      enableMetrics.hashCode ^
      circuitBreakerEnabled.hashCode ^
      retryAttempts.hashCode ^
      requestTimeout.hashCode;
}

/// Провайдер для управления настройками оптимизированной системы
@riverpod
class OptimizedSystemSettingsNotifier
    extends _$OptimizedSystemSettingsNotifier {
  late final GlobalApiSettingsService _settingsService;

  @override
  Future<OptimizedSystemSettings> build() async {
    _settingsService = ref.watch(globalApiSettingsServiceProvider);
    return _loadSettings();
  }

  Future<OptimizedSystemSettings> _loadSettings() async {
    try {
      final settings = await _settingsService.getOptimizedSystemSettings();
      return OptimizedSystemSettings(
        useOptimizedSystem: settings['useOptimizedSystem'] as bool,
        enableCaching: settings['enableCaching'] as bool,
        enableMetrics: settings['enableMetrics'] as bool,
        circuitBreakerEnabled: settings['circuitBreakerEnabled'] as bool,
        retryAttempts: settings['retryAttempts'] as int,
        requestTimeout: settings['requestTimeout'] as int,
      );
    } catch (e) {
      // Возвращаем значения по умолчанию при ошибке
      return OptimizedSystemSettings.defaults();
    }
  }

  /// Обновить настройки оптимизированной системы
  Future<void> updateSettings(OptimizedSystemSettings newSettings) async {
    state = const AsyncValue.loading();

    try {
      // Сохраняем каждую настройку
      await _settingsService.setEnableCaching(newSettings.enableCaching);
      await _settingsService.setEnableMetrics(newSettings.enableMetrics);
      await _settingsService
          .setCircuitBreakerEnabled(newSettings.circuitBreakerEnabled);
      await _settingsService.setRetryAttempts(newSettings.retryAttempts);
      await _settingsService.setRequestTimeout(newSettings.requestTimeout);

      state = AsyncValue.data(newSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Включить/выключить оптимизированную систему
  Future<void> toggleOptimizedSystem(bool enabled) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(useOptimizedSystem: enabled));
  }

  /// Включить/выключить кэширование
  Future<void> toggleCaching(bool enabled) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(enableCaching: enabled));
  }

  /// Включить/выключить сбор метрик
  Future<void> toggleMetrics(bool enabled) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(enableMetrics: enabled));
  }

  /// Включить/выключить circuit breaker
  Future<void> toggleCircuitBreaker(bool enabled) async {
    final currentSettings = await future;
    await updateSettings(
        currentSettings.copyWith(circuitBreakerEnabled: enabled));
  }

  /// Установить количество попыток повтора
  Future<void> setRetryAttempts(int attempts) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(retryAttempts: attempts));
  }

  /// Установить таймаут запроса
  Future<void> setRequestTimeout(int timeoutMs) async {
    final currentSettings = await future;
    await updateSettings(currentSettings.copyWith(requestTimeout: timeoutMs));
  }

  /// Сбросить настройки к значениям по умолчанию
  Future<void> resetToDefaults() async {
    state = const AsyncValue.loading();

    try {
      await _settingsService.resetOptimizedSystemSettings();
      final defaultSettings = OptimizedSystemSettings.defaults();
      state = AsyncValue.data(defaultSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Экспорт настроек в Map
  Future<Map<String, dynamic>> exportSettings() async {
    final settings = await future;
    return {
      'useOptimizedSystem': settings.useOptimizedSystem,
      'enableCaching': settings.enableCaching,
      'enableMetrics': settings.enableMetrics,
      'circuitBreakerEnabled': settings.circuitBreakerEnabled,
      'retryAttempts': settings.retryAttempts,
      'requestTimeout': settings.requestTimeout,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Импорт настроек из Map
  Future<void> importSettings(Map<String, dynamic> settingsMap) async {
    try {
      final settings = OptimizedSystemSettings(
        useOptimizedSystem: settingsMap['useOptimizedSystem'] as bool? ?? true,
        enableCaching: settingsMap['enableCaching'] as bool? ?? true,
        enableMetrics: settingsMap['enableMetrics'] as bool? ?? true,
        circuitBreakerEnabled:
            settingsMap['circuitBreakerEnabled'] as bool? ?? true,
        retryAttempts: settingsMap['retryAttempts'] as int? ?? 3,
        requestTimeout: settingsMap['requestTimeout'] as int? ?? 30000,
      );

      await updateSettings(settings);
    } catch (e) {
      throw Exception('Ошибка импорта настроек: $e');
    }
  }
}

/// Краткие провайдеры для отдельных настроек
@riverpod
Future<bool> useOptimizedSystem(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.useOptimizedSystem;
}

@riverpod
Future<bool> enableCaching(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.enableCaching;
}

@riverpod
Future<bool> enableMetrics(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.enableMetrics;
}

@riverpod
Future<bool> circuitBreakerEnabled(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.circuitBreakerEnabled;
}

@riverpod
Future<int> retryAttempts(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.retryAttempts;
}

@riverpod
Future<int> requestTimeout(Ref ref) async {
  final settings =
      await ref.watch(optimizedSystemSettingsNotifierProvider.future);
  return settings.requestTimeout;
}
