// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Catalog _$CatalogFromJson(Map<String, dynamic> json) {
  return _Catalog.fromJson(json);
}

/// @nodoc
mixin _$Catalog {
  /// Идентификатор каталога.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название каталога.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Количество моделей в каталоге.
  @JsonKey(name: 'models_count')
  int get modelsCount => throw _privateConstructorUsedError;

  /// Serializes this Catalog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogCopyWith<Catalog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogCopyWith<$Res> {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) then) =
      _$CatalogCopyWithImpl<$Res, Catalog>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class _$CatalogCopyWithImpl<$Res, $Val extends Catalog>
    implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
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
      modelsCount: null == modelsCount
          ? _value.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogImplCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$$CatalogImplCopyWith(
          _$CatalogImpl value, $Res Function(_$CatalogImpl) then) =
      __$$CatalogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class __$$CatalogImplCopyWithImpl<$Res>
    extends _$CatalogCopyWithImpl<$Res, _$CatalogImpl>
    implements _$$CatalogImplCopyWith<$Res> {
  __$$CatalogImplCopyWithImpl(
      _$CatalogImpl _value, $Res Function(_$CatalogImpl) _then)
      : super(_value, _then);

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
  }) {
    return _then(_$CatalogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modelsCount: null == modelsCount
          ? _value.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogImpl implements _Catalog {
  _$CatalogImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'models_count') required this.modelsCount});

  factory _$CatalogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogImplFromJson(json);

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

  @override
  String toString() {
    return 'Catalog(id: $id, name: $name, modelsCount: $modelsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.modelsCount, modelsCount) ||
                other.modelsCount == modelsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, modelsCount);

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogImplCopyWith<_$CatalogImpl> get copyWith =>
      __$$CatalogImplCopyWithImpl<_$CatalogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogImplToJson(
      this,
    );
  }
}

abstract class _Catalog implements Catalog {
  factory _Catalog(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'models_count') required final int modelsCount}) =
      _$CatalogImpl;

  factory _Catalog.fromJson(Map<String, dynamic> json) = _$CatalogImpl.fromJson;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название каталога.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Количество моделей в каталоге.
  @override
  @JsonKey(name: 'models_count')
  int get modelsCount;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogImplCopyWith<_$CatalogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
