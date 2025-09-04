import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/core/utils/default_to_bool_converter.dart';

part 'we_item.freezed.dart';
part 'we_item.g.dart';

@freezed
abstract class WeItem with _$WeItem {
  const factory WeItem({
    @JsonKey(name: 'KUNNR') String? kunnr,
    @JsonKey(name: 'WERKS') String? werks,
    @DefaultToBoolConverter() @JsonKey(name: 'DEFAULT') bool? defaultFlag,
    @JsonKey(name: 'SNAME') String? sname,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'ADRESS') String? adress,
    @JsonKey(name: 'PHONE') String? phone,
  }) = _WeItem;

  factory WeItem.fromJson(Map<String, dynamic> json) => _$WeItemFromJson(json);
}
