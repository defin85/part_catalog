import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_status_response.freezed.dart';
part 'price_status_response.g.dart';

/// Ответ на запрос статуса прайса
@freezed
abstract class PriceStatusResponse with _$PriceStatusResponse {
  const factory PriceStatusResponse({
    String? status,
    String? message,
    @JsonKey(name: 'processed_count') int? processedCount,
    @JsonKey(name: 'total_count') int? totalCount,
    Map<String, dynamic>? additionalData,
  }) = _PriceStatusResponse;

  factory PriceStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PriceStatusResponseFromJson(json);
}
