import 'package:dio/dio.dart';

/// Утилита для обработки ошибок подключения к API поставщиков
class ConnectionErrorHandler {
  /// Преобразует техническую ошибку в понятное пользователю сообщение
  static String getReadableErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    final errorString = error.toString().toLowerCase();

    // Проверяем различные типы ошибок
    if (errorString.contains('socketexception') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Ошибка сети. Проверьте подключение к интернету и URL API.';
    }

    if (errorString.contains('timeout')) {
      return 'Превышено время ожидания. Сервер не отвечает или недоступен.';
    }

    if (errorString.contains('certificate') || errorString.contains('ssl')) {
      return 'Ошибка SSL-сертификата. Проверьте настройки подключения.';
    }

    if (errorString.contains('format')) {
      return 'Ошибка формата данных. Неверный URL или некорректный ответ сервера.';
    }

    // Если не удалось определить тип ошибки, возвращаем общее сообщение
    return 'Не удалось подключиться к API. Проверьте настройки подключения.';
  }

  /// Обработка специфичных ошибок Dio
  static String _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Превышено время ожидания подключения. Проверьте URL API.';

      case DioExceptionType.sendTimeout:
        return 'Превышено время ожидания отправки данных.';

      case DioExceptionType.receiveTimeout:
        return 'Превышено время ожидания ответа от сервера.';

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Запрос был отменен.';

      case DioExceptionType.connectionError:
        return 'Ошибка подключения. Проверьте интернет-соединение и URL API.';

      case DioExceptionType.badCertificate:
        return 'Ошибка SSL-сертификата. Проверьте настройки безопасности.';

      case DioExceptionType.unknown:
        return 'Неизвестная ошибка подключения. Проверьте настройки.';
    }
  }

  /// Обработка HTTP ошибок по кодам статуса
  static String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Неверный запрос. Проверьте правильность введенных данных.';

      case 401:
        return 'Неверный логин или пароль. Проверьте учетные данные.';

      case 403:
        return 'Доступ запрещен. У вас нет прав для выполнения этого действия.';

      case 404:
        return 'Сервис не найден. Проверьте правильность URL API.';

      case 408:
        return 'Превышено время ожидания запроса.';

      case 429:
        return 'Слишком много запросов. Повторите попытку позже.';

      case 500:
        return 'Внутренняя ошибка сервера. Обратитесь к администратору.';

      case 502:
        return 'Сервер недоступен. Попробуйте позже.';

      case 503:
        return 'Сервис временно недоступен. Попробуйте позже.';

      case 504:
        return 'Превышено время ожидания ответа от сервера.';

      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return 'Ошибка клиента (HTTP $statusCode). Проверьте настройки.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Ошибка сервера (HTTP $statusCode). Обратитесь к администратору.';
        } else {
          return 'Неизвестная ошибка HTTP${statusCode != null ? ' ($statusCode)' : ''}.';
        }
    }
  }

  /// Проверяет, является ли ошибка критичной (требующей особого внимания)
  static bool isCriticalError(dynamic error) {
    if (error is DioException) {
      // 401 - неверные учетные данные, не критично
      // 404 - неверный URL, не критично
      // 500+ - критично
      final statusCode = error.response?.statusCode;
      return statusCode != null && statusCode >= 500;
    }

    final errorString = error.toString().toLowerCase();
    return errorString.contains('certificate') ||
        errorString.contains('ssl') ||
        errorString.contains('security');
  }

  /// Получает краткое описание ошибки для логирования
  static String getErrorSummary(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      return 'DioException: ${error.type.name}${statusCode != null ? ' (HTTP $statusCode)' : ''}';
    }

    return error.runtimeType.toString();
  }
}
