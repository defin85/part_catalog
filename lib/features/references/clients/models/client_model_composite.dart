import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/references/clients/models/client_specific_data.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
import 'package:part_catalog/features/core/i_reference_entity.dart'; // Используем IReferenceEntity
// import 'package:part_catalog/features/core/i_item_entity.dart'; // Больше не нужен базовый
import 'package:part_catalog/features/core/i_reference_item_entity.dart'; // Используем специфичный
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart'; // Для unmodifiable map/list

/// {@template client_model_composite}
/// Бизнес-модель (композитор) для представления клиента.
/// Реализует интерфейс [IReferenceEntity] и композирует модели данных
/// [EntityCoreData] и [ClientSpecificData].
/// {@endtemplate}
class ClientModelComposite implements IReferenceEntity {
  /// Базовые данные сущности.
  final EntityCoreData coreData;

  /// Специфичные данные клиента.
  final ClientSpecificData clientData;

  // --- Поля из IReferenceEntity ---

  @override
  final String? parentId; // Клиенты обычно не имеют родителя

  @override
  final bool isFolder; // Клиенты не являются папками

  @override
  final List<String> ancestorIds; // У клиентов нет предков в иерархии

  @override
  final Map<BaseItemType, List<IReferenceItemEntity>> // Обновлен тип
      itemsMap; // Клиенты обычно не имеют элементов

  /// Приватный конструктор для использования в фабричных методах и `with...`.
  const ClientModelComposite._(
    this.coreData,
    this.clientData, {
    this.parentId, // Инициализация полей IReferenceEntity
    this.isFolder = false,
    List<String>? ancestorIds,
    Map<BaseItemType, List<IReferenceItemEntity>>? itemsMap, // Обновлен тип
  })  : ancestorIds = ancestorIds ?? const [],
        itemsMap = itemsMap ?? const {};

  /// Фабричный конструктор для создания нового экземпляра клиента.
  factory ClientModelComposite.create({
    required String code,
    required String displayName, // Стандартизировано
    required ClientType type,
    required String contactInfo,
    String? additionalInfo,
    String? parentId, // Можно передать, если нужна иерархия
  }) {
    final now = DateTime.now();
    final core = EntityCoreData(
      uuid: const Uuid().v4(),
      code: code,
      displayName: displayName, // Используем displayName
      createdAt: now,
      modifiedAt: now,
      isDeleted: false,
      deletedAt: null, // Явно указываем null при создании
    );
    final specific = ClientSpecificData(
      type: type,
      contactInfo: contactInfo,
      additionalInfo: additionalInfo,
    );
    return ClientModelComposite._(
      core,
      specific,
      parentId: parentId,
      isFolder: false,
      ancestorIds: const [],
      itemsMap: const {},
    );
  }

  /// Фабричный конструктор для создания экземпляра из моделей данных.
  /// Используется сервисом при маппинге данных из DAO.
  factory ClientModelComposite.fromData(
    EntityCoreData coreData,
    ClientSpecificData clientData, {
    String? parentId, // Получаем из DAO, если есть
    bool isFolder = false, // Получаем из DAO, если есть
    List<String>? ancestorIds, // Получаем из DAO, если есть
    Map<BaseItemType, List<IReferenceItemEntity>>? // Обновлен тип
        itemsMap, // Получаем из DAO, если есть
  }) {
    // Убедимся, что карта и списки неизменяемы, если они переданы
    final unmodifiableItemsMap = itemsMap == null
        ? const <BaseItemType, List<IReferenceItemEntity>>{}
        : Map<BaseItemType, List<IReferenceItemEntity>>.unmodifiable(
            itemsMap.map(
              (key, value) =>
                  MapEntry(key, List<IReferenceItemEntity>.unmodifiable(value)),
            ),
          );

    return ClientModelComposite._(
      coreData,
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: unmodifiableItemsMap, // Используем неизменяемую карту
    );
  }

