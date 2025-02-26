// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schemas_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemasResponse _$SchemasResponseFromJson(Map<String, dynamic> json) {
  return _SchemasResponse.fromJson(json);
}

/// @nodoc
mixin _$SchemasResponse {
  /// Группа (может быть null).
  @JsonKey(name: 'group')
  Group? get group => throw _privateConstructorUsedError;

  /// Список схем.
  @JsonKey(name: 'list')
  List<SchemaModel>? get list => throw _privateConstructorUsedError;

  /// Serializes this SchemasResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchemasResponseCopyWith<SchemasResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemasResponseCopyWith<$Res> {
  factory $SchemasResponseCopyWith(
          SchemasResponse value, $Res Function(SchemasResponse) then) =
      _$SchemasResponseCopyWithImpl<$Res, SchemasResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});
}

/// @nodoc
class _$SchemasResponseCopyWithImpl<$Res, $Val extends SchemasResponse>
    implements $SchemasResponseCopyWith<$Res> {
  _$SchemasResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_value.copyWith(
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemasResponseImplCopyWith<$Res>
    implements $SchemasResponseCopyWith<$Res> {
  factory _$$SchemasResponseImplCopyWith(_$SchemasResponseImpl value,
          $Res Function(_$SchemasResponseImpl) then) =
      __$$SchemasResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});
}

/// @nodoc
class __$$SchemasResponseImplCopyWithImpl<$Res>
    extends _$SchemasResponseCopyWithImpl<$Res, _$SchemasResponseImpl>
    implements _$$SchemasResponseImplCopyWith<$Res> {
  __$$SchemasResponseImplCopyWithImpl(
      _$SchemasResponseImpl _value, $Res Function(_$SchemasResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_$SchemasResponseImpl(
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemasResponseImpl implements _SchemasResponse {
  _$SchemasResponseImpl(
      {@JsonKey(name: 'group') this.group,
      @JsonKey(name: 'list') final List<SchemaModel>? list})
      : _list = list;

  factory _$SchemasResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemasResponseImplFromJson(json);

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

  @override
  String toString() {
    return 'SchemasResponse(group: $group, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemasResponseImpl &&
            const DeepCollectionEquality().equals(other.group, group) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(group),
      const DeepCollectionEquality().hash(_list));

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemasResponseImplCopyWith<_$SchemasResponseImpl> get copyWith =>
      __$$SchemasResponseImplCopyWithImpl<_$SchemasResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemasResponseImplToJson(
      this,
    );
  }
}

abstract class _SchemasResponse implements SchemasResponse {
  factory _SchemasResponse(
          {@JsonKey(name: 'group') final Group? group,
          @JsonKey(name: 'list') final List<SchemaModel>? list}) =
      _$SchemasResponseImpl;

  factory _SchemasResponse.fromJson(Map<String, dynamic> json) =
      _$SchemasResponseImpl.fromJson;

  /// Группа (может быть null).
  @override
  @JsonKey(name: 'group')
  Group? get group;

  /// Список схем.
  @override
  @JsonKey(name: 'list')
  List<SchemaModel>? get list;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchemasResponseImplCopyWith<_$SchemasResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
