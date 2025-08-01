import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/daos/cars_dao.dart'; // Нужен для транзакции с машинами
import 'package:part_catalog/core/database/daos/clients_dao.dart'; // Содержит ClientFullData
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/database_error_recovery.dart';
import 'package:part_catalog/core/utils/error_handler.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
// Логгер и сообщения
import 'package:part_catalog/core/utils/logger_config.dart';
// Импорт бизнес-модели (композитора)
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
// Импорт интерфейса и других необходимых типов
import 'package:part_catalog/features/references/clients/models/client_type.dart';
// Импорт композитора для машин (предполагается, что он существует)
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';

/// {@template client_service}
/// Сервис для управления клиентами.
/// Работает с бизнес-моделью [ClientModelComposite] и взаимодействует
/// с DAO для получения/сохранения данных в виде @freezed моделей.
/// {@endtemplate}
class ClientService {
  /// {@macro client_service}
  ClientService(this._db)
      : _logger = AppLoggers.clients, // Используем настроенный логгер
        _errorRecovery = DatabaseErrorRecovery(_db);

  final AppDatabase _db;
  final Logger _logger;
  final DatabaseErrorRecovery _errorRecovery;

  /// Получение DAO для работы с клиентами
  ClientsDao get _clientsDao => _db.clientsDao;

  /// Получение DAO для работы с машинами (для транзакций)
  CarsDao get _carsDao => _db.carsDao;

  // --- Приватный метод маппинга из @freezed в Композитор ---
  ClientModelComposite _mapDataToComposite(ClientFullData data) {
    // Используем фабричный конструктор fromData композитора
    return ClientModelComposite.fromData(
      data.coreData,
      data.clientData,
      // parentId, isFolder, ancestorIds, itemsMap пока не поддерживаются DAO
    );
  }

  /// Возвращает поток списка активных клиентов [ClientModelComposite].
  Stream<List<ClientModelComposite>> watchClients() {
    _logger.i(LogMessages.clientWatchActive);
    return _clientsDao.watchActiveClients().map(
          (dataList) => dataList.map(_mapDataToComposite).toList(),
        );
  }

  /// Получает клиента [ClientModelComposite] по UUID.
  Future<ClientModelComposite?> getClientByUuid(String uuid) async {
    _logger.i(LogMessages.clientGetByUuid.replaceAll('{uuid}', uuid));
    
    return _errorRecovery.executeWithRetry(
      () async {
        final clientData = await _clientsDao.getClientByUuid(uuid);
        if (clientData == null) {
          _logger.w(LogMessages.clientNotFoundByUuid.replaceAll('{uuid}', uuid));
          return null;
        }
        return _mapDataToComposite(clientData);
      },
      operationName: 'getClientByUuid($uuid)',
    );
  }

