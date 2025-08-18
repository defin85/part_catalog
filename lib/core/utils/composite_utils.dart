import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/entity_core_data.dart';

/// Утилиты для работы с композитными моделями.
/// Предоставляет общую функциональность без использования наследования.
class CompositeUtils {
  CompositeUtils._(); // Приватный конструктор

  /// Помечает сущность как удаленную.
  ///
  /// [coreData] - текущие базовые данные сущности
  /// [rebuild] - функция для создания новой сущности с обновленными данными
  ///
  /// Возвращает новый экземпляр сущности с установленными флагами удаления.
  static T markAsDeleted<T>({
    required EntityCoreData coreData,
    required T Function(EntityCoreData) rebuild,
  }) {
    if (coreData.isDeleted) {
      // Уже удалено, возвращаем как есть через rebuild
      return rebuild(coreData);
    }

    final now = DateTime.now();
    return rebuild(coreData.copyWith(
      isDeleted: true,
      deletedAt: now,
      modifiedAt: now,
    ));
  }

  /// Восстанавливает удаленную сущность.
  ///
  /// [coreData] - текущие базовые данные сущности
  /// [rebuild] - функция для создания новой сущности с обновленными данными
  ///
  /// Возвращает новый экземпляр сущности со сброшенными флагами удаления.
  static T restore<T>({
    required EntityCoreData coreData,
    required T Function(EntityCoreData) rebuild,
  }) {
    if (!coreData.isDeleted) {
      // Не удалено, возвращаем как есть
      return rebuild(coreData);
    }

    return rebuild(coreData.copyWith(
      isDeleted: false,
      deletedAt: null,
      modifiedAt: DateTime.now(),
    ));
  }

  /// Обновляет дату модификации сущности.
  ///
  /// [coreData] - текущие базовые данные сущности
  /// [rebuild] - функция для создания новой сущности с обновленными данными
  /// [modifiedDate] - новая дата модификации (по умолчанию - текущее время)
  ///
  /// Возвращает новый экземпляр сущности с обновленной датой модификации.
  static T updateModifiedDate<T>({
    required EntityCoreData coreData,
    required T Function(EntityCoreData) rebuild,
    DateTime? modifiedDate,
  }) {
    return rebuild(coreData.copyWith(
      modifiedAt: modifiedDate ?? DateTime.now(),
    ));
  }

  /// Проверяет, содержит ли сущность искомый текст в базовых полях.
  ///
  /// [code] - код сущности
  /// [displayName] - отображаемое имя сущности
  /// [searchQuery] - искомый текст
  /// [additionalFields] - дополнительные поля для поиска
  ///
  /// Возвращает true, если хотя бы одно поле содержит искомый текст.
  static bool containsSearchText({
    required String code,
    required String displayName,
    required String searchQuery,
    List<String?> additionalFields = const [],
  }) {
    if (searchQuery.isEmpty) return true;

    final lowerQuery = searchQuery.toLowerCase();

    // Проверяем базовые поля
    if (code.toLowerCase().contains(lowerQuery) ||
        displayName.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    // Проверяем дополнительные поля
    for (final field in additionalFields) {
      if (field != null && field.toLowerCase().contains(lowerQuery)) {
        return true;
      }
    }

    return false;
  }

  /// Создает копию EntityCoreData с обновленной датой модификации,
  /// если она не была изменена.
  static EntityCoreData ensureModifiedDate(EntityCoreData coreData) {
    // Если дата модификации не установлена или равна дате создания,
    // устанавливаем текущее время
    if (coreData.modifiedAt == null ||
        coreData.modifiedAt == coreData.createdAt) {
      return coreData.copyWith(modifiedAt: DateTime.now());
    }
    return coreData;
  }

  /// Проверяет, была ли сущность изменена после создания.
  static bool wasModified(EntityCoreData coreData) {
    return coreData.modifiedAt != null &&
        coreData.modifiedAt != coreData.createdAt;
  }

  /// Возвращает возраст сущности в днях.
  static int getAgeInDays(EntityCoreData coreData) {
    return DateTime.now().difference(coreData.createdAt).inDays;
  }

  /// Проверяет, является ли сущность новой (создана менее часа назад).
  static bool isNew(EntityCoreData coreData) {
    return DateTime.now().difference(coreData.createdAt).inHours < 1;
  }
}

/// Утилиты для работы с документными композитными моделями.
class DocumentCompositeUtils {
  DocumentCompositeUtils._(); // Приватный конструктор

  /// Проверяет, можно ли редактировать документ.
  static bool canEdit({
    required bool isPosted,
    required DocumentStatus status,
  }) {
    return !isPosted && status != DocumentStatus.cancelled;
  }

  /// Проверяет, можно ли проводить документ.
  static bool canPost({
    required bool isPosted,
    required DocumentStatus status,
  }) {
    return !isPosted &&
        (status == DocumentStatus.newDoc || status == DocumentStatus.draft);
  }

  /// Проверяет, можно ли отменить проведение документа.
  static bool canUnpost({
    required bool isPosted,
    required DocumentStatus status,
  }) {
    return isPosted && status == DocumentStatus.posted;
  }

  /// Проверяет, можно ли отменить документ.
  static bool canCancel({
    required DocumentStatus status,
  }) {
    return status != DocumentStatus.cancelled &&
        status != DocumentStatus.completed;
  }

  /// Проверяет, просрочен ли документ.
  static bool isOverdue({
    required DateTime? scheduledDate,
    required DocumentStatus status,
  }) {
    if (scheduledDate == null) return false;
    if (status == DocumentStatus.completed ||
        status == DocumentStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(scheduledDate);
  }

  /// Возвращает количество дней до/после плановой даты.
  static int? getDaysUntilScheduled(DateTime? scheduledDate) {
    if (scheduledDate == null) return null;
    return scheduledDate.difference(DateTime.now()).inDays;
  }

  /// Проверяет, находится ли документ в активной работе.
  static bool isActive(DocumentStatus status) {
    return status == DocumentStatus.inProgress ||
        status == DocumentStatus.newDoc ||
        status == DocumentStatus.draft;
  }

  /// Проверяет, завершен ли документ (любым способом).
  static bool isFinished(DocumentStatus status) {
    return status == DocumentStatus.completed ||
        status == DocumentStatus.cancelled;
  }
}
