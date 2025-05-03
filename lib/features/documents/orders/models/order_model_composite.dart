import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/core/document_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_specific_data.dart';
import 'package:part_catalog/features/core/i_document_entity.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart'; // Для генерации UUID
import 'package:collection/collection.dart'; // Для ListEquality, MapEquality

// Импорты для сериализации элементов (предполагается, что они существуют)
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';

/// {@template order_model_composite}
/// Бизнес-модель (композитор) для представления Заказ-наряда.
/// Реализует интерфейс [IDocumentEntity] и композирует модели данных
/// [EntityCoreData], [DocumentSpecificData] и [OrderSpecificData].
/// {@endtemplate}
class OrderModelComposite implements IDocumentEntity {
  /// Базовые данные сущности.
  final EntityCoreData coreData;

  /// Специфичные данные документа.
  final DocumentSpecificData docData;

  /// Специфичные данные заказ-наряда.
  final OrderSpecificData orderData;

  /// Карта элементов документа (запчасти, услуги).
  @override
  final Map<BaseItemType, List<IDocumentItemEntity>> itemsMap;

  /// Приватный конструктор для использования в фабричных методах и `with...`.
  const OrderModelComposite._(
      this.coreData, this.docData, this.orderData, this.itemsMap);

  /// Фабричный конструктор для создания нового Заказ-наряда.
  factory OrderModelComposite.create({
    required String code,
    required String displayName,
    required DateTime documentDate,
    DocumentStatus status = DocumentStatus.newDoc, // Значение по умолчанию
    String? clientId,
    String? carId,
    String? description,
    DateTime? scheduledDate, // <--- Добавляем параметр сюда
    Map<BaseItemType, List<IDocumentItemEntity>> itemsMap = const {},
  }) {
    final now = DateTime.now();
    return OrderModelComposite._(
      EntityCoreData(
        uuid: const Uuid().v4(),
        code: code,
        displayName: displayName,
        createdAt: now,
        modifiedAt: now, // Устанавливаем modifiedAt при создании
        isDeleted: false,
        deletedAt: null,
      ),
      DocumentSpecificData(
        status: status,
        documentDate: documentDate,
        scheduledDate: scheduledDate, // <--- Используем параметр здесь
        isPosted: false, // По умолчанию не проведен
        postedAt: null,
        // completedAt и totalAmount будут null по умолчанию
      ),
      OrderSpecificData(
        clientId: clientId,
        carId: carId,
        description: description,
        // scheduledDate здесь больше не нужен
      ),
      Map.unmodifiable(itemsMap), // Делаем карту неизменяемой
    );
  }

  /// Фабричный конструктор для создания экземпляра из моделей данных.
  /// Используется сервисом при маппинге данных из DAO.
  factory OrderModelComposite.fromData(
    EntityCoreData coreData,
    DocumentSpecificData docData,
    OrderSpecificData orderData,
    Map<BaseItemType, List<IDocumentItemEntity>> itemsMap,
  ) {
    // Убедимся, что карта и списки неизменяемы
    final unmodifiableItemsMap =
        Map<BaseItemType, List<IDocumentItemEntity>>.unmodifiable(
      itemsMap.map(
        (key, value) =>
            MapEntry(key, List<IDocumentItemEntity>.unmodifiable(value)),
      ),
    );
    return OrderModelComposite._(
        coreData, docData, orderData, unmodifiableItemsMap);
  }

  // --- Реализация интерфейса IEntity ---
  @override
  String get uuid => coreData.uuid;
  @override
  String get code => coreData.code;
  @override
  String get displayName => coreData.displayName;
  @override
  DateTime get createdAt => coreData.createdAt;
  @override
  DateTime? get modifiedAt => coreData.modifiedAt;
  @override
  DateTime? get deletedAt => coreData.deletedAt;
  @override
  bool get isDeleted => coreData.isDeleted; // Используем поле из coreData

  @override
  bool containsSearchText(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();

    if (coreData.displayName.toLowerCase().contains(lowerQuery)) return true;
    if (coreData.code.toLowerCase().contains(lowerQuery)) return true;
    if (orderData.description?.toLowerCase().contains(lowerQuery) ?? false) {
      return true;
    }

    // Поиск по элементам
    for (final item in items) {
      if (item.containsSearchText(lowerQuery)) return true;
    }

    return false;
  }

  // --- Реализация интерфейса IDocumentEntity ---
  @override
  DocumentStatus get status => docData.status;
  @override
  DateTime get documentDate => docData.documentDate;
  @override
  bool get isPosted => docData.isPosted;
  @override
  DateTime? get postedAt => docData.postedAt;
  // itemsMap уже реализован как поле класса

