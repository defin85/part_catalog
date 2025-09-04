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

    /// Контактная информация (телефон, email, адрес).
    /// Может быть строкой или отдельной моделью Value Object.
    @JsonKey(name: 'contactInfo') required String contactInfo,

    /// Дополнительная информация.
    @JsonKey(name: 'additionalInfo') String? additionalInfo,

    // Другие специфичные поля для клиента, если нужны
    // Например:
    // String? inn;
    // String? kpp;
    // String? legalAddress;
    // String? actualAddress;
  }) = _ClientSpecificData;

  /// Преобразование JSON в объект `ClientSpecificData`.
  factory ClientSpecificData.fromJson(Map<String, dynamic> json) =>
      _$ClientSpecificDataFromJson(json);
}
