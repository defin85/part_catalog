// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_idx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameterIdx _$CarParameterIdxFromJson(Map<String, dynamic> json) {
  return _CarParameterIdx.fromJson(json);
}

/// @nodoc
mixin _$CarParameterIdx {
  /// Индекс параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Serializes this CarParameterIdx to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterIdxCopyWith<CarParameterIdx> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterIdxCopyWith<$Res> {
  factory $CarParameterIdxCopyWith(
          CarParameterIdx value, $Res Function(CarParameterIdx) then) =
      _$CarParameterIdxCopyWithImpl<$Res, CarParameterIdx>;
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class _$CarParameterIdxCopyWithImpl<$Res, $Val extends CarParameterIdx>
    implements $CarParameterIdxCopyWith<$Res> {
  _$CarParameterIdxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterIdxImplCopyWith<$Res>
    implements $CarParameterIdxCopyWith<$Res> {
  factory _$$CarParameterIdxImplCopyWith(_$CarParameterIdxImpl value,
          $Res Function(_$CarParameterIdxImpl) then) =
      __$$CarParameterIdxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class __$$CarParameterIdxImplCopyWithImpl<$Res>
    extends _$CarParameterIdxCopyWithImpl<$Res, _$CarParameterIdxImpl>
    implements _$$CarParameterIdxImplCopyWith<$Res> {
  __$$CarParameterIdxImplCopyWithImpl(
      _$CarParameterIdxImpl _value, $Res Function(_$CarParameterIdxImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_$CarParameterIdxImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterIdxImpl implements _CarParameterIdx {
  _$CarParameterIdxImpl({@JsonKey(name: 'idx') this.idx});

  factory _$CarParameterIdxImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterIdxImplFromJson(json);

  /// Индекс параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  @override
  String toString() {
    return 'CarParameterIdx(idx: $idx)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterIdxImpl &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idx);

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterIdxImplCopyWith<_$CarParameterIdxImpl> get copyWith =>
      __$$CarParameterIdxImplCopyWithImpl<_$CarParameterIdxImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterIdxImplToJson(
      this,
    );
  }
}

abstract class _CarParameterIdx implements CarParameterIdx {
  factory _CarParameterIdx({@JsonKey(name: 'idx') final String? idx}) =
      _$CarParameterIdxImpl;

  factory _CarParameterIdx.fromJson(Map<String, dynamic> json) =
      _$CarParameterIdxImpl.fromJson;

  /// Индекс параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterIdxImplCopyWith<_$CarParameterIdxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
