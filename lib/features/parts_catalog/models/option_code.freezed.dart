// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OptionCode _$OptionCodeFromJson(Map<String, dynamic> json) {
  return _OptionCode.fromJson(json);
}

/// @nodoc
mixin _$OptionCode {
  /// Код опции.
  @JsonKey(name: 'code')
  String? get code => throw _privateConstructorUsedError;

  /// Описание опции.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this OptionCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptionCodeCopyWith<OptionCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionCodeCopyWith<$Res> {
  factory $OptionCodeCopyWith(
          OptionCode value, $Res Function(OptionCode) then) =
      _$OptionCodeCopyWithImpl<$Res, OptionCode>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class _$OptionCodeCopyWithImpl<$Res, $Val extends OptionCode>
    implements $OptionCodeCopyWith<$Res> {
  _$OptionCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptionCodeImplCopyWith<$Res>
    implements $OptionCodeCopyWith<$Res> {
  factory _$$OptionCodeImplCopyWith(
          _$OptionCodeImpl value, $Res Function(_$OptionCodeImpl) then) =
      __$$OptionCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class __$$OptionCodeImplCopyWithImpl<$Res>
    extends _$OptionCodeCopyWithImpl<$Res, _$OptionCodeImpl>
    implements _$$OptionCodeImplCopyWith<$Res> {
  __$$OptionCodeImplCopyWithImpl(
      _$OptionCodeImpl _value, $Res Function(_$OptionCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_$OptionCodeImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OptionCodeImpl implements _OptionCode {
  _$OptionCodeImpl(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'description') this.description});

  factory _$OptionCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptionCodeImplFromJson(json);

  /// Код опции.
  @override
  @JsonKey(name: 'code')
  final String? code;

  /// Описание опции.
  @override
  @JsonKey(name: 'description')
  final String? description;

  @override
  String toString() {
    return 'OptionCode(code: $code, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptionCodeImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptionCodeImplCopyWith<_$OptionCodeImpl> get copyWith =>
      __$$OptionCodeImplCopyWithImpl<_$OptionCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptionCodeImplToJson(
      this,
    );
  }
}

abstract class _OptionCode implements OptionCode {
  factory _OptionCode(
          {@JsonKey(name: 'code') final String? code,
          @JsonKey(name: 'description') final String? description}) =
      _$OptionCodeImpl;

  factory _OptionCode.fromJson(Map<String, dynamic> json) =
      _$OptionCodeImpl.fromJson;

  /// Код опции.
  @override
  @JsonKey(name: 'code')
  String? get code;

  /// Описание опции.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptionCodeImplCopyWith<_$OptionCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
