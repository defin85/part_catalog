import 'package:json_annotation/json_annotation.dart';

/// Конвертер для преобразования различных представлений флага "по умолчанию"
/// (например, "Y", "N", "X", 0, 1, "true", "false", "DEFAULT") в bool?.
/// Используется с json_serializable (@Freezed).
class DefaultToBoolConverter implements JsonConverter<bool?, Object?> {
  const DefaultToBoolConverter();

  @override
  bool? fromJson(Object? jsonValue) {
    if (jsonValue == null) {
      return null;
    }
    if (jsonValue is bool) {
      return jsonValue;
    }
    if (jsonValue is String) {
      final lowerCaseJson = jsonValue.toLowerCase();
      if (lowerCaseJson == 'true' ||
          lowerCaseJson == 'y' ||
          lowerCaseJson == 'yes' ||
          lowerCaseJson == '1' ||
          lowerCaseJson == 'default' ||
          lowerCaseJson == 'x') {
        // 'x' часто используется как true
        return true;
      }
      if (lowerCaseJson == 'false' ||
          lowerCaseJson == 'n' ||
          lowerCaseJson == 'no' ||
          lowerCaseJson == '0') {
        return false;
      }
    }
    if (jsonValue is int) {
      if (jsonValue == 1) {
        return true;
      }
      if (jsonValue == 0) {
        return false;
      }
    }
    // Если не удалось распознать, можно вернуть null или выбросить исключение,
    // в зависимости от требований к строгости парсинга.
    // В данном случае возвращаем null, если значение не распознано как булево.
    return null;
  }

  @override
  Object? toJson(bool? object) {
    // Преобразование обратно в JSON.
    // Если object равен true, можно вернуть "Y" или 1, если false - "N" или 0.
    // Зависит от того, какой формат ожидает API при записи (если это необходимо).
    // Для простоты, если флаг только читается, можно вернуть сам bool объект.
    // Если API ожидает строку:
    // if (object == true) return 'Y';
    // if (object == false) return 'N';
    return object; // Оставляем как есть для простоты, если запись не требуется или API принимает bool
  }
}

// Пример использования DefaultToBoolConverter в @freezed модели:
/*
import 'package:part_catalog/core/utils/default_to_bool_converter.dart';

@freezed
class UserStructureItem with _$UserStructureItem {
  const factory UserStructureItem({
    // ... другие поля
    @DefaultToBoolConverter() bool? defaultFlag,
  }) = _UserStructureItem;

  factory UserStructureItem.fromJson(Map<String, dynamic> json) =>
      _$UserStructureItemFromJson(json);
}
*/
