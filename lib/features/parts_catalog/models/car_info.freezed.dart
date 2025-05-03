// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarInfo {
  /// Заголовок.
  @JsonKey(name: 'title')
  String? get title;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String? get catalogId;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Идентификатор автомобиля.
  @JsonKey(name: 'carId')
  String? get carId;

  /// Критерии для поиска.
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Список кодов опций автомобиля.
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes;

  /// Список параметров автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarInfoCopyWith<CarInfo> get copyWith =>
      _$CarInfoCopyWithImpl<CarInfo>(this as CarInfo, _$identity);

  /// Serializes this CarInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarInfo &&
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
                .equals(other.optionCodes, optionCodes) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters));
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
      const DeepCollectionEquality().hash(optionCodes),
      const DeepCollectionEquality().hash(parameters));

  @override
  String toString() {
    return 'CarInfo(title: $title, catalogId: $catalogId, brand: $brand, modelId: $modelId, carId: $carId, criteria: $criteria, vin: $vin, frame: $frame, modelName: $modelName, description: $description, groupsTreeAvailable: $groupsTreeAvailable, optionCodes: $optionCodes, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class $CarInfoCopyWith<$Res> {
  factory $CarInfoCopyWith(CarInfo value, $Res Function(CarInfo) _then) =
      _$CarInfoCopyWithImpl;
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
class _$CarInfoCopyWithImpl<$Res> implements $CarInfoCopyWith<$Res> {
  _$CarInfoCopyWithImpl(this._self, this._then);

  final CarInfo _self;
  final $Res Function(CarInfo) _then;

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
    return _then(_self.copyWith(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _self.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _self.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _self.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _self.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _self.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _self.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _self.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _self.optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _self.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarInfo implements CarInfo {
  _CarInfo(
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
  factory _CarInfo.fromJson(Map<String, dynamic> json) =>
      _$CarInfoFromJson(json);

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

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarInfoCopyWith<_CarInfo> get copyWith =>
      __$CarInfoCopyWithImpl<_CarInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarInfo &&
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

  @override
  String toString() {
    return 'CarInfo(title: $title, catalogId: $catalogId, brand: $brand, modelId: $modelId, carId: $carId, criteria: $criteria, vin: $vin, frame: $frame, modelName: $modelName, description: $description, groupsTreeAvailable: $groupsTreeAvailable, optionCodes: $optionCodes, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class _$CarInfoCopyWith<$Res> implements $CarInfoCopyWith<$Res> {
  factory _$CarInfoCopyWith(_CarInfo value, $Res Function(_CarInfo) _then) =
      __$CarInfoCopyWithImpl;
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
class __$CarInfoCopyWithImpl<$Res> implements _$CarInfoCopyWith<$Res> {
  __$CarInfoCopyWithImpl(this._self, this._then);

  final _CarInfo _self;
  final $Res Function(_CarInfo) _then;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_CarInfo(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _self.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _self.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _self.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _self.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _self.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _self.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _self.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _self._optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _self._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

// dart format on
