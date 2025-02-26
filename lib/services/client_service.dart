import 'package:part_catalog/models/client.dart' as client_model;
import 'package:part_catalog/database/database.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart' show Value;
import 'package:part_catalog/models/client_type.dart';
// Import the Clients table

/// {@template client_service}
/// Сервис для управления клиентами.
/// {@endtemplate}
class ClientService {
  /// {@macro client_service}
  ClientService() : _db = GetIt.instance<AppDatabase>();

  final AppDatabase _db;

  /// Получить список клиентов.
  Future<List<client_model.Client>> getClients() async {
    final results = await _db.select(_db.clients).get();
    return results
        .map((row) => client_model.Client(
              id: row.id,
              type: ClientTypeExtension.fromString(row.type),
              name: row.name,
              contactInfo: row.contactInfo,
              additionalInfo: row.additionalInfo,
            ))
        .toList();
  }

  /// Получить клиента по ID.
  Future<client_model.Client?> getClient(String id) async {
    final query = _db.select(_db.clients)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    if (result == null) {
      return null;
    }
    return client_model.Client(
      id: result.id,
      type: ClientTypeExtension.fromString(result.type),
      name: result.name,
      contactInfo: result.contactInfo,
      additionalInfo: result.additionalInfo,
    );
  }

  /// Добавить клиента.
  Future<void> addClient(client_model.Client client) async {
    await _db.into(_db.clients).insert(
          ClientsCompanion.insert(
            id: client.id,
            type: client.type.toShortString(),
            name: client.name,
            contactInfo: client.contactInfo,
            additionalInfo: Value(client.additionalInfo),
          ),
        );
  }

  /// Обновить клиента.
  Future<void> updateClient(client_model.Client client) async {
    await (_db.update(_db.clients)..where((t) => t.id.equals(client.id))).write(
      ClientsCompanion(
        type: Value(client.type.toShortString()),
        name: Value(client.name),
        contactInfo: Value(client.contactInfo),
        additionalInfo: Value(client.additionalInfo),
      ),
    );
  }

  /// Удалить клиента.
  Future<void> deleteClient(String id) async {
    await (_db.delete(_db.clients)..where((t) => t.id.equals(id))).go();
  }
}
