import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_structure_item.dart';
import 'contact_tab_item.dart';
import 'dogovor_item.dart';

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
    @JsonKey(name: 'CONTACT_TAB') List<ContactTabItem>? contactTab,
    @JsonKey(name: 'DOGOVOR_TAB') List<DogovorItem>? dogovorTab,
  }) = _UserStructureRoot;

  factory UserStructureRoot.fromJson(Map<String, dynamic> json) =>
      _$UserStructureRootFromJson(json);
}
