import 'package:drift/drift.dart';

class SupplierSettingsItems extends Table {
  @override
  String get tableName => 'supplier_settings';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get supplierCode => text().unique().withLength(min: 1, max: 50)();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// Зашифрованные учетные данные (логин, пароль, API-ключ в виде JSON-строки, затем зашифрованной).
  /// Может храниться как BLOB, если шифрование дает бинарные данные,
  /// или как TEXT, если результат шифрования - base64 строка.
  /// Выберем TEXT для простоты, предполагая base64.
  TextColumn get encryptedCredentials => text().nullable()();

  /// Статус последней проверки ("success", "error_auth", "error_network", "not_checked" и т.д.).
  TextColumn get lastCheckStatus => text().nullable()();
  TextColumn get lastCheckMessage => text().nullable()();
  DateTimeColumn get lastSuccessfulCheckAt => dateTime().nullable()();

  /// ID клиента у поставщика (если есть, например, после успешной регистрации/подключения).
  TextColumn get clientIdentifierAtSupplier => text().nullable()();

  /// JSON-строка для хранения специфичных для поставщика настроек
  /// (например, выбранный VKORG для Armtek, список выбранных складов и т.д.).
  TextColumn get additionalConfig => text().nullable()();

  // Можно добавить поля created_at и updated_at, если необходимо отслеживать изменения
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
