import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/references/clients/models/client_type.dart';

part 'client_specific_data.freezed.dart';
part 'client_specific_data.g.dart';

/// {@template client_specific_data}
/// Специфичные данные для сущности "Клиент".
/// Содержит поля, уникальные для клиентов.
/// {@endtemplate}
@freezed
abstract class ClientSpecificData with _$ClientSpecificData {
  /// {@macro client_specific_data}
  const factory ClientSpecificData({
    /// Тип клиента (physical, legal, individualEntrepreneur, other).
    @JsonKey(name: 'type') required ClientType type,

    /// Отображаемое имя клиента
    @JsonKey(name: 'displayName') required String displayName,

    /// Телефон клиента
    @JsonKey(name: 'phone') String? phone,

    /// Email клиента
    @JsonKey(name: 'email') String? email,

    /// Является ли клиент физическим лицом
    @JsonKey(name: 'isIndividual') required bool isIndividual,

    /// Контактная информация (телефон, email, адрес).
    /// Может быть строкой или отдельной моделью Value Object.
    @JsonKey(name: 'contactInfo') required String contactInfo,

    /// Дополнительная информация.
    @JsonKey(name: 'additionalInfo') String? additionalInfo,

    // Другие специфичные поля для клиента
    /// ИНН (для юридических лиц)
    @JsonKey(name: 'inn') String? inn,

    /// КПП (для юридических лиц)
    @JsonKey(name: 'kpp') String? kpp,

    /// Юридический адрес
    @JsonKey(name: 'legalAddress') String? legalAddress,

    /// Фактический адрес
    @JsonKey(name: 'actualAddress') String? actualAddress,
  }) = _ClientSpecificData;

  /// Преобразование JSON в объект `ClientSpecificData`.
  factory ClientSpecificData.fromJson(Map<String, dynamic> json) =>
      _$ClientSpecificDataFromJson(json);
}
