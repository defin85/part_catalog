import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/references/vehicles/models/car_specific_data.dart';
import 'package:part_catalog/features/core/i_reference_entity.dart';
import 'package:part_catalog/features/core/i_reference_item_entity.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart'; // Для ListEquality, MapEquality

/// {@template car_model_composite}
/// Бизнес-модель (композитор) для представления автомобиля.
/// Реализует интерфейс [IReferenceEntity] и композирует модели данных
/// [EntityCoreData] и [CarSpecificData].
/// {@endtemplate}
class CarModelComposite implements IReferenceEntity {
  /// Базовые данные сущности.
  final EntityCoreData coreData;

  /// Специфичные данные автомобиля.
  final CarSpecificData carData;

  // --- Поля из IReferenceEntity ---

  @override
  final String? parentId; // Автомобили обычно не имеют родителя

  @override
  final bool isFolder; // Автомобили не являются папками

  @override
  final List<String> ancestorIds; // У автомобилей нет предков в иерархии

  @override
  final Map<BaseItemType, List<IReferenceItemEntity>>
      itemsMap; // Автомобили обычно не имеют элементов

  /// Приватный конструктор для использования в фабричных методах и `with...`.
  const CarModelComposite._(
    this.coreData,
    this.carData, {
    this.parentId,
    this.isFolder = false,
    List<String>? ancestorIds,
    Map<BaseItemType, List<IReferenceItemEntity>>? itemsMap,
  })  : ancestorIds = ancestorIds ?? const [],
        itemsMap = itemsMap ?? const {};

  /// Фабричный конструктор для создания нового экземпляра автомобиля.
  factory CarModelComposite.create({
    required String code, // Код может быть VIN или другим уникальным значением
    required String make,
    required String model,
    required int year,
    required String vin,
    required String clientId,
    String? licensePlate,
    String? additionalInfo,
    String? parentId, // Можно передать, если нужна иерархия
  }) {
    final now = DateTime.now();
    // Используем комбинацию марки и модели для displayName
    final displayName = '$make $model ($year)';
    final core = EntityCoreData(
      uuid: const Uuid().v4(),
      code: code, // Используем переданный код
      displayName: displayName,
      createdAt: now,
      modifiedAt: now,
      isDeleted: false,
      deletedAt: null,
    );
    final specific = CarSpecificData(
      clientId: clientId,
      vin: vin,
      make: make,
      model: model,
      year: year,
      licensePlate: licensePlate,
      additionalInfo: additionalInfo,
    );
    return CarModelComposite._(
      core,
      specific,
      parentId: parentId,
      isFolder: false,
      ancestorIds: const [], // Или вычислить, если parentId задан
      itemsMap: const {},
    );
  }

