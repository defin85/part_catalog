import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

/// Результат поиска запчасти
@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    @JsonKey(name: 'PIN') String? articleNumber,
    @JsonKey(name: 'BRAND') String? brand,
    @JsonKey(name: 'NAME') String? name,
    @JsonKey(name: 'PRICE') double? price,
    @JsonKey(name: 'QUANTITY') int? quantity,
    @JsonKey(name: 'DELIVERY_TIME') int? deliveryTime,
    @JsonKey(name: 'SUPPLIER') String? supplier,
    Map<String, dynamic>? additionalData,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
