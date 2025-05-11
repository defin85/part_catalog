import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_request.freezed.dart';
part 'user_info_request.g.dart';

@freezed
abstract class UserInfoRequest with _$UserInfoRequest {
  const factory UserInfoRequest({
    @JsonKey(name: 'VKORG') required String vkorg,
    @JsonKey(name: 'STRUCTURE', defaultValue: '1') String? structure,
    @JsonKey(name: 'FTPDATA', defaultValue: '1') String? ftpData,
  }) = _UserInfoRequest;

  factory UserInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UserInfoRequestFromJson(json);
}
