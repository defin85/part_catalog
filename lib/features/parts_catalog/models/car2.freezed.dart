// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Car2 {
  /// Идентификатор автомобиля.
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String get catalogId;

  /// Название автомобиля.
  @JsonKey(name: 'name')
  String get name;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// URL изображения модели автомобиля.
  @JsonKey(name: 'modelImg')
  String? get modelImg;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame;

  /// Критерии для фильтрации групп и запчастей.
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Параметры автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Car2CopyWith<Car2> get copyWith =>
      _$Car2CopyWithImpl<Car2>(this as Car2, _$identity);

  /// Serializes this Car2 to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Car2 &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.modelImg, modelImg) ||
                other.modelImg == modelImg) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.groupsTreeAvailable, groupsTreeAvailable) ||
                other.groupsTreeAvailable == groupsTreeAvailable) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      catalogId,
      name,
      description,
      modelId,
      modelName,
      modelImg,
      vin,
      frame,
      criteria,
      brand,
      groupsTreeAvailable,
      const DeepCollectionEquality().hash(parameters));

  @override
  String toString() {
    return 'Car2(id: $id, catalogId: $catalogId, name: $name, description: $description, modelId: $modelId, modelName: $modelName, modelImg: $modelImg, vin: $vin, frame: $frame, criteria: $criteria, brand: $brand, groupsTreeAvailable: $groupsTreeAvailable, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class $Car2CopyWith<$Res> {
  factory $Car2CopyWith(Car2 value, $Res Function(Car2) _then) =
      _$Car2CopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'catalogId') String catalogId,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'modelImg') String? modelImg,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class _$Car2CopyWithImpl<$Res> implements $Car2CopyWith<$Res> {
  _$Car2CopyWithImpl(this._self, this._then);

  final Car2 _self;
  final $Res Function(Car2) _then;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? name = null,
    Object? description = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
    Object? modelImg = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? criteria = freezed,
    Object? brand = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _self.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _self.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _self.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _self.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _self.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _self.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _self.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _self.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Car2 implements Car2 {
  _Car2(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'catalogId') required this.catalogId,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'modelId') this.modelId,
      @JsonKey(name: 'modelName') this.modelName,
      @JsonKey(name: 'modelImg') this.modelImg,
      @JsonKey(name: 'vin') this.vin,
      @JsonKey(name: 'frame') this.frame,
      @JsonKey(name: 'criteria') this.criteria,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'groupsTreeAvailable') this.groupsTreeAvailable,
      @JsonKey(name: 'parameters') final List<CarParameter>? parameters})
      : _parameters = parameters;
  factory _Car2.fromJson(Map<String, dynamic> json) => _$Car2FromJson(json);

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  final String catalogId;

  /// Название автомобиля.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  final String? modelId;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  final String? modelName;

  /// URL изображения модели автомобиля.
  @override
  @JsonKey(name: 'modelImg')
  final String? modelImg;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  final String? vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  final String? frame;

  /// Критерии для фильтрации групп и запчастей.
  @override
  @JsonKey(name: 'criteria')
  final String? criteria;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  final bool? groupsTreeAvailable;

  /// Параметры автомобиля.
  final List<CarParameter>? _parameters;

  /// Параметры автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Car2CopyWith<_Car2> get copyWith =>
      __$Car2CopyWithImpl<_Car2>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$Car2ToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Car2 &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.modelImg, modelImg) ||
                other.modelImg == modelImg) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.groupsTreeAvailable, groupsTreeAvailable) ||
                other.groupsTreeAvailable == groupsTreeAvailable) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      catalogId,
      name,
      description,
      modelId,
      modelName,
      modelImg,
      vin,
      frame,
      criteria,
      brand,
      groupsTreeAvailable,
      const DeepCollectionEquality().hash(_parameters));

  @override
  String toString() {
    return 'Car2(id: $id, catalogId: $catalogId, name: $name, description: $description, modelId: $modelId, modelName: $modelName, modelImg: $modelImg, vin: $vin, frame: $frame, criteria: $criteria, brand: $brand, groupsTreeAvailable: $groupsTreeAvailable, parameters: $parameters)';
  }
}

/// @nodoc
abstract mixin class _$Car2CopyWith<$Res> implements $Car2CopyWith<$Res> {
  factory _$Car2CopyWith(_Car2 value, $Res Function(_Car2) _then) =
      __$Car2CopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'catalogId') String catalogId,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'modelImg') String? modelImg,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class __$Car2CopyWithImpl<$Res> implements _$Car2CopyWith<$Res> {
  __$Car2CopyWithImpl(this._self, this._then);

  final _Car2 _self;
  final $Res Function(_Car2) _then;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? name = null,
    Object? description = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
    Object? modelImg = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? criteria = freezed,
    Object? brand = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_Car2(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _self.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _self.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _self.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _self.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _self.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _self.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _self.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _self._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CarParameterCopyWith<CarParameter> get copyWith =>
      _$CarParameterCopyWithImpl<CarParameter>(
          this as CarParameter, _$identity);

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CarParameter &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, key, name, value, sortOrder);

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) _then) =
      _$CarParameterCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res> implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._self, this._then);

  final CarParameter _self;
  final $Res Function(CarParameter) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_self.copyWith(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CarParameter implements CarParameter {
  _CarParameter(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});
  factory _CarParameter.fromJson(Map<String, dynamic> json) =>
      _$CarParameterFromJson(json);

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  final String? value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CarParameterCopyWith<_CarParameter> get copyWith =>
      __$CarParameterCopyWithImpl<_CarParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CarParameterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CarParameter &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, key, name, value, sortOrder);

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$CarParameterCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$CarParameterCopyWith(
          _CarParameter value, $Res Function(_CarParameter) _then) =
      __$CarParameterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$CarParameterCopyWithImpl<$Res>
    implements _$CarParameterCopyWith<$Res> {
  __$CarParameterCopyWithImpl(this._self, this._then);

  final _CarParameter _self;
  final $Res Function(_CarParameter) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_CarParameter(
      idx: freezed == idx
          ? _self.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
