// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schemas_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchemasResponse {
  /// Группа (может быть null).
  @JsonKey(name: 'group')
  Group? get group;

  /// Список схем.
  @JsonKey(name: 'list')
  List<SchemaModel>? get list;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SchemasResponseCopyWith<SchemasResponse> get copyWith =>
      _$SchemasResponseCopyWithImpl<SchemasResponse>(
          this as SchemasResponse, _$identity);

  /// Serializes this SchemasResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SchemasResponse &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other.list, list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, group, const DeepCollectionEquality().hash(list));

  @override
  String toString() {
    return 'SchemasResponse(group: $group, list: $list)';
  }
}

/// @nodoc
abstract mixin class $SchemasResponseCopyWith<$Res> {
  factory $SchemasResponseCopyWith(
          SchemasResponse value, $Res Function(SchemasResponse) _then) =
      _$SchemasResponseCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});

  $GroupCopyWith<$Res>? get group;
}

/// @nodoc
class _$SchemasResponseCopyWithImpl<$Res>
    implements $SchemasResponseCopyWith<$Res> {
  _$SchemasResponseCopyWithImpl(this._self, this._then);

  final SchemasResponse _self;
  final $Res Function(SchemasResponse) _then;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_self.copyWith(
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ));
  }

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
      return null;
    }

    return $GroupCopyWith<$Res>(_self.group!, (value) {
      return _then(_self.copyWith(group: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SchemasResponse implements SchemasResponse {
  _SchemasResponse(
      {@JsonKey(name: 'group') this.group,
      @JsonKey(name: 'list') final List<SchemaModel>? list})
      : _list = list;
  factory _SchemasResponse.fromJson(Map<String, dynamic> json) =>
      _$SchemasResponseFromJson(json);

  /// Группа (может быть null).
  @override
  @JsonKey(name: 'group')
  final Group? group;

  /// Список схем.
  final List<SchemaModel>? _list;

  /// Список схем.
  @override
  @JsonKey(name: 'list')
  List<SchemaModel>? get list {
    final value = _list;
    if (value == null) return null;
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SchemasResponseCopyWith<_SchemasResponse> get copyWith =>
      __$SchemasResponseCopyWithImpl<_SchemasResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SchemasResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SchemasResponse &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, group, const DeepCollectionEquality().hash(_list));

  @override
  String toString() {
    return 'SchemasResponse(group: $group, list: $list)';
  }
}

/// @nodoc
abstract mixin class _$SchemasResponseCopyWith<$Res>
    implements $SchemasResponseCopyWith<$Res> {
  factory _$SchemasResponseCopyWith(
          _SchemasResponse value, $Res Function(_SchemasResponse) _then) =
      __$SchemasResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});

  @override
  $GroupCopyWith<$Res>? get group;
}

/// @nodoc
class __$SchemasResponseCopyWithImpl<$Res>
    implements _$SchemasResponseCopyWith<$Res> {
  __$SchemasResponseCopyWithImpl(this._self, this._then);

  final _SchemasResponse _self;
  final $Res Function(_SchemasResponse) _then;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_SchemasResponse(
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _self._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ));
  }

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
      return null;
    }

    return $GroupCopyWith<$Res>(_self.group!, (value) {
      return _then(_self.copyWith(group: value));
    });
  }
}

// dart format on
