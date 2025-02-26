// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Car2 _$Car2FromJson(Map<String, dynamic> json) {
  return _Car2.fromJson(json);
}

/// @nodoc
mixin _$Car2 {
  /// Идентификатор автомобиля.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String get catalogId => throw _privateConstructorUsedError;

  /// Название автомобиля.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId => throw _privateConstructorUsedError;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName => throw _privateConstructorUsedError;

  /// URL изображения модели автомобиля.
  @JsonKey(name: 'modelImg')
  String? get modelImg => throw _privateConstructorUsedError;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin => throw _privateConstructorUsedError;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame => throw _privateConstructorUsedError;

  /// Критерии для фильтрации групп и запчастей.
  @JsonKey(name: 'criteria')
  String? get criteria => throw _privateConstructorUsedError;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable => throw _privateConstructorUsedError;

  /// Параметры автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this Car2 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Car2CopyWith<Car2> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Car2CopyWith<$Res> {
  factory $Car2CopyWith(Car2 value, $Res Function(Car2) then) =
      _$Car2CopyWithImpl<$Res, Car2>;
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
class _$Car2CopyWithImpl<$Res, $Val extends Car2>
    implements $Car2CopyWith<$Res> {
  _$Car2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _value.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Car2ImplCopyWith<$Res> implements $Car2CopyWith<$Res> {
  factory _$$Car2ImplCopyWith(
          _$Car2Impl value, $Res Function(_$Car2Impl) then) =
      __$$Car2ImplCopyWithImpl<$Res>;
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
class __$$Car2ImplCopyWithImpl<$Res>
    extends _$Car2CopyWithImpl<$Res, _$Car2Impl>
    implements _$$Car2ImplCopyWith<$Res> {
  __$$Car2ImplCopyWithImpl(_$Car2Impl _value, $Res Function(_$Car2Impl) _then)
      : super(_value, _then);

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
    return _then(_$Car2Impl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _value.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Car2Impl implements _Car2 {
  _$Car2Impl(
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

  factory _$Car2Impl.fromJson(Map<String, dynamic> json) =>
      _$$Car2ImplFromJson(json);

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

  @override
  String toString() {
    return 'Car2(id: $id, catalogId: $catalogId, name: $name, description: $description, modelId: $modelId, modelName: $modelName, modelImg: $modelImg, vin: $vin, frame: $frame, criteria: $criteria, brand: $brand, groupsTreeAvailable: $groupsTreeAvailable, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Car2Impl &&
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

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Car2ImplCopyWith<_$Car2Impl> get copyWith =>
      __$$Car2ImplCopyWithImpl<_$Car2Impl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Car2ImplToJson(
      this,
    );
  }
}

abstract class _Car2 implements Car2 {
  factory _Car2(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'catalogId') required final String catalogId,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'modelId') final String? modelId,
          @JsonKey(name: 'modelName') final String? modelName,
          @JsonKey(name: 'modelImg') final String? modelImg,
          @JsonKey(name: 'vin') final String? vin,
          @JsonKey(name: 'frame') final String? frame,
          @JsonKey(name: 'criteria') final String? criteria,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'groupsTreeAvailable') final bool? groupsTreeAvailable,
          @JsonKey(name: 'parameters') final List<CarParameter>? parameters}) =
      _$Car2Impl;

  factory _Car2.fromJson(Map<String, dynamic> json) = _$Car2Impl.fromJson;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  String get catalogId;

  /// Название автомобиля.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// URL изображения модели автомобиля.
  @override
  @JsonKey(name: 'modelImg')
  String? get modelImg;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  String? get frame;

  /// Критерии для фильтрации групп и запчастей.
  @override
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Параметры автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Car2ImplCopyWith<_$Car2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

CarParameter _$CarParameterFromJson(Map<String, dynamic> json) {
  return _CarParameter.fromJson(json);
}

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterCopyWith<CarParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) then) =
      _$CarParameterCopyWithImpl<$Res, CarParameter>;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res, $Val extends CarParameter>
    implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterImplCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$$CarParameterImplCopyWith(
          _$CarParameterImpl value, $Res Function(_$CarParameterImpl) then) =
      __$$CarParameterImplCopyWithImpl<$Res>;
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
class __$$CarParameterImplCopyWithImpl<$Res>
    extends _$CarParameterCopyWithImpl<$Res, _$CarParameterImpl>
    implements _$$CarParameterImplCopyWith<$Res> {
  __$$CarParameterImplCopyWithImpl(
      _$CarParameterImpl _value, $Res Function(_$CarParameterImpl) _then)
      : super(_value, _then);

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
    return _then(_$CarParameterImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterImpl implements _CarParameter {
  _$CarParameterImpl(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});

  factory _$CarParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterImplFromJson(json);

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

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterImpl &&
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

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      __$$CarParameterImplCopyWithImpl<_$CarParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterImplToJson(
      this,
    );
  }
}

abstract class _CarParameter implements CarParameter {
  factory _CarParameter(
      {@JsonKey(name: 'idx') final String? idx,
      @JsonKey(name: 'key') final String? key,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'value') final String? value,
      @JsonKey(name: 'sortOrder') final int? sortOrder}) = _$CarParameterImpl;

  factory _CarParameter.fromJson(Map<String, dynamic> json) =
      _$CarParameterImpl.fromJson;

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
