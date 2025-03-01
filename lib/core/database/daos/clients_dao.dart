import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';

part 'clients_dao.g.dart';

/// {@template clients_dao}
/// DAO для работы с таблицей клиентов.
/// {@endtemplate}
@DriftAccessor(tables: [ClientsItems])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  /// {@macro clients_dao}
  ClientsDao(super.db);

  /// Возвращает поток списка активных клиентов.
  Stream<List<ClientsItem>> watchActiveClients() {
    return (select(clientsItems)..where((c) => c.deletedAt.isNull())).watch();
  }

  /// Возвращает клиента по идентификатору.
  Future<ClientsItem?> getClientById(int id) {
    return (select(clientsItems)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Добавляет нового клиента.
  Future<int> insertClient(ClientsItemsCompanion client) {
    return into(clientsItems).insert(client);
  }

  /// Обновляет данные клиента.
  Future<bool> updateClient(ClientsItemsCompanion client) {
    return update(clientsItems).replace(client);
  }

  /// Выполняет soft-delete клиента.
  Future<int> softDeleteClient(int id) {
    return (update(clientsItems)..where((c) => c.id.equals(id)))
        .write(ClientsItemsCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Возвращает список всех клиентов.
  Future<List<ClientsItem>> getAllClients({bool includeDeleted = false}) {
    final query = select(clientsItems);
    if (!includeDeleted) {
      query.where((c) => c.deletedAt.isNull());
    }
    return query.get();
  }

  /// Фильтрует клиентов по типу.
  Future<List<ClientsItem>> getClientsByType(String type) {
    return (select(clientsItems)
          ..where((c) => c.type.equals(type) & c.deletedAt.isNull()))
        .get();
  }

  /// Восстанавливает удалённого клиента.
  Future<int> restoreClient(int id) {
    return (update(clientsItems)..where((c) => c.id.equals(id)))
        .write(const ClientsItemsCompanion(deletedAt: Value(null)));
  }

  /// Поиск клиентов по имени или контактной информации.
  Future<List<ClientsItem>> searchClients(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(clientsItems)
          ..where((c) =>
              c.name.lower().like(lowerQuery) |
              c.contactInfo.lower().like(lowerQuery) & c.deletedAt.isNull()))
        .get();
  }

  /// Подсчитывает количество клиентов по типу.
  Future<int> countClientsByType(String type) async {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.type.equals(type) & clientsItems.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(countAll()) ?? 0;
  }

  /// Получает поток с количеством клиентов (для обновления бейджей в UI).
  Stream<int> watchClientCount() {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.deletedAt.isNull());

    return query.watchSingle().map((row) => row.read(countAll()) ?? 0);
  }
}
