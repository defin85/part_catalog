// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartsGroup {
  /// Название запчасти.
  @JsonKey(name: 'name')
  String? get name;

  /// Номер группы запчастей.
  @JsonKey(name: 'number')
  String? get number;

  /// Номер позиции группы запчастей на изображении.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// Описание группы запчастей.
  @JsonKey(name: 'description')
  String? get description;

  /// Список деталей в группе.
  @JsonKey(name: 'parts')
  List<Part>? get parts;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PartsGroupCopyWith<PartsGroup> get copyWith =>
      _$PartsGroupCopyWithImpl<PartsGroup>(this as PartsGroup, _$identity);

  /// Serializes this PartsGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PartsGroup &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.parts, parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, number, positionNumber,
      description, const DeepCollectionEquality().hash(parts));

  @override
  String toString() {
    return 'PartsGroup(name: $name, number: $number, positionNumber: $positionNumber, description: $description, parts: $parts)';
  }
}

/// @nodoc
abstract mixin class $PartsGroupCopyWith<$Res> {
  factory $PartsGroupCopyWith(
          PartsGroup value, $Res Function(PartsGroup) _then) =
      _$PartsGroupCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class _$PartsGroupCopyWithImpl<$Res> implements $PartsGroupCopyWith<$Res> {
  _$PartsGroupCopyWithImpl(this._self, this._then);

  final PartsGroup _self;
  final $Res Function(PartsGroup) _then;

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
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _self.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _self.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PartsGroup implements PartsGroup {
  _PartsGroup(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'parts') final List<Part>? parts})
      : _parts = parts;
  factory _PartsGroup.fromJson(Map<String, dynamic> json) =>
      _$PartsGroupFromJson(json);

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

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PartsGroupCopyWith<_PartsGroup> get copyWith =>
      __$PartsGroupCopyWithImpl<_PartsGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PartsGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PartsGroup &&
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

  @override
  String toString() {
    return 'PartsGroup(name: $name, number: $number, positionNumber: $positionNumber, description: $description, parts: $parts)';
  }
}

/// @nodoc
abstract mixin class _$PartsGroupCopyWith<$Res>
    implements $PartsGroupCopyWith<$Res> {
  factory _$PartsGroupCopyWith(
          _PartsGroup value, $Res Function(_PartsGroup) _then) =
      __$PartsGroupCopyWithImpl;
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
class __$PartsGroupCopyWithImpl<$Res> implements _$PartsGroupCopyWith<$Res> {
  __$PartsGroupCopyWithImpl(this._self, this._then);

  final _PartsGroup _self;
  final $Res Function(_PartsGroup) _then;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_PartsGroup(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _self.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _self._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ));
  }
}

// dart format on
