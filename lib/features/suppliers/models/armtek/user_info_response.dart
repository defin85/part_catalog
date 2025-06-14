// filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\models\user_info_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_structure_root.dart';
import 'user_ftp_data.dart';

part 'user_info_response.freezed.dart';
part 'user_info_response.g.dart';

@freezed
abstract class UserInfoResponse with _$UserInfoResponse {
  const factory UserInfoResponse({
    @JsonKey(name: 'STRUCTURE') UserStructureRoot? structure,
    @JsonKey(name: 'FTPDATA') UserFtpData? ftpData,
  }) = _UserInfoResponse;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
}
