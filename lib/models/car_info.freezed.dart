// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarInfo _$CarInfoFromJson(Map<String, dynamic> json) {
  return _CarInfo.fromJson(json);
}

/// @nodoc
mixin _$CarInfo {
  /// Заголовок.
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String? get catalogId => throw _privateConstructorUsedError;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId => throw _privateConstructorUsedError;

  /// Идентификатор автомобиля.
  @JsonKey(name: 'carId')
  String? get carId => throw _privateConstructorUsedError;

  /// Критерии для поиска.
  @JsonKey(name: 'criteria')
  String? get criteria => throw _privateConstructorUsedError;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin => throw _privateConstructorUsedError;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame => throw _privateConstructorUsedError;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName => throw _privateConstructorUsedError;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable => throw _privateConstructorUsedError;

  /// Список кодов опций автомобиля.
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes => throw _privateConstructorUsedError;

  /// Список параметров автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this CarInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarInfoCopyWith<CarInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarInfoCopyWith<$Res> {
  factory $CarInfoCopyWith(CarInfo value, $Res Function(CarInfo) then) =
      _$CarInfoCopyWithImpl<$Res, CarInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String? title,
      @JsonKey(name: 'catalogId') String? catalogId,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'carId') String? carId,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class _$CarInfoCopyWithImpl<$Res, $Val extends CarInfo>
    implements $CarInfoCopyWith<$Res> {
  _$CarInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? catalogId = freezed,
    Object? brand = freezed,
    Object? modelId = freezed,
    Object? carId = freezed,
    Object? criteria = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? modelName = freezed,
    Object? description = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? optionCodes = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _value.optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarInfoImplCopyWith<$Res> implements $CarInfoCopyWith<$Res> {
  factory _$$CarInfoImplCopyWith(
          _$CarInfoImpl value, $Res Function(_$CarInfoImpl) then) =
      __$$CarInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String? title,
      @JsonKey(name: 'catalogId') String? catalogId,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'carId') String? carId,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class __$$CarInfoImplCopyWithImpl<$Res>
    extends _$CarInfoCopyWithImpl<$Res, _$CarInfoImpl>
    implements _$$CarInfoImplCopyWith<$Res> {
  __$$CarInfoImplCopyWithImpl(
      _$CarInfoImpl _value, $Res Function(_$CarInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? catalogId = freezed,
    Object? brand = freezed,
    Object? modelId = freezed,
    Object? carId = freezed,
    Object? criteria = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? modelName = freezed,
    Object? description = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? optionCodes = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_$CarInfoImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _value._optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarInfoImpl implements _CarInfo {
  _$CarInfoImpl(
      {@JsonKey(name: 'title') this.title,
      @JsonKey(name: 'catalogId') this.catalogId,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'modelId') this.modelId,
      @JsonKey(name: 'carId') this.carId,
      @JsonKey(name: 'criteria') this.criteria,
      @JsonKey(name: 'vin') this.vin,
      @JsonKey(name: 'frame') this.frame,
      @JsonKey(name: 'modelName') this.modelName,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'groupsTreeAvailable') this.groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') final List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') final List<CarParameter>? parameters})
      : _optionCodes = optionCodes,
        _parameters = parameters;

  factory _$CarInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarInfoImplFromJson(json);

  /// Заголовок.
  @override
  @JsonKey(name: 'title')
  final String? title;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  final String? catalogId;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  final String? modelId;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'carId')
  final String? carId;

  /// Критерии для поиска.
  @override
  @JsonKey(name: 'criteria')
  final String? criteria;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  final String? vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  final String? frame;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  final String? modelName;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  final bool? groupsTreeAvailable;

  /// Список кодов опций автомобиля.
  final List<OptionCode>? _optionCodes;

  /// Список кодов опций автомобиля.
  @override
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes {
    final value = _optionCodes;
    if (value == null) return null;
    if (_optionCodes is EqualUnmodifiableListView) return _optionCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Список параметров автомобиля.
  final List<CarParameter>? _parameters;

  /// Список параметров автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CarInfo(title: $title, catalogId: $catalogId, brand: $brand, modelId: $modelId, carId: $carId, criteria: $criteria, vin: $vin, frame: $frame, modelName: $modelName, description: $description, groupsTreeAvailable: $groupsTreeAvailable, optionCodes: $optionCodes, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarInfoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.groupsTreeAvailable, groupsTreeAvailable) ||
                other.groupsTreeAvailable == groupsTreeAvailable) &&
            const DeepCollectionEquality()
                .equals(other._optionCodes, _optionCodes) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      catalogId,
      brand,
      modelId,
      carId,
      criteria,
      vin,
      frame,
      modelName,
      description,
      groupsTreeAvailable,
      const DeepCollectionEquality().hash(_optionCodes),
      const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarInfoImplCopyWith<_$CarInfoImpl> get copyWith =>
      __$$CarInfoImplCopyWithImpl<_$CarInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarInfoImplToJson(
      this,
    );
  }
}

abstract class _CarInfo implements CarInfo {
  factory _CarInfo(
          {@JsonKey(name: 'title') final String? title,
          @JsonKey(name: 'catalogId') final String? catalogId,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'modelId') final String? modelId,
          @JsonKey(name: 'carId') final String? carId,
          @JsonKey(name: 'criteria') final String? criteria,
          @JsonKey(name: 'vin') final String? vin,
          @JsonKey(name: 'frame') final String? frame,
          @JsonKey(name: 'modelName') final String? modelName,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'groupsTreeAvailable') final bool? groupsTreeAvailable,
          @JsonKey(name: 'optionCodes') final List<OptionCode>? optionCodes,
          @JsonKey(name: 'parameters') final List<CarParameter>? parameters}) =
      _$CarInfoImpl;

  factory _CarInfo.fromJson(Map<String, dynamic> json) = _$CarInfoImpl.fromJson;

  /// Заголовок.
  @override
  @JsonKey(name: 'title')
  String? get title;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  String? get catalogId;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'carId')
  String? get carId;

  /// Критерии для поиска.
  @override
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  String? get frame;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Список кодов опций автомобиля.
  @override
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes;

  /// Список параметров автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarInfoImplCopyWith<_$CarInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
