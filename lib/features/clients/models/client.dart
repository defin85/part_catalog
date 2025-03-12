import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';

part 'client.freezed.dart';
part 'client.g.dart';

/// {@template client_model}
/// Модель данных для представления клиента.
/// {@endtemplate}
@freezed
class ClientModel with _$ClientModel {
  /// {@macro client_model}
  const factory ClientModel({
    /// Уникальный идентификатор клиента.
    required int id,

    /// Тип клиента (physical, legal, individualEntrepreneur, other).
    required ClientType type,

    /// ФИО для физического лица или название организации для юридического лица.
    required String name,

    /// Контактная информация (телефон, email, адрес).
    required String contactInfo,

    /// Дополнительная информация.
    String? additionalInfo,
  }) = _ClientModel;

  /// Преобразование JSON в объект `ClientModel`.
  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);
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
