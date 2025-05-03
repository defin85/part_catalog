import 'package:part_catalog/features/core/i_item_entity.dart';
import 'package:part_catalog/features/core/base_item_type.dart';

/// Интерфейс для элементов табличных частей документов
abstract class IDocumentItemEntity implements IItemEntity {
  double? get price;
  double? get quantity;
  bool get isCompleted;
  BaseItemType get documentItemType; // Конкретный тип элемента документа

  double? get totalPrice;
}
