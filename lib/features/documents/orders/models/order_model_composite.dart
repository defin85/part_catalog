import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/core/document_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_specific_data.dart';
import 'package:part_catalog/features/core/i_document_entity.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class OrderModelComposite implements IDocumentEntity {
  final EntityCoreData coreData;
  final DocumentSpecificData docData;
  final OrderSpecificData orderData;
  @override
  final Map<BaseItemType, List<IDocumentItemEntity>> itemsMap;

  const OrderModelComposite({
    required this.coreData,
    required this.docData,
    required this.orderData,
    required this.itemsMap,
  });

  factory OrderModelComposite.fromData(
    EntityCoreData coreData,
    DocumentSpecificData docData,
    OrderSpecificData orderData,
    Map<BaseItemType, List<IDocumentItemEntity>> itemsMap,
  ) {
    return OrderModelComposite(
      coreData: coreData,
      docData: docData,
      orderData: orderData,
      itemsMap: Map.unmodifiable(itemsMap),
    );
  }

  factory OrderModelComposite.create({
    required String code,
    required String displayName,
    required DateTime documentDate,
    DocumentStatus status = DocumentStatus.newDoc,
    String? clientId,
    String? carId,
    String? description,
    DateTime? scheduledDate,
    Map<BaseItemType, List<IDocumentItemEntity>> itemsMap = const {},
  }) {
    final now = DateTime.now();
    return OrderModelComposite(
      coreData: EntityCoreData(
        uuid: const Uuid().v4(),
        code: code,
        displayName: displayName,
        createdAt: now,
        modifiedAt: now,
        isDeleted: false,
        deletedAt: null,
      ),
      docData: DocumentSpecificData(
        status: status,
        documentDate: documentDate,
        scheduledDate: scheduledDate,
        isPosted: false,
        postedAt: null,
      ),
      orderData: OrderSpecificData(
        clientId: clientId,
        carId: carId,
        description: description,
      ),
      itemsMap: Map.unmodifiable(itemsMap),
    );
  }

  @override
  String get uuid => coreData.uuid;
  @override
  String get code => coreData.code;
  @override
  String get displayName => coreData.displayName;
  @override
  DateTime get createdAt => coreData.createdAt;
  @override
  DateTime? get modifiedAt => coreData.modifiedAt;
  @override
  DateTime? get deletedAt => coreData.deletedAt;
  @override
  bool get isDeleted => coreData.isDeleted;

  @override
  bool containsSearchText(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    if (displayName.toLowerCase().contains(lowerQuery)) return true;
    if (code.toLowerCase().contains(lowerQuery)) return true;
    if (description?.toLowerCase().contains(lowerQuery) ?? false) return true;
    for (final item in items) {
      if (item.containsSearchText(lowerQuery)) return true;
    }
    return false;
  }

  @override
  DocumentStatus get status => docData.status;
  @override
  DateTime get documentDate => docData.documentDate;
  @override
  bool get isPosted => docData.isPosted;
  @override
  DateTime? get postedAt => docData.postedAt;

  @override
  List<IDocumentItemEntity> get items =>
      itemsMap.values.expand((list) => list).toList();

  @override
  List<IDocumentItemEntity> getItemsByType(BaseItemType type) =>
      List.unmodifiable(itemsMap[type] ?? const []);

  @override
  List<IDocumentItemEntity> searchItems(String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items.where((item) => item.containsSearchText(lowerQuery)).toList();
  }

  String? get clientId => orderData.clientId;
  String? get carId => orderData.carId;
  String? get description => orderData.description;

  @override
  OrderModelComposite withStatus(DocumentStatus newStatus) {
    return copyWith(
      docData: docData.copyWith(status: newStatus),
    );
  }

  @override
  OrderModelComposite withAddedItem(IDocumentItemEntity item,
      {BaseItemType? itemType}) {
    final type = itemType ?? item.itemType;
    final updatedItemsMap = Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    final currentList = List<IDocumentItemEntity>.from(updatedItemsMap[type] ?? []);
    if (currentList.any((existing) => existing.uuid == item.uuid)) {
      return this;
    }
    currentList.add(item);
    updatedItemsMap[type] = List.unmodifiable(currentList);
    return copyWith(
      itemsMap: Map.unmodifiable(updatedItemsMap),
    );
  }

  @override
  OrderModelComposite withUpdatedItem(IDocumentItemEntity item,
      {BaseItemType? itemType}) {
    final type = itemType ?? item.itemType;
    final updatedItemsMap = Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    final currentList = updatedItemsMap[type];
    if (currentList == null) return this;
    final index = currentList.indexWhere((i) => i.uuid == item.uuid);
    if (index == -1) return this;
    final newList = List<IDocumentItemEntity>.from(currentList);
    newList[index] = item;
    updatedItemsMap[type] = List.unmodifiable(newList);
    return copyWith(
      itemsMap: Map.unmodifiable(updatedItemsMap),
    );
  }

  @override
  OrderModelComposite withRemovedItem(String itemId, {BaseItemType? itemType}) {
    final updatedItemsMap = Map<BaseItemType, List<IDocumentItemEntity>>.from(itemsMap);
    bool itemRemoved = false;
    if (itemType != null) {
      final currentList = updatedItemsMap[itemType];
      if (currentList != null) {
        final newList = currentList.where((i) => i.uuid != itemId).toList();
        if (newList.length < currentList.length) {
          itemRemoved = true;
          if (newList.isEmpty) {
            updatedItemsMap.remove(itemType);
          } else {
            updatedItemsMap[itemType] = List.unmodifiable(newList);
          }
        }
      }
    } else {
      for (final type in updatedItemsMap.keys.toList()) {
        final currentList = updatedItemsMap[type]!;
        final newList = currentList.where((i) => i.uuid != itemId).toList();
        if (newList.length < currentList.length) {
          itemRemoved = true;
          if (newList.isEmpty) {
            updatedItemsMap.remove(type);
          } else {
            updatedItemsMap[type] = List.unmodifiable(newList);
          }
          break;
        }
      }
    }
    if (!itemRemoved) return this;
    return copyWith(
      itemsMap: Map.unmodifiable(updatedItemsMap),
    );
  }

  OrderModelComposite withClient(String? clientId) {
    return copyWith(
      orderData: orderData.copyWith(clientId: clientId),
    );
  }

  OrderModelComposite withCar(String? carId) {
    return copyWith(
      orderData: orderData.copyWith(carId: carId),
    );
  }

  OrderModelComposite withDescription(String? description) {
    return copyWith(
      orderData: orderData.copyWith(description: description),
    );
  }

  OrderModelComposite withScheduledDate(DateTime? scheduledDate) {
    return copyWith(
      docData: docData.copyWith(scheduledDate: scheduledDate),
    );
  }

  OrderModelComposite withItems(Map<BaseItemType, List<IDocumentItemEntity>> itemsMap) {
    return copyWith(
      itemsMap: Map.unmodifiable(itemsMap),
    );
  }

  OrderModelComposite copyWith({
    EntityCoreData? coreData,
    DocumentSpecificData? docData,
    OrderSpecificData? orderData,
    Map<BaseItemType, List<IDocumentItemEntity>>? itemsMap,
  }) {
    return OrderModelComposite(
      coreData: coreData ?? this.coreData,
      docData: docData ?? this.docData,
      orderData: orderData ?? this.orderData,
      itemsMap: itemsMap ?? this.itemsMap,
    );
  }
}