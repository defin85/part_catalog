import 'package:freezed_annotation/freezed_annotation.dart';
import 'exw_item.dart'; // Новая модель
import 'za_item.dart'; // Новая модель
import 'dogovor_item.dart'; // Новая модель
import 'contact_tab_item.dart'; // Новая модель

part 'user_structure_item.freezed.dart';
part 'user_structure_item.g.dart';

@freezed
abstract class UserStructureItem with _$UserStructureItem {
  const factory UserStructureItem({
    @JsonKey(name: 'KUNNR') String? kunnr,
    @JsonKey(name: 'DEFAULT') int? defaultFlag,
    @JsonKey(name: 'SNAME') String? sname,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'ADRESS') String? adress,
    @JsonKey(name: 'PHONE') String? phone,
    @JsonKey(name: 'WE_TAB') List<ExwItem>? weTab,
    @JsonKey(name: 'ZA_TAB') List<ZaItem>? zaTab,
    @JsonKey(name: 'EXW_TAB') List<ExwItem>? exwTab,
    @JsonKey(name: 'DOGOVOR_TAB') List<DogovorItem>? dogovorTab,
    @JsonKey(name: 'CONTACT_TAB') List<ContactTabItem>? contactTab,
  }) = _UserStructureItem;

  factory UserStructureItem.fromJson(Map<String, dynamic> json) =>
      _$UserStructureItemFromJson(json);
}
