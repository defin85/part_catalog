// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Suggest {
  /// Идентификатор поиска.
  @JsonKey(name: 'sid')
  String? get sid;

  /// Название.
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SuggestCopyWith<Suggest> get copyWith =>
      _$SuggestCopyWithImpl<Suggest>(this as Suggest, _$identity);

  /// Serializes this Suggest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Suggest &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sid, name);

  @override
  String toString() {
    return 'Suggest(sid: $sid, name: $name)';
  }
}

/// @nodoc
abstract mixin class $SuggestCopyWith<$Res> {
  factory $SuggestCopyWith(Suggest value, $Res Function(Suggest) _then) =
      _$SuggestCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$SuggestCopyWithImpl<$Res> implements $SuggestCopyWith<$Res> {
  _$SuggestCopyWithImpl(this._self, this._then);

  final Suggest _self;
  final $Res Function(Suggest) _then;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_self.copyWith(
      sid: freezed == sid
          ? _self.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Suggest implements Suggest {
  _Suggest({@JsonKey(name: 'sid') this.sid, @JsonKey(name: 'name') this.name});
  factory _Suggest.fromJson(Map<String, dynamic> json) =>
      _$SuggestFromJson(json);

  /// Идентификатор поиска.
  @override
  @JsonKey(name: 'sid')
  final String? sid;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SuggestCopyWith<_Suggest> get copyWith =>
      __$SuggestCopyWithImpl<_Suggest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SuggestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Suggest &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sid, name);

  @override
  String toString() {
    return 'Suggest(sid: $sid, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$SuggestCopyWith<$Res> implements $SuggestCopyWith<$Res> {
  factory _$SuggestCopyWith(_Suggest value, $Res Function(_Suggest) _then) =
      __$SuggestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$SuggestCopyWithImpl<$Res> implements _$SuggestCopyWith<$Res> {
  __$SuggestCopyWithImpl(this._self, this._then);

  final _Suggest _self;
  final $Res Function(_Suggest) _then;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_Suggest(
      sid: freezed == sid
          ? _self.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
