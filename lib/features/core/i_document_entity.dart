import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/i_entity.dart';

/// Интерфейс для сущностей типа "Документ"
abstract class IDocumentEntity implements IEntity {
  DocumentStatus get status;
  DateTime get documentDate;
  bool get isPosted;
  DateTime? get postedAt;
  Map<BaseItemType, List<IDocumentItemEntity>>
      get itemsMap; // Используем интерфейс элемента

  List<IDocumentItemEntity> get items;
  List<IDocumentItemEntity> getItemsByType(BaseItemType type);
  List<IDocumentItemEntity> searchItems(String query);

  // Методы для иммутабельного управления элементами
  IDocumentEntity withAddedItem(IDocumentItemEntity item,
      {BaseItemType? itemType});
  IDocumentEntity withUpdatedItem(IDocumentItemEntity item,
      {BaseItemType? itemType});
  IDocumentEntity withRemovedItem(String itemId, {BaseItemType? itemType});

  // Метод для иммутабельного обновления статуса
  IDocumentEntity withStatus(DocumentStatus newStatus);
}
