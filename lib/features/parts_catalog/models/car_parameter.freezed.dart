// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarParameterCopyWith<CarParameter> get copyWith =>
      _$CarParameterCopyWithImpl<CarParameter>(
          this as CarParameter, _$identity);

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarParameter &&
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

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) _then) =
      _$CarParameterCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res> implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._self, this._then);

  final CarParameter _self;
  final $Res Function(CarParameter) _then;

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
    return _then(_self.copyWith(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarParameter implements CarParameter {
  _CarParameter(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});
  factory _CarParameter.fromJson(Map<String, dynamic> json) =>
      _$CarParameterFromJson(json);

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

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarParameterCopyWith<_CarParameter> get copyWith =>
      __$CarParameterCopyWithImpl<_CarParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarParameterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarParameter &&
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

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$CarParameterCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$CarParameterCopyWith(
          _CarParameter value, $Res Function(_CarParameter) _then) =
      __$CarParameterCopyWithImpl;
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
class __$CarParameterCopyWithImpl<$Res>
    implements _$CarParameterCopyWith<$Res> {
  __$CarParameterCopyWithImpl(this._self, this._then);

  final _CarParameter _self;
  final $Res Function(_CarParameter) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_CarParameter(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
