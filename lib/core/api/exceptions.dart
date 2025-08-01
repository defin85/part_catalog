import 'package:dio/dio.dart';

/// Базовое исключение для всех API-ошибок
abstract class ApiException implements Exception {
  final String message;
  final dynamic cause;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
  
  const ApiException(
    this.message, {
    this.cause,
    this.statusCode,
    this.metadata,
  });

  @override
  String toString() => 'ApiException: $message';
}

/// Исключение при ошибках сети
class NetworkException extends ApiException {
  final Duration? timeout;
  final String? url;
  
  const NetworkException(
    super.message, {
    super.statusCode,
    super.cause,
    super.metadata,
    this.timeout,
    this.url,
  });

  @override
  String toString() => 'NetworkException: $message${url != null ? ' (URL: $url)' : ''}';
}

/// Исключение при таймауте запроса
class TimeoutException extends NetworkException {
  const TimeoutException(
    super.message, {
    super.timeout,
    super.url,
    super.metadata,
  }) : super(statusCode: 408);

  @override
  String toString() => 'TimeoutException: $message${timeout != null ? ' (Timeout: ${timeout!.inMilliseconds}ms)' : ''}';
}

/// Исключение при ошибках в ответе API
class ApiResponseException extends ApiException {
  final String? errorCode;
  final String? responseBody;
  
  const ApiResponseException(
    super.message, {
    super.statusCode,
    super.cause,
    super.metadata,
    this.errorCode,
    this.responseBody,
  });

  @override
  String toString() => 'ApiResponseException: $message${errorCode != null ? ' (Code: $errorCode)' : ''}';
}

/// Исключение при ошибках авторизации
class AuthenticationException extends ApiException {
  final String? authMethod;
  
