import 'package:freezed_annotation/freezed_annotation.dart';

// filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\models\user_ftp_data.dart

part 'user_ftp_data.freezed.dart';
part 'user_ftp_data.g.dart';

@freezed
abstract class UserFtpData with _$UserFtpData {
  const factory UserFtpData({
    @JsonKey(name: 'FTP_SERVER') String? server,
    @JsonKey(name: 'FTP_LOGIN') String? login,
    @JsonKey(name: 'FTP_PASSWORD') String? password,
    @JsonKey(name: 'FTP_WORK_DIR') String? workDir,
  }) = _UserFtpData;

  factory UserFtpData.fromJson(Map<String, dynamic> json) =>
      _$UserFtpDataFromJson(json);
}
