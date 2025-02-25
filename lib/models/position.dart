import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

/// {@template position}
/// Модель данных для позиции блока с номером на изображении.
/// {@endtemplate}
@freezed
class Position with _$Position {
  /// {@macro position}
  factory Position({
    /// Номер на изображении.
    @JsonKey(name: 'number') String? number,

    /// Координаты блока с номером на изображении (X, Y, H, W).
    @JsonKey(name: 'coordinates') List<double>? coordinates,
  }) = _Position;

  /// Преобразует JSON в объект [Position].
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}
