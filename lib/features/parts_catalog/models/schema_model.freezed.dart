// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchemaModel {
  /// Идентификатор группы.
  @JsonKey(name: 'groupId')
  String get groupId;

  /// URL изображения.
  @JsonKey(name: 'img')
  String? get img;

  /// Название.
  @JsonKey(name: 'name')
  String get name;

  /// Описание.
  @JsonKey(name: 'description')
  String? get description;

  /// Список названий деталей.
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SchemaModelCopyWith<SchemaModel> get copyWith =>
      _$SchemaModelCopyWithImpl<SchemaModel>(this as SchemaModel, _$identity);

  /// Serializes this SchemaModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SchemaModel &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.partNames, partNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, img, name, description,
      const DeepCollectionEquality().hash(partNames));

  @override
  String toString() {
    return 'SchemaModel(groupId: $groupId, img: $img, name: $name, description: $description, partNames: $partNames)';
  }
}

/// @nodoc
abstract mixin class $SchemaModelCopyWith<$Res> {
  factory $SchemaModelCopyWith(
          SchemaModel value, $Res Function(SchemaModel) _then) =
      _$SchemaModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'groupId') String groupId,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'partNames') List<PartName>? partNames});
}

/// @nodoc
class _$SchemaModelCopyWithImpl<$Res> implements $SchemaModelCopyWith<$Res> {
  _$SchemaModelCopyWithImpl(this._self, this._then);

  final SchemaModel _self;
  final $Res Function(SchemaModel) _then;

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
    return _then(_self.copyWith(
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _self.partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SchemaModel implements SchemaModel {
  _SchemaModel(
      {@JsonKey(name: 'groupId') required this.groupId,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'partNames') final List<PartName>? partNames})
      : _partNames = partNames;
  factory _SchemaModel.fromJson(Map<String, dynamic> json) =>
      _$SchemaModelFromJson(json);

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

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SchemaModelCopyWith<_SchemaModel> get copyWith =>
      __$SchemaModelCopyWithImpl<_SchemaModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SchemaModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SchemaModel &&
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

  @override
  String toString() {
    return 'SchemaModel(groupId: $groupId, img: $img, name: $name, description: $description, partNames: $partNames)';
  }
}

/// @nodoc
abstract mixin class _$SchemaModelCopyWith<$Res>
    implements $SchemaModelCopyWith<$Res> {
  factory _$SchemaModelCopyWith(
          _SchemaModel value, $Res Function(_SchemaModel) _then) =
      __$SchemaModelCopyWithImpl;
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
class __$SchemaModelCopyWithImpl<$Res> implements _$SchemaModelCopyWith<$Res> {
  __$SchemaModelCopyWithImpl(this._self, this._then);

  final _SchemaModel _self;
  final $Res Function(_SchemaModel) _then;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? groupId = null,
    Object? img = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? partNames = freezed,
  }) {
    return _then(_SchemaModel(
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _self._partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ));
  }
}

// dart format on
