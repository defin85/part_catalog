import 'package:freezed_annotation/freezed_annotation.dart';

part 'armtek_message.freezed.dart';
part 'armtek_message.g.dart';

@freezed
abstract class ArmtekMessage with _$ArmtekMessage {
  const factory ArmtekMessage({
    @JsonKey(name: 'TYPE') required String type,
    @JsonKey(name: 'TEXT') required String text,
    @JsonKey(name: 'DATE')
    required String date, // Можно преобразовать в DateTime при необходимости
  }) = _ArmtekMessage;

  factory ArmtekMessage.fromJson(Map<String, dynamic> json) =>
      _$ArmtekMessageFromJson(json);
}
