// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupsTree _$GroupsTreeFromJson(Map<String, dynamic> json) {
  return _GroupsTree.fromJson(json);
}

/// @nodoc
mixin _$GroupsTree {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;

  /// Список подгрупп.
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups => throw _privateConstructorUsedError;

  /// Serializes this GroupsTree to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupsTreeCopyWith<GroupsTree> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupsTreeCopyWith<$Res> {
  factory $GroupsTreeCopyWith(
          GroupsTree value, $Res Function(GroupsTree) then) =
      _$GroupsTreeCopyWithImpl<$Res, GroupsTree>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class _$GroupsTreeCopyWithImpl<$Res, $Val extends GroupsTree>
    implements $GroupsTreeCopyWith<$Res> {
  _$GroupsTreeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: null == subGroups
          ? _value.subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupsTreeImplCopyWith<$Res>
    implements $GroupsTreeCopyWith<$Res> {
  factory _$$GroupsTreeImplCopyWith(
          _$GroupsTreeImpl value, $Res Function(_$GroupsTreeImpl) then) =
      __$$GroupsTreeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class __$$GroupsTreeImplCopyWithImpl<$Res>
    extends _$GroupsTreeCopyWithImpl<$Res, _$GroupsTreeImpl>
    implements _$$GroupsTreeImplCopyWith<$Res> {
  __$$GroupsTreeImplCopyWithImpl(
      _$GroupsTreeImpl _value, $Res Function(_$GroupsTreeImpl) _then)
      : super(_value, _then);

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
    return _then(_$GroupsTreeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: null == subGroups
          ? _value._subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupsTreeImpl implements _GroupsTree {
  _$GroupsTreeImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'subGroups') final List<GroupsTree> subGroups = const []})
      : _subGroups = subGroups;

  factory _$GroupsTreeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupsTreeImplFromJson(json);

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

  @override
  String toString() {
    return 'GroupsTree(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupsTreeImpl &&
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

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupsTreeImplCopyWith<_$GroupsTreeImpl> get copyWith =>
      __$$GroupsTreeImplCopyWithImpl<_$GroupsTreeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupsTreeImplToJson(
      this,
    );
  }
}

abstract class _GroupsTree implements GroupsTree {
  factory _GroupsTree(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'parentId') final String? parentId,
          @JsonKey(name: 'subGroups') final List<GroupsTree> subGroups}) =
      _$GroupsTreeImpl;

  factory _GroupsTree.fromJson(Map<String, dynamic> json) =
      _$GroupsTreeImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupsTreeImplCopyWith<_$GroupsTreeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