  /// Получает клиента [ClientModelComposite] по коду.
  Future<ClientModelComposite?> getClientByCode(String code) async {
    _logger.i(LogMessages.clientGetByCode.replaceAll('{code}', code));
    
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final clientData = await _clientsDao.getClientByCode(code);
        if (clientData == null) {
          _logger.w(LogMessages.clientNotFoundByCode.replaceAll('{code}', code));
          return null;
        }
        return _mapDataToComposite(clientData);
      },
      logger: _logger,
      operationName: 'getClientByCode($code)',
    );
  }

  /// Добавляет нового клиента.
  /// Принимает [ClientModelComposite].
  /// Возвращает UUID созданного клиента.
  Future<String> addClient(ClientModelComposite client) async {
    // Если UUID не задан в композиторе, он должен быть сгенерирован при создании композитора
    if (client.uuid.isEmpty) {
      // Этого не должно происходить, если композитор создан через .create()
      _logger.e(LogMessages.clientAddErrorMissingUuid);
      throw Exception(LogMessages.clientAddErrorMissingUuid);
    }

    // Извлекаем @freezed модели из композитора
    final coreData = client.coreData;
    final clientData = client.clientData;

    return _errorRecovery.executeWithRetry(
      () async {
        await _clientsDao.insertClient(coreData, clientData);
        _logger.i(LogMessages.clientCreated.replaceAll('{uuid}', client.uuid));
        return client.uuid;
      },
      operationName: 'addClient(${client.uuid})',
    );
  }

  /// Обновляет существующего клиента.
  /// Принимает [ClientModelComposite] с обновленными данными.
  Future<void> updateClient(ClientModelComposite client) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Обновляем дату модификации перед сохранением
        final updatedClient = client.withModifiedDate(DateTime.now());

        // Извлекаем @freezed модели из обновленного композитора
        final coreData = updatedClient.coreData;
        final clientData = updatedClient.clientData;

        final updatedRows =
            await _clientsDao.updateClientByUuid(coreData, clientData);
        if (updatedRows == 0) {
          _logger.w(LogMessages.clientNotFoundForUpdate
              .replaceAll('{uuid}', client.uuid));
          // Можно бросить исключение или просто завершить
          // throw Exception(LogMessages.clientNotFoundForUpdate.replaceAll('{uuid}', client.uuid));
        }
      },
      logger: _logger,
      operationName: 'updateClient(${client.uuid})',
    );
  }

  /// Удаляет клиента (мягкое удаление).
  Future<void> deleteClient(String uuid) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Можно сначала получить клиента, чтобы убедиться, что он существует
        final client = await getClientByUuid(uuid);
        if (client == null) {
          _logger.logWarning(LogMessages.clientNotFoundForDelete.replaceAll('{uuid}', uuid));
          return; // Клиент не найден или уже удален
        }
        if (client.isDeleted) {
          _logger.logWarning(LogMessages.clientAlreadyDeleted.replaceAll('{uuid}', uuid));
          return; // Уже удален
        }
        // Помечаем как удаленный и обновляем
        final deletedClient = client.markAsDeleted();
        await updateClient(deletedClient); // Используем общий метод обновления
      },
      logger: _logger,
      operationName: 'deleteClient($uuid)',
    );
  }

  /// Возвращает список всех клиентов [ClientModelComposite].
  Future<List<ClientModelComposite>> getAllClients(
      {bool includeDeleted = false}) async {
    _logger.i(LogMessages.clientGetAll(includeDeleted));
    
    return _errorRecovery.executeWithRetry(
      () async {
        final clientDataList =
            await _clientsDao.getAllClients(includeDeleted: includeDeleted);
        return clientDataList.map(_mapDataToComposite).toList();
      },
      operationName: 'getAllClients(includeDeleted: $includeDeleted)',
    );
  }

  /// Фильтрует клиентов по типу.
  Future<List<ClientModelComposite>> getClientsByType(ClientType type) async {
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final clientDataList = await _clientsDao.getClientsByType(type);
        return clientDataList.map(_mapDataToComposite).toList();
      },
      logger: _logger,
      operationName: 'getClientsByType(${type.name})',
    );
  }

  /// Восстанавливает удалённого клиента.
  Future<void> restoreClient(String uuid) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Получаем текущие данные (DAO должен уметь получать удаленных для восстановления)
        // TODO: Убедиться, что getClientByUuid или специальный метод DAO может получить удаленного
        final clientData = await _clientsDao
            .getClientByUuid(uuid); // Предполагаем, что может вернуть удаленного
        if (clientData == null) {
          _logger.logWarning(LogMessages.clientNotFoundForRestore.replaceAll('{uuid}', uuid));
          return;
        }
        final client = _mapDataToComposite(clientData);

        if (!client.isDeleted) {
          _logger.logWarning(LogMessages.clientRestoreAttemptOnNonDeleted
              .replaceAll('{uuid}', uuid));
          return; // Не удален
        }

        // Восстанавливаем и обновляем
        final restoredClient = client.restore();
        await updateClient(restoredClient); // Используем общий метод обновления
      },
      logger: _logger,
      operationName: 'restoreClient($uuid)',
    );
  }

  /// Создаёт нового клиента вместе с его автомобилями в одной транзакции.
  /// Принимает [ClientModelComposite] и список [CarModelComposite].
  Future<String> createClientWithCars(
      ClientModelComposite client, List<CarModelComposite> cars) async {
    if (client.uuid.isEmpty) {
      _logger.e(LogMessages.clientAddErrorMissingUuid);
      throw Exception(LogMessages.clientAddErrorMissingUuid);
    }

    _logger.i(LogMessages.clientCreatingWithCars
        .replaceAll('{uuid}', client.uuid)
        .replaceAll('{carCount}', cars.length.toString()));

    final clientCore = client.coreData;
    final clientSpecific = client.clientData;

    return ErrorHandler.executeWithLogging(
      operation: () async {
        await _db.transaction(() async {
          // 1. Вставляем клиента
          // DAO клиента возвращает int ID вставленной записи, но он нам здесь не нужен
          await _clientsDao.insertClient(clientCore, clientSpecific);
          _logger.d(LogMessages.clientInsertedInTransaction
              .replaceAll('{uuid}', client.uuid));

          // 2. Вставляем автомобили, связанные с этим клиентом
          for (final car in cars) {
            // Обновляем carSpecificData, добавляя clientId (UUID)
            final carSpecificWithClient = car.carData
                .copyWith(clientId: client.uuid); // Связываем по UUID клиента
            // Обновляем carCoreData с датой модификации
            final carCoreWithModified =
                car.coreData.copyWith(modifiedAt: DateTime.now());

            // Вызываем DAO для вставки машины.
            // CarsDao.insertCar сам найдет int ID клиента по UUID из carSpecificWithClient.
            await _carsDao.insertCar(carCoreWithModified, carSpecificWithClient);
            _logger.d(LogMessages.clientCarAddedInTransaction
                .replaceAll('{carUuid}', car.uuid)
                .replaceAll('{clientUuid}', client.uuid));
          }
        });
        _logger.i(LogMessages.clientCreatedWithCarsSuccess
            .replaceAll('{uuid}', client.uuid));
        return client.uuid;
      },
      logger: _logger,
      operationName: 'createClientWithCars(${client.uuid})',
    );
  }

  /// Поиск клиентов [ClientModelComposite] по имени, коду или контактной информации.
  Future<List<ClientModelComposite>> searchClients(String query) async {
    _logger.i(LogMessages.clientSearching.replaceAll('{query}', query));
    
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final clientDataList = await _clientsDao.searchClients(query);
        return clientDataList.map(_mapDataToComposite).toList();
      },
      logger: _logger,
      operationName: 'searchClients($query)',
    );
  }

  /// Проверяет уникальность кода клиента.
  Future<bool> isCodeUnique(String code, {String? excludeUuid}) async {
    _logger
        .i(LogMessages.clientCheckingCodeUniqueness.replaceAll('{code}', code));
    
    return ErrorHandler.executeWithLogging(
      operation: () async {
        return _clientsDao.isCodeUnique(code, excludeUuid: excludeUuid);
      },
      logger: _logger,
      operationName: 'isCodeUnique($code, excludeUuid: $excludeUuid)',
    );
  }

  // Старые методы _mapToModel и _mapToCompanion больше не нужны
}