  // --- Реализация интерфейса IEntity ---

  @override
  String get uuid => coreData.uuid;

  @override
  String get code => coreData.code;

  @override
  String get displayName => coreData.displayName; // Используем displayName

  @override
  DateTime get createdAt => coreData.createdAt;

  @override
  DateTime? get modifiedAt => coreData.modifiedAt;

  @override
  bool get isDeleted => coreData.isDeleted;

  @override
  DateTime? get deletedAt => coreData.deletedAt; // Реализация getter deletedAt

  @override
  bool containsSearchText(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();

    // Проверяем основные поля
    if (coreData.displayName.toLowerCase().contains(lowerQuery)) return true;
    if (coreData.code.toLowerCase().contains(lowerQuery)) return true;
    if (clientData.contactInfo.toLowerCase().contains(lowerQuery)) return true;
    if (clientData.additionalInfo?.toLowerCase().contains(lowerQuery) ??
        false) {
      return true;
    }

    // Поиск по элементам (если они есть)
    for (final item in items) {
      // Предполагаем, что у IReferenceItemEntity есть метод containsSearchText
      // или доступ к coreData
      if (item.containsSearchText(lowerQuery)) return true;
    }

    return false;
  }

  // --- Геттеры для специфичных данных клиента ---

  /// Тип клиента.
  ClientType get type => clientData.type;

  /// Контактная информация.
  String get contactInfo => clientData.contactInfo;

  /// Дополнительная информация.
  String? get additionalInfo => clientData.additionalInfo;

  // --- Реализация интерфейса IReferenceEntity (дополнительные методы) ---

  @override
  List<IReferenceItemEntity> get items => // Обновлен тип
      itemsMap.values.expand((list) => list).toList();

  @override
  List<IReferenceItemEntity> getItemsByType(BaseItemType type) {
    // Обновлен тип
    return List.unmodifiable(itemsMap[type] ?? const []);
  }

  @override
  List<IReferenceItemEntity> searchItems(String query) {
    // Обновлен тип
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    // Предполагаем, что у IReferenceItemEntity есть coreData или containsSearchText
    return items.where((item) => item.containsSearchText(lowerQuery)).toList();
  }

  // --- Методы для иммутабельного обновления ---

