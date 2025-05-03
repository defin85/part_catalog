// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupsTree {
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
  List<GroupsTree> get subGroups;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupsTreeCopyWith<GroupsTree> get copyWith =>
      _$GroupsTreeCopyWithImpl<GroupsTree>(this as GroupsTree, _$identity);

  /// Serializes this GroupsTree to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupsTree &&
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
    return 'GroupsTree(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }
}

/// @nodoc
abstract mixin class $GroupsTreeCopyWith<$Res> {
  factory $GroupsTreeCopyWith(
          GroupsTree value, $Res Function(GroupsTree) _then) =
      _$GroupsTreeCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class _$GroupsTreeCopyWithImpl<$Res> implements $GroupsTreeCopyWith<$Res> {
  _$GroupsTreeCopyWithImpl(this._self, this._then);

  final GroupsTree _self;
  final $Res Function(GroupsTree) _then;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = null,
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
      subGroups: null == subGroups
          ? _self.subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GroupsTree implements GroupsTree {
  _GroupsTree(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'subGroups') final List<GroupsTree> subGroups = const []})
      : _subGroups = subGroups;
  factory _GroupsTree.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeFromJson(json);

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
  final List<GroupsTree> _subGroups;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups {
    if (_subGroups is EqualUnmodifiableListView) return _subGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subGroups);
  }

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupsTreeCopyWith<_GroupsTree> get copyWith =>
      __$GroupsTreeCopyWithImpl<_GroupsTree>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupsTreeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupsTree &&
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
    return 'GroupsTree(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }
}

/// @nodoc
abstract mixin class _$GroupsTreeCopyWith<$Res>
    implements $GroupsTreeCopyWith<$Res> {
  factory _$GroupsTreeCopyWith(
          _GroupsTree value, $Res Function(_GroupsTree) _then) =
      __$GroupsTreeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class __$GroupsTreeCopyWithImpl<$Res> implements _$GroupsTreeCopyWith<$Res> {
  __$GroupsTreeCopyWithImpl(this._self, this._then);

  final _GroupsTree _self;
  final $Res Function(_GroupsTree) _then;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = null,
  }) {
    return _then(_GroupsTree(
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
      subGroups: null == subGroups
          ? _self._subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ));
  }
}

// dart format on
