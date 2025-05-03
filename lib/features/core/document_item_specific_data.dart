import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_item_specific_data.freezed.dart';
part 'document_item_specific_data.g.dart';

/// Данные, специфичные для элементов документов
@freezed
abstract class DocumentItemSpecificData with _$DocumentItemSpecificData {
  const factory DocumentItemSpecificData({
    double? price,
    double? quantity,
    @Default(false) bool isCompleted,
  }) = _DocumentItemSpecificData;

  factory DocumentItemSpecificData.fromJson(Map<String, dynamic> json) =>
      _$DocumentItemSpecificDataFromJson(json);
}
