import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/core/utils/default_to_bool_converter.dart';

import 'contact_tab_item.dart'; // Новая модель
import 'dogovor_item.dart'; // Новая модель
import 'exw_item.dart'; // Новая модель
import 'we_item.dart'; // Новая модель
import 'za_item.dart'; // Новая модель

part 'user_structure_item.freezed.dart';
part 'user_structure_item.g.dart';

@freezed
abstract class UserStructureItem with _$UserStructureItem {
  const factory UserStructureItem({
    @JsonKey(name: 'KUNNR') String? kunnr,
    @DefaultToBoolConverter() @JsonKey(name: 'DEFAULT') bool? defaultFlag,
    @JsonKey(name: 'SNAME') String? sname,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'ADRESS') String? adress,
    @JsonKey(name: 'PHONE') String? phone,
    @JsonKey(name: 'WE_TAB') List<WeItem>? weTab,
    @JsonKey(name: 'ZA_TAB') List<ZaItem>? zaTab,
    @JsonKey(name: 'EXW_TAB') List<ExwItem>? exwTab,
    @JsonKey(name: 'DOGOVOR_TAB') List<DogovorItem>? dogovorTab,
    @JsonKey(name: 'CONTACT_TAB') List<ContactTabItem>? contactTab,
  }) = _UserStructureItem;

  factory UserStructureItem.fromJson(Map<String, dynamic> json) =>
      _$UserStructureItemFromJson(json);
}