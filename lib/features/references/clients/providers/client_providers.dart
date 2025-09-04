import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/providers/core_providers.dart';
import 'package:part_catalog/core/service_locator.dart'; // Используем для AppDatabase и Logger
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';

part 'client_providers.g.dart'; // Сгенерированный файл

// Провайдер для ClientService
// Используем keepAlive, чтобы сервис не пересоздавался без необходимости
@Riverpod(keepAlive: true)
ClientService clientService(Ref ref) {
  // Получаем AppDatabase через существующий locator или через другой Riverpod провайдер
  final db = locator<AppDatabase>();
  return ClientService(db);
}

// AsyncNotifier для управления списком клиентов
@riverpod
class ClientsNotifier extends _$ClientsNotifier {
  // Получаем логгер и сервис для использования в методах
  Logger get _logger => ref.read(clientsLoggerProvider);
  ClientService get _clientService => ref.read(clientServiceProvider);

  @override
  FutureOr<List<ClientModelComposite>> build() async {
    _logger.d('ClientsNotifier: Initial build loading clients...');
    // Начальная загрузка всех активных клиентов
    // Используем watch, чтобы перестроиться, если сам сервис изменится (маловероятно, но возможно)
    return ref.watch(clientServiceProvider).getAllClients();
  }

  /// Добавляет нового клиента
  Future<void> addClient(ClientModelComposite client) async {
    _logger.d('ClientsNotifier: Attempting to add client: ${client.code}');
    try {
      await _clientService.addClient(client);
      ref.invalidateSelf(); // Инвалидируем, чтобы build() перезагрузил список
      _logger.i('ClientsNotifier: Client added successfully: ${client.code}');
    } catch (e, s) {
      _logger.e('ClientsNotifier: Error adding client: ${client.code}',
          error: e, stackTrace: s);
      // Пробрасываем ошибку для обработки в UI (например, для SnackBar)
      rethrow;
    }
  }

  /// Обновляет существующего клиента
  Future<void> updateClient(ClientModelComposite client) async {
    _logger.d('ClientsNotifier: Attempting to update client: ${client.uuid}');
    try {
      await _clientService.updateClient(client);
      ref.invalidateSelf(); // Перезагружаем список
      _logger.i('ClientsNotifier: Client updated successfully: ${client.uuid}');
    } catch (e, s) {
      _logger.e('ClientsNotifier: Error updating client: ${client.uuid}',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Мягко удаляет клиента
  Future<void> deleteClient(String clientUuid) async {
    _logger.d('ClientsNotifier: Attempting to delete client: $clientUuid');
    try {
      await _clientService.deleteClient(clientUuid);
      ref.invalidateSelf(); // Перезагружаем список
      _logger.i('ClientsNotifier: Client deleted successfully: $clientUuid');
    } catch (e, s) {
      _logger.e('ClientsNotifier: Error deleting client: $clientUuid',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Восстанавливает мягко удаленного клиента
  Future<void> restoreClient(String clientUuid) async {
    _logger.d('ClientsNotifier: Attempting to restore client: $clientUuid');
    try {
      await _clientService.restoreClient(clientUuid);
      ref.invalidateSelf(); // Перезагружаем список
      _logger.i('ClientsNotifier: Client restored successfully: $clientUuid');
    } catch (e, s) {
      _logger.e('ClientsNotifier: Error restoring client: $clientUuid',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Выполняет поиск клиентов или загружает всех, если запрос пуст
  Future<void> searchClients(String? query) async {
    _logger.d('ClientsNotifier: Searching clients with query: "$query"');
    // Устанавливаем состояние загрузки перед выполнением запроса
    state = const AsyncValue.loading();
    // Используем AsyncValue.guard для автоматической обработки try/catch
    state = await AsyncValue.guard(() async {
      if (query == null || query.trim().isEmpty) {
        _logger.d('ClientsNotifier: Empty query, loading all clients.');
        // Если запрос пуст, загружаем всех клиентов (как в build)
        return _clientService.getAllClients();
      } else {
        _logger.d('ClientsNotifier: Executing search.');
        // Иначе выполняем поиск
        return _clientService.searchClients(query.trim());
      }
    });
    _logger.d('ClientsNotifier: Search finished. State updated.');
  }
}

// Провайдер для проверки уникальности кода (асинхронный)
// Используем family для передачи параметров
@riverpod
Future<bool> isClientCodeUnique(Ref ref,
    {required String code, String? excludeUuid}) async {
  final logger = ref.read(clientsLoggerProvider);
  logger.d(
      'isClientCodeUniqueProvider: Checking code "$code", excluding "$excludeUuid"');
  final clientService = ref.watch(clientServiceProvider);
  try {
    final isUnique =
        await clientService.isCodeUnique(code, excludeUuid: excludeUuid);
    logger.d('isClientCodeUniqueProvider: Code "$code" is unique: $isUnique');
    return isUnique;
  } catch (e, s) {
    logger.e(
        'isClientCodeUniqueProvider: Error checking code uniqueness for "$code"',
        error: e,
        stackTrace: s);
    // В случае ошибки считаем код не уникальным, чтобы предотвратить сохранение
    return false;
  }
}

// Провайдер для получения одного клиента по UUID (семейство)
// Добавляем сюда
@riverpod
Future<ClientModelComposite?> client(Ref ref, String uuid) async {
  final logger = ref.read(clientsLoggerProvider);
  logger.d('clientProvider: Fetching client with UUID: $uuid');
  try {
    final clientService = ref.watch(clientServiceProvider);
    final client = await clientService.getClientByUuid(uuid);
    if (client == null) {
      logger.w('clientProvider: Client with UUID $uuid not found.');
    }
    return client;
  } catch (e, s) {
    logger.e('clientProvider: Error fetching client $uuid',
        error: e, stackTrace: s);
    // Можно пробросить ошибку или вернуть null/состояние ошибки
    return null; // Или throw e;
  }
}
