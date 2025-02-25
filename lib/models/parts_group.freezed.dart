// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartsGroup _$PartsGroupFromJson(Map<String, dynamic> json) {
  return _PartsGroup.fromJson(json);
}

/// @nodoc
mixin _$PartsGroup {
  /// Название запчасти.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Номер группы запчастей.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Номер позиции группы запчастей на изображении.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber => throw _privateConstructorUsedError;

  /// Описание группы запчастей.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Список деталей в группе.
  @JsonKey(name: 'parts')
  List<Part>? get parts => throw _privateConstructorUsedError;

  /// Serializes this PartsGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartsGroupCopyWith<PartsGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartsGroupCopyWith<$Res> {
  factory $PartsGroupCopyWith(
          PartsGroup value, $Res Function(PartsGroup) then) =
      _$PartsGroupCopyWithImpl<$Res, PartsGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class _$PartsGroupCopyWithImpl<$Res, $Val extends PartsGroup>
    implements $PartsGroupCopyWith<$Res> {
  _$PartsGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartsGroupImplCopyWith<$Res>
    implements $PartsGroupCopyWith<$Res> {
  factory _$$PartsGroupImplCopyWith(
          _$PartsGroupImpl value, $Res Function(_$PartsGroupImpl) then) =
      __$$PartsGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class __$$PartsGroupImplCopyWithImpl<$Res>
    extends _$PartsGroupCopyWithImpl<$Res, _$PartsGroupImpl>
    implements _$$PartsGroupImplCopyWith<$Res> {
  __$$PartsGroupImplCopyWithImpl(
      _$PartsGroupImpl _value, $Res Function(_$PartsGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_$PartsGroupImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartsGroupImpl implements _PartsGroup {
  _$PartsGroupImpl(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'parts') final List<Part>? parts})
      : _parts = parts;

  factory _$PartsGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartsGroupImplFromJson(json);

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  final String? positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Список деталей в группе.
  final List<Part>? _parts;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PartsGroup(name: $name, number: $number, positionNumber: $positionNumber, description: $description, parts: $parts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartsGroupImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._parts, _parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, number, positionNumber,
      description, const DeepCollectionEquality().hash(_parts));

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      __$$PartsGroupImplCopyWithImpl<_$PartsGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartsGroupImplToJson(
      this,
    );
  }
}

abstract class _PartsGroup implements PartsGroup {
  factory _PartsGroup(
      {@JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'number') final String? number,
      @JsonKey(name: 'positionNumber') final String? positionNumber,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'parts') final List<Part>? parts}) = _$PartsGroupImpl;

  factory _PartsGroup.fromJson(Map<String, dynamic> json) =
      _$PartsGroupImpl.fromJson;

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
