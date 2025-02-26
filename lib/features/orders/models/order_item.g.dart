// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      partNumber: json['partNumber'] as String,
      partName: json['partName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      supplier: json['supplier'] as String,
      deliveryTime: json['deliveryTime'] as String,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'partNumber': instance.partNumber,
      'partName': instance.partName,
      'quantity': instance.quantity,
      'price': instance.price,
      'supplier': instance.supplier,
      'deliveryTime': instance.deliveryTime,
    };
