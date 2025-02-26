import 'package:freezed_annotation/freezed_annotation.dart';

part 'ip.freezed.dart';
part 'ip.g.dart';

/// {@template ip}
/// Модель данных для IP-адреса.
/// {@endtemplate}
@freezed
class Ip with _$Ip {
  /// {@macro ip}
  factory Ip({
    /// IP-адрес.
    @JsonKey(name: 'ip') String? ip,
  }) = _Ip;

  /// Преобразует JSON в объект [Ip].
  factory Ip.fromJson(Map<String, dynamic> json) => _$IpFromJson(json);
}
