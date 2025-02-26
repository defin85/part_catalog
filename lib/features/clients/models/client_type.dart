/// {@template client_type}
/// Тип клиента.
/// {@endtemplate}
enum ClientType {
  /// {@macro client_type}
  physical,

  /// {@macro client_type}
  legal,

  /// {@macro client_type}
  individualEntrepreneur,

  /// {@macro client_type}
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

  static ClientType fromString(String value) {
    switch (value) {
      case 'physical':
        return ClientType.physical;
      case 'legal':
        return ClientType.legal;
      case 'individualEntrepreneur':
        return ClientType.individualEntrepreneur;
      case 'other':
        return ClientType.other;
      default:
        return ClientType.physical;
    }
  }
}

extension ParseToString on ClientType {
  String toShortString() {
    return toString().split('.').last;
  }
}
