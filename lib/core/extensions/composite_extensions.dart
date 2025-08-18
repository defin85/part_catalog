import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_entity.dart';
import 'package:part_catalog/features/core/i_entity.dart';
import 'package:part_catalog/features/core/i_reference_entity.dart';

/// Расширения для интерфейса IEntity.
/// Добавляет удобные методы для всех сущностей.
extension EntityExtensions on IEntity {
  /// Проверяет, была ли сущность изменена после создания.
  bool get wasModified => modifiedAt != null && modifiedAt != createdAt;

  /// Возвращает возраст сущности в днях.
  int get ageInDays => DateTime.now().difference(createdAt).inDays;

  /// Проверяет, является ли сущность новой (создана менее часа назад).
  bool get isNew => DateTime.now().difference(createdAt).inHours < 1;

  /// Возвращает человекочитаемое представление статуса удаления.
  String get deletionStatus => isDeleted ? 'Удалено' : 'Активно';

  /// Проверяет, содержит ли сущность любой из искомых текстов.
  bool containsAnySearchText(List<String> queries) {
    return queries.any((query) => containsSearchText(query));
  }

  /// Проверяет, содержит ли сущность все искомые тексты.
  bool containsAllSearchText(List<String> queries) {
    return queries.every((query) => containsSearchText(query));
  }
}

/// Расширения для интерфейса IDocumentEntity.
/// Добавляет удобные методы для документов.
extension DocumentEntityExtensions on IDocumentEntity {
  /// Проверяет, находится ли документ в активной работе.
  bool get isActive =>
      status.name == 'inProgress' ||
      status.name == 'newDoc' ||
      status.name == 'draft';

  /// Проверяет, завершен ли документ (любым способом).
  bool get isFinished =>
      status.name == 'completed' || status.name == 'cancelled';

  /// Проверяет, можно ли редактировать документ.
  bool get canEdit => !isPosted && status.name != 'cancelled';

  /// Проверяет, можно ли проводить документ.
  bool get canPost =>
      !isPosted && (status.name == 'newDoc' || status.name == 'draft');

  /// Проверяет, можно ли отменить проведение.
  bool get canUnpost => isPosted && status.name == 'posted';

  /// Проверяет, можно ли отменить документ.
  bool get canCancel =>
      status.name != 'cancelled' && status.name != 'completed';

  /// Возвращает общее количество элементов во всех типах.
  int get totalItemsCount => items.length;

  /// Возвращает количество элементов определенного типа.
  int getItemsCountByType(BaseItemType type) => getItemsByType(type).length;

  /// Проверяет наличие элемента с указанным ID.
  bool hasItem(String itemId) {
    return items.any((item) => item.uuid == itemId);
  }

  /// Возвращает все уникальные типы элементов в документе.
  Set<BaseItemType> get uniqueItemTypes => itemsMap.keys.toSet();

  /// Проверяет, есть ли элементы определенного типа.
  bool hasItemsOfType(BaseItemType type) =>
      itemsMap.containsKey(type) && itemsMap[type]!.isNotEmpty;
}

/// Расширения для интерфейса IReferenceEntity.
/// Добавляет удобные методы для справочников.
extension ReferenceEntityExtensions on IReferenceEntity {
  /// Проверяет, является ли элемент корневым (не имеет родителя).
  bool get isRoot => parentId == null;

  /// Возвращает уровень вложенности элемента.
  int get nestingLevel => ancestorIds.length;

  /// Проверяет, является ли элемент потомком указанного предка.
  bool isDescendantOf(String ancestorId) => ancestorIds.contains(ancestorId);

  /// Проверяет, является ли элемент прямым потомком указанного родителя.
  bool isChildOf(String parentId) => this.parentId == parentId;

  /// Возвращает общее количество элементов во всех типах.
  int get totalItemsCount => items.length;

  /// Возвращает количество элементов определенного типа.
  int getItemsCountByType(BaseItemType type) => getItemsByType(type).length;

  /// Проверяет наличие элемента с указанным ID.
  bool hasItem(String itemId) {
    return items.any((item) => item.uuid == itemId);
  }

  /// Возвращает все уникальные типы элементов в справочнике.
  Set<BaseItemType> get uniqueItemTypes => itemsMap.keys.toSet();

  /// Проверяет, есть ли элементы определенного типа.
  bool hasItemsOfType(BaseItemType type) =>
      itemsMap.containsKey(type) && itemsMap[type]!.isNotEmpty;
}

