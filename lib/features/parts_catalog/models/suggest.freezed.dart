// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Suggest _$SuggestFromJson(Map<String, dynamic> json) {
  return _Suggest.fromJson(json);
}

/// @nodoc
mixin _$Suggest {
  /// Идентификатор поиска.
  @JsonKey(name: 'sid')
  String? get sid => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this Suggest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestCopyWith<Suggest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestCopyWith<$Res> {
  factory $SuggestCopyWith(Suggest value, $Res Function(Suggest) then) =
      _$SuggestCopyWithImpl<$Res, Suggest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$SuggestCopyWithImpl<$Res, $Val extends Suggest>
    implements $SuggestCopyWith<$Res> {
  _$SuggestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      sid: freezed == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestImplCopyWith<$Res> implements $SuggestCopyWith<$Res> {
  factory _$$SuggestImplCopyWith(
          _$SuggestImpl value, $Res Function(_$SuggestImpl) then) =
      __$$SuggestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$$SuggestImplCopyWithImpl<$Res>
    extends _$SuggestCopyWithImpl<$Res, _$SuggestImpl>
    implements _$$SuggestImplCopyWith<$Res> {
  __$$SuggestImplCopyWithImpl(
      _$SuggestImpl _value, $Res Function(_$SuggestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_$SuggestImpl(
      sid: freezed == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestImpl implements _Suggest {
  _$SuggestImpl(
      {@JsonKey(name: 'sid') this.sid, @JsonKey(name: 'name') this.name});

  factory _$SuggestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestImplFromJson(json);

  /// Идентификатор поиска.
  @override
  @JsonKey(name: 'sid')
  final String? sid;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'Suggest(sid: $sid, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestImpl &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sid, name);

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestImplCopyWith<_$SuggestImpl> get copyWith =>
      __$$SuggestImplCopyWithImpl<_$SuggestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestImplToJson(
      this,
    );
  }
}

abstract class _Suggest implements Suggest {
  factory _Suggest(
      {@JsonKey(name: 'sid') final String? sid,
      @JsonKey(name: 'name') final String? name}) = _$SuggestImpl;

  factory _Suggest.fromJson(Map<String, dynamic> json) = _$SuggestImpl.fromJson;

  /// Идентификатор поиска.
  @override
  @JsonKey(name: 'sid')
  String? get sid;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestImplCopyWith<_$SuggestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
