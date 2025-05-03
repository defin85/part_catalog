// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Position {
  /// Номер на изображении.
  @JsonKey(name: 'number')
  String? get number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PositionCopyWith<Position> get copyWith =>
      _$PositionCopyWithImpl<Position>(this as Position, _$identity);

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Position &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other.coordinates, coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(coordinates));

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) _then) =
      _$PositionCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res> implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._self, this._then);

  final Position _self;
  final $Res Function(Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_self.copyWith(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Position implements Position {
  _Position(
      {@JsonKey(name: 'number') this.number,
      @JsonKey(name: 'coordinates') final List<double>? coordinates})
      : _coordinates = coordinates;
  factory _Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  final List<double>? _coordinates;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PositionCopyWith<_Position> get copyWith =>
      __$PositionCopyWithImpl<_Position>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PositionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Position &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(_coordinates));

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class _$PositionCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$PositionCopyWith(_Position value, $Res Function(_Position) _then) =
      __$PositionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class __$PositionCopyWithImpl<$Res> implements _$PositionCopyWith<$Res> {
  __$PositionCopyWithImpl(this._self, this._then);

  final _Position _self;
  final $Res Function(_Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_Position(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

// dart format on
