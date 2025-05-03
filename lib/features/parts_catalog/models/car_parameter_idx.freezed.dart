// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_idx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarParameterIdx {
  /// Индекс параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarParameterIdxCopyWith<CarParameterIdx> get copyWith =>
      _$CarParameterIdxCopyWithImpl<CarParameterIdx>(
          this as CarParameterIdx, _$identity);

  /// Serializes this CarParameterIdx to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarParameterIdx &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idx);

  @override
  String toString() {
    return 'CarParameterIdx(idx: $idx)';
  }
}

/// @nodoc
abstract mixin class $CarParameterIdxCopyWith<$Res> {
  factory $CarParameterIdxCopyWith(
          CarParameterIdx value, $Res Function(CarParameterIdx) _then) =
      _$CarParameterIdxCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class _$CarParameterIdxCopyWithImpl<$Res>
    implements $CarParameterIdxCopyWith<$Res> {
  _$CarParameterIdxCopyWithImpl(this._self, this._then);

  final CarParameterIdx _self;
  final $Res Function(CarParameterIdx) _then;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_self.copyWith(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarParameterIdx implements CarParameterIdx {
  _CarParameterIdx({@JsonKey(name: 'idx') this.idx});
  factory _CarParameterIdx.fromJson(Map<String, dynamic> json) =>
      _$CarParameterIdxFromJson(json);

  /// Индекс параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarParameterIdxCopyWith<_CarParameterIdx> get copyWith =>
      __$CarParameterIdxCopyWithImpl<_CarParameterIdx>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarParameterIdxToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarParameterIdx &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idx);

  @override
  String toString() {
    return 'CarParameterIdx(idx: $idx)';
  }
}

/// @nodoc
abstract mixin class _$CarParameterIdxCopyWith<$Res>
    implements $CarParameterIdxCopyWith<$Res> {
  factory _$CarParameterIdxCopyWith(
          _CarParameterIdx value, $Res Function(_CarParameterIdx) _then) =
      __$CarParameterIdxCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class __$CarParameterIdxCopyWithImpl<$Res>
    implements _$CarParameterIdxCopyWith<$Res> {
  __$CarParameterIdxCopyWithImpl(this._self, this._then);

  final _CarParameterIdx _self;
  final $Res Function(_CarParameterIdx) _then;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_CarParameterIdx(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
