import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/core/document_status.dart';

part 'document_specific_data.freezed.dart';
part 'document_specific_data.g.dart';

/// Данные, специфичные для документов
@freezed
abstract class DocumentSpecificData with _$DocumentSpecificData {
  const factory DocumentSpecificData({
    required DocumentStatus status,
    required DateTime documentDate,
    @Default(false) bool isPosted,
    DateTime? postedAt,
    DateTime? scheduledDate, // Планируемая дата
    DateTime? completedAt, // Дата завершения
    double? totalAmount, // Итоговая сумма
  }) = _DocumentSpecificData;

  factory DocumentSpecificData.fromJson(Map<String, dynamic> json) =>
      _$DocumentSpecificDataFromJson(json);
}
