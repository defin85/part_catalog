import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/core/document_status.dart';

part 'document_specific_data.freezed.dart';
part 'document_specific_data.g.dart';

/// Данные, специфичные для документов
@freezed
abstract class DocumentSpecificData with _$DocumentSpecificData {
  const factory DocumentSpecificData({
    required DateTime documentDate,
    required DocumentStatus status,
    DateTime? scheduledDate,
    DateTime? completedAt,
    DateTime? postedAt,
    @Default(false) bool isPosted,
    double? totalAmount,
  }) = _DocumentSpecificData;

  factory DocumentSpecificData.fromJson(Map<String, dynamic> json) =>
      _$DocumentSpecificDataFromJson(json);
}