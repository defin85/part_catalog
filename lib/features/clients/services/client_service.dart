import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';
import 'package:logger/logger.dart';

/// {@template client_service}
/// Сервис для управления клиентами в базе данных.
/// {@endtemplate}
class ClientService {
  /// {@macro client_service}
  ClientService(this._db) : _logger = Logger();

  final AppDatabase _db;
  final Logger _logger;

  /// Возвращает поток списка клиентов, обновляемый при изменениях в БД.
  Stream<List<ClientModel>> watchClients() {
    _logger.i('Запрос потока списка активных клиентов');
    return _db.clientsDao.watchActiveClients().map(
          (clients) => clients.map(_mapToModel).toList(),
        );
  }

  /// Получает клиента по идентификатору.
  Future<ClientModel?> getClientById(int id) async {
    _logger.i('Запрос клиента с ID: $id');
    final clientItem = await _db.clientsDao.getClientById(id);
    if (clientItem == null) return null;
    return _mapToModel(clientItem);
  }

  /// Добавляет нового клиента.
  Future<int> addClient(ClientModel client) {
    _logger.i('Добавление нового клиента: ${client.name}');
    final companion = _mapToCompanion(client);
    return _db.clientsDao.insertClient(companion);
  }

  /// Обновляет существующего клиента.
  Future<bool> updateClient(ClientModel client) {
    _logger.i('Обновление клиента с ID: ${client.id}');
    final companion = _mapToCompanion(client, withId: true);
    return _db.clientsDao.updateClient(companion);
  }

  /// Удаляет клиента (мягкое удаление).
  Future<int> deleteClient(int id) {
    _logger.i('Мягкое удаление клиента с ID: $id');
    return _db.clientsDao.softDeleteClient(id);
  }

  /// Возвращает список всех клиентов, включая удалённых.
  Future<List<ClientModel>> getAllClients({bool includeDeleted = false}) async {
    _logger
        .i('Запрос списка всех клиентов (включая удалённых: $includeDeleted)');
    final clientItems =
        await _db.clientsDao.getAllClients(includeDeleted: includeDeleted);
    return clientItems.map(_mapToModel).toList();
  }

  /// Фильтрует клиентов по типу.
  Future<List<ClientModel>> getClientsByType(ClientType type) async {
    _logger.i('Фильтрация клиентов по типу: ${type.toString()}');
    final clientItems =
        await _db.clientsDao.getClientsByType(type.toShortString());
    return clientItems.map(_mapToModel).toList();
  }

  /// Восстанавливает удалённого клиента.
  Future<int> restoreClient(int id) {
    _logger.i('Восстановление удалённого клиента с ID: $id');
    return _db.clientsDao.restoreClient(id);
  }

  /// Создаёт нового клиента вместе с его автомобилями в одной транзакции.
  Future<int> createClientWithCars(
      ClientModel client, List<CarsItemsCompanion> cars) {
    _logger.i(
        'Создание клиента с автомобилями: ${client.name}, количество автомобилей: ${cars.length}');
    final clientCompanion = _mapToCompanion(client);
    return _db.transaction(() async {
      // Создаём клиента и получаем его ID
      final clientId = await _db.clientsDao.insertClient(clientCompanion);

      // Добавляем все автомобили этому клиенту
      for (var car in cars) {
        final carWithClientId = car.copyWith(clientId: Value(clientId));
        await _db.carsDao.insertCar(carWithClientId);
      }

      return clientId;
    });
  }

  /// Поиск клиентов по имени или контактной информации.
  Future<List<ClientModel>> searchClients(String query) async {
    _logger.i('Поиск клиентов по запросу: $query');
    final clientItems = await _db.clientsDao.searchClients(query);
    return clientItems.map(_mapToModel).toList();
  }

  /// Преобразует запись из базы данных в бизнес-модель клиента.
  ClientModel _mapToModel(ClientsItem item) {
    return ClientModel(
      id: item.id,
      type: ClientTypeExtension.fromString(item.type),
      name: item.name,
      contactInfo: item.contactInfo,
      additionalInfo: item.additionalInfo,
    );
  }

  /// Преобразует бизнес-модель в модель базы данных.
  ClientsItemsCompanion _mapToCompanion(ClientModel client,
      {bool withId = false}) {
    var companion = ClientsItemsCompanion(
      type: Value(client.type.toShortString()),
      name: Value(client.name),
      contactInfo: Value(client.contactInfo),
      additionalInfo: Value(client.additionalInfo),
    );

    if (withId) {
      companion = companion.copyWith(id: Value(client.id));
    }

    return companion;
  }
}
