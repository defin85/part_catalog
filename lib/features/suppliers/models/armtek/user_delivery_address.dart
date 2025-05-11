// filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\models\user_delivery_address.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_delivery_address.freezed.dart';
part 'user_delivery_address.g.dart';

@freezed
abstract class UserDeliveryAddress with _$UserDeliveryAddress {
  const factory UserDeliveryAddress({
    @JsonKey(name: 'ADDRESS_CODE') String? addressCode,
    @JsonKey(name: 'ADDRESS_NAME') String? addressName,
  }) = _UserDeliveryAddress;

  factory UserDeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$UserDeliveryAddressFromJson(json);
}
