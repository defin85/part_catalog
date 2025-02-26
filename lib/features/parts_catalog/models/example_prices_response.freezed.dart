// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_prices_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExamplePricesResponse _$ExamplePricesResponseFromJson(
    Map<String, dynamic> json) {
  return _ExamplePricesResponse.fromJson(json);
}

/// @nodoc
mixin _$ExamplePricesResponse {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;

  /// Код.
  @JsonKey(name: 'code')
  String? get code => throw _privateConstructorUsedError;

  /// Бренд.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Цена.
  @JsonKey(name: 'price')
  String? get price => throw _privateConstructorUsedError;

  /// Количество в корзине.
  @JsonKey(name: 'basketQty')
  String? get basketQty => throw _privateConstructorUsedError;

  /// Количество в наличии.
  @JsonKey(name: 'inStockQty')
  String? get inStockQty => throw _privateConstructorUsedError;

  /// Рейтинг.
  @JsonKey(name: 'rating')
  String? get rating => throw _privateConstructorUsedError;

  /// Доставка.
  @JsonKey(name: 'delivery')
  String? get delivery => throw _privateConstructorUsedError;

  /// Полезная нагрузка (payload).
  @JsonKey(name: 'payload')
  Map<String, String>? get payload => throw _privateConstructorUsedError;

  /// Serializes this ExamplePricesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamplePricesResponseCopyWith<ExamplePricesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamplePricesResponseCopyWith<$Res> {
  factory $ExamplePricesResponseCopyWith(ExamplePricesResponse value,
          $Res Function(ExamplePricesResponse) then) =
      _$ExamplePricesResponseCopyWithImpl<$Res, ExamplePricesResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'code') String? code,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'price') String? price,
      @JsonKey(name: 'basketQty') String? basketQty,
      @JsonKey(name: 'inStockQty') String? inStockQty,
      @JsonKey(name: 'rating') String? rating,
      @JsonKey(name: 'delivery') String? delivery,
      @JsonKey(name: 'payload') Map<String, String>? payload});
}

/// @nodoc
class _$ExamplePricesResponseCopyWithImpl<$Res,
        $Val extends ExamplePricesResponse>
    implements $ExamplePricesResponseCopyWith<$Res> {
  _$ExamplePricesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? code = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? basketQty = freezed,
    Object? inStockQty = freezed,
    Object? rating = freezed,
    Object? delivery = freezed,
    Object? payload = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _value.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _value.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamplePricesResponseImplCopyWith<$Res>
    implements $ExamplePricesResponseCopyWith<$Res> {
  factory _$$ExamplePricesResponseImplCopyWith(
          _$ExamplePricesResponseImpl value,
          $Res Function(_$ExamplePricesResponseImpl) then) =
      __$$ExamplePricesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'code') String? code,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'price') String? price,
      @JsonKey(name: 'basketQty') String? basketQty,
      @JsonKey(name: 'inStockQty') String? inStockQty,
      @JsonKey(name: 'rating') String? rating,
      @JsonKey(name: 'delivery') String? delivery,
      @JsonKey(name: 'payload') Map<String, String>? payload});
}

/// @nodoc
class __$$ExamplePricesResponseImplCopyWithImpl<$Res>
    extends _$ExamplePricesResponseCopyWithImpl<$Res,
        _$ExamplePricesResponseImpl>
    implements _$$ExamplePricesResponseImplCopyWith<$Res> {
  __$$ExamplePricesResponseImplCopyWithImpl(_$ExamplePricesResponseImpl _value,
      $Res Function(_$ExamplePricesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? code = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? basketQty = freezed,
    Object? inStockQty = freezed,
    Object? rating = freezed,
    Object? delivery = freezed,
    Object? payload = freezed,
  }) {
    return _then(_$ExamplePricesResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _value.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _value.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamplePricesResponseImpl implements _ExamplePricesResponse {
  _$ExamplePricesResponseImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'title') this.title,
      @JsonKey(name: 'code') this.code,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'price') this.price,
      @JsonKey(name: 'basketQty') this.basketQty,
      @JsonKey(name: 'inStockQty') this.inStockQty,
      @JsonKey(name: 'rating') this.rating,
      @JsonKey(name: 'delivery') this.delivery,
      @JsonKey(name: 'payload') final Map<String, String>? payload})
      : _payload = payload;

  factory _$ExamplePricesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamplePricesResponseImplFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Название.
  @override
  @JsonKey(name: 'title')
  final String? title;

  /// Код.
  @override
  @JsonKey(name: 'code')
  final String? code;

  /// Бренд.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Цена.
  @override
  @JsonKey(name: 'price')
  final String? price;

  /// Количество в корзине.
  @override
  @JsonKey(name: 'basketQty')
  final String? basketQty;

  /// Количество в наличии.
  @override
  @JsonKey(name: 'inStockQty')
  final String? inStockQty;

  /// Рейтинг.
  @override
  @JsonKey(name: 'rating')
  final String? rating;

  /// Доставка.
  @override
  @JsonKey(name: 'delivery')
  final String? delivery;

  /// Полезная нагрузка (payload).
  final Map<String, String>? _payload;

  /// Полезная нагрузка (payload).
  @override
  @JsonKey(name: 'payload')
  Map<String, String>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ExamplePricesResponse(id: $id, title: $title, code: $code, brand: $brand, price: $price, basketQty: $basketQty, inStockQty: $inStockQty, rating: $rating, delivery: $delivery, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamplePricesResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.basketQty, basketQty) ||
                other.basketQty == basketQty) &&
            (identical(other.inStockQty, inStockQty) ||
                other.inStockQty == inStockQty) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            const DeepCollectionEquality().equals(other._payload, _payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      code,
      brand,
      price,
      basketQty,
      inStockQty,
      rating,
      delivery,
      const DeepCollectionEquality().hash(_payload));

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamplePricesResponseImplCopyWith<_$ExamplePricesResponseImpl>
      get copyWith => __$$ExamplePricesResponseImplCopyWithImpl<
          _$ExamplePricesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamplePricesResponseImplToJson(
      this,
    );
  }
}

abstract class _ExamplePricesResponse implements ExamplePricesResponse {
  factory _ExamplePricesResponse(
          {@JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'title') final String? title,
          @JsonKey(name: 'code') final String? code,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'price') final String? price,
          @JsonKey(name: 'basketQty') final String? basketQty,
          @JsonKey(name: 'inStockQty') final String? inStockQty,
          @JsonKey(name: 'rating') final String? rating,
          @JsonKey(name: 'delivery') final String? delivery,
          @JsonKey(name: 'payload') final Map<String, String>? payload}) =
      _$ExamplePricesResponseImpl;

  factory _ExamplePricesResponse.fromJson(Map<String, dynamic> json) =
      _$ExamplePricesResponseImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Название.
  @override
  @JsonKey(name: 'title')
  String? get title;

  /// Код.
  @override
  @JsonKey(name: 'code')
  String? get code;

  /// Бренд.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Цена.
  @override
  @JsonKey(name: 'price')
  String? get price;

  /// Количество в корзине.
  @override
  @JsonKey(name: 'basketQty')
  String? get basketQty;

  /// Количество в наличии.
  @override
  @JsonKey(name: 'inStockQty')
  String? get inStockQty;

  /// Рейтинг.
  @override
  @JsonKey(name: 'rating')
  String? get rating;

  /// Доставка.
  @override
  @JsonKey(name: 'delivery')
  String? get delivery;

  /// Полезная нагрузка (payload).
  @override
  @JsonKey(name: 'payload')
  Map<String, String>? get payload;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamplePricesResponseImplCopyWith<_$ExamplePricesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
