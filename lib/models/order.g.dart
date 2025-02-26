// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      carId: json['carId'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      workItems: (json['workItems'] as List<dynamic>)
          .map((e) => WorkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'carId': instance.carId,
      'date': instance.date,
      'description': instance.description,
      'workItems': instance.workItems,
      'orderItems': instance.orderItems,
      'totalCost': instance.totalCost,
      'status': instance.status,
    };

WorkItem _$WorkItemFromJson(Map<String, dynamic> json) => WorkItem(
      description: json['description'] as String,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkItemToJson(WorkItem instance) => <String, dynamic>{
      'description': instance.description,
      'cost': instance.cost,
    };
