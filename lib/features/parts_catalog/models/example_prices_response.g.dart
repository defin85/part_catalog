// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_prices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamplePricesResponseImpl _$$ExamplePricesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ExamplePricesResponseImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      code: json['code'] as String?,
      brand: json['brand'] as String?,
      price: json['price'] as String?,
      basketQty: json['basketQty'] as String?,
      inStockQty: json['inStockQty'] as String?,
      rating: json['rating'] as String?,
      delivery: json['delivery'] as String?,
      payload: (json['payload'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$ExamplePricesResponseImplToJson(
        _$ExamplePricesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
      'brand': instance.brand,
      'price': instance.price,
      'basketQty': instance.basketQty,
      'inStockQty': instance.inStockQty,
      'rating': instance.rating,
      'delivery': instance.delivery,
      'payload': instance.payload,
    };
