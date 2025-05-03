import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_specific_data.freezed.dart';
part 'order_specific_data.g.dart';

/// Данные, специфичные для Заказ-наряда
@freezed
abstract class OrderSpecificData with _$OrderSpecificData {
  const factory OrderSpecificData({
    String? clientId,
    String? carId,
    String? description,
    // ... другие поля, специфичные для OrderModel ...
  }) = _OrderSpecificData;

  factory OrderSpecificData.fromJson(Map<String, dynamic> json) =>
      _$OrderSpecificDataFromJson(json);
}
