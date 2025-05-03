// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Parts {
  /// URL изображения группы запчастей.
  @JsonKey(name: 'img')
  String? get img;

  /// Описание изображения группы запчастей.
  @JsonKey(name: 'imgDescription')
  String? get imgDescription;

  /// Список групп запчастей.
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups;

  /// Список позиций блоков с номерами на изображении.
  @JsonKey(name: 'positions')
  List<Position>? get positions;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PartsCopyWith<Parts> get copyWith =>
      _$PartsCopyWithImpl<Parts>(this as Parts, _$identity);

  /// Serializes this Parts to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Parts &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.imgDescription, imgDescription) ||
                other.imgDescription == imgDescription) &&
            const DeepCollectionEquality()
                .equals(other.partGroups, partGroups) &&
            const DeepCollectionEquality().equals(other.positions, positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      img,
      imgDescription,
      const DeepCollectionEquality().hash(partGroups),
      const DeepCollectionEquality().hash(positions));

  @override
  String toString() {
    return 'Parts(img: $img, imgDescription: $imgDescription, partGroups: $partGroups, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class $PartsCopyWith<$Res> {
  factory $PartsCopyWith(Parts value, $Res Function(Parts) _then) =
      _$PartsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class _$PartsCopyWithImpl<$Res> implements $PartsCopyWith<$Res> {
  _$PartsCopyWithImpl(this._self, this._then);

  final Parts _self;
  final $Res Function(Parts) _then;

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
    return _then(_self.copyWith(
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _self.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _self.partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Parts implements Parts {
  _Parts(
      {@JsonKey(name: 'img') this.img,
      @JsonKey(name: 'imgDescription') this.imgDescription,
      @JsonKey(name: 'partGroups') final List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') final List<Position>? positions})
      : _partGroups = partGroups,
        _positions = positions;
  factory _Parts.fromJson(Map<String, dynamic> json) => _$PartsFromJson(json);

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

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PartsCopyWith<_Parts> get copyWith =>
      __$PartsCopyWithImpl<_Parts>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PartsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Parts &&
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

  @override
  String toString() {
    return 'Parts(img: $img, imgDescription: $imgDescription, partGroups: $partGroups, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class _$PartsCopyWith<$Res> implements $PartsCopyWith<$Res> {
  factory _$PartsCopyWith(_Parts value, $Res Function(_Parts) _then) =
      __$PartsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class __$PartsCopyWithImpl<$Res> implements _$PartsCopyWith<$Res> {
  __$PartsCopyWithImpl(this._self, this._then);

  final _Parts _self;
  final $Res Function(_Parts) _then;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? img = freezed,
    Object? imgDescription = freezed,
    Object? partGroups = freezed,
    Object? positions = freezed,
  }) {
    return _then(_Parts(
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _self.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _self._partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _self._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ));
  }
}

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

/// @nodoc
mixin _$Position {
  /// Номер на изображении.
  @JsonKey(name: 'number')
  String? get number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PositionCopyWith<Position> get copyWith =>
      _$PositionCopyWithImpl<Position>(this as Position, _$identity);

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Position &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other.coordinates, coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(coordinates));

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) _then) =
      _$PositionCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res> implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._self, this._then);

  final Position _self;
  final $Res Function(Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_self.copyWith(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Position implements Position {
  _Position(
      {@JsonKey(name: 'number') this.number,
      @JsonKey(name: 'coordinates') final List<double>? coordinates})
      : _coordinates = coordinates;
  factory _Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

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

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PositionCopyWith<_Position> get copyWith =>
      __$PositionCopyWithImpl<_Position>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PositionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Position &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(_coordinates));

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class _$PositionCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$PositionCopyWith(_Position value, $Res Function(_Position) _then) =
      __$PositionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class __$PositionCopyWithImpl<$Res> implements _$PositionCopyWith<$Res> {
  __$PositionCopyWithImpl(this._self, this._then);

  final _Position _self;
  final $Res Function(_Position) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_Position(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

// dart format on
