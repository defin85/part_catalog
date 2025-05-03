// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Catalog {
  /// Идентификатор каталога.
  @JsonKey(name: 'id')
  String get id;

  /// Название каталога.
  @JsonKey(name: 'name')
  String get name;

  /// Количество моделей в каталоге.
  @JsonKey(name: 'models_count')
  int get modelsCount;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CatalogCopyWith<Catalog> get copyWith =>
      _$CatalogCopyWithImpl<Catalog>(this as Catalog, _$identity);

  /// Serializes this Catalog to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Catalog &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.modelsCount, modelsCount) ||
                other.modelsCount == modelsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, modelsCount);

  @override
  String toString() {
    return 'Catalog(id: $id, name: $name, modelsCount: $modelsCount)';
  }
}

/// @nodoc
abstract mixin class $CatalogCopyWith<$Res> {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) _then) =
      _$CatalogCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class _$CatalogCopyWithImpl<$Res> implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._self, this._then);

  final Catalog _self;
  final $Res Function(Catalog) _then;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
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
      modelsCount: null == modelsCount
          ? _self.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Catalog implements Catalog {
  _Catalog(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'models_count') required this.modelsCount});
  factory _Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название каталога.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Количество моделей в каталоге.
  @override
  @JsonKey(name: 'models_count')
  final int modelsCount;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CatalogCopyWith<_Catalog> get copyWith =>
      __$CatalogCopyWithImpl<_Catalog>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CatalogToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Catalog &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.modelsCount, modelsCount) ||
                other.modelsCount == modelsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, modelsCount);

  @override
  String toString() {
    return 'Catalog(id: $id, name: $name, modelsCount: $modelsCount)';
  }
}

/// @nodoc
abstract mixin class _$CatalogCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$CatalogCopyWith(_Catalog value, $Res Function(_Catalog) _then) =
      __$CatalogCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class __$CatalogCopyWithImpl<$Res> implements _$CatalogCopyWith<$Res> {
  __$CatalogCopyWithImpl(this._self, this._then);

  final _Catalog _self;
  final $Res Function(_Catalog) _then;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
  }) {
    return _then(_Catalog(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modelsCount: null == modelsCount
          ? _self.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
