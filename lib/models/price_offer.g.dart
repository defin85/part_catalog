// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceOffer _$PriceOfferFromJson(Map<String, dynamic> json) => PriceOffer(
      partNumber: json['partNumber'] as String,
      price: (json['price'] as num).toDouble(),
      deliveryTime: json['deliveryTime'] as String,
      supplierId: json['supplierId'] as String,
    );

Map<String, dynamic> _$PriceOfferToJson(PriceOffer instance) =>
    <String, dynamic>{
      'partNumber': instance.partNumber,
      'price': instance.price,
      'deliveryTime': instance.deliveryTime,
      'supplierId': instance.supplierId,
    };
