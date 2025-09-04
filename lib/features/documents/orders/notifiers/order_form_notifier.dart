import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:part_catalog/core/service_locator.dart'; // Временно оставим для логгера
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/documents/orders/state/order_form_state.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';

// Предполагаем наличие этих провайдеров
final orderServiceProvider =
    Provider<OrderService>((ref) => locator<OrderService>());
final clientServiceProvider =
    Provider<ClientService>((ref) => locator<ClientService>());
final carServiceProvider = Provider<CarService>((ref) => locator<CarService>());

// Провайдер для нашего Notifier
final orderFormNotifierProvider = StateNotifierProvider.autoDispose
    .family<OrderFormNotifier, OrderFormState, String?>((ref, orderUuid) {
  return OrderFormNotifier(ref, orderUuid);
});

class OrderFormNotifier extends StateNotifier<OrderFormState> {
  final Ref _ref;
  final String? _orderUuid;
  final _logger = AppLoggers.orders; // Используем логгер

  OrderFormNotifier(this._ref, this._orderUuid)
      : super(OrderFormState(isEditMode: _orderUuid != null)) {
    if (state.isEditMode) {
      _loadExistingOrder();
    } else {
      // Устанавливаем дату по умолчанию для нового заказа
      state = state.copyWith(
          scheduledDate: DateTime.now().add(const Duration(days: 1)));
    }
  }

  Future<void> _loadExistingOrder() async {
    state = state.copyWith(isLoading: true, error: null);
    _logger.i('Загрузка заказа для редактирования: $_orderUuid');
    try {
      final orderService = _ref.read(orderServiceProvider);
      final clientService = _ref.read(clientServiceProvider);
      final carService = _ref.read(carServiceProvider);

      final order = await orderService.getOrderByUuid(_orderUuid!);
      ClientModelComposite? client;
      CarModelComposite? car;

      if (order.clientId != null) {
        try {
          client = await clientService.getClientByUuid(order.clientId!);
        } catch (e, s) {
          _logger.e('Ошибка загрузки клиента ${order.clientId}',
              error: e, stackTrace: s);
          // Не прерываем загрузку, просто клиент будет null
        }
      }
      if (order.carId != null) {
        try {
          car = await carService.getCarByUuid(order.carId!);
        } catch (e, s) {
          _logger.e('Ошибка загрузки автомобиля ${order.carId}',
              error: e, stackTrace: s);
          // Не прерываем загрузку, просто авто будет null
        }
      }

      state = state.copyWith(
        isLoading: false,
        initialOrder: order,
        selectedClient: client,
        selectedCar: car,
        description: order.description ?? '',
        scheduledDate: order.docData.scheduledDate ??
            state.scheduledDate, // Сохраняем дефолт, если null
        itemsMap: Map.from(order.itemsMap), // Копируем карту
      );
    } catch (e, s) {
      _logger.e('Ошибка загрузки заказ-наряда $_orderUuid или заказ не найден',
          error: e, stackTrace: s);
      state = state.copyWith(isLoading: false, error: e.toString());
      // Ошибка будет отображена в UI
    }
  }

  void updateClient(ClientModelComposite? client) {
    _logger.d('Обновление клиента: ${client?.uuid}');
    // Сбрасываем авто, если клиент изменился или стал null
    final shouldResetCar = state.selectedClient?.uuid != client?.uuid;
    state = state.copyWith(
      selectedClient: client,
      selectedCar: shouldResetCar ? null : state.selectedCar,
    );
  }

  void updateCar(CarModelComposite? car) {
    _logger.d('Обновление автомобиля: ${car?.uuid}');
    state = state.copyWith(selectedCar: car);
  }

  void updateScheduledDate(DateTime date) {
    _logger.d('Обновление даты: $date');
    state = state.copyWith(scheduledDate: date);
  }

  void updateDescription(String description) {
    // Не логируем каждое изменение текста для производительности
    state = state.copyWith(description: description);
  }

  void addItem(IDocumentItemEntity item) {
    _logger.d('Добавление/обновление элемента: ${item.uuid}');
    final newMap = Map<String, IDocumentItemEntity>.from(state.itemsMap);
    newMap[item.uuid] = item;
    state = state.copyWith(itemsMap: newMap);
  }

  void removeItem(String itemUuid) {
    _logger.d('Удаление элемента: $itemUuid');
    final newMap = Map<String, IDocumentItemEntity>.from(state.itemsMap);
    newMap.remove(itemUuid);
    state = state.copyWith(itemsMap: newMap);
  }

  Future<bool> saveOrder() async {
    if (state.selectedClient == null || state.selectedCar == null) {
      state = state.copyWith(
          error:
              "Клиент и автомобиль должны быть выбраны"); // TODO: Локализовать
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);
    _logger.i(state.isEditMode
        ? 'Сохранение изменений заказа: $_orderUuid'
        : 'Создание нового заказа');

    try {
      final orderService = _ref.read(orderServiceProvider);
      final Map<BaseItemType, List<IDocumentItemEntity>> groupedItemsMap =
          state.itemsMap.values.groupListsBy((item) => item.itemType);

      OrderModelComposite orderToSave;

      if (state.isEditMode) {
        orderToSave = state.initialOrder!
            .withClient(state.selectedClient!.uuid)
            .withCar(state.selectedCar!.uuid)
            .withDescription(state.description)
            .withScheduledDate(
                state.scheduledDate!) // Дата не может быть null здесь
            .withItems(groupedItemsMap);
      } else {
        orderToSave = OrderModelComposite.create(
          code: 'ЗН-${DateTime.now().millisecondsSinceEpoch}',
          displayName:
              'Заказ-наряд от ${DateFormat('dd.MM.yy').format(DateTime.now())}',
          documentDate: DateTime.now(),
          clientId: state.selectedClient!.uuid,
          carId: state.selectedCar!.uuid,
          description: state.description,
          scheduledDate: state.scheduledDate!, // Дата не может быть null здесь
          itemsMap: groupedItemsMap,
        );
      }

      if (state.isEditMode) {
        await orderService.updateOrder(orderToSave);
        _logger.i('Заказ ${orderToSave.uuid} успешно обновлен.');
      } else {
        await orderService.createOrder(orderToSave);
        _logger.i('Новый заказ ${orderToSave.uuid} успешно создан.');
      }

      state = state.copyWith(isSaving: false);
      return true; // Успех
    } catch (e, s) {
      _logger.e('Ошибка сохранения заказ-наряда', error: e, stackTrace: s);
      state = state.copyWith(isSaving: false, error: e.toString());
      return false; // Ошибка
    }
  }
}
