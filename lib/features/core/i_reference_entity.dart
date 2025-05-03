import 'package:part_catalog/features/core/i_entity.dart';
import 'package:part_catalog/features/core/i_reference_item_entity.dart'; // Используем специфичный интерфейс
import 'package:part_catalog/features/core/base_item_type.dart';

/// Интерфейс для сущностей типа "Справочник"
abstract class IReferenceEntity implements IEntity {
  /// Идентификатор родительского элемента (для иерархических справочников)
  String? get parentId;

  /// Признак того, что элемент является группой (папкой)
  bool get isFolder;

  /// Список идентификаторов всех предков (для быстрого построения иерархии)
  List<String> get ancestorIds;

  /// Элементы табличной части (если справочник имеет табличные части)
  /// Используем IReferenceItemEntity для большей специфичности.
  Map<BaseItemType, List<IReferenceItemEntity>> get itemsMap;

  /// Возвращает плоский список всех элементов справочника.
  List<IReferenceItemEntity> get items;

  /// Возвращает список элементов указанного типа.
  List<IReferenceItemEntity> getItemsByType(BaseItemType type);

  /// Выполняет поиск среди элементов справочника.
  List<IReferenceItemEntity> searchItems(String query);

  // Методы для иммутабельного управления элементами (если применимо)
  // Теперь принимают и возвращают IReferenceItemEntity.
  IReferenceEntity withAddedItem(IReferenceItemEntity item,
      {BaseItemType? itemType});
  IReferenceEntity withUpdatedItem(IReferenceItemEntity item,
      {BaseItemType? itemType});
  IReferenceEntity withRemovedItem(String itemId, {BaseItemType? itemType});

  // Метод для иммутабельного обновления родителя
  IReferenceEntity withParentId(String? newParentId);
}