/// Расширения для коллекций сущностей.
extension EntityListExtensions<T extends IEntity> on List<T> {
  /// Фильтрует список, оставляя только активные (не удаленные) сущности.
  List<T> get activeOnly => where((entity) => !entity.isDeleted).toList();

  /// Фильтрует список, оставляя только удаленные сущности.
  List<T> get deletedOnly => where((entity) => entity.isDeleted).toList();

  /// Сортирует список по дате создания (новые первые).
  List<T> sortByCreatedDate({bool descending = true}) {
    final sorted = List<T>.from(this);
    sorted.sort((a, b) => descending
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    return sorted;
  }

  /// Сортирует список по дате модификации (недавно измененные первые).
  List<T> sortByModifiedDate({bool descending = true}) {
    final sorted = List<T>.from(this);
    sorted.sort((a, b) {
      final aDate = a.modifiedAt ?? a.createdAt;
      final bDate = b.modifiedAt ?? b.createdAt;
      return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });
    return sorted;
  }

  /// Сортирует список по отображаемому имени.
  List<T> sortByDisplayName({bool descending = false}) {
    final sorted = List<T>.from(this);
    sorted.sort((a, b) => descending
        ? b.displayName.compareTo(a.displayName)
        : a.displayName.compareTo(b.displayName));
    return sorted;
  }

  /// Фильтрует список по поисковому запросу.
  List<T> search(String query) =>
      where((entity) => entity.containsSearchText(query)).toList();

  /// Находит сущность по UUID.
  T? findByUuid(String uuid) {
    try {
      return firstWhere((entity) => entity.uuid == uuid);
    } catch (_) {
      return null;
    }
  }

  /// Находит сущность по коду.
  T? findByCode(String code) {
    try {
      return firstWhere((entity) => entity.code == code);
    } catch (_) {
      return null;
    }
  }

  /// Группирует сущности по дате создания.
  Map<DateTime, List<T>> groupByCreatedDate() {
    final Map<DateTime, List<T>> grouped = {};
    for (final entity in this) {
      final date = DateTime(
        entity.createdAt.year,
        entity.createdAt.month,
        entity.createdAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(entity);
    }
    return grouped;
  }
}

/// Расширения для коллекций документов.
extension DocumentListExtensions<T extends IDocumentEntity> on List<T> {
  /// Фильтрует список, оставляя только проведенные документы.
  List<T> get postedOnly => where((doc) => doc.isPosted).toList();

  /// Фильтрует список, оставляя только непроведенные документы.
  List<T> get unpostedOnly => where((doc) => !doc.isPosted).toList();

  /// Фильтрует список по статусу документа.
  List<T> withStatus(String statusName) =>
      where((doc) => doc.status.name == statusName).toList();

  /// Сортирует список по дате документа.
  List<T> sortByDocumentDate({bool descending = true}) {
    final sorted = List<T>.from(this);
    sorted.sort((a, b) => descending
        ? b.documentDate.compareTo(a.documentDate)
        : a.documentDate.compareTo(b.documentDate));
    return sorted;
  }

  /// Группирует документы по статусу.
  Map<String, List<T>> groupByStatus() {
    final Map<String, List<T>> grouped = {};
    for (final doc in this) {
      grouped.putIfAbsent(doc.status.name, () => []).add(doc);
    }
    return grouped;
  }
}

/// Расширения для коллекций справочников.
extension ReferenceListExtensions<T extends IReferenceEntity> on List<T> {
  /// Фильтрует список, оставляя только корневые элементы.
  List<T> get rootsOnly => where((ref) => ref.isRoot).toList();

  /// Фильтрует список, оставляя только папки.
  List<T> get foldersOnly => where((ref) => ref.isFolder).toList();

  /// Фильтрует список, оставляя только элементы (не папки).
  List<T> get itemsOnly => where((ref) => !ref.isFolder).toList();

  /// Находит всех прямых потомков указанного родителя.
  List<T> childrenOf(String parentId) =>
      where((ref) => ref.parentId == parentId).toList();

  /// Находит всех потомков (включая вложенные) указанного предка.
  List<T> descendantsOf(String ancestorId) =>
      where((ref) => ref.isDescendantOf(ancestorId)).toList();

  /// Строит дерево элементов, начиная с корневых.
  Map<String?, List<T>> buildTree() {
    final Map<String?, List<T>> tree = {};
    for (final ref in this) {
      tree.putIfAbsent(ref.parentId, () => []).add(ref);
    }
    return tree;
  }
}
