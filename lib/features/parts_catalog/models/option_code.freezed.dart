// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OptionCode {
  /// Код опции.
  @JsonKey(name: 'code')
  String? get code;

  /// Описание опции.
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OptionCodeCopyWith<OptionCode> get copyWith =>
      _$OptionCodeCopyWithImpl<OptionCode>(this as OptionCode, _$identity);

  /// Serializes this OptionCode to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OptionCode &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  @override
  String toString() {
    return 'OptionCode(code: $code, description: $description)';
  }
}

/// @nodoc
abstract mixin class $OptionCodeCopyWith<$Res> {
  factory $OptionCodeCopyWith(
          OptionCode value, $Res Function(OptionCode) _then) =
      _$OptionCodeCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class _$OptionCodeCopyWithImpl<$Res> implements $OptionCodeCopyWith<$Res> {
  _$OptionCodeCopyWithImpl(this._self, this._then);

  final OptionCode _self;
  final $Res Function(OptionCode) _then;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_self.copyWith(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OptionCode implements OptionCode {
  _OptionCode(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'description') this.description});
  factory _OptionCode.fromJson(Map<String, dynamic> json) =>
      _$OptionCodeFromJson(json);

  /// Код опции.
  @override
  @JsonKey(name: 'code')
  final String? code;

  /// Описание опции.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OptionCodeCopyWith<_OptionCode> get copyWith =>
      __$OptionCodeCopyWithImpl<_OptionCode>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OptionCodeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OptionCode &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  @override
  String toString() {
    return 'OptionCode(code: $code, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$OptionCodeCopyWith<$Res>
    implements $OptionCodeCopyWith<$Res> {
  factory _$OptionCodeCopyWith(
          _OptionCode value, $Res Function(_OptionCode) _then) =
      __$OptionCodeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class __$OptionCodeCopyWithImpl<$Res> implements _$OptionCodeCopyWith<$Res> {
  __$OptionCodeCopyWithImpl(this._self, this._then);

  final _OptionCode _self;
  final $Res Function(_OptionCode) _then;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_OptionCode(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