  /// Возвращает новый экземпляр с обновленными базовыми данными.
  /// Принимает функцию, которая получает текущий coreData и возвращает новый.
  ClientModelComposite copyWithCoreData(
      EntityCoreData Function(EntityCoreData core) update) {
    final newCoreData = update(coreData);
    // Убедимся, что дата модификации обновлена, если не обновлена вручную
    final finalCoreData = newCoreData.modifiedAt == coreData.modifiedAt
        ? newCoreData.copyWith(modifiedAt: DateTime.now())
        : newCoreData;
    return ClientModelComposite._(
      finalCoreData,
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленными специфичными данными клиента.
  /// Принимает функцию, которая получает текущий clientData и возвращает новый.
  ClientModelComposite copyWithClientData(
      ClientSpecificData Function(ClientSpecificData client) update) {
    return ClientModelComposite._(
      coreData.copyWith(
          modifiedAt: DateTime.now()), // Обновляем дату модификации
      update(clientData),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным типом.
  ClientModelComposite withType(ClientType newType) {
    return copyWithClientData((client) => client.copyWith(type: newType));
  }

  /// Возвращает новый экземпляр с обновленным именем/названием.
  ClientModelComposite withName(String newName) {
    return copyWithCoreData((core) => core.copyWith(displayName: newName));
  }

  /// Возвращает новый экземпляр с обновленной контактной информацией.
  ClientModelComposite withContactInfo(String newContactInfo) {
    return copyWithClientData(
        (client) => client.copyWith(contactInfo: newContactInfo));
  }

  /// Возвращает новый экземпляр с обновленной дополнительной информацией.
  ClientModelComposite withAdditionalInfo(String? newAdditionalInfo) {
    return copyWithClientData(
        (client) => client.copyWith(additionalInfo: newAdditionalInfo));
  }

  /// Возвращает новый экземпляр, помеченный как удаленный.
  ClientModelComposite markAsDeleted() {
    if (isDeleted) return this;
    final now = DateTime.now();
    return copyWithCoreData((core) => core.copyWith(
          isDeleted: true,
          modifiedAt: now,
          deletedAt: now, // Устанавливаем deletedAt
        ));
  }

  /// Возвращает новый экземпляр, восстановленный из удаленных.
  ClientModelComposite restore() {
    if (!isDeleted) return this;
    return copyWithCoreData((core) => core.copyWith(
          isDeleted: false,
          modifiedAt: DateTime.now(),
          deletedAt: null, // Сбрасываем deletedAt
        ));
  }

  /// Возвращает новый экземпляр с обновленной датой модификации.
  /// Используется перед сохранением.
  ClientModelComposite withModifiedDate(DateTime modifiedDate) {
    return copyWithCoreData((core) => core.copyWith(modifiedAt: modifiedDate));
  }

  // --- Методы для иммутабельного обновления из IReferenceEntity ---

  @override
  ClientModelComposite withParentId(String? newParentId) {
    // Здесь можно добавить логику обновления ancestorIds, если необходимо
    return ClientModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      clientData,
      parentId: newParentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds, // Потребуется пересчет, если parentId изменился
      itemsMap: itemsMap,
    );
  }

  // Методы для работы с itemsMap. Для клиентов они могут быть не нужны
  // или выбрасывать исключение, если клиенты не должны иметь элементов.
  @override
  ClientModelComposite withAddedItem(IReferenceItemEntity item, // Обновлен тип
      {BaseItemType? itemType}) {
    // Пример реализации, если клиенты могут иметь элементы
    final type = itemType ?? item.itemType;
    final updatedItems = Map<BaseItemType, List<IReferenceItemEntity>>.from(
        itemsMap); // Обновлен тип
    final list = updatedItems.putIfAbsent(type, () => []);
    // Проверка на дубликат по UUID
    if (list.any((existing) => existing.uuid == item.uuid)) {
      return this; // Или обновить существующий? Зависит от логики.
    }
    updatedItems[type] = List.unmodifiable([...list, item]);

    return ClientModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: Map.unmodifiable(updatedItems),
    );
    // Или: throw UnsupportedError('Клиенты не могут содержать элементы');
  }

  @override
  ClientModelComposite withUpdatedItem(
      IReferenceItemEntity item, // Обновлен тип
      {BaseItemType? itemType}) {
    final type = itemType ?? item.itemType;
    if (!itemsMap.containsKey(type)) return this;

    final updatedItems = Map<BaseItemType, List<IReferenceItemEntity>>.from(
        itemsMap); // Обновлен тип
    final list = updatedItems[type]!;
    final index = list.indexWhere((existing) => existing.uuid == item.uuid);

    if (index == -1) return this; // Элемент не найден

    final newList = List<IReferenceItemEntity>.from(list); // Обновлен тип
    newList[index] = item;
    updatedItems[type] = List.unmodifiable(newList);

    return ClientModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: Map.unmodifiable(updatedItems),
    );
    // Или: throw UnsupportedError('Клиенты не могут содержать элементы');
  }

  @override
  ClientModelComposite withRemovedItem(String itemId,
      {BaseItemType? itemType}) {
    BaseItemType? typeToRemoveFrom = itemType;

    // Если тип не указан, ищем элемент во всех типах
    if (typeToRemoveFrom == null) {
      for (final entry in itemsMap.entries) {
        if (entry.value.any((item) => item.uuid == itemId)) {
          typeToRemoveFrom = entry.key;
          break;
        }
      }
    }

    if (typeToRemoveFrom == null || !itemsMap.containsKey(typeToRemoveFrom)) {
      return this; // Тип не найден или элемент не найден в этом типе
    }

    final updatedItems = Map<BaseItemType, List<IReferenceItemEntity>>.from(
        itemsMap); // Обновлен тип
    final list = updatedItems[typeToRemoveFrom]!;
    final newList = list.where((item) => item.uuid != itemId).toList();

    if (newList.length == list.length) return this; // Элемент не найден

    if (newList.isEmpty) {
      updatedItems.remove(typeToRemoveFrom); // Удаляем ключ, если список пуст
    } else {
      updatedItems[typeToRemoveFrom] = List.unmodifiable(newList);
    }

    return ClientModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      clientData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: Map.unmodifiable(updatedItems),
    );
    // Или: throw UnsupportedError('Клиенты не могут содержать элементы');
  }

