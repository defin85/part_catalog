import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_specific_data.freezed.dart';
part 'part_specific_data.g.dart';

/// Данные, специфичные для Запчасти в Заказ-наряде
@freezed
abstract class PartSpecificData with _$PartSpecificData {
  const factory PartSpecificData({
    required String documentUuid, // ID родительского документа
    required String partNumber,
    String? brand,
    String? supplierName,
    int? deliveryDays,
    @Default(false) bool isOrdered,
    @Default(false) bool isReceived,
  }) = _PartSpecificData;

  factory PartSpecificData.fromJson(Map<String, dynamic> json) =>
      _$PartSpecificDataFromJson(json);
}
