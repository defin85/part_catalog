import 'package:json_annotation/json_annotation.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';

part 'client.g.dart';

/// {@template client}
/// Модель данных для представления клиента.
/// {@endtemplate}
@JsonSerializable(converters: [ClientTypeConverter()]) // Add converter
class Client {
  /// {@macro client}
  Client({
    required this.id,
    required this.type,
    required this.name,
    required this.contactInfo,
    this.additionalInfo,
  });

  /// Уникальный идентификатор клиента.
  @JsonKey(name: 'id')
  final int id; // Изменено с String на int

  /// Тип клиента (physical, legal, individualEntrepreneur, other).
  @JsonKey(name: 'type')
  final ClientType type;

  /// ФИО для физического лица или название организации для юридического лица.
  @JsonKey(name: 'name')
  final String name;

  /// Контактная информация (телефон, email, адрес).
  @JsonKey(name: 'contactInfo')
  final String contactInfo;

  /// Дополнительная информация.
  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  /// Преобразование JSON в объект `Client`.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Преобразование объекта `Client` в JSON.
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}

/// {@template client_type_converter}
/// Конвертер для преобразования ClientType из/в JSON.
/// {@endtemplate}
class ClientTypeConverter implements JsonConverter<ClientType, String> {
  /// {@macro client_type_converter}
  const ClientTypeConverter();

  @override
  ClientType fromJson(String json) {
    switch (json) {
      case 'Физическое лицо':
        return ClientType.physical;
      case 'Юридическое лицо':
        return ClientType.legal;
      case 'Индивидуальный предприниматель':
        return ClientType.individualEntrepreneur;
      case 'Другое':
        return ClientType.other;
      default:
        throw ArgumentError('Unknown ClientType: $json');
    }
  }

  @override
  String toJson(ClientType object) {
    return object.displayName;
  }
}
