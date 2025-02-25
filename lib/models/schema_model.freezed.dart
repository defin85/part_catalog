// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemaModel _$SchemaModelFromJson(Map<String, dynamic> json) {
  return _SchemaModel.fromJson(json);
}

/// @nodoc
mixin _$SchemaModel {
  /// Идентификатор группы.
  @JsonKey(name: 'groupId')
  String get groupId => throw _privateConstructorUsedError;

  /// URL изображения.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Описание.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Список названий деталей.
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames => throw _privateConstructorUsedError;

  /// Serializes this SchemaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchemaModelCopyWith<SchemaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaModelCopyWith<$Res> {
  factory $SchemaModelCopyWith(
          SchemaModel value, $Res Function(SchemaModel) then) =
      _$SchemaModelCopyWithImpl<$Res, SchemaModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'groupId') String groupId,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'partNames') List<PartName>? partNames});
}

/// @nodoc
class _$SchemaModelCopyWithImpl<$Res, $Val extends SchemaModel>
    implements $SchemaModelCopyWith<$Res> {
  _$SchemaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? img = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? partNames = freezed,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _value.partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemaModelImplCopyWith<$Res>
    implements $SchemaModelCopyWith<$Res> {
  factory _$$SchemaModelImplCopyWith(
          _$SchemaModelImpl value, $Res Function(_$SchemaModelImpl) then) =
      __$$SchemaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'groupId') String groupId,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'partNames') List<PartName>? partNames});
}

/// @nodoc
class __$$SchemaModelImplCopyWithImpl<$Res>
    extends _$SchemaModelCopyWithImpl<$Res, _$SchemaModelImpl>
    implements _$$SchemaModelImplCopyWith<$Res> {
  __$$SchemaModelImplCopyWithImpl(
      _$SchemaModelImpl _value, $Res Function(_$SchemaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? img = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? partNames = freezed,
  }) {
    return _then(_$SchemaModelImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _value._partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaModelImpl implements _SchemaModel {
  _$SchemaModelImpl(
      {@JsonKey(name: 'groupId') required this.groupId,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'partNames') final List<PartName>? partNames})
      : _partNames = partNames;

  factory _$SchemaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaModelImplFromJson(json);

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'groupId')
  final String groupId;

  /// URL изображения.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Описание.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Список названий деталей.
  final List<PartName>? _partNames;

  /// Список названий деталей.
  @override
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames {
    final value = _partNames;
    if (value == null) return null;
    if (_partNames is EqualUnmodifiableListView) return _partNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SchemaModel(groupId: $groupId, img: $img, name: $name, description: $description, partNames: $partNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._partNames, _partNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, img, name, description,
      const DeepCollectionEquality().hash(_partNames));

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaModelImplCopyWith<_$SchemaModelImpl> get copyWith =>
      __$$SchemaModelImplCopyWithImpl<_$SchemaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaModelImplToJson(
      this,
    );
  }
}

abstract class _SchemaModel implements SchemaModel {
  factory _SchemaModel(
          {@JsonKey(name: 'groupId') required final String groupId,
          @JsonKey(name: 'img') final String? img,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'partNames') final List<PartName>? partNames}) =
      _$SchemaModelImpl;

  factory _SchemaModel.fromJson(Map<String, dynamic> json) =
      _$SchemaModelImpl.fromJson;

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'groupId')
  String get groupId;

  /// URL изображения.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Описание.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Список названий деталей.
  @override
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchemaModelImplCopyWith<_$SchemaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
