// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartName {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @JsonKey(name: 'name')
  String get name;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PartNameCopyWith<PartName> get copyWith =>
      _$PartNameCopyWithImpl<PartName>(this as PartName, _$identity);

  /// Serializes this PartName to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PartName &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'PartName(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $PartNameCopyWith<$Res> {
  factory $PartNameCopyWith(PartName value, $Res Function(PartName) _then) =
      _$PartNameCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id, @JsonKey(name: 'name') String name});
}

/// @nodoc
class _$PartNameCopyWithImpl<$Res> implements $PartNameCopyWith<$Res> {
  _$PartNameCopyWithImpl(this._self, this._then);

  final PartName _self;
  final $Res Function(PartName) _then;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PartName implements PartName {
  _PartName(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name});
  factory _PartName.fromJson(Map<String, dynamic> json) =>
      _$PartNameFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PartNameCopyWith<_PartName> get copyWith =>
      __$PartNameCopyWithImpl<_PartName>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PartNameToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PartName &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'PartName(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$PartNameCopyWith<$Res>
    implements $PartNameCopyWith<$Res> {
  factory _$PartNameCopyWith(_PartName value, $Res Function(_PartName) _then) =
      __$PartNameCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id, @JsonKey(name: 'name') String name});
}

/// @nodoc
class __$PartNameCopyWithImpl<$Res> implements _$PartNameCopyWith<$Res> {
  __$PartNameCopyWithImpl(this._self, this._then);

  final _PartName _self;
  final $Res Function(_PartName) _then;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_PartName(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
