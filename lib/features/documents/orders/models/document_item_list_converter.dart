import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/document_item_converter.dart';

class DocumentItemListConverter
    implements
        JsonConverter<List<IDocumentItemEntity>, List<Map<String, dynamic>>> {
  const DocumentItemListConverter();

  @override
  List<IDocumentItemEntity> fromJson(List<Map<String, dynamic>> json) {
    return json
        .map((item) => const DocumentItemConverter().fromJson(item))
        .toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<IDocumentItemEntity> object) {
    return object
        .map((item) => const DocumentItemConverter().toJson(item))
        .toList();
  }
}