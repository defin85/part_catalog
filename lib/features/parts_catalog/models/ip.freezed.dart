// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ip {
  /// IP-адрес.
  @JsonKey(name: 'ip')
  String? get ip;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IpCopyWith<Ip> get copyWith => _$IpCopyWithImpl<Ip>(this as Ip, _$identity);

  /// Serializes this Ip to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Ip &&
            (identical(other.ip, ip) || other.ip == ip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip);

  @override
  String toString() {
    return 'Ip(ip: $ip)';
  }
}

/// @nodoc
abstract mixin class $IpCopyWith<$Res> {
  factory $IpCopyWith(Ip value, $Res Function(Ip) _then) = _$IpCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class _$IpCopyWithImpl<$Res> implements $IpCopyWith<$Res> {
  _$IpCopyWithImpl(this._self, this._then);

  final Ip _self;
  final $Res Function(Ip) _then;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_self.copyWith(
      ip: freezed == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Ip implements Ip {
  _Ip({@JsonKey(name: 'ip') this.ip});
  factory _Ip.fromJson(Map<String, dynamic> json) => _$IpFromJson(json);

  /// IP-адрес.
  @override
  @JsonKey(name: 'ip')
  final String? ip;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IpCopyWith<_Ip> get copyWith => __$IpCopyWithImpl<_Ip>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IpToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Ip &&
            (identical(other.ip, ip) || other.ip == ip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip);

  @override
  String toString() {
    return 'Ip(ip: $ip)';
  }
}

/// @nodoc
abstract mixin class _$IpCopyWith<$Res> implements $IpCopyWith<$Res> {
  factory _$IpCopyWith(_Ip value, $Res Function(_Ip) _then) = __$IpCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class __$IpCopyWithImpl<$Res> implements _$IpCopyWith<$Res> {
  __$IpCopyWithImpl(this._self, this._then);

  final _Ip _self;
  final $Res Function(_Ip) _then;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_Ip(
      ip: freezed == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
