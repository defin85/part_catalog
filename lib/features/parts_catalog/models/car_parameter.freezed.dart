// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameter _$CarParameterFromJson(Map<String, dynamic> json) {
  return _CarParameter.fromJson(json);
}

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterCopyWith<CarParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) then) =
      _$CarParameterCopyWithImpl<$Res, CarParameter>;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res, $Val extends CarParameter>
    implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterImplCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$$CarParameterImplCopyWith(
          _$CarParameterImpl value, $Res Function(_$CarParameterImpl) then) =
      __$$CarParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$$CarParameterImplCopyWithImpl<$Res>
    extends _$CarParameterCopyWithImpl<$Res, _$CarParameterImpl>
    implements _$$CarParameterImplCopyWith<$Res> {
  __$$CarParameterImplCopyWithImpl(
      _$CarParameterImpl _value, $Res Function(_$CarParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$CarParameterImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterImpl implements _CarParameter {
  _$CarParameterImpl(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});

  factory _$CarParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterImplFromJson(json);

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  final String? value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterImpl &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, key, name, value, sortOrder);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      __$$CarParameterImplCopyWithImpl<_$CarParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterImplToJson(
      this,
    );
  }
}

abstract class _CarParameter implements CarParameter {
  factory _CarParameter(
      {@JsonKey(name: 'idx') final String? idx,
      @JsonKey(name: 'key') final String? key,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'value') final String? value,
      @JsonKey(name: 'sortOrder') final int? sortOrder}) = _$CarParameterImpl;

  factory _CarParameter.fromJson(Map<String, dynamic> json) =
      _$CarParameterImpl.fromJson;

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
