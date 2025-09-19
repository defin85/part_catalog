import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';

/// Предустановленный профиль поставщика
class SupplierProfile {
  final String code;
  final String name;
  final String description;
  final String baseUrl;
  final AuthenticationType authType;
  final ApiConnectionMode connectionMode;
  final Map<String, dynamic>? defaultParams;
  final List<String> tags;

  const SupplierProfile({
    required this.code,
    required this.name,
    required this.description,
    required this.baseUrl,
    required this.authType,
    this.connectionMode = ApiConnectionMode.direct,
    this.defaultParams,
    this.tags = const [],
  });

  /// Создать конфигурацию из профиля
  SupplierConfig toConfig({
    String? customDisplayName,
    SupplierCredentials? credentials,
  }) {
    return SupplierConfig(
      supplierCode: code,
      displayName: customDisplayName ?? name,
      isEnabled: true,
      apiConfig: SupplierApiConfig(
        baseUrl: baseUrl,
        authType: authType,
        connectionMode: connectionMode,
        credentials: credentials,
      ),
      businessConfig: defaultParams != null
          ? SupplierBusinessConfig.fromJson(defaultParams!)
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Сервис управления профилями поставщиков
class SupplierProfileService {
  static const List<SupplierProfile> _predefinedProfiles = [
    // Профили Армтек
    SupplierProfile(
      code: 'armtek',
      name: 'Армтек - Стандартный',
      description: 'Стандартная настройка для прямого подключения к API Армтек',
      baseUrl: 'https://ws.armtek.ru',
      authType: AuthenticationType.basic,
      connectionMode: ApiConnectionMode.direct,
      tags: ['armtek', 'автозапчасти', 'россия'],
    ),
    SupplierProfile(
      code: 'armtek_proxy',
      name: 'Армтек - Через прокси',
      description: 'Настройка для подключения к Армтек через корпоративный прокси',
      baseUrl: 'https://ws.armtek.ru',
      authType: AuthenticationType.basic,
      connectionMode: ApiConnectionMode.proxy,
      tags: ['armtek', 'автозапчасти', 'прокси', 'корпоративный'],
    ),
    SupplierProfile(
      code: 'armtek_autotrade',
      name: 'Армтек - Autotrade API',
      description: 'Альтернативное подключение через api2.autotrade.su',
      baseUrl: 'https://api2.autotrade.su',
      authType: AuthenticationType.basic,
      connectionMode: ApiConnectionMode.direct,
      tags: ['armtek', 'autotrade', 'альтернатива'],
    ),

    // Пользовательские профили
    SupplierProfile(
      code: 'custom_basic',
      name: 'Пользовательский - Basic Auth',
      description: 'Шаблон для пользовательского API с Basic аутентификацией',
      baseUrl: 'https://api.example.com',
      authType: AuthenticationType.basic,
      connectionMode: ApiConnectionMode.direct,
      tags: ['пользовательский', 'basic', 'шаблон'],
    ),
    SupplierProfile(
      code: 'custom_apikey',
      name: 'Пользовательский - API Key',
      description: 'Шаблон для пользовательского API с API Key аутентификацией',
      baseUrl: 'https://api.example.com',
      authType: AuthenticationType.apiKey,
      connectionMode: ApiConnectionMode.direct,
      tags: ['пользовательский', 'api-key', 'шаблон'],
    ),
    SupplierProfile(
      code: 'custom_bearer',
      name: 'Пользовательский - Bearer Token',
      description: 'Шаблон для пользовательского API с Bearer Token аутентификацией',
      baseUrl: 'https://api.example.com',
      authType: AuthenticationType.bearer,
      connectionMode: ApiConnectionMode.direct,
      tags: ['пользовательский', 'bearer', 'шаблон'],
    ),
  ];

  /// Получить все доступные профили
  static List<SupplierProfile> getAllProfiles() {
    return _predefinedProfiles;
  }

  /// Получить профили по тегу
  static List<SupplierProfile> getProfilesByTag(String tag) {
    return _predefinedProfiles
        .where((profile) => profile.tags.contains(tag.toLowerCase()))
        .toList();
  }

  /// Получить профили для конкретного поставщика
  static List<SupplierProfile> getProfilesForSupplier(String supplierCode) {
    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        return _predefinedProfiles
            .where((profile) => profile.tags.contains('armtek'))
            .toList();
      case 'custom':
        return _predefinedProfiles
            .where((profile) => profile.tags.contains('пользовательский'))
            .toList();
      default:
        return [];
    }
  }

  /// Найти профиль по коду
  static SupplierProfile? getProfileByCode(String code) {
    try {
      return _predefinedProfiles.firstWhere((profile) => profile.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Поиск профилей по запросу
  static List<SupplierProfile> searchProfiles(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _predefinedProfiles.where((profile) {
      return profile.name.toLowerCase().contains(lowercaseQuery) ||
          profile.description.toLowerCase().contains(lowercaseQuery) ||
          profile.tags.any((tag) => tag.contains(lowercaseQuery));
    }).toList();
  }

  /// Получить рекомендуемые URL для поставщика
  static List<String> getRecommendedUrls(String supplierCode) {
    final profiles = getProfilesForSupplier(supplierCode);
    return profiles.map((profile) => profile.baseUrl).toSet().toList();
  }

  /// Получить рекомендуемый тип аутентификации для поставщика
  static AuthenticationType? getRecommendedAuthType(String supplierCode) {
    final profiles = getProfilesForSupplier(supplierCode);
    if (profiles.isNotEmpty) {
      // Возвращаем наиболее часто используемый тип аутентификации
      final authTypes = profiles.map((p) => p.authType).toList();
      return authTypes.first; // Для простоты берем первый
    }
    return null;
  }

  /// Создать быструю конфигурацию из профиля
  static SupplierConfig createQuickConfig(
    String profileCode, {
    String? displayName,
    String? username,
    String? password,
    String? apiKey,
  }) {
    final profile = getProfileByCode(profileCode);
    if (profile == null) {
      throw ArgumentError('Profile not found: $profileCode');
    }

    SupplierCredentials? credentials;
    switch (profile.authType) {
      case AuthenticationType.basic:
        if (username != null && password != null) {
          credentials = SupplierCredentials(
            username: username,
            password: password,
          );
        }
        break;
      case AuthenticationType.apiKey:
      case AuthenticationType.bearer:
        if (apiKey != null) {
          credentials = SupplierCredentials(apiKey: apiKey);
        }
        break;
      case AuthenticationType.none:
        credentials = null;
        break;
      case AuthenticationType.oauth2:
      case AuthenticationType.custom:
        // TODO: Implement when OAuth2 support is added
        credentials = null;
        break;
    }

    return profile.toConfig(
      customDisplayName: displayName,
      credentials: credentials,
    );
  }

  /// Получить подсказки для настройки конкретного профиля
  static List<String> getConfigurationTips(String profileCode) {
    switch (profileCode) {
      case 'armtek':
      case 'armtek_proxy':
      case 'armtek_autotrade':
        return [
          'Используйте ваши учетные данные от личного кабинета Армтек',
          'После настройки обязательно загрузите список VKORG',
          'Укажите ваш код клиента для корректной работы API',
          'Проверьте доступность складов в вашем регионе',
        ];
      case 'custom_basic':
        return [
          'Убедитесь, что API поддерживает Basic Authentication',
          'Проверьте правильность базового URL',
          'Уточните у поставщика формат передачи учетных данных',
        ];
      case 'custom_apikey':
        return [
          'Получите API ключ в личном кабинете поставщика',
          'Уточните, в каком заголовке передается ключ',
          'Проверьте лимиты на количество запросов',
        ];
      case 'custom_bearer':
        return [
          'Получите Bearer токен у поставщика',
          'Уточните срок действия токена',
          'Настройте автоматическое обновление токена при необходимости',
        ];
      default:
        return [
          'Следуйте инструкциям поставщика по настройке API',
          'Проверьте доступность эндпоинтов',
          'Настройте корректные заголовки запросов',
        ];
    }
  }
}