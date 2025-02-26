// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Part _$PartFromJson(Map<String, dynamic> json) {
  return _Part.fromJson(json);
}

/// @nodoc
mixin _$Part {
  /// Идентификатор детали.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Идентификатор названия детали (может быть null).
  @JsonKey(name: 'nameId')
  String? get nameId => throw _privateConstructorUsedError;

  /// Название детали.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Номер детали.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Примечание к детали.
  @JsonKey(name: 'notice')
  String? get notice => throw _privateConstructorUsedError;

  /// Описание детали.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Номер позиции на изображении группы.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber => throw _privateConstructorUsedError;

  /// URL для поиска результатов.
  @JsonKey(name: 'url')
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this Part to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartCopyWith<Part> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartCopyWith<$Res> {
  factory $PartCopyWith(Part value, $Res Function(Part) then) =
      _$PartCopyWithImpl<$Res, Part>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'nameId') String? nameId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'notice') String? notice,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'url') String? url});
}

/// @nodoc
class _$PartCopyWithImpl<$Res, $Val extends Part>
    implements $PartCopyWith<$Res> {
  _$PartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nameId = freezed,
    Object? name = freezed,
    Object? number = freezed,
    Object? notice = freezed,
    Object? description = freezed,
    Object? positionNumber = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _value.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartImplCopyWith<$Res> implements $PartCopyWith<$Res> {
  factory _$$PartImplCopyWith(
          _$PartImpl value, $Res Function(_$PartImpl) then) =
      __$$PartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'nameId') String? nameId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'notice') String? notice,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'url') String? url});
}

/// @nodoc
class __$$PartImplCopyWithImpl<$Res>
    extends _$PartCopyWithImpl<$Res, _$PartImpl>
    implements _$$PartImplCopyWith<$Res> {
  __$$PartImplCopyWithImpl(_$PartImpl _value, $Res Function(_$PartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nameId = freezed,
    Object? name = freezed,
    Object? number = freezed,
    Object? notice = freezed,
    Object? description = freezed,
    Object? positionNumber = freezed,
    Object? url = freezed,
  }) {
    return _then(_$PartImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _value.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartImpl implements _Part {
  _$PartImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'nameId') this.nameId,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'notice') this.notice,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'url') this.url});

  factory _$PartImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartImplFromJson(json);

  /// Идентификатор детали.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Идентификатор названия детали (может быть null).
  @override
  @JsonKey(name: 'nameId')
  final String? nameId;

  /// Название детали.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Номер детали.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Примечание к детали.
  @override
  @JsonKey(name: 'notice')
  final String? notice;

  /// Описание детали.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Номер позиции на изображении группы.
  @override
  @JsonKey(name: 'positionNumber')
  final String? positionNumber;

  /// URL для поиска результатов.
  @override
  @JsonKey(name: 'url')
  final String? url;

  @override
  String toString() {
    return 'Part(id: $id, nameId: $nameId, name: $name, number: $number, notice: $notice, description: $description, positionNumber: $positionNumber, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameId, nameId) || other.nameId == nameId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.notice, notice) || other.notice == notice) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameId, name, number, notice,
      description, positionNumber, url);

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartImplCopyWith<_$PartImpl> get copyWith =>
      __$$PartImplCopyWithImpl<_$PartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartImplToJson(
      this,
    );
  }
}

abstract class _Part implements Part {
  factory _Part(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'nameId') final String? nameId,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'number') final String? number,
      @JsonKey(name: 'notice') final String? notice,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'positionNumber') final String? positionNumber,
      @JsonKey(name: 'url') final String? url}) = _$PartImpl;

  factory _Part.fromJson(Map<String, dynamic> json) = _$PartImpl.fromJson;

  /// Идентификатор детали.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Идентификатор названия детали (может быть null).
  @override
  @JsonKey(name: 'nameId')
  String? get nameId;

  /// Название детали.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Номер детали.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Примечание к детали.
  @override
  @JsonKey(name: 'notice')
  String? get notice;

  /// Описание детали.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Номер позиции на изображении группы.
  @override
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// URL для поиска результатов.
  @override
  @JsonKey(name: 'url')
  String? get url;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartImplCopyWith<_$PartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
