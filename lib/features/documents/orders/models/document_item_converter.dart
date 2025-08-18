import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';

class DocumentItemConverter
    implements JsonConverter<IDocumentItemEntity, Map<String, dynamic>> {
  const DocumentItemConverter();

  @override
  IDocumentItemEntity fromJson(Map<String, dynamic> json) {
    final typeString = json['coreData']['itemType'] as String?;
    if (typeString == null) {
      throw Exception('itemType is null in DocumentItemEntity JSON');
    }
    final type = BaseItemType.values.byName(typeString);

    switch (type) {
      case BaseItemType.part:
        return OrderPartModelComposite.fromJson(json);
      case BaseItemType.service:
        return OrderServiceModelComposite.fromJson(json);
      default:
        throw Exception('Unknown DocumentItemEntity type: $type');
    }
  }

  @override
  Map<String, dynamic> toJson(IDocumentItemEntity object) {
    if (object is OrderPartModelComposite) {
      return object.toJson();
    } else if (object is OrderServiceModelComposite) {
      return object.toJson();
    }
    throw Exception('Unknown DocumentItemEntity type: ${object.runtimeType}');
  }
}