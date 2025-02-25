// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Parts _$PartsFromJson(Map<String, dynamic> json) {
  return _Parts.fromJson(json);
}

/// @nodoc
mixin _$Parts {
  /// URL изображения группы запчастей.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Описание изображения группы запчастей.
  @JsonKey(name: 'imgDescription')
  String? get imgDescription => throw _privateConstructorUsedError;

  /// Список групп запчастей.
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups => throw _privateConstructorUsedError;

  /// Список позиций блоков с номерами на изображении.
  @JsonKey(name: 'positions')
  List<Position>? get positions => throw _privateConstructorUsedError;

  /// Serializes this Parts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartsCopyWith<Parts> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartsCopyWith<$Res> {
  factory $PartsCopyWith(Parts value, $Res Function(Parts) then) =
      _$PartsCopyWithImpl<$Res, Parts>;
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class _$PartsCopyWithImpl<$Res, $Val extends Parts>
    implements $PartsCopyWith<$Res> {
  _$PartsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? img = freezed,
    Object? imgDescription = freezed,
    Object? partGroups = freezed,
    Object? positions = freezed,
  }) {
    return _then(_value.copyWith(
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _value.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _value.partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _value.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartsImplCopyWith<$Res> implements $PartsCopyWith<$Res> {
  factory _$$PartsImplCopyWith(
          _$PartsImpl value, $Res Function(_$PartsImpl) then) =
      __$$PartsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class __$$PartsImplCopyWithImpl<$Res>
    extends _$PartsCopyWithImpl<$Res, _$PartsImpl>
    implements _$$PartsImplCopyWith<$Res> {
  __$$PartsImplCopyWithImpl(
      _$PartsImpl _value, $Res Function(_$PartsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? img = freezed,
    Object? imgDescription = freezed,
    Object? partGroups = freezed,
    Object? positions = freezed,
  }) {
    return _then(_$PartsImpl(
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _value.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _value._partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _value._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartsImpl implements _Parts {
  _$PartsImpl(
      {@JsonKey(name: 'img') this.img,
      @JsonKey(name: 'imgDescription') this.imgDescription,
      @JsonKey(name: 'partGroups') final List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') final List<Position>? positions})
      : _partGroups = partGroups,
        _positions = positions;

  factory _$PartsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartsImplFromJson(json);

  /// URL изображения группы запчастей.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Описание изображения группы запчастей.
  @override
  @JsonKey(name: 'imgDescription')
  final String? imgDescription;

  /// Список групп запчастей.
  final List<PartsGroup>? _partGroups;

  /// Список групп запчастей.
  @override
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups {
    final value = _partGroups;
    if (value == null) return null;
    if (_partGroups is EqualUnmodifiableListView) return _partGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Список позиций блоков с номерами на изображении.
  final List<Position>? _positions;

  /// Список позиций блоков с номерами на изображении.
  @override
  @JsonKey(name: 'positions')
  List<Position>? get positions {
    final value = _positions;
    if (value == null) return null;
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Parts(img: $img, imgDescription: $imgDescription, partGroups: $partGroups, positions: $positions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartsImpl &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.imgDescription, imgDescription) ||
                other.imgDescription == imgDescription) &&
            const DeepCollectionEquality()
                .equals(other._partGroups, _partGroups) &&
            const DeepCollectionEquality()
                .equals(other._positions, _positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      img,
      imgDescription,
      const DeepCollectionEquality().hash(_partGroups),
      const DeepCollectionEquality().hash(_positions));

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartsImplCopyWith<_$PartsImpl> get copyWith =>
      __$$PartsImplCopyWithImpl<_$PartsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartsImplToJson(
      this,
    );
  }
}

abstract class _Parts implements Parts {
  factory _Parts(
          {@JsonKey(name: 'img') final String? img,
          @JsonKey(name: 'imgDescription') final String? imgDescription,
          @JsonKey(name: 'partGroups') final List<PartsGroup>? partGroups,
          @JsonKey(name: 'positions') final List<Position>? positions}) =
      _$PartsImpl;

  factory _Parts.fromJson(Map<String, dynamic> json) = _$PartsImpl.fromJson;

  /// URL изображения группы запчастей.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Описание изображения группы запчастей.
  @override
  @JsonKey(name: 'imgDescription')
  String? get imgDescription;

  /// Список групп запчастей.
  @override
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups;

  /// Список позиций блоков с номерами на изображении.
  @override
  @JsonKey(name: 'positions')
  List<Position>? get positions;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartsImplCopyWith<_$PartsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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

Position _$PositionFromJson(Map<String, dynamic> json) {
  return _Position.fromJson(json);
}

/// @nodoc
mixin _$Position {
  /// Номер на изображении.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates => throw _privateConstructorUsedError;

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionCopyWith<Position> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) then) =
      _$PositionCopyWithImpl<$Res, Position>;
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res, $Val extends Position>
    implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PositionImplCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$$PositionImplCopyWith(
          _$PositionImpl value, $Res Function(_$PositionImpl) then) =
      __$$PositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class __$$PositionImplCopyWithImpl<$Res>
    extends _$PositionCopyWithImpl<$Res, _$PositionImpl>
    implements _$$PositionImplCopyWith<$Res> {
  __$$PositionImplCopyWithImpl(
      _$PositionImpl _value, $Res Function(_$PositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_$PositionImpl(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionImpl implements _Position {
  _$PositionImpl(
      {@JsonKey(name: 'number') this.number,
      @JsonKey(name: 'coordinates') final List<double>? coordinates})
      : _coordinates = coordinates;

  factory _$PositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionImplFromJson(json);

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  final List<double>? _coordinates;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionImpl &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(_coordinates));

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      __$$PositionImplCopyWithImpl<_$PositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionImplToJson(
      this,
    );
  }
}

abstract class _Position implements Position {
  factory _Position(
          {@JsonKey(name: 'number') final String? number,
          @JsonKey(name: 'coordinates') final List<double>? coordinates}) =
      _$PositionImpl;

  factory _Position.fromJson(Map<String, dynamic> json) =
      _$PositionImpl.fromJson;

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
