// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarParameterInfo {
  /// Ключ параметра.
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра.
  @JsonKey(name: 'name')
  String? get name;

  /// Список значений параметра.
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values;

  /// Порядок сортировки параметра.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarParameterInfoCopyWith<CarParameterInfo> get copyWith =>
      _$CarParameterInfoCopyWithImpl<CarParameterInfo>(
          this as CarParameterInfo, _$identity);

  /// Serializes this CarParameterInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarParameterInfo &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.values, values) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name,
      const DeepCollectionEquality().hash(values), sortOrder);

  @override
  String toString() {
    return 'CarParameterInfo(key: $key, name: $name, values: $values, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $CarParameterInfoCopyWith<$Res> {
  factory $CarParameterInfoCopyWith(
          CarParameterInfo value, $Res Function(CarParameterInfo) _then) =
      _$CarParameterInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterInfoCopyWithImpl<$Res>
    implements $CarParameterInfoCopyWith<$Res> {
  _$CarParameterInfoCopyWithImpl(this._self, this._then);

  final CarParameterInfo _self;
  final $Res Function(CarParameterInfo) _then;

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
    return _then(_self.copyWith(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _self.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarParameterInfo implements CarParameterInfo {
  _CarParameterInfo(
      {@JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'values') final List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') this.sortOrder})
      : _values = values;
  factory _CarParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$CarParameterInfoFromJson(json);

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

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarParameterInfoCopyWith<_CarParameterInfo> get copyWith =>
      __$CarParameterInfoCopyWithImpl<_CarParameterInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarParameterInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarParameterInfo &&
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

  @override
  String toString() {
    return 'CarParameterInfo(key: $key, name: $name, values: $values, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$CarParameterInfoCopyWith<$Res>
    implements $CarParameterInfoCopyWith<$Res> {
  factory _$CarParameterInfoCopyWith(
          _CarParameterInfo value, $Res Function(_CarParameterInfo) _then) =
      __$CarParameterInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$CarParameterInfoCopyWithImpl<$Res>
    implements _$CarParameterInfoCopyWith<$Res> {
  __$CarParameterInfoCopyWithImpl(this._self, this._then);

  final _CarParameterInfo _self;
  final $Res Function(_CarParameterInfo) _then;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? values = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_CarParameterInfo(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _self._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$CarFilterValues {
  /// Идентификатор значения.
  @JsonKey(name: 'id')
  String? get id;

  /// Текст значения.
  @JsonKey(name: 'text')
  String? get text;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarFilterValuesCopyWith<CarFilterValues> get copyWith =>
      _$CarFilterValuesCopyWithImpl<CarFilterValues>(
          this as CarFilterValues, _$identity);

  /// Serializes this CarFilterValues to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarFilterValues &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  @override
  String toString() {
    return 'CarFilterValues(id: $id, text: $text)';
  }
}

/// @nodoc
abstract mixin class $CarFilterValuesCopyWith<$Res> {
  factory $CarFilterValuesCopyWith(
          CarFilterValues value, $Res Function(CarFilterValues) _then) =
      _$CarFilterValuesCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class _$CarFilterValuesCopyWithImpl<$Res>
    implements $CarFilterValuesCopyWith<$Res> {
  _$CarFilterValuesCopyWithImpl(this._self, this._then);

  final CarFilterValues _self;
  final $Res Function(CarFilterValues) _then;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarFilterValues implements CarFilterValues {
  _CarFilterValues(
      {@JsonKey(name: 'id') this.id, @JsonKey(name: 'text') this.text});
  factory _CarFilterValues.fromJson(Map<String, dynamic> json) =>
      _$CarFilterValuesFromJson(json);

  /// Идентификатор значения.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Текст значения.
  @override
  @JsonKey(name: 'text')
  final String? text;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarFilterValuesCopyWith<_CarFilterValues> get copyWith =>
      __$CarFilterValuesCopyWithImpl<_CarFilterValues>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarFilterValuesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarFilterValues &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  @override
  String toString() {
    return 'CarFilterValues(id: $id, text: $text)';
  }
}

/// @nodoc
abstract mixin class _$CarFilterValuesCopyWith<$Res>
    implements $CarFilterValuesCopyWith<$Res> {
  factory _$CarFilterValuesCopyWith(
          _CarFilterValues value, $Res Function(_CarFilterValues) _then) =
      __$CarFilterValuesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class __$CarFilterValuesCopyWithImpl<$Res>
    implements _$CarFilterValuesCopyWith<$Res> {
  __$CarFilterValuesCopyWithImpl(this._self, this._then);

  final _CarFilterValues _self;
  final $Res Function(_CarFilterValues) _then;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_CarFilterValues(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
