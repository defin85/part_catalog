import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';
// Импортируем @freezed модели данных
import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/references/clients/models/client_specific_data.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
// Логгер и сообщения
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/core/utils/log_messages.dart';

part 'clients_dao.g.dart';

/// Модель для возврата полных данных клиента (@freezed модели)
class ClientFullData {
  final EntityCoreData coreData;
  final ClientSpecificData clientData;

  ClientFullData({required this.coreData, required this.clientData});
}

/// {@template clients_dao}
/// DAO для работы с таблицей клиентов.
/// Работает с @freezed моделями данных (EntityCoreData, ClientSpecificData).
/// {@endtemplate}
@DriftAccessor(tables: [ClientsItems])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  /// {@macro clients_dao}
  ClientsDao(super.db);

  final _logger = AppLoggers.databaseLogger;

  // --- Приватные методы маппинга ---

  /// Маппинг из ClientsItem в EntityCoreData
  EntityCoreData _mapToCoreData(ClientsItem item) {
    return EntityCoreData(
      uuid: item.uuid,
      code: item.code,
      displayName: item.name, // Используем name из таблицы как displayName
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      deletedAt: item.deletedAt,
      isDeleted: item.deletedAt != null,
    );
  }

  /// Маппинг из ClientsItem в ClientSpecificData
  ClientSpecificData _mapToClientSpecificData(ClientsItem item) {
    return ClientSpecificData(
      type: ClientType.values.firstWhere((e) => e.name == item.type,
          orElse: () => ClientType.other), // Преобразуем строку в enum
      contactInfo: item.contactInfo,
      additionalInfo: item.additionalInfo,
    );
  }

  /// Маппинг из ClientsItem в ClientFullData
  ClientFullData _mapToClientFullData(ClientsItem item) {
    return ClientFullData(
      coreData: _mapToCoreData(item),
      clientData: _mapToClientSpecificData(item),
    );
  }

  // --- Публичные методы DAO ---

  /// Возвращает поток списка активных клиентов в виде ClientFullData.
  Stream<List<ClientFullData>> watchActiveClients() {
    final query = select(clientsItems)..where((c) => c.deletedAt.isNull());
    return query.watch().map((rows) => rows.map(_mapToClientFullData).toList());
  }

  /// Возвращает клиента по UUID в виде ClientFullData.
  Future<ClientFullData?> getClientByUuid(String uuid) async {
    final item = await (select(clientsItems)
          ..where((c) => c.uuid.equals(uuid) & c.deletedAt.isNull()))
        .getSingleOrNull();
    return item != null ? _mapToClientFullData(item) : null;
  }

  /// Возвращает клиента по коду в виде ClientFullData.
  Future<ClientFullData?> getClientByCode(String code) async {
    final item = await (select(clientsItems)
          ..where((c) => c.code.equals(code) & c.deletedAt.isNull()))
        .getSingleOrNull();
    return item != null ? _mapToClientFullData(item) : null;
  }

  /// Добавляет нового клиента. Принимает @freezed модели.
  /// Генерирует код, если он не предоставлен.
  Future<int> insertClient(
      EntityCoreData core, ClientSpecificData specific) async {
    String finalCode = core.code;
    // Генерируем код, если он пустой или не уникальный
    if (finalCode.isEmpty || !(await isCodeUnique(finalCode))) {
      final count = await (selectOnly(clientsItems)..addColumns([countAll()]))
          .getSingle()
          .then((value) => value.read(countAll()) ?? 0);
      finalCode = 'CL-${(count + 1).toString().padLeft(5, '0')}';
      _logger
          .i(LogMessages.clientGeneratedCode.replaceAll('{code}', finalCode));
    }

    final companion = ClientsItemsCompanion(
      uuid: Value(core.uuid),
      code: Value(finalCode),
      name: Value(core.displayName),
      type: Value(specific.type.name), // Преобразуем enum в строку
      contactInfo: Value(specific.contactInfo),
      additionalInfo: Value(specific.additionalInfo),
      createdAt: Value(core.createdAt),
      modifiedAt: Value(core.modifiedAt ?? core.createdAt),
      deletedAt: Value(core.deletedAt),
    );
    _logger.d(LogMessages.clientInserting
        .replaceAll('{uuid}', core.uuid)
        .replaceAll('{code}', finalCode));
    try {
      return await into(clientsItems).insert(companion);
    } catch (e, s) {
      _logger.e(LogMessages.clientAddError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет данные клиента по UUID. Принимает @freezed модели.
  Future<int> updateClientByUuid(
      EntityCoreData core, ClientSpecificData specific) async {
    // Проверяем уникальность кода, если он меняется
    if (core.code.isNotEmpty) {
      final existingClient = await getClientByUuid(core.uuid);
      if (existingClient != null && existingClient.coreData.code != core.code) {
        if (!(await isCodeUnique(core.code, excludeUuid: core.uuid))) {
          throw Exception(
              'Client code ${core.code} is not unique, cannot update.');
        }
      }
    }

    final companion = ClientsItemsCompanion(
      // uuid и createdAt не обновляем
      code: Value(core.code),
      name: Value(core.displayName),
      type: Value(specific.type.name),
      contactInfo: Value(specific.contactInfo),
      additionalInfo: Value(specific.additionalInfo),
      modifiedAt: Value(DateTime.now()), // Всегда обновляем modifiedAt
      deletedAt: Value(core.deletedAt), // Позволяем обновить/сбросить deletedAt
    );
    _logger.d(LogMessages.clientUpdating.replaceAll('{uuid}', core.uuid));
    try {
      return await (update(clientsItems)
            ..where((c) => c.uuid.equals(core.uuid)))
          .write(companion);
    } catch (e, s) {
      _logger.e(LogMessages.clientUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Выполняет soft-delete клиента по UUID.
  Future<int> softDeleteClientByUuid(String uuid) {
    _logger.i(LogMessages.clientSoftDeleting.replaceAll('{uuid}', uuid));
    try {
      return (update(clientsItems)..where((c) => c.uuid.equals(uuid)))
          .write(ClientsItemsCompanion(
        deletedAt: Value(DateTime.now()),
        modifiedAt: Value(DateTime.now()),
      ));
    } catch (e, s) {
      _logger.e(LogMessages.clientDeleteError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Возвращает список всех клиентов в виде ClientFullData.
  Future<List<ClientFullData>> getAllClients(
      {bool includeDeleted = false}) async {
    final query = select(clientsItems);
    if (!includeDeleted) {
      query.where((c) => c.deletedAt.isNull());
    }
    final items = await query.get();
    return items.map(_mapToClientFullData).toList();
  }

  /// Фильтрует клиентов по типу и возвращает список ClientFullData.
  Future<List<ClientFullData>> getClientsByType(ClientType type) async {
    final items = await (select(clientsItems)
          ..where((c) => c.type.equals(type.name) & c.deletedAt.isNull()))
        .get();
    return items.map(_mapToClientFullData).toList();
  }

  /// Восстанавливает удалённого клиента по UUID.
  Future<int> restoreClientByUuid(String uuid) {
    _logger.i(LogMessages.clientRestoring.replaceAll('{uuid}', uuid));
    try {
      return (update(clientsItems)..where((c) => c.uuid.equals(uuid)))
          .write(const ClientsItemsCompanion(
        deletedAt: Value(null),
        modifiedAt: Value.absent(), // modifiedAt обновится в сервисе
      ));
    } catch (e, s) {
      _logger.e(LogMessages.clientRestoreError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Поиск клиентов по имени, коду или контактной информации. Возвращает ClientFullData.
  Future<List<ClientFullData>> searchClients(String query) async {
    if (query.isEmpty) return [];
    final lowerQuery = '%${query.toLowerCase()}%';
    final items = await (select(clientsItems)
          ..where((c) =>
              (c.name.lower().like(lowerQuery) |
                  c.code.lower().like(lowerQuery) |
                  c.contactInfo.lower().like(lowerQuery)) &
              c.deletedAt.isNull()))
        .get();
    return items.map(_mapToClientFullData).toList();
  }

  /// Подсчитывает количество активных клиентов по типу.
  Future<int> countClientsByType(ClientType type) async {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.type.equals(type.name) &
          clientsItems.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(countAll()) ?? 0;
  }

  /// Получает поток с количеством активных клиентов.
  Stream<int> watchClientCount() {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.deletedAt.isNull());

    return query.watchSingle().map((row) => row.read(countAll()) ?? 0);
  }

  /// Проверяет уникальность кода, исключая клиента с заданным UUID.
  Future<bool> isCodeUnique(String code, {String? excludeUuid}) async {
    final query = select(clientsItems)
      ..where((c) => c.code.equals(code) & c.deletedAt.isNull());

    if (excludeUuid != null) {
      query.where((c) => c.uuid.equals(excludeUuid).not());
    }

    final existingClient = await query.getSingleOrNull();
    return existingClient == null;
  }

  /// Получает список клиентов (ClientFullData), обновленных после указанной даты.
  Future<List<ClientFullData>> getClientsModifiedAfter(DateTime date) async {
    final items = await (select(clientsItems)
          ..where((c) => c.modifiedAt.isBiggerOrEqualValue(date)))
        .get();
    return items.map(_mapToClientFullData).toList();
  }

  /// Возвращает базовые данные клиента по UUID.
  Future<EntityCoreData?> getClientCoreData(String uuid) async {
    final item = await (select(clientsItems)..where((c) => c.uuid.equals(uuid)))
        .getSingleOrNull();
    if (item == null) return null;
    // Маппинг в EntityCoreData
    return EntityCoreData(
      uuid: item.uuid,
      code: '', // У клиентов нет явного кода в таблице?
      displayName: item.name,
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      deletedAt: item.deletedAt,
      isDeleted: item.deletedAt != null,
    );
  }
}
