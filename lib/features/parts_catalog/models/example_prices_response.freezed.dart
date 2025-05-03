// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_prices_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamplePricesResponse {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String? get id;

  /// Название.
  @JsonKey(name: 'title')
  String? get title;

  /// Код.
  @JsonKey(name: 'code')
  String? get code;

  /// Бренд.
  @JsonKey(name: 'brand')
  String? get brand;

  /// Цена.
  @JsonKey(name: 'price')
  String? get price;

  /// Количество в корзине.
  @JsonKey(name: 'basketQty')
  String? get basketQty;

  /// Количество в наличии.
  @JsonKey(name: 'inStockQty')
  String? get inStockQty;

  /// Рейтинг.
  @JsonKey(name: 'rating')
  String? get rating;

  /// Доставка.
  @JsonKey(name: 'delivery')
  String? get delivery;

  /// Полезная нагрузка (payload).
  @JsonKey(name: 'payload')
  Map<String, String>? get payload;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExamplePricesResponseCopyWith<ExamplePricesResponse> get copyWith =>
      _$ExamplePricesResponseCopyWithImpl<ExamplePricesResponse>(
          this as ExamplePricesResponse, _$identity);

  /// Serializes this ExamplePricesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExamplePricesResponse &&
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
            const DeepCollectionEquality().equals(other.payload, payload));
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
      const DeepCollectionEquality().hash(payload));

  @override
  String toString() {
    return 'ExamplePricesResponse(id: $id, title: $title, code: $code, brand: $brand, price: $price, basketQty: $basketQty, inStockQty: $inStockQty, rating: $rating, delivery: $delivery, payload: $payload)';
  }
}

/// @nodoc
abstract mixin class $ExamplePricesResponseCopyWith<$Res> {
  factory $ExamplePricesResponseCopyWith(ExamplePricesResponse value,
          $Res Function(ExamplePricesResponse) _then) =
      _$ExamplePricesResponseCopyWithImpl;
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
class _$ExamplePricesResponseCopyWithImpl<$Res>
    implements $ExamplePricesResponseCopyWith<$Res> {
  _$ExamplePricesResponseCopyWithImpl(this._self, this._then);

  final ExamplePricesResponse _self;
  final $Res Function(ExamplePricesResponse) _then;

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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _self.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _self.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _self.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ExamplePricesResponse implements ExamplePricesResponse {
  _ExamplePricesResponse(
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
  factory _ExamplePricesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamplePricesResponseFromJson(json);

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

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExamplePricesResponseCopyWith<_ExamplePricesResponse> get copyWith =>
      __$ExamplePricesResponseCopyWithImpl<_ExamplePricesResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExamplePricesResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExamplePricesResponse &&
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

  @override
  String toString() {
    return 'ExamplePricesResponse(id: $id, title: $title, code: $code, brand: $brand, price: $price, basketQty: $basketQty, inStockQty: $inStockQty, rating: $rating, delivery: $delivery, payload: $payload)';
  }
}

/// @nodoc
abstract mixin class _$ExamplePricesResponseCopyWith<$Res>
    implements $ExamplePricesResponseCopyWith<$Res> {
  factory _$ExamplePricesResponseCopyWith(_ExamplePricesResponse value,
          $Res Function(_ExamplePricesResponse) _then) =
      __$ExamplePricesResponseCopyWithImpl;
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
class __$ExamplePricesResponseCopyWithImpl<$Res>
    implements _$ExamplePricesResponseCopyWith<$Res> {
  __$ExamplePricesResponseCopyWithImpl(this._self, this._then);

  final _ExamplePricesResponse _self;
  final $Res Function(_ExamplePricesResponse) _then;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ExamplePricesResponse(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _self.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _self.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _self._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

// dart format on