  /// Фабричный конструктор для создания экземпляра из моделей данных.
  /// Используется сервисом при маппинге данных из DAO.
  factory CarModelComposite.fromData(
    EntityCoreData coreData,
    CarSpecificData carData, {
    String? parentId,
    bool isFolder = false,
    List<String>? ancestorIds,
    Map<BaseItemType, List<IReferenceItemEntity>>? itemsMap,
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

    return CarModelComposite._(
      coreData,
      carData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: unmodifiableItemsMap,
    );
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
  bool get isDeleted => coreData.isDeleted;

  @override
  DateTime? get deletedAt => coreData.deletedAt;

  @override
  bool containsSearchText(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();

    // Проверяем основные поля
    if (coreData.displayName.toLowerCase().contains(lowerQuery)) return true;
    if (coreData.code.toLowerCase().contains(lowerQuery)) {
      return true; // Поиск по коду (может быть VIN)
    }
    if (carData.vin.toLowerCase().contains(lowerQuery)) {
      return true; // Явный поиск по VIN
    }
    if (carData.make.toLowerCase().contains(lowerQuery)) return true;
    if (carData.model.toLowerCase().contains(lowerQuery)) return true;
    if (carData.licensePlate?.toLowerCase().contains(lowerQuery) ?? false) {
      return true;
    }
    if (carData.additionalInfo?.toLowerCase().contains(lowerQuery) ?? false) {
      return true;
    }

    // Поиск по элементам (если они есть)
    for (final item in items) {
      if (item.containsSearchText(lowerQuery)) return true;
    }

    return false;
  }

  // --- Геттеры для специфичных данных автомобиля ---

  String get clientId => carData.clientId;
  String get vin => carData.vin;
  String get make => carData.make;
  String get model => carData.model;
  int get year => carData.year;
  String? get licensePlate => carData.licensePlate;
  String? get additionalInfo => carData.additionalInfo;

  /// Возвращает номерной знак или прочерк, если он не указан
  String get displayLicensePlate => licensePlate ?? '—';

  // --- Реализация интерфейса IReferenceEntity (дополнительные методы) ---

  @override
  List<IReferenceItemEntity> get items =>
      itemsMap.values.expand((list) => list).toList();

  @override
  List<IReferenceItemEntity> getItemsByType(BaseItemType type) {
    return List.unmodifiable(itemsMap[type] ?? const []);
  }

  @override
  List<IReferenceItemEntity> searchItems(String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items.where((item) => item.containsSearchText(lowerQuery)).toList();
  }

  // --- Методы для иммутабельного обновления ---

  /// Возвращает новый экземпляр с обновленным кодом.
  CarModelComposite withCode(String newCode) {
    return CarModelComposite._(
      coreData.copyWith(code: newCode, modifiedAt: DateTime.now()),
      carData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным VIN.
  /// Также обновляет code, если он совпадает с VIN.
  CarModelComposite withVin(String newVin) {
    final newCoreData = coreData.code == carData.vin
        ? coreData.copyWith(code: newVin, modifiedAt: DateTime.now())
        : coreData.copyWith(modifiedAt: DateTime.now());
    return CarModelComposite._(
      newCoreData,
      carData.copyWith(vin: newVin),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной маркой.
  /// Обновляет displayName.
  CarModelComposite withMake(String newMake) {
    final newDisplayName = '$newMake ${carData.model} (${carData.year})';
    return CarModelComposite._(
      coreData.copyWith(
          displayName: newDisplayName, modifiedAt: DateTime.now()),
      carData.copyWith(make: newMake),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной моделью.
  /// Обновляет displayName.
  CarModelComposite withModel(String newModel) {
    final newDisplayName = '${carData.make} $newModel (${carData.year})';
    return CarModelComposite._(
      coreData.copyWith(
          displayName: newDisplayName, modifiedAt: DateTime.now()),
      carData.copyWith(model: newModel),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным годом.
  /// Обновляет displayName.
  CarModelComposite withYear(int newYear) {
    final newDisplayName = '${carData.make} ${carData.model} ($newYear)';
    return CarModelComposite._(
      coreData.copyWith(
          displayName: newDisplayName, modifiedAt: DateTime.now()),
      carData.copyWith(year: newYear),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным номерным знаком.
  CarModelComposite withLicensePlate(String? newLicensePlate) {
    return CarModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      carData.copyWith(licensePlate: newLicensePlate),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной доп. информацией.
  CarModelComposite withAdditionalInfo(String? newAdditionalInfo) {
    return CarModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      carData.copyWith(additionalInfo: newAdditionalInfo),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленным владельцем.
  CarModelComposite withOwner(String newClientId) {
    return CarModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      carData.copyWith(clientId: newClientId),
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр, помеченный как удаленный.
  CarModelComposite markAsDeleted() {
    if (isDeleted) return this;
    final now = DateTime.now();
    return CarModelComposite._(
      coreData.copyWith(isDeleted: true, modifiedAt: now, deletedAt: now),
      carData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр, восстановленный из удаленных.
  CarModelComposite restore() {
    if (!isDeleted) return this;
    return CarModelComposite._(
      coreData.copyWith(
          isDeleted: false, modifiedAt: DateTime.now(), deletedAt: null),
      carData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  /// Возвращает новый экземпляр с обновленной датой модификации.
  CarModelComposite withModifiedDate(DateTime modifiedDate) {
    return CarModelComposite._(
      coreData.copyWith(modifiedAt: modifiedDate),
      carData,
      parentId: parentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds,
      itemsMap: itemsMap,
    );
  }

  // --- Методы для иммутабельного обновления из IReferenceEntity ---

  @override
  CarModelComposite withParentId(String? newParentId) {
    // Логика обновления ancestorIds, если необходимо
    return CarModelComposite._(
      coreData.copyWith(modifiedAt: DateTime.now()),
      carData,
      parentId: newParentId,
      isFolder: isFolder,
      ancestorIds: ancestorIds, // Потребуется пересчет
      itemsMap: itemsMap,
    );
  }

  // Методы для работы с itemsMap. Для автомобилей они обычно не нужны.
  @override
  CarModelComposite withAddedItem(IReferenceItemEntity item,
      {BaseItemType? itemType}) {
    throw UnsupportedError('Автомобили не могут содержать элементы');
  }

  @override
  CarModelComposite withUpdatedItem(IReferenceItemEntity item,
      {BaseItemType? itemType}) {
    throw UnsupportedError('Автомобили не могут содержать элементы');
  }

  @override
  CarModelComposite withRemovedItem(String itemId, {BaseItemType? itemType}) {
    throw UnsupportedError('Автомобили не могут содержать элементы');
  }

  // --- Сериализация/Десериализация (Ручная) ---

  Map<String, dynamic> toJson() {
    // Сериализация itemsMap не нужна, т.к. они не используются
    return {
      ...coreData.toJson(),
      ...carData.toJson(),
      // Добавить сериализацию полей IReferenceEntity, если нужно
      // 'parentId': parentId,
      // 'isFolder': isFolder,
      // 'ancestorIds': ancestorIds,
    };
  }

  factory CarModelComposite.fromJson(Map<String, dynamic> json) {
    final core = EntityCoreData.fromJson(json);
    final specific = CarSpecificData.fromJson(json);
    // Десериализация itemsMap не нужна
    return CarModelComposite._(
      core,
      specific,
      // parentId: json['parentId'] as String?,
      // isFolder: json['isFolder'] as bool? ?? false,
      // ancestorIds: (json['ancestorIds'] as List?)?.cast<String>(),
      // itemsMap: const {},
    );
  }

  // --- Переопределение стандартных методов ---

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarModelComposite &&
          runtimeType == other.runtimeType &&
          coreData == other.coreData &&
          carData == other.carData &&
          parentId == other.parentId &&
          isFolder == other.isFolder &&
          const ListEquality().equals(ancestorIds, other.ancestorIds) &&
          const MapEquality<BaseItemType, List<IReferenceItemEntity>>()
              .equals(itemsMap, other.itemsMap);

  @override
  int get hashCode =>
      coreData.hashCode ^
      carData.hashCode ^
      parentId.hashCode ^
      isFolder.hashCode ^
      const ListEquality().hash(ancestorIds) ^
      const MapEquality<BaseItemType, List<IReferenceItemEntity>>()
          .hash(itemsMap);

  @override
  String toString() {
    return 'CarModelComposite(uuid: $uuid, displayName: $displayName, vin: $vin)';
  }
}
