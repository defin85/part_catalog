// filepath: c:\FlutterProject\part_catalog\lib\features\suppliers\models\armtek\contact_tab_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_tab_item.freezed.dart';
part 'contact_tab_item.g.dart';

@freezed
abstract class ContactTabItem with _$ContactTabItem {
  const factory ContactTabItem({
    @JsonKey(name: 'PARNR') String? parnr,
    @JsonKey(name: 'DEFAULT') int? defaultFlag,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'LNAME') String? lname,
    @JsonKey(name: 'MNAME') String? mname,
    @JsonKey(name: 'PHONE') String? phone,
    @JsonKey(name: 'EMAIL') String? email,
  }) = _ContactTabItem;

  factory ContactTabItem.fromJson(Map<String, dynamic> json) =>
      _$ContactTabItemFromJson(json);
}
