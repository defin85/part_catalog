import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_specific_data.freezed.dart';
part 'service_specific_data.g.dart';

/// Данные, специфичные для Услуги в Заказ-наряде
@freezed
abstract class ServiceSpecificData with _$ServiceSpecificData {
  const factory ServiceSpecificData({
    required String documentUuid, // ID родительского документа
    double? duration, // Продолжительность в часах
    String? performedBy, // Исполнитель
    String? description,
    // Можно добавить другие специфичные поля для услуг
  }) = _ServiceSpecificData;

  factory ServiceSpecificData.fromJson(Map<String, dynamic> json) =>
      _$ServiceSpecificDataFromJson(json);
}
