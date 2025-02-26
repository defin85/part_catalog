// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  /// Идентификатор группы.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;

  /// Признак наличия подгрупп.
  @JsonKey(name: 'hasSubgroups')
  bool? get hasSubgroups => throw _privateConstructorUsedError;

  /// Признак наличия деталей в группе.
  @JsonKey(name: 'hasParts')
  bool? get hasParts => throw _privateConstructorUsedError;

  /// Название группы.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Изображение группы.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Описание группы.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
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
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _value.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _value.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
          _$GroupImpl value, $Res Function(_$GroupImpl) then) =
      __$$GroupImplCopyWithImpl<$Res>;
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
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
      _$GroupImpl _value, $Res Function(_$GroupImpl) _then)
      : super(_value, _then);

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
    return _then(_$GroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _value.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _value.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl implements _Group {
  _$GroupImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'hasSubgroups') this.hasSubgroups,
      @JsonKey(name: 'hasParts') this.hasParts,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'description') this.description});

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

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

  @override
  String toString() {
    return 'Group(id: $id, parentId: $parentId, hasSubgroups: $hasSubgroups, hasParts: $hasParts, name: $name, img: $img, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
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

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  factory _Group(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'parentId') final String? parentId,
      @JsonKey(name: 'hasSubgroups') final bool? hasSubgroups,
      @JsonKey(name: 'hasParts') final bool? hasParts,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'img') final String? img,
      @JsonKey(name: 'description') final String? description}) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Признак наличия подгрупп.
  @override
  @JsonKey(name: 'hasSubgroups')
  bool? get hasSubgroups;

  /// Признак наличия деталей в группе.
  @override
  @JsonKey(name: 'hasParts')
  bool? get hasParts;

  /// Название группы.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Изображение группы.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Описание группы.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
