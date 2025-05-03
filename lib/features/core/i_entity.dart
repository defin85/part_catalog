/// Базовый интерфейс для всех сущностей (Справочники, Документы)
abstract class IEntity {
  String get uuid;
  String get code;
  String get displayName;
  DateTime get createdAt;
  DateTime? get modifiedAt;
  DateTime? get deletedAt;
  bool get isDeleted;

  bool containsSearchText(String searchText);
}
