import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_item.freezed.dart';
part 'store_item.g.dart';

@freezed
abstract class StoreItem with _$StoreItem {
  const factory StoreItem({
    @JsonKey(name: 'KEYZAK') required String keyzak,
    @JsonKey(name: 'SKLCODE') required String sklCode,
    @JsonKey(name: 'SKLNAME') required String sklName,
  }) = _StoreItem;

  factory StoreItem.fromJson(Map<String, dynamic> json) =>
      _$StoreItemFromJson(json);
}
