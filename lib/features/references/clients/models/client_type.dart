import 'package:freezed_annotation/freezed_annotation.dart'; // Добавить импорт

/// {@template client_type}
/// Тип клиента.
/// {@endtemplate}
enum ClientType {
  /// {@macro client_type}
  @JsonValue('physical') // Добавить JsonValue
  physical,

  /// {@macro client_type}
  @JsonValue('legal') // Добавить JsonValue
  legal,

  /// {@macro client_type}
  @JsonValue('individualEntrepreneur') // Добавить JsonValue
  individualEntrepreneur,

  /// {@macro client_type}
  @JsonValue('other') // Добавить JsonValue
  other,
}

/// {@template client_type_extension}
/// Расширение для перечисления ClientType.
/// {@endtemplate}
extension ClientTypeExtension on ClientType {
  /// {@macro client_type_extension}
  String get displayName {
    switch (this) {
      case ClientType.physical:
        return 'Физическое лицо';
      case ClientType.legal:
        return 'Юридическое лицо';
      case ClientType.individualEntrepreneur:
        return 'Индивидуальный предприниматель';
      case ClientType.other:
        return 'Другое';
    }
  }

  // Метод fromString больше не нужен, т.к. @freezed/json_serializable справятся
  // static ClientType fromString(String value) { ... }
}

// Расширение ParseToString тоже больше не нужно, т.к. @JsonValue используется
// extension ParseToString on ClientType { ... }
