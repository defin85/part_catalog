import 'package:dio/dio.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

/// Результат умной валидации
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? suggestion;
  final ValidationLevel level;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.suggestion,
    this.level = ValidationLevel.error,
  });

  ValidationResult.success()
      : isValid = true,
        errorMessage = null,
        suggestion = null,
        level = ValidationLevel.success;

  ValidationResult.warning(String message, [String? suggestion])
      : isValid = true,
        errorMessage = message,
        suggestion = suggestion,
        level = ValidationLevel.warning;

  ValidationResult.error(String message, [String? suggestion])
      : isValid = false,
        errorMessage = message,
        suggestion = suggestion,
        level = ValidationLevel.error;
}

enum ValidationLevel { success, warning, error }

/// Сервис умной валидации конфигураций поставщиков
class SmartValidationService {
  static const Map<String, List<String>> _supplierUrls = {
    'armtek': [
      'https://ws.armtek.ru',
      'https://api2.autotrade.su',
      'http://ws.armtek.ru',
    ],
    'custom': [],
  };

  static final Map<String, RegExp> _urlPatterns = {
    'armtek': RegExp(r'(ws\.armtek\.ru|api2\.autotrade\.su)'),
  };

  /// Валидация URL для конкретного поставщика
  static ValidationResult validateUrl(String url, String supplierCode) {
    // Базовая проверка формата URL
    final urlResult = _validateUrlFormat(url);
    if (!urlResult.isValid) {
      return urlResult;
    }

    // Специфичная валидация для поставщика
    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        return _validateArmtekUrl(url);
      case 'custom':
        return _validateCustomUrl(url);
      default:
        return ValidationResult.success();
    }
  }

  /// Автодополнение URL на основе поставщика
  static List<String> getSuggestedUrls(String supplierCode, String currentInput) {
    final suggestions = _supplierUrls[supplierCode.toLowerCase()] ?? [];

    if (currentInput.isEmpty) {
      return suggestions;
    }

    // Фильтрация по вводу пользователя
    return suggestions
        .where((url) => url.toLowerCase().contains(currentInput.toLowerCase()))
        .toList();
  }

  /// Умная валидация учетных данных
  static ValidationResult validateCredentials(
    AuthenticationType authType,
    SupplierCredentials? credentials,
    String supplierCode,
  ) {
    switch (authType) {
      case AuthenticationType.none:
        return ValidationResult.success();

      case AuthenticationType.basic:
        return _validateBasicCredentials(credentials, supplierCode);

      case AuthenticationType.apiKey:
        return _validateApiKeyCredentials(credentials, supplierCode);

      case AuthenticationType.bearer:
        return _validateBearerCredentials(credentials, supplierCode);

      case AuthenticationType.oauth2:
      case AuthenticationType.custom:
        return ValidationResult.warning(
          'Данный тип аутентификации в разработке',
          'Выберите Basic Auth или API Key для полной поддержки',
        );
    }
  }

  /// Быстрая проверка доступности URL
  static Future<ValidationResult> quickUrlCheck(String url) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);

      final response = await dio.head(url);

      if (response.statusCode == 200) {
        return ValidationResult.success();
      } else if (response.statusCode == 404) {
        return ValidationResult.error(
          'URL недоступен (404)',
          'Проверьте правильность адреса API',
        );
      } else {
        return ValidationResult.warning(
          'Сервер отвечает с кодом ${response.statusCode}',
          'Возможно, API работает, но требует аутентификации',
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ValidationResult.error(
        'Ошибка при проверке URL: $e',
        'Проверьте подключение к интернету',
      );
    }
  }

  /// Валидация бизнес-параметров Armtek
  static ValidationResult validateArmtekBusinessConfig(
    SupplierBusinessConfig? businessConfig,
    SupplierCredentials? credentials,
  ) {
    if (businessConfig == null) {
      return ValidationResult.warning(
        'Бизнес-конфигурация не задана',
        'Заполните дополнительные параметры для полной функциональности',
      );
    }

    final errors = <String>[];
    final suggestions = <String>[];

    // Проверка VKORG
    final vkorg = credentials?.additionalParams?['VKORG'];
    if (vkorg == null || vkorg.isEmpty) {
      errors.add('VKORG не указан');
      suggestions.add('Загрузите список VKORG из API');
    }

    // Проверка кода клиента
    if (businessConfig.customerCode?.isEmpty ?? true) {
      errors.add('Код клиента не указан');
      suggestions.add('Укажите ваш код клиента в системе Армтек');
    }

    if (errors.isNotEmpty) {
      return ValidationResult.error(
        errors.join(', '),
        suggestions.join('. '),
      );
    }

    return ValidationResult.success();
  }

  /// Валидация полной конфигурации
  static List<ValidationResult> validateFullConfig(SupplierConfig config) {
    final results = <ValidationResult>[];

    // Валидация основных полей
    if (config.displayName.isEmpty) {
      results.add(ValidationResult.error(
        'Название конфигурации не может быть пустым',
      ));
    }

    // Валидация URL
    results.add(validateUrl(config.apiConfig.baseUrl, config.supplierCode));

    // Валидация учетных данных
    results.add(validateCredentials(
      config.apiConfig.authType,
      config.apiConfig.credentials,
      config.supplierCode,
    ));

    // Специфичная валидация для Armtek
    if (config.supplierCode == 'armtek') {
      results.add(validateArmtekBusinessConfig(
        config.businessConfig,
        config.apiConfig.credentials,
      ));
    }

    return results.where((r) => !r.isValid || r.level == ValidationLevel.warning).toList();
  }

  // Приватные методы

  static ValidationResult _validateUrlFormat(String url) {
    if (url.isEmpty) {
      return ValidationResult.error('URL не может быть пустым');
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return ValidationResult.error(
        'Некорректный формат URL',
        'Пример: https://api.example.com',
      );
    }

    if (!uri.hasScheme) {
      return ValidationResult.error(
        'URL должен содержать протокол',
        'Добавьте http:// или https://',
      );
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return ValidationResult.error(
        'Поддерживаются только HTTP и HTTPS протоколы',
      );
    }

    if (!uri.hasAuthority) {
      return ValidationResult.error(
        'URL должен содержать домен',
        'Пример: https://api.example.com',
      );
    }

    return ValidationResult.success();
  }

  static ValidationResult _validateArmtekUrl(String url) {
    final pattern = _urlPatterns['armtek']!;

    if (!pattern.hasMatch(url)) {
      return ValidationResult.error(
        'URL не соответствует API Армтек',
        'Используйте ws.armtek.ru или api2.autotrade.su',
      );
    }

    // Проверка рекомендуемого протокола
    if (url.startsWith('http://')) {
      return ValidationResult.warning(
        'Рекомендуется использовать HTTPS',
        'Замените http:// на https:// для безопасности',
      );
    }

    return ValidationResult.success();
  }

  static ValidationResult _validateCustomUrl(String url) {
    // Для пользовательских API проводим только базовую проверку
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      return ValidationResult.warning(
        'Используется локальный адрес',
        'Убедитесь, что API доступен для других пользователей',
      );
    }

    return ValidationResult.success();
  }

  static ValidationResult _validateBasicCredentials(
    SupplierCredentials? credentials,
    String supplierCode,
  ) {
    if (credentials?.username?.isEmpty ?? true) {
      return ValidationResult.error('Введите имя пользователя');
    }

    if (credentials?.password?.isEmpty ?? true) {
      return ValidationResult.error('Введите пароль');
    }

    // Специфичные проверки для Armtek
    if (supplierCode == 'armtek') {
      final username = credentials!.username!;
      if (username.length < 3) {
        return ValidationResult.warning(
          'Имя пользователя кажется слишком коротким',
          'Обычно логины Армтек содержат минимум 3 символа',
        );
      }
    }

    return ValidationResult.success();
  }

  static ValidationResult _validateApiKeyCredentials(
    SupplierCredentials? credentials,
    String supplierCode,
  ) {
    if (credentials?.apiKey?.isEmpty ?? true) {
      return ValidationResult.error('Введите API ключ');
    }

    final apiKey = credentials!.apiKey!;

    // Проверка длины ключа
    if (apiKey.length < 10) {
      return ValidationResult.warning(
        'API ключ кажется слишком коротким',
        'Убедитесь, что вы скопировали ключ полностью',
      );
    }

    return ValidationResult.success();
  }

  static ValidationResult _validateBearerCredentials(
    SupplierCredentials? credentials,
    String supplierCode,
  ) {
    if (credentials?.apiKey?.isEmpty ?? true) {
      return ValidationResult.error('Введите Bearer токен');
    }

    final token = credentials!.apiKey!;

    // Проверка формата Bearer токена
    if (token.startsWith('Bearer ')) {
      return ValidationResult.warning(
        'Уберите префикс "Bearer " из токена',
        'Система автоматически добавит префикс при отправке запросов',
      );
    }

    return ValidationResult.success();
  }

  static ValidationResult _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ValidationResult.error(
          'Время ожидания подключения истекло',
          'Проверьте URL и подключение к интернету',
        );
      case DioExceptionType.connectionError:
        return ValidationResult.error(
          'Не удается подключиться к серверу',
          'Проверьте URL и доступность сервера',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return ValidationResult.warning(
            'Сервер требует аутентификацию',
            'API доступен, но нужны корректные учетные данные',
          );
        } else if (statusCode == 403) {
          return ValidationResult.warning(
            'Доступ запрещен',
            'API доступен, но нет прав доступа',
          );
        } else {
          return ValidationResult.error(
            'Сервер ответил с ошибкой $statusCode',
            'Проверьте корректность URL API',
          );
        }
      default:
        return ValidationResult.error(
          'Ошибка сети: ${e.message}',
          'Проверьте подключение к интернету',
        );
    }
  }
}