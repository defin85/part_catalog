import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_vkorg.freezed.dart';
part 'user_vkorg.g.dart';

@freezed
abstract class UserVkorg with _$UserVkorg {
  const factory UserVkorg({
    @JsonKey(name: 'VKORG') required String vkorg,
    @JsonKey(name: 'PROGRAM_NAME') required String programName,
  }) = _UserVkorg;

  factory UserVkorg.fromJson(Map<String, dynamic> json) =>
      _$UserVkorgFromJson(json);
}
