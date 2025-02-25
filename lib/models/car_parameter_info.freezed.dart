// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameterInfo _$CarParameterInfoFromJson(Map<String, dynamic> json) {
  return _CarParameterInfo.fromJson(json);
}

/// @nodoc
mixin _$CarParameterInfo {
  /// Ключ параметра.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Список значений параметра.
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterInfoCopyWith<CarParameterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterInfoCopyWith<$Res> {
  factory $CarParameterInfoCopyWith(
          CarParameterInfo value, $Res Function(CarParameterInfo) then) =
      _$CarParameterInfoCopyWithImpl<$Res, CarParameterInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterInfoCopyWithImpl<$Res, $Val extends CarParameterInfo>
    implements $CarParameterInfoCopyWith<$Res> {
  _$CarParameterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? values = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterInfoImplCopyWith<$Res>
    implements $CarParameterInfoCopyWith<$Res> {
  factory _$$CarParameterInfoImplCopyWith(_$CarParameterInfoImpl value,
          $Res Function(_$CarParameterInfoImpl) then) =
      __$$CarParameterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$$CarParameterInfoImplCopyWithImpl<$Res>
    extends _$CarParameterInfoCopyWithImpl<$Res, _$CarParameterInfoImpl>
    implements _$$CarParameterInfoImplCopyWith<$Res> {
  __$$CarParameterInfoImplCopyWithImpl(_$CarParameterInfoImpl _value,
      $Res Function(_$CarParameterInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? values = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$CarParameterInfoImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterInfoImpl implements _CarParameterInfo {
  _$CarParameterInfoImpl(
      {@JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'values') final List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') this.sortOrder})
      : _values = values;

  factory _$CarParameterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterInfoImplFromJson(json);

  /// Ключ параметра.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Список значений параметра.
  final List<CarFilterValues>? _values;

  /// Список значений параметра.
  @override
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values {
    final value = _values;
    if (value == null) return null;
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Порядок сортировки параметра.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  @override
  String toString() {
    return 'CarParameterInfo(key: $key, name: $name, values: $values, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterInfoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name,
      const DeepCollectionEquality().hash(_values), sortOrder);

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterInfoImplCopyWith<_$CarParameterInfoImpl> get copyWith =>
      __$$CarParameterInfoImplCopyWithImpl<_$CarParameterInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterInfoImplToJson(
      this,
    );
  }
}

abstract class _CarParameterInfo implements CarParameterInfo {
  factory _CarParameterInfo(
          {@JsonKey(name: 'key') final String? key,
          @JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'values') final List<CarFilterValues>? values,
          @JsonKey(name: 'sortOrder') final int? sortOrder}) =
      _$CarParameterInfoImpl;

  factory _CarParameterInfo.fromJson(Map<String, dynamic> json) =
      _$CarParameterInfoImpl.fromJson;

  /// Ключ параметра.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Список значений параметра.
  @override
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values;

  /// Порядок сортировки параметра.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterInfoImplCopyWith<_$CarParameterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CarFilterValues _$CarFilterValuesFromJson(Map<String, dynamic> json) {
  return _CarFilterValues.fromJson(json);
}

/// @nodoc
mixin _$CarFilterValues {
  /// Идентификатор значения.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Текст значения.
  @JsonKey(name: 'text')
  String? get text => throw _privateConstructorUsedError;

  /// Serializes this CarFilterValues to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarFilterValuesCopyWith<CarFilterValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarFilterValuesCopyWith<$Res> {
  factory $CarFilterValuesCopyWith(
          CarFilterValues value, $Res Function(CarFilterValues) then) =
      _$CarFilterValuesCopyWithImpl<$Res, CarFilterValues>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class _$CarFilterValuesCopyWithImpl<$Res, $Val extends CarFilterValues>
    implements $CarFilterValuesCopyWith<$Res> {
  _$CarFilterValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarFilterValuesImplCopyWith<$Res>
    implements $CarFilterValuesCopyWith<$Res> {
  factory _$$CarFilterValuesImplCopyWith(_$CarFilterValuesImpl value,
          $Res Function(_$CarFilterValuesImpl) then) =
      __$$CarFilterValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class __$$CarFilterValuesImplCopyWithImpl<$Res>
    extends _$CarFilterValuesCopyWithImpl<$Res, _$CarFilterValuesImpl>
    implements _$$CarFilterValuesImplCopyWith<$Res> {
  __$$CarFilterValuesImplCopyWithImpl(
      _$CarFilterValuesImpl _value, $Res Function(_$CarFilterValuesImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_$CarFilterValuesImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarFilterValuesImpl implements _CarFilterValues {
  _$CarFilterValuesImpl(
      {@JsonKey(name: 'id') this.id, @JsonKey(name: 'text') this.text});

  factory _$CarFilterValuesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarFilterValuesImplFromJson(json);

  /// Идентификатор значения.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Текст значения.
  @override
  @JsonKey(name: 'text')
  final String? text;

  @override
  String toString() {
    return 'CarFilterValues(id: $id, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarFilterValuesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarFilterValuesImplCopyWith<_$CarFilterValuesImpl> get copyWith =>
      __$$CarFilterValuesImplCopyWithImpl<_$CarFilterValuesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarFilterValuesImplToJson(
      this,
    );
  }
}

abstract class _CarFilterValues implements CarFilterValues {
  factory _CarFilterValues(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'text') final String? text}) = _$CarFilterValuesImpl;

  factory _CarFilterValues.fromJson(Map<String, dynamic> json) =
      _$CarFilterValuesImpl.fromJson;

  /// Идентификатор значения.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Текст значения.
  @override
  @JsonKey(name: 'text')
  String? get text;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarFilterValuesImplCopyWith<_$CarFilterValuesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
