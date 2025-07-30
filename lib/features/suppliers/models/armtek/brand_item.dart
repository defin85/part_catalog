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

  // Фабричный метод для создания из строки (когда API возвращает список строк)
  factory BrandItem.fromString(String? brandString) {
    final safeString = brandString ?? 'UNKNOWN';
    return BrandItem(
      brand: safeString,
      brandName: safeString, // Используем ту же строку для имени бренда
    );
  }
}