  // --- Сериализация/Десериализация (Ручная) ---

  /// Преобразование объекта в JSON.
  /// Объединяет JSON из `coreData` и `clientData`.
  /// Поля IReferenceEntity (parentId, isFolder, ancestorIds, itemsMap) пока не сериализуются.
  Map<String, dynamic> toJson() {
    // Сериализация itemsMap потребует знания конкретных типов IReferenceItemEntity
    // и их методов toJson(). Пока оставляем заглушку.
    // final Map<String, List<Map<String, dynamic>>> serializedItemsMap = {};
    // itemsMap.forEach((key, value) {
    //   serializedItemsMap[key.name] = value.map((item) => item.toJson()).toList();
    // });

    return {
      ...coreData.toJson(),
      ...clientData.toJson(),
      // Добавить сериализацию полей IReferenceEntity, если нужно
      // 'parentId': parentId,
      // 'isFolder': isFolder,
      // 'ancestorIds': ancestorIds,
      // 'itemsMap': serializedItemsMap,
    };
  }

  /// Создание объекта из JSON.
  /// Разделяет JSON и создает `coreData` и `clientData`.
  /// Поля IReferenceEntity пока не десериализуются.
  factory ClientModelComposite.fromJson(Map<String, dynamic> json) {
    final core = EntityCoreData.fromJson(json);
    final specific = ClientSpecificData.fromJson(json);

    // Десериализация itemsMap потребует знания конкретных типов IReferenceItemEntity
    // и их конструкторов fromJson(). Пока оставляем заглушку.
    // final Map<BaseItemType, List<IReferenceItemEntity>> deserializedItemsMap = {};
    // final Map<String, dynamic>? rawItemsMap = json['itemsMap'] as Map<String, dynamic>?;
    // if (rawItemsMap != null) { ... }

    return ClientModelComposite._(
      core,
      specific,
      // parentId: json['parentId'] as String?,
      // isFolder: json['isFolder'] as bool? ?? false,
      // ancestorIds: (json['ancestorIds'] as List?)?.cast<String>(),
      // itemsMap: deserializedItemsMap,
    );
  }

  // --- Переопределение стандартных методов ---

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelComposite &&
          runtimeType == other.runtimeType &&
          coreData == other.coreData && // Сравнение по данным
          clientData == other.clientData &&
          parentId == other.parentId && // Сравнение по полям IReferenceEntity
          isFolder == other.isFolder &&
          const ListEquality().equals(ancestorIds, other.ancestorIds) &&
          const MapEquality<BaseItemType,
                  List<IReferenceItemEntity>>() // Уточнен тип
              .equals(itemsMap, other.itemsMap);

  @override
  int get hashCode =>
      coreData.hashCode ^
      clientData.hashCode ^
      parentId.hashCode ^
      isFolder.hashCode ^
      const ListEquality().hash(ancestorIds) ^
      const MapEquality<BaseItemType,
              List<IReferenceItemEntity>>() // Уточнен тип
          .hash(itemsMap);

  @override
  String toString() {
    return 'ClientModelComposite(uuid: $uuid, name: $displayName, type: ${type.name})';
  }
}
