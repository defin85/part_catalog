import 'package:part_catalog/features/core/base_item_type.dart';

/// Базовый интерфейс для всех элементов табличных частей
abstract class IItemEntity {
  String get uuid;
  String get name;
  BaseItemType get itemType;
  int get lineNumber;
  Map<String, dynamic> get data;

  bool containsSearchText(String searchText);
  T? getValue<T>(String key);
  // Метод для иммутабельного обновления данных элемента
  IItemEntity withUpdatedData(Map<String, dynamic> newData);
}
