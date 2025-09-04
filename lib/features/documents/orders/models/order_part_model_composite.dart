import 'package:uuid/uuid.dart';

import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/documents/orders/models/part_specific_data.dart';

class OrderPartModelComposite implements IDocumentItemEntity {
  final ItemCoreData coreData;
  final DocumentItemSpecificData docItemData;
  final PartSpecificData partData;

  const OrderPartModelComposite({
    required this.coreData,
    required this.docItemData,
    required this.partData,
  });

  factory OrderPartModelComposite.fromData(
    ItemCoreData coreData,
    DocumentItemSpecificData docItemData,
    PartSpecificData partData,
  ) {
    return OrderPartModelComposite(
      coreData: coreData,
      docItemData: docItemData,
      partData: partData,
    );
  }

  factory OrderPartModelComposite.create({
    required String documentUuid,
    required String partNumber,
    required String name,
    required double price,
    String? brand,
    double quantity = 1.0,
    String? supplierName,
    int? deliveryDays,
    int lineNumber = 0,
    Map<String, dynamic> data = const {},
  }) {
    return OrderPartModelComposite(
      coreData: ItemCoreData(
        uuid: const Uuid().v4(),
        name: name,
        itemType: BaseItemType.part,
        lineNumber: lineNumber,
        data: data,
      ),
      docItemData: DocumentItemSpecificData(
        price: price,
        quantity: quantity,
        isCompleted: false,
      ),
      partData: PartSpecificData(
        documentUuid: documentUuid,
        partNumber: partNumber,
        brand: brand,
        supplierName: supplierName,
        deliveryDays: deliveryDays,
        isOrdered: false,
        isReceived: false,
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
        partData.partNumber.toLowerCase().contains(lowercaseSearch) ||
        (partData.brand?.toLowerCase().contains(lowercaseSearch) ?? false);
  }

  @override
  T? getValue<T>(String key) => data[key] is T ? data[key] as T : null;

  @override
  OrderPartModelComposite withUpdatedData(Map<String, dynamic> newData) {
    return OrderPartModelComposite(
      coreData: coreData.copyWith(data: {...coreData.data, ...newData}),
      docItemData: docItemData,
      partData: partData,
    );
  }

  @override
  double? get price => docItemData.price;
  @override
  double? get quantity => docItemData.quantity;
  @override
  bool get isCompleted => docItemData.isCompleted;
  @override
  BaseItemType get documentItemType => BaseItemType.part;

  @override
  double? get totalPrice =>
      (price != null && quantity != null) ? price! * quantity! : price;

  String get documentUuid => partData.documentUuid;
  String get partNumber => partData.partNumber;
  String? get brand => partData.brand;
  String? get supplierName => partData.supplierName;
  int? get deliveryDays => partData.deliveryDays;
  bool get isOrdered => partData.isOrdered;
  bool get isReceived => partData.isReceived;

  factory OrderPartModelComposite.fromJson(Map<String, dynamic> json) {
    return OrderPartModelComposite(
      coreData: ItemCoreData.fromJson(json['coreData'] as Map<String, dynamic>),
      docItemData: DocumentItemSpecificData.fromJson(
          json['docItemData'] as Map<String, dynamic>),
      partData:
          PartSpecificData.fromJson(json['partData'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coreData': coreData.toJson(),
      'docItemData': docItemData.toJson(),
      'partData': partData.toJson(),
    };
  }

  OrderPartModelComposite copyWith({
    ItemCoreData? coreData,
    DocumentItemSpecificData? docItemData,
    PartSpecificData? partData,
  }) {
    return OrderPartModelComposite(
      coreData: coreData ?? this.coreData,
      docItemData: docItemData ?? this.docItemData,
      partData: partData ?? this.partData,
    );
  }
}
