import 'package:dio/dio.dart';

import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/base_supplier_api_client.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

/// Фабрика для создания API клиентов на основе конфигураций
class ApiClientFactory {
  static final _logger = AppLoggers.suppliers;

  /// Создать API клиент на основе конфигурации поставщика
  static BaseSupplierApiClient? createClient(
    SupplierConfig config,
    Dio dio, {
    bool useProxy = false,
  }) {
    _logger.i('Creating API client for supplier: ${config.supplierCode}');

    final apiConfig = config.apiConfig;
    final baseUrl = useProxy && apiConfig.proxyUrl != null
        ? apiConfig.proxyUrl!
        : apiConfig.baseUrl;

    switch (config.supplierCode.toLowerCase()) {
      case 'armtek':
        return _createArmtekClient(config, dio, baseUrl, useProxy);

      case 'autotrade':
        // TODO: Реализовать AutotradeApiClient
        _logger.w('AutotradeApiClient not implemented yet');
        return null;

      case 'autodoc':
        // TODO: Реализовать AutodocApiClient
        _logger.w('AutodocApiClient not implemented yet');
        return null;

      default:
        _logger.e('Unknown supplier code: ${config.supplierCode}');
        return null;
    }
  }

  /// Создать клиент Armtek
  static ArmtekApiClient? _createArmtekClient(
    SupplierConfig config,
    Dio dio,
    String baseUrl,
    bool useProxy,
  ) {
    final creds = config.apiConfig.credentials;

    if (!useProxy && config.apiConfig.authType == AuthenticationType.basic) {
      // Прямое подключение с Basic Auth
      if (creds?.username == null || creds?.password == null) {
        _logger
            .e('Username and password required for Armtek direct connection');
        return null;
      }

      return ArmtekApiClient(
        dio,
        baseUrl: baseUrl,
        username: creds!.username,
        password: creds.password,
        vkorg: creds.additionalParams?['VKORG'],
      );
    } else if (useProxy) {
      // Подключение через прокси
      return ArmtekApiClient(
        dio,
        baseUrl: baseUrl,
        vkorg: creds?.additionalParams?['VKORG'],
        proxyAuthToken: creds?.token, // Если прокси требует токен
      );
    }

    _logger.e('Invalid configuration for Armtek client');
    return null;
  }

  /// Настроить Dio с параметрами из конфигурации
  static void configureDio(Dio dio, SupplierConfig config) {
    final apiConfig = config.apiConfig;

    // Установить таймаут
    if (apiConfig.timeout != null) {
      dio.options.connectTimeout = apiConfig.timeout!;
      dio.options.receiveTimeout = apiConfig.timeout!;
    }

    // Добавить дополнительные заголовки
    if (apiConfig.defaultHeaders != null) {
      dio.options.headers.addAll(apiConfig.defaultHeaders!);
    }

    // Добавить интерсептор для повторных попыток
    if (apiConfig.retryAttempts != null && apiConfig.retryAttempts! > 0) {
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          retries: apiConfig.retryAttempts!,
          retryDelays: [
            const Duration(seconds: 1),
            const Duration(seconds: 2),
            const Duration(seconds: 4),
          ],
        ),
      );
    }

    // Добавить интерсептор для отслеживания лимитов
    if (apiConfig.rateLimit?.trackUsage == true) {
      dio.interceptors.add(
        RateLimitInterceptor(
          supplierCode: config.supplierCode,
          rateLimit: apiConfig.rateLimit!,
        ),
      );
    }
  }
}

/// Интерсептор для повторных попыток
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.retries,
    required this.retryDelays,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['retryAttempt'] ?? 0;

    if (attempt < retries && _shouldRetry(err)) {
      err.requestOptions.extra['retryAttempt'] = attempt + 1;

      // Задержка перед повторной попыткой
      if (attempt < retryDelays.length) {
        await Future.delayed(retryDelays[attempt]);
      }

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}

/// Интерсептор для отслеживания лимитов API
class RateLimitInterceptor extends Interceptor {
  final String supplierCode;
  final RateLimitConfig rateLimit;
  static final Map<String, RateLimitTracker> _trackers = {};

  RateLimitInterceptor({
    required this.supplierCode,
    required this.rateLimit,
  }) {
    _trackers[supplierCode] ??= RateLimitTracker(rateLimit);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tracker = _trackers[supplierCode]!;

    if (!tracker.canMakeRequest()) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Rate limit exceeded for $supplierCode',
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }

    tracker.recordRequest();
    handler.next(options);
  }
}

/// Отслеживание использования лимитов
class RateLimitTracker {
  final RateLimitConfig config;
  final List<DateTime> _requests = [];

  RateLimitTracker(this.config);

  bool canMakeRequest() {
    _cleanOldRequests();

    if (config.dailyLimit != null) {
      final dailyCount = _requests
          .where((r) =>
              r.isAfter(DateTime.now().subtract(const Duration(days: 1))))
          .length;

      if (dailyCount >= config.dailyLimit!) {
        return false;
      }
    }

    if (config.hourlyLimit != null) {
      final hourlyCount = _requests
          .where((r) =>
              r.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
          .length;

      if (hourlyCount >= config.hourlyLimit!) {
        return false;
      }
    }

    return true;
  }

  void recordRequest() {
    _requests.add(DateTime.now());
  }

  void _cleanOldRequests() {
    final cutoff = DateTime.now().subtract(const Duration(days: 1));
    _requests.removeWhere((r) => r.isBefore(cutoff));
  }

  Map<String, int> getUsageStats() {
    _cleanOldRequests();

    return {
      'daily': _requests
          .where((r) =>
              r.isAfter(DateTime.now().subtract(const Duration(days: 1))))
          .length,
      'hourly': _requests
          .where((r) =>
              r.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
          .length,
    };
  }
}