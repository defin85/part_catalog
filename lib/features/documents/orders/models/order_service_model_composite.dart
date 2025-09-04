import 'package:uuid/uuid.dart';

import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/documents/orders/models/service_specific_data.dart';

class OrderServiceModelComposite implements IDocumentItemEntity {
  final ItemCoreData coreData;
  final DocumentItemSpecificData docItemData;
  final ServiceSpecificData serviceData;

  const OrderServiceModelComposite({
    required this.coreData,
    required this.docItemData,
    required this.serviceData,
  });

  factory OrderServiceModelComposite.create({
    required String documentUuid,
    required String name,
    String? description,
    required double price,
    double quantity = 1.0,
    double? duration,
    String? performedBy,
    int lineNumber = 0,
    Map<String, dynamic> data = const {},
  }) {
    return OrderServiceModelComposite(
      coreData: ItemCoreData(
        uuid: const Uuid().v4(),
        name: name,
        itemType: BaseItemType.service,
        lineNumber: lineNumber,
        data: data,
      ),
      docItemData: DocumentItemSpecificData(
        price: price,
        quantity: quantity,
        isCompleted: false,
      ),
      serviceData: ServiceSpecificData(
        documentUuid: documentUuid,
        description: description,
        duration: duration,
        performedBy: performedBy,
      ),
    );
  }

  @override
  String get uuid => coreData.uuid;
  @override
  String get name => coreData.name;
  @override
  BaseItemType get itemType => coreData.itemType;
  @override
  int get lineNumber => coreData.lineNumber;
  @override
  Map<String, dynamic> get data => coreData.data;

  @override
  bool containsSearchText(String searchText) {
    final lowercaseSearch = searchText.toLowerCase();
    return name.toLowerCase().contains(lowercaseSearch) ||
        (serviceData.performedBy?.toLowerCase().contains(lowercaseSearch) ??
            false);
  }

  @override
  T? getValue<T>(String key) => data[key] is T ? data[key] as T : null;

  @override
  OrderServiceModelComposite withUpdatedData(Map<String, dynamic> newData) {
    return OrderServiceModelComposite(
      coreData: coreData.copyWith(data: {...coreData.data, ...newData}),
      docItemData: docItemData,
      serviceData: serviceData,
    );
  }

  @override
  double? get price => docItemData.price;
  @override
  double? get quantity => docItemData.quantity;
  @override
  bool get isCompleted => docItemData.isCompleted;
  @override
  BaseItemType get documentItemType => BaseItemType.service;

  @override
  double? get totalPrice =>
      (price != null && quantity != null) ? price! * quantity! : price;

  String get documentUuid => serviceData.documentUuid;
  String? get description => serviceData.description;
  double? get duration => serviceData.duration;
  String? get performedBy => serviceData.performedBy;

  factory OrderServiceModelComposite.fromJson(Map<String, dynamic> json) {
    return OrderServiceModelComposite(
      coreData: ItemCoreData.fromJson(json['coreData'] as Map<String, dynamic>),
      docItemData: DocumentItemSpecificData.fromJson(
          json['docItemData'] as Map<String, dynamic>),
      serviceData: ServiceSpecificData.fromJson(
          json['serviceData'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coreData': coreData.toJson(),
      'docItemData': docItemData.toJson(),
      'serviceData': serviceData.toJson(),
    };
  }

  OrderServiceModelComposite copyWith({
    ItemCoreData? coreData,
    DocumentItemSpecificData? docItemData,
    ServiceSpecificData? serviceData,
  }) {
    return OrderServiceModelComposite(
      coreData: coreData ?? this.coreData,
      docItemData: docItemData ?? this.docItemData,
      serviceData: serviceData ?? this.serviceData,
    );
  }
}
