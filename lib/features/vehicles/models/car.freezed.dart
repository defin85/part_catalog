// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarModel _$CarModelFromJson(Map<String, dynamic> json) {
  return _CarModel.fromJson(json);
}

/// @nodoc
mixin _$CarModel {
  /// Уникальный идентификатор автомобиля.
  String get id => throw _privateConstructorUsedError;

  /// Идентификатор клиента-владельца.
  String get clientId => throw _privateConstructorUsedError;

  /// VIN-код.
  String get vin => throw _privateConstructorUsedError;

  /// Марка автомобиля.
  String get make => throw _privateConstructorUsedError;

  /// Модель автомобиля.
  String get model => throw _privateConstructorUsedError;

  /// Год выпуска.
  int get year => throw _privateConstructorUsedError;

  /// Номерной знак.
  String? get licensePlate => throw _privateConstructorUsedError;

  /// Дополнительная информация.
  String? get additionalInfo => throw _privateConstructorUsedError;

  /// Serializes this CarModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarModelCopyWith<CarModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarModelCopyWith<$Res> {
  factory $CarModelCopyWith(CarModel value, $Res Function(CarModel) then) =
      _$CarModelCopyWithImpl<$Res, CarModel>;
  @useResult
  $Res call(
      {String id,
      String clientId,
      String vin,
      String make,
      String model,
      int year,
      String? licensePlate,
      String? additionalInfo});
}

/// @nodoc
class _$CarModelCopyWithImpl<$Res, $Val extends CarModel>
    implements $CarModelCopyWith<$Res> {
  _$CarModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? vin = null,
    Object? make = null,
    Object? model = null,
    Object? year = null,
    Object? licensePlate = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      licensePlate: freezed == licensePlate
          ? _value.licensePlate
          : licensePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarModelImplCopyWith<$Res>
    implements $CarModelCopyWith<$Res> {
  factory _$$CarModelImplCopyWith(
          _$CarModelImpl value, $Res Function(_$CarModelImpl) then) =
      __$$CarModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clientId,
      String vin,
      String make,
      String model,
      int year,
      String? licensePlate,
      String? additionalInfo});
}

/// @nodoc
class __$$CarModelImplCopyWithImpl<$Res>
    extends _$CarModelCopyWithImpl<$Res, _$CarModelImpl>
    implements _$$CarModelImplCopyWith<$Res> {
  __$$CarModelImplCopyWithImpl(
      _$CarModelImpl _value, $Res Function(_$CarModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? vin = null,
    Object? make = null,
    Object? model = null,
    Object? year = null,
    Object? licensePlate = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_$CarModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      licensePlate: freezed == licensePlate
          ? _value.licensePlate
          : licensePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarModelImpl implements _CarModel {
  const _$CarModelImpl(
      {required this.id,
      required this.clientId,
      required this.vin,
      required this.make,
      required this.model,
      required this.year,
      this.licensePlate,
      this.additionalInfo});

  factory _$CarModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarModelImplFromJson(json);

  /// Уникальный идентификатор автомобиля.
  @override
  final String id;

  /// Идентификатор клиента-владельца.
  @override
  final String clientId;

  /// VIN-код.
  @override
  final String vin;

  /// Марка автомобиля.
  @override
  final String make;

  /// Модель автомобиля.
  @override
  final String model;

  /// Год выпуска.
  @override
  final int year;

  /// Номерной знак.
  @override
  final String? licensePlate;

  /// Дополнительная информация.
  @override
  final String? additionalInfo;

  @override
  String toString() {
    return 'CarModel(id: $id, clientId: $clientId, vin: $vin, make: $make, model: $model, year: $year, licensePlate: $licensePlate, additionalInfo: $additionalInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.licensePlate, licensePlate) ||
                other.licensePlate == licensePlate) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clientId, vin, make, model,
      year, licensePlate, additionalInfo);

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      __$$CarModelImplCopyWithImpl<_$CarModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarModelImplToJson(
      this,
    );
  }
}

abstract class _CarModel implements CarModel {
  const factory _CarModel(
      {required final String id,
      required final String clientId,
      required final String vin,
      required final String make,
      required final String model,
      required final int year,
      final String? licensePlate,
      final String? additionalInfo}) = _$CarModelImpl;

  factory _CarModel.fromJson(Map<String, dynamic> json) =
      _$CarModelImpl.fromJson;

  /// Уникальный идентификатор автомобиля.
  @override
  String get id;

  /// Идентификатор клиента-владельца.
  @override
  String get clientId;

  /// VIN-код.
  @override
  String get vin;

  /// Марка автомобиля.
  @override
  String get make;

  /// Модель автомобиля.
  @override
  String get model;

  /// Год выпуска.
  @override
  int get year;

  /// Номерной знак.
  @override
  String? get licensePlate;

  /// Дополнительная информация.
  @override
  String? get additionalInfo;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
