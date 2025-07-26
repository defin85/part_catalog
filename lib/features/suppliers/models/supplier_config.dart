import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_config.freezed.dart';
part 'supplier_config.g.dart';

/// Типы аутентификации для API поставщиков
enum AuthenticationType {
  basic, // Basic Auth (username/password)
  bearer, // Bearer token
  apiKey, // API Key
  oauth2, // OAuth 2.0
  custom, // Кастомная аутентификация
}

/// Базовая конфигурация для любого поставщика
@freezed
class SupplierConfig with _$SupplierConfig {
  const factory SupplierConfig({
    required String supplierCode, // Уникальный код поставщика (armtek, autotrade, etc.)
    required String displayName, // Отображаемое название
    required bool isEnabled, // Включен ли поставщик
    required SupplierApiConfig apiConfig, // Конфигурация API
    SupplierBusinessConfig? businessConfig, // Бизнес-параметры
    Map<String, dynamic>? additionalSettings, // Дополнительные настройки
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SupplierConfig;

  factory SupplierConfig.fromJson(Map<String, dynamic> json) =>
      _$SupplierConfigFromJson(json);
}

/// Конфигурация API поставщика
@freezed
class SupplierApiConfig with _$SupplierApiConfig {
  const factory SupplierApiConfig({
    required String baseUrl, // Базовый URL API
    String? proxyUrl, // URL прокси-сервера (если используется)
    required AuthenticationType authType, // Тип аутентификации
    SupplierCredentials? credentials, // Учетные данные
    Map<String, String>? defaultHeaders, // Дополнительные заголовки
    @Default(30000) int timeout, // Таймаут запросов в миллисекундах
    @Default(3) int maxRetries, // Максимальное количество повторов
    RateLimitConfig? rateLimit, // Конфигурация лимитов
  }) = _SupplierApiConfig;

  factory SupplierApiConfig.fromJson(Map<String, dynamic> json) =>
      _$SupplierApiConfigFromJson(json);
}

/// Учетные данные для аутентификации
@freezed
class SupplierCredentials with _$SupplierCredentials {
  const factory SupplierCredentials({
    String? username, // Для Basic Auth
    String? password, // Для Basic Auth
    String? apiKey, // Для API Key auth
    String? token, // Для Bearer token
    String? refreshToken, // Для OAuth2
    DateTime? tokenExpiry, // Срок действия токена
    Map<String, String>? additionalParams, // Дополнительные параметры (VKORG и т.д.)
  }) = _SupplierCredentials;

  factory SupplierCredentials.fromJson(Map<String, dynamic> json) =>
      _$SupplierCredentialsFromJson(json);
}

/// Конфигурация лимитов API
@freezed
class RateLimitConfig with _$RateLimitConfig {
  const factory RateLimitConfig({
    int? dailyLimit, // Дневной лимит запросов
    int? hourlyLimit, // Часовой лимит запросов
    int? concurrentLimit, // Максимальное количество одновременных запросов
    @Default(true) bool trackUsage, // Отслеживать использование
  }) = _RateLimitConfig;

  factory RateLimitConfig.fromJson(Map<String, dynamic> json) =>
      _$RateLimitConfigFromJson(json);
}

/// Бизнес-конфигурация поставщика
@freezed
class SupplierBusinessConfig with _$SupplierBusinessConfig {
  const factory SupplierBusinessConfig({
    // Параметры специфичные для бизнес-логики
    String? customerCode, // Код клиента (KUNNR_RG для Armtek)
    String? deliveryAddressCode, // Код адреса доставки (KUNNR_ZA)
    String? contractNumber, // Номер договора (VBELN)
    String? deliveryTerms, // Условия доставки (INCOTERMS)
    String? organizationCode, // Код организации (VKORG для Armtek)
    
    // Настройки поиска
    @Default(true) bool searchWithCross, // Искать с кроссами
    @Default(false) bool exactSearch, // Точный поиск
    
    // Настройки заказов
    @Default(true) bool allowTestOrders, // Разрешить тестовые заказы
    String? defaultWarehouse, // Склад по умолчанию
    
    Map<String, dynamic>? additionalParams, // Дополнительные бизнес-параметры
  }) = _SupplierBusinessConfig;

  factory SupplierBusinessConfig.fromJson(Map<String, dynamic> json) =>
      _$SupplierBusinessConfigFromJson(json);
}

/// Фабричные методы для создания конфигураций популярных поставщиков
extension SupplierConfigFactories on SupplierConfig {
  /// Создать конфигурацию для Armtek
  static SupplierConfig createArmtekConfig({
    required String username,
    required String password,
    required String vkorg,
    String? customerCode,
    String? contractNumber,
    bool useProxy = false,
    String? proxyUrl,
  }) {
    return SupplierConfig(
      supplierCode: 'armtek',
      displayName: 'Armtek',
      isEnabled: true,
      apiConfig: SupplierApiConfig(
        baseUrl: 'http://ws.armtek.ru/api',
        proxyUrl: useProxy ? proxyUrl : null,
        authType: AuthenticationType.basic,
        credentials: SupplierCredentials(
          username: username,
          password: password,
          additionalParams: {'VKORG': vkorg},
        ),
        rateLimit: const RateLimitConfig(
          dailyLimit: 1000,
          trackUsage: true,
        ),
      ),
      businessConfig: SupplierBusinessConfig(
        organizationCode: vkorg,
        customerCode: customerCode,
        contractNumber: contractNumber,
      ),
      createdAt: DateTime.now(),
    );
  }

  /// Создать конфигурацию для Autotrade
  static SupplierConfig createAutotradeConfig({
    required String apiKey,
    String? customerCode,
    bool useProxy = false,
    String? proxyUrl,
  }) {
    return SupplierConfig(
      supplierCode: 'autotrade',
      displayName: 'Autotrade',
      isEnabled: true,
      apiConfig: SupplierApiConfig(
        baseUrl: 'https://api2.autotrade.su',
        proxyUrl: useProxy ? proxyUrl : null,
        authType: AuthenticationType.apiKey,
        credentials: SupplierCredentials(
          apiKey: apiKey,
        ),
      ),
      businessConfig: SupplierBusinessConfig(
        customerCode: customerCode,
      ),
      createdAt: DateTime.now(),
    );
  }
}