import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_item.freezed.dart';
part 'brand_item.g.dart';

@freezed
abstract class BrandItem with _$BrandItem {
  const factory BrandItem({
    @JsonKey(name: 'BRAND') required String brand,
    @JsonKey(name: 'BRAND_NAME') required String brandName,
  }) = _BrandItem;

  factory BrandItem.fromJson(Map<String, dynamic> json) =>
      _$BrandItemFromJson(json);
}
