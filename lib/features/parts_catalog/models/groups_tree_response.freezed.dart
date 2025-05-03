// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_tree_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupsTreeResponse {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @JsonKey(name: 'name')
  String get name;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Список подгрупп.
  @JsonKey(name: 'subGroups')
  List<GroupsTree>? get subGroups;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupsTreeResponseCopyWith<GroupsTreeResponse> get copyWith =>
      _$GroupsTreeResponseCopyWithImpl<GroupsTreeResponse>(
          this as GroupsTreeResponse, _$identity);

  /// Serializes this GroupsTreeResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupsTreeResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other.subGroups, subGroups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, parentId,
      const DeepCollectionEquality().hash(subGroups));

  @override
  String toString() {
    return 'GroupsTreeResponse(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }
}

/// @nodoc
abstract mixin class $GroupsTreeResponseCopyWith<$Res> {
  factory $GroupsTreeResponseCopyWith(
          GroupsTreeResponse value, $Res Function(GroupsTreeResponse) _then) =
      _$GroupsTreeResponseCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups});
}

/// @nodoc
class _$GroupsTreeResponseCopyWithImpl<$Res>
    implements $GroupsTreeResponseCopyWith<$Res> {
  _$GroupsTreeResponseCopyWithImpl(this._self, this._then);

  final GroupsTreeResponse _self;
  final $Res Function(GroupsTreeResponse) _then;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = freezed,
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
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: freezed == subGroups
          ? _self.subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GroupsTreeResponse implements GroupsTreeResponse {
  _GroupsTreeResponse(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'subGroups') final List<GroupsTree>? subGroups})
      : _subGroups = subGroups;
  factory _GroupsTreeResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeResponseFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Список подгрупп.
  final List<GroupsTree>? _subGroups;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree>? get subGroups {
    final value = _subGroups;
    if (value == null) return null;
    if (_subGroups is EqualUnmodifiableListView) return _subGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupsTreeResponseCopyWith<_GroupsTreeResponse> get copyWith =>
      __$GroupsTreeResponseCopyWithImpl<_GroupsTreeResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupsTreeResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupsTreeResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality()
                .equals(other._subGroups, _subGroups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, parentId,
      const DeepCollectionEquality().hash(_subGroups));

  @override
  String toString() {
    return 'GroupsTreeResponse(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }
}

/// @nodoc
abstract mixin class _$GroupsTreeResponseCopyWith<$Res>
    implements $GroupsTreeResponseCopyWith<$Res> {
  factory _$GroupsTreeResponseCopyWith(
          _GroupsTreeResponse value, $Res Function(_GroupsTreeResponse) _then) =
      __$GroupsTreeResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups});
}

/// @nodoc
class __$GroupsTreeResponseCopyWithImpl<$Res>
    implements _$GroupsTreeResponseCopyWith<$Res> {
  __$GroupsTreeResponseCopyWithImpl(this._self, this._then);

  final _GroupsTreeResponse _self;
  final $Res Function(_GroupsTreeResponse) _then;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = freezed,
  }) {
    return _then(_GroupsTreeResponse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: freezed == subGroups
          ? _self._subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>?,
    ));
  }
}

// dart format on