  @override
  List<IDocumentItemEntity> get items =>
      itemsMap.values.expand((list) => list).toList();

  @override
  List<IDocumentItemEntity> getItemsByType(BaseItemType type) =>
      List.unmodifiable(
          itemsMap[type] ?? const []); // Возвращаем неизменяемый список

  @override
  List<IDocumentItemEntity> searchItems(String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items.where((item) => item.containsSearchText(lowerQuery)).toList();
  }

  // --- Геттеры для специфичных данных заказ-наряда ---
  String? get clientId => orderData.clientId;
  String? get carId => orderData.carId;
  String? get description => orderData.description;

  // --- Иммутабельные методы обновления ---
  @override
  OrderModelComposite withStatus(DocumentStatus newStatus) {
    // Проверка логики перехода статусов может быть здесь или в сервисе
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData.copyWith(status: newStatus),
      orderData,
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным clientId.
  OrderModelComposite withClient(String? clientId) {
    if (orderData.clientId == clientId) return this;
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData.copyWith(clientId: clientId),
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным carId.
  OrderModelComposite withCar(String? carId) {
    if (orderData.carId == carId) return this;
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData.copyWith(carId: carId),
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным описанием.
  OrderModelComposite withDescription(String? description) {
    if (orderData.description == description) return this;
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData.copyWith(description: description),
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной запланированной датой.
  OrderModelComposite withScheduledDate(DateTime? scheduledDate) {
    if (docData.scheduledDate == scheduledDate) return this;
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData.copyWith(scheduledDate: scheduledDate),
      orderData,
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной картой элементов.
  /// Принимает карту, сгруппированную по BaseItemType.
  OrderModelComposite withItems(
      Map<BaseItemType, List<IDocumentItemEntity>> newItemsMap) {
    // Убедимся, что новая карта и списки неизменяемы
    final unmodifiableNewItemsMap =
        Map<BaseItemType, List<IDocumentItemEntity>>.unmodifiable(
      newItemsMap.map(
        (key, value) =>
            MapEntry(key, List<IDocumentItemEntity>.unmodifiable(value)),
      ),
    );
    // Используем MapEquality для сравнения
    if (const MapEquality().equals(itemsMap, unmodifiableNewItemsMap)) {
      return this;
    }
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData,
      unmodifiableNewItemsMap,
    );
  }

  @override
  OrderModelComposite withAddedItem(IDocumentItemEntity item,
      {BaseItemType? itemType}) {
    final type = itemType ?? item.itemType;
    final updatedItemsMap =
        Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    final currentList =
        List<IDocumentItemEntity>.from(updatedItemsMap[type] ?? []);

    // Проверка на дубликат по UUID
    if (currentList.any((existing) => existing.uuid == item.uuid)) {
      return this; // Не добавляем дубликат
    }

    currentList.add(item);
    updatedItemsMap[type] =
        List.unmodifiable(currentList); // Сохраняем неизменяемый список

    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData,
      Map.unmodifiable(updatedItemsMap), // Сохраняем неизменяемую карту
    );
  }

  @override
  OrderModelComposite withUpdatedItem(IDocumentItemEntity item,
      {BaseItemType? itemType}) {
    final type = itemType ?? item.itemType;
    final updatedItemsMap =
        Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    final currentList = updatedItemsMap[type];
    if (currentList == null) return this; // Элемента такого типа нет

    final index = currentList.indexWhere((i) => i.uuid == item.uuid);
    if (index == -1) return this; // Элемент не найден

    final newList = List<IDocumentItemEntity>.from(currentList);
    newList[index] = item;
    updatedItemsMap[type] = List.unmodifiable(newList);

    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData,
      Map.unmodifiable(updatedItemsMap),
    );
  }

  @override
  OrderModelComposite withRemovedItem(String itemId, {BaseItemType? itemType}) {
    final updatedItemsMap =
        Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    bool itemRemoved = false;

    if (itemType != null) {
      // Удаляем из конкретного типа
      final currentList = updatedItemsMap[itemType];
      if (currentList != null) {
        final newList = currentList.where((i) => i.uuid != itemId).toList();
        if (newList.length < currentList.length) {
          itemRemoved = true;
          if (newList.isEmpty) {
            updatedItemsMap.remove(itemType);
          } else {
            updatedItemsMap[itemType] = List.unmodifiable(newList);
          }
        }
      }
    } else {
      // Ищем и удаляем по всем типам
      for (final type in updatedItemsMap.keys.toList()) {
        // Копируем ключи для безопасного удаления
        final currentList = updatedItemsMap[type]!;
        final newList = currentList.where((i) => i.uuid != itemId).toList();
        if (newList.length < currentList.length) {
          itemRemoved = true;
          if (newList.isEmpty) {
            updatedItemsMap.remove(type);
          } else {
            updatedItemsMap[type] = List.unmodifiable(newList);
          }
          break; // Предполагаем, что UUID уникальны по всем типам
        }
      }
    }

    if (!itemRemoved) return this; // Ничего не удалено

    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      docData,
      orderData,
      Map.unmodifiable(updatedItemsMap),
    );
  }

  /// Возвращает новый экземпляр с обновленной датой модификации.
  OrderModelComposite withModifiedDate(DateTime modifiedDate) {
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: modifiedDate),
      docData,
      orderData,
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр, помеченный как удаленный.
  OrderModelComposite markAsDeleted() {
    if (isDeleted) return this;
    final now = DateTime.now();
    return OrderModelComposite._(
      coreData.copyWith(isDeleted: true, modifiedAt: now, deletedAt: now),
      docData,
      orderData,
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр, восстановленный из удаленных.
  OrderModelComposite restore() {
    if (!isDeleted) return this;
    return OrderModelComposite._(
      coreData.copyWith(
          isDeleted: false, modifiedAt: DateTime.now(), deletedAt: null),
      docData,
      orderData,
      itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным флагом проведения.
  OrderModelComposite withProveden(bool isProveden) {
    final now = DateTime.now();
    return OrderModelComposite._(
      coreData.copyWith(modifiedAt: now),
      docData.copyWith(isPosted: isProveden, postedAt: isProveden ? now : null),
      orderData,
      itemsMap,
    );
  }

  // --- Сериализация/Десериализация (Ручная) ---

  /// Преобразование объекта в JSON.
  Map<String, dynamic> toJson() {
    // Сериализуем карту элементов
    final Map<String, List<Map<String, dynamic>>> serializedItemsMap = {};
    itemsMap.forEach((key, value) {
      serializedItemsMap[key.name] = value.map((item) {
        // Предполагаем, что у IDocumentItemEntity есть метод toJson()
        // или мы можем определить его тип и вызвать соответствующий toJson
        if (item is OrderPartModelComposite) {
          return item.toJson();
        } else if (item is OrderServiceModelComposite) {
          return item.toJson();
        }
        // Добавить обработку других типов, если они появятся
        throw Exception(
            'Неизвестный тип элемента для сериализации: ${item.runtimeType}');
      }).toList();
    });

    return {
      ...coreData.toJson(),
      ...docData.toJson(),
      ...orderData.toJson(),
      'itemsMap': serializedItemsMap,
    };
  }

  /// Создание объекта из JSON.
  factory OrderModelComposite.fromJson(Map<String, dynamic> json) {
    final core = EntityCoreData.fromJson(json);
    final doc = DocumentSpecificData.fromJson(json);
    final order = OrderSpecificData.fromJson(json);

    // Десериализуем карту элементов
    final Map<BaseItemType, List<IDocumentItemEntity>> deserializedItemsMap =
        {};
    final Map<String, dynamic>? rawItemsMap =
        json['itemsMap'] as Map<String, dynamic>?;

    if (rawItemsMap != null) {
      rawItemsMap.forEach((key, value) {
        final itemType =
            BaseItemType.values.byName(key); // Получаем enum по имени
        final List<dynamic> itemsList = value as List<dynamic>;

        deserializedItemsMap[itemType] = itemsList.map((itemJson) {
          final itemMap = itemJson as Map<String, dynamic>;
          // Определяем тип элемента и вызываем соответствующий fromJson
          // Это может потребовать добавления поля 'type' в JSON элемента
          // или другой логики определения типа
          switch (itemType) {
            case BaseItemType.part:
              return OrderPartModelComposite.fromJson(itemMap);
            case BaseItemType.service:
              return OrderServiceModelComposite.fromJson(itemMap);
            // Добавить обработку других типов
            default:
              throw Exception(
                  'Неизвестный тип элемента для десериализации: $itemType');
          }
        }).toList();
      });
    }

    return OrderModelComposite.fromData(core, doc, order, deserializedItemsMap);
  }

  // --- Переопределение стандартных методов ---

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelComposite &&
          runtimeType == other.runtimeType &&
          coreData == other.coreData &&
          docData == other.docData &&
          orderData == other.orderData &&
          const MapEquality()
              .equals(itemsMap, other.itemsMap); // Сравнение карт

  @override
  int get hashCode =>
      coreData.hashCode ^
      docData.hashCode ^
      orderData.hashCode ^
      const MapEquality().hash(itemsMap); // Хэш карты

  @override
  String toString() {
    return 'OrderModelComposite(uuid: $uuid, code: $code, displayName: $displayName, status: ${status.name})';
  }
}