  const AuthenticationException(
    super.message, {
    super.statusCode = 401,
    super.cause,
    super.metadata,
    this.authMethod,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Исключение при отсутствии прав доступа
class AuthorizationException extends ApiException {
  final String? requiredPermission;
  
  const AuthorizationException(
    super.message, {
    super.statusCode = 403,
    super.cause,
    super.metadata,
    this.requiredPermission,
  });

  @override
  String toString() => 'AuthorizationException: $message';
}

/// Исключение при ошибках конфигурации
class ConfigurationException extends ApiException {
  final String? configKey;
  
  const ConfigurationException(
    super.message, {
    super.cause,
    super.metadata,
    this.configKey,
  });

  @override
  String toString() => 'ConfigurationException: $message${configKey != null ? ' (Key: $configKey)' : ''}';
}

/// Исключение при ошибках валидации данных
class ValidationException extends ApiException {
  final List<String>? validationErrors;
  
  const ValidationException(
    super.message, {
    super.statusCode = 422,
    super.cause,
    super.metadata,
    this.validationErrors,
  });

  @override
  String toString() {
    final errors = validationErrors?.join(', ') ?? '';
    return 'ValidationException: $message${errors.isNotEmpty ? ' (Errors: $errors)' : ''}';
  }
}

/// Исключение при недоступности сервиса
class ServiceUnavailableException extends ApiException {
  final Duration? retryAfter;
  
  const ServiceUnavailableException(
    super.message, {
    super.statusCode = 503,
    super.cause,
    super.metadata,
    this.retryAfter,
  });

  @override
  String toString() => 'ServiceUnavailableException: $message${retryAfter != null ? ' (Retry after: ${retryAfter!.inSeconds}s)' : ''}';
}

/// Исключение при превышении лимита запросов
class RateLimitException extends ApiException {
  final Duration? retryAfter;
  final int? remainingRequests;
  
  const RateLimitException(
    super.message, {
    super.statusCode = 429,
    super.cause,
    super.metadata,
    this.retryAfter,
    this.remainingRequests,
  });

  @override
  String toString() => 'RateLimitException: $message${retryAfter != null ? ' (Retry after: ${retryAfter!.inSeconds}s)' : ''}';
}

/// Исключение при ошибках сериализации/десериализации
class SerializationException extends ApiException {
  final String? fieldName;
  final Type? expectedType;
  
  const SerializationException(
    super.message, {
    super.cause,
    super.metadata,
    this.fieldName,
    this.expectedType,
  });

  @override
  String toString() => 'SerializationException: $message${fieldName != null ? ' (Field: $fieldName)' : ''}';
}

/// Утилита для преобразования DioException в типизированные исключения
class ApiExceptionMapper {
  static ApiException fromDioException(DioException dioException) {
    final response = dioException.response;
    final requestPath = dioException.requestOptions.path;
    final baseUrl = dioException.requestOptions.baseUrl;
    final fullUrl = '$baseUrl$requestPath';
    
    final metadata = <String, dynamic>{
      'method': dioException.requestOptions.method,
      'url': fullUrl,
      if (response?.headers != null) 'headers': response!.headers.map,
    };

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          _getTimeoutMessage(dioException.type),
          timeout: _getTimeout(dioException),
          url: fullUrl,
          metadata: metadata,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'Ошибка подключения к серверу',
          cause: dioException.error,
          url: fullUrl,
          metadata: metadata,
        );

      case DioExceptionType.badResponse:
        return _mapResponseException(response!, metadata);

      case DioExceptionType.cancel:
        return NetworkException(
          'Запрос был отменен',
          url: fullUrl,
          metadata: metadata,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Ошибка SSL сертификата',
          cause: dioException.error,
          url: fullUrl,
          metadata: metadata,
        );

      case DioExceptionType.unknown:
        return NetworkException(
          'Неизвестная ошибка сети: ${dioException.message}',
          cause: dioException.error,
          url: fullUrl,
          metadata: metadata,
        );
    }
  }

  static String _getTimeoutMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Превышено время ожидания подключения';
      case DioExceptionType.sendTimeout:
        return 'Превышено время ожидания отправки данных';
      case DioExceptionType.receiveTimeout:
        return 'Превышено время ожидания ответа';
      default:
        return 'Превышено время ожидания';
    }
  }

  static Duration? _getTimeout(DioException dioException) {
    final options = dioException.requestOptions;
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return options.connectTimeout;
      case DioExceptionType.sendTimeout:
        return options.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return options.receiveTimeout;
      default:
        return null;
    }
  }

  static ApiException _mapResponseException(Response response, Map<String, dynamic> metadata) {
    final statusCode = response.statusCode!;
    final responseBody = response.data?.toString();
    
    // Пытаемся извлечь сообщение об ошибке из ответа
    String message = 'Ошибка сервера';
    String? errorCode;
    
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      message = data['message'] ?? data['error'] ?? data['detail'] ?? message;
      errorCode = data['code']?.toString() ?? data['error_code']?.toString();
    } else if (responseBody != null) {
      message = responseBody;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message,
          statusCode: statusCode,
          metadata: metadata,
        );

      case 401:
        return AuthenticationException(
          message,
          statusCode: statusCode,
          metadata: metadata,
        );

      case 403:
        return AuthorizationException(
          message,
          statusCode: statusCode,
          metadata: metadata,
        );

      case 404:
        return ApiResponseException(
          'Ресурс не найден',
          statusCode: statusCode,
          errorCode: errorCode,
          metadata: metadata,
          responseBody: responseBody,
        );

      case 422:
        List<String>? validationErrors;
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          if (data['errors'] is List) {
            validationErrors = (data['errors'] as List).map((e) => e.toString()).toList();
          }
        }
        
        return ValidationException(
          message,
          statusCode: statusCode,
          validationErrors: validationErrors,
          metadata: metadata,
        );

      case 429:
        Duration? retryAfter;
        final retryHeader = response.headers.value('retry-after');
        if (retryHeader != null) {
          final seconds = int.tryParse(retryHeader);
          if (seconds != null) {
            retryAfter = Duration(seconds: seconds);
          }
        }
        
        return RateLimitException(
          message,
          statusCode: statusCode,
          retryAfter: retryAfter,
          metadata: metadata,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServiceUnavailableException(
          message,
          statusCode: statusCode,
          metadata: metadata,
        );

      default:
        return ApiResponseException(
          message,
          statusCode: statusCode,
          errorCode: errorCode,
          metadata: metadata,
          responseBody: responseBody,
        );
    }
  }
}