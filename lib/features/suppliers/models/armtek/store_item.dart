import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_item.freezed.dart';
part 'store_item.g.dart';

@freezed
abstract class StoreItem with _$StoreItem {
  const factory StoreItem({
    @JsonKey(name: 'KEYZAK') required String keyzak,
    @JsonKey(name: 'KEYZAK_NAME') required String keyzakName,
    @JsonKey(name: 'WERKS') String? werks,
    @JsonKey(name: 'ACTIVE') String? active,
  }) = _StoreItem;

  factory StoreItem.fromJson(Map<String, dynamic> json) =>
      _$StoreItemFromJson(json);
}
