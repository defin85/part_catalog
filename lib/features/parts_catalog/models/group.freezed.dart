// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Group {
  /// Идентификатор группы.
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Признак наличия подгрупп.
  @JsonKey(name: 'hasSubgroups')
  bool? get hasSubgroups;

  /// Признак наличия деталей в группе.
  @JsonKey(name: 'hasParts')
  bool? get hasParts;

  /// Название группы.
  @JsonKey(name: 'name')
  String get name;

  /// Изображение группы.
  @JsonKey(name: 'img')
  String? get img;

  /// Описание группы.
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupCopyWith<Group> get copyWith =>
      _$GroupCopyWithImpl<Group>(this as Group, _$identity);

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Group &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.hasSubgroups, hasSubgroups) ||
                other.hasSubgroups == hasSubgroups) &&
            (identical(other.hasParts, hasParts) ||
                other.hasParts == hasParts) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, hasSubgroups,
      hasParts, name, img, description);

  @override
  String toString() {
    return 'Group(id: $id, parentId: $parentId, hasSubgroups: $hasSubgroups, hasParts: $hasParts, name: $name, img: $img, description: $description)';
  }
}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) =
      _$GroupCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,
      @JsonKey(name: 'hasParts') bool? hasParts,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class _$GroupCopyWithImpl<$Res> implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? hasSubgroups = freezed,
    Object? hasParts = freezed,
    Object? name = null,
    Object? img = freezed,
    Object? description = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _self.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _self.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Group implements Group {
  _Group(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'hasSubgroups') this.hasSubgroups,
      @JsonKey(name: 'hasParts') this.hasParts,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'description') this.description});
  factory _Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Признак наличия подгрупп.
  @override
  @JsonKey(name: 'hasSubgroups')
  final bool? hasSubgroups;

  /// Признак наличия деталей в группе.
  @override
  @JsonKey(name: 'hasParts')
  final bool? hasParts;

  /// Название группы.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Изображение группы.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Описание группы.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupCopyWith<_Group> get copyWith =>
      __$GroupCopyWithImpl<_Group>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Group &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.hasSubgroups, hasSubgroups) ||
                other.hasSubgroups == hasSubgroups) &&
            (identical(other.hasParts, hasParts) ||
                other.hasParts == hasParts) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, hasSubgroups,
      hasParts, name, img, description);

  @override
  String toString() {
    return 'Group(id: $id, parentId: $parentId, hasSubgroups: $hasSubgroups, hasParts: $hasParts, name: $name, img: $img, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) =
      __$GroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,
      @JsonKey(name: 'hasParts') bool? hasParts,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class __$GroupCopyWithImpl<$Res> implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? hasSubgroups = freezed,
    Object? hasParts = freezed,
    Object? name = null,
    Object? img = freezed,
    Object? description = freezed,
  }) {
    return _then(_Group(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _self.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _self.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
