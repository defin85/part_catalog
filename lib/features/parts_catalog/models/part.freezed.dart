// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Part {
  /// Идентификатор детали.
  @JsonKey(name: 'id')
  String? get id;

  /// Идентификатор названия детали (может быть null).
  @JsonKey(name: 'nameId')
  String? get nameId;

  /// Название детали.
  @JsonKey(name: 'name')
  String? get name;

  /// Номер детали.
  @JsonKey(name: 'number')
  String? get number;

  /// Примечание к детали.
  @JsonKey(name: 'notice')
  String? get notice;

  /// Описание детали.
  @JsonKey(name: 'description')
  String? get description;

  /// Номер позиции на изображении группы.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// URL для поиска результатов.
  @JsonKey(name: 'url')
  String? get url;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PartCopyWith<Part> get copyWith =>
      _$PartCopyWithImpl<Part>(this as Part, _$identity);

  /// Serializes this Part to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Part &&
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

  @override
  String toString() {
    return 'Part(id: $id, nameId: $nameId, name: $name, number: $number, notice: $notice, description: $description, positionNumber: $positionNumber, url: $url)';
  }
}

/// @nodoc
abstract mixin class $PartCopyWith<$Res> {
  factory $PartCopyWith(Part value, $Res Function(Part) _then) =
      _$PartCopyWithImpl;
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
class _$PartCopyWithImpl<$Res> implements $PartCopyWith<$Res> {
  _$PartCopyWithImpl(this._self, this._then);

  final Part _self;
  final $Res Function(Part) _then;

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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _self.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _self.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _self.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Part implements Part {
  _Part(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'nameId') this.nameId,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'notice') this.notice,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'url') this.url});
  factory _Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);

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

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PartCopyWith<_Part> get copyWith =>
      __$PartCopyWithImpl<_Part>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PartToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Part &&
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

  @override
  String toString() {
    return 'Part(id: $id, nameId: $nameId, name: $name, number: $number, notice: $notice, description: $description, positionNumber: $positionNumber, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$PartCopyWith<$Res> implements $PartCopyWith<$Res> {
  factory _$PartCopyWith(_Part value, $Res Function(_Part) _then) =
      __$PartCopyWithImpl;
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
class __$PartCopyWithImpl<$Res> implements _$PartCopyWith<$Res> {
  __$PartCopyWithImpl(this._self, this._then);

  final _Part _self;
  final $Res Function(_Part) _then;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_Part(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _self.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _self.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _self.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
