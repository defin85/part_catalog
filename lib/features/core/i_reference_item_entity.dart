import 'package:part_catalog/features/core/i_item_entity.dart';

/// Интерфейс для элементов табличных частей справочников
/// В базовом варианте может не добавлять специфичных полей/методов,
/// но служит для типизации и возможного будущего расширения.
abstract class IReferenceItemEntity implements IItemEntity {
  // Здесь могут быть добавлены специфичные для элементов справочников
  // свойства или методы, если они понадобятся.
  // Например:
  // String? get referenceSpecificProperty;
  // IReferenceItemEntity withReferenceSpecificProperty(String? value);

  // Пока что он просто наследует контракт IItemEntity.
}
