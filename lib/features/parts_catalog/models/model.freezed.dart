// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Model {
  /// Идентификатор модели.
  @JsonKey(name: 'id')
  String get id;

  /// Название модели.
  @JsonKey(name: 'name')
  String get name;

  /// URL изображения модели.
  @JsonKey(name: 'img')
  String? get img;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModelCopyWith<Model> get copyWith =>
      _$ModelCopyWithImpl<Model>(this as Model, _$identity);

  /// Serializes this Model to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Model &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, img);

  @override
  String toString() {
    return 'Model(id: $id, name: $name, img: $img)';
  }
}

/// @nodoc
abstract mixin class $ModelCopyWith<$Res> {
  factory $ModelCopyWith(Model value, $Res Function(Model) _then) =
      _$ModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img});
}

/// @nodoc
class _$ModelCopyWithImpl<$Res> implements $ModelCopyWith<$Res> {
  _$ModelCopyWithImpl(this._self, this._then);

  final Model _self;
  final $Res Function(Model) _then;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
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
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Model implements Model {
  _Model(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'img') this.img});
  factory _Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  /// Идентификатор модели.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название модели.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// URL изображения модели.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ModelCopyWith<_Model> get copyWith =>
      __$ModelCopyWithImpl<_Model>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Model &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, img);

  @override
  String toString() {
    return 'Model(id: $id, name: $name, img: $img)';
  }
}

/// @nodoc
abstract mixin class _$ModelCopyWith<$Res> implements $ModelCopyWith<$Res> {
  factory _$ModelCopyWith(_Model value, $Res Function(_Model) _then) =
      __$ModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img});
}

/// @nodoc
class __$ModelCopyWithImpl<$Res> implements _$ModelCopyWith<$Res> {
  __$ModelCopyWithImpl(this._self, this._then);

  final _Model _self;
  final $Res Function(_Model) _then;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
  }) {
    return _then(_Model(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
