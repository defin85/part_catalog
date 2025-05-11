// filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\models\user_contact.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_contact.freezed.dart';
part 'user_contact.g.dart';

@freezed
abstract class UserContact with _$UserContact {
  const factory UserContact({
    @JsonKey(name: 'NAME_CON') String? name,
    @JsonKey(name: 'TEL_CON') String? telephone,
    @JsonKey(name: 'MOB_CON') String? mobile,
    @JsonKey(name: 'EMAIL_CON') String? email,
  }) = _UserContact;

  factory UserContact.fromJson(Map<String, dynamic> json) =>
      _$UserContactFromJson(json);
}
