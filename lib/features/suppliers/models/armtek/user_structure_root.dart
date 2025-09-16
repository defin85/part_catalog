import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_structure_item.dart';

part 'user_structure_root.freezed.dart';
part 'user_structure_root.g.dart';

@freezed
abstract class UserStructureRoot with _$UserStructureRoot {
  const factory UserStructureRoot({
    @JsonKey(name: 'KUNAG') String? kunag,
    @JsonKey(name: 'VKORG') String? vkorg,
    @JsonKey(name: 'SNAME') String? sname,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'ADRESS') String? adress, // В JSON "ADRESS"
    @JsonKey(name: 'PHONE') String? phone,
    @JsonKey(name: 'RG_TAB') List<UserStructureItem>? rgTab,
    // CONTACT_TAB и DOGOVOR_TAB находятся внутри каждого элемента RG_TAB, а не на корневом уровне
  }) = _UserStructureRoot;

  factory UserStructureRoot.fromJson(Map<String, dynamic> json) =>
      _$UserStructureRootFromJson(json);
}
