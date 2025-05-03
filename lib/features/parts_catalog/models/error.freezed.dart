// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Error {
  /// Код ошибки.
  @JsonKey(name: 'code')
  int? get code;

  /// Код ошибки (строковый).
  @JsonKey(name: 'errorCode')
  String? get errorCode;

  /// Сообщение об ошибке.
  @JsonKey(name: 'message')
  String? get message;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this as Error, _$identity);

  /// Serializes this Error to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Error &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, errorCode, message);

  @override
  String toString() {
    return 'Error(code: $code, errorCode: $errorCode, message: $message)';
  }
}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) =
      _$ErrorCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'message') String? message});
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res> implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_self.copyWith(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Error implements Error {
  _Error(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'errorCode') this.errorCode,
      @JsonKey(name: 'message') this.message});
  factory _Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  /// Код ошибки.
  @override
  @JsonKey(name: 'code')
  final int? code;

  /// Код ошибки (строковый).
  @override
  @JsonKey(name: 'errorCode')
  final String? errorCode;

  /// Сообщение об ошибке.
  @override
  @JsonKey(name: 'message')
  final String? message;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, errorCode, message);

  @override
  String toString() {
    return 'Error(code: $code, errorCode: $errorCode, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ErrorCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'message') String? message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_Error(
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
