// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ip _$IpFromJson(Map<String, dynamic> json) {
  return _Ip.fromJson(json);
}

/// @nodoc
mixin _$Ip {
  /// IP-адрес.
  @JsonKey(name: 'ip')
  String? get ip => throw _privateConstructorUsedError;

  /// Serializes this Ip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IpCopyWith<Ip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IpCopyWith<$Res> {
  factory $IpCopyWith(Ip value, $Res Function(Ip) then) =
      _$IpCopyWithImpl<$Res, Ip>;
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class _$IpCopyWithImpl<$Res, $Val extends Ip> implements $IpCopyWith<$Res> {
  _$IpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_value.copyWith(
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IpImplCopyWith<$Res> implements $IpCopyWith<$Res> {
  factory _$$IpImplCopyWith(_$IpImpl value, $Res Function(_$IpImpl) then) =
      __$$IpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class __$$IpImplCopyWithImpl<$Res> extends _$IpCopyWithImpl<$Res, _$IpImpl>
    implements _$$IpImplCopyWith<$Res> {
  __$$IpImplCopyWithImpl(_$IpImpl _value, $Res Function(_$IpImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_$IpImpl(
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IpImpl implements _Ip {
  _$IpImpl({@JsonKey(name: 'ip') this.ip});

  factory _$IpImpl.fromJson(Map<String, dynamic> json) =>
      _$$IpImplFromJson(json);

  /// IP-адрес.
  @override
  @JsonKey(name: 'ip')
  final String? ip;

  @override
  String toString() {
    return 'Ip(ip: $ip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IpImpl &&
            (identical(other.ip, ip) || other.ip == ip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip);

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IpImplCopyWith<_$IpImpl> get copyWith =>
      __$$IpImplCopyWithImpl<_$IpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IpImplToJson(
      this,
    );
  }
}

abstract class _Ip implements Ip {
  factory _Ip({@JsonKey(name: 'ip') final String? ip}) = _$IpImpl;

  factory _Ip.fromJson(Map<String, dynamic> json) = _$IpImpl.fromJson;

  /// IP-адрес.
  @override
  @JsonKey(name: 'ip')
  String? get ip;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IpImplCopyWith<_$IpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
