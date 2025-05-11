// filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\models\user_structure_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_contact.dart';
import 'user_delivery_address.dart';

part 'user_structure_item.freezed.dart';
part 'user_structure_item.g.dart';

@freezed
abstract class UserStructureItem with _$UserStructureItem {
  const factory UserStructureItem({
    @JsonKey(name: 'KUNNR') String? kunnr,
    @JsonKey(name: 'NAME1') String? name1,
    @JsonKey(name: 'NAME2') String? name2,
    @JsonKey(name: 'ORT01') String? city,
    @JsonKey(name: 'STRAS') String? street,
    @JsonKey(name: 'KUNNR_RG') String? payerKunnr,
    @JsonKey(name: 'KUNNR_WE') String? consigneeKunnr,
    @JsonKey(name: 'PARVW') String? partnerRole,
    @JsonKey(name: 'CONTACTS') List<UserContact>? contacts,
    @JsonKey(name: 'DELIVERY_ADDRESSES')
    List<UserDeliveryAddress>? deliveryAddresses,
  }) = _UserStructureItem;

  factory UserStructureItem.fromJson(Map<String, dynamic> json) =>
      _$UserStructureItemFromJson(json);
}
