import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/part_specific_data.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart';

class OrderPartModelComposite implements IDocumentItemEntity {
  final ItemCoreData _coreData;
  final DocumentItemSpecificData _docItemData;
  final PartSpecificData _partData;

  OrderPartModelComposite._(this._coreData, this._docItemData, this._partData);

  // Новый публичный фабричный конструктор для создания из данных
  factory OrderPartModelComposite.fromData(
    ItemCoreData coreData,
    DocumentItemSpecificData docItemData,
    PartSpecificData partData,
  ) {
    // Можно добавить проверки на соответствие типов и данных, если нужно
    if (coreData.itemType != BaseItemType.part) {
      throw ArgumentError(
          'ItemCoreData must have itemType BaseItemType.part for OrderPartModelComposite');
    }
    return OrderPartModelComposite._(coreData, docItemData, partData);
  }

  factory OrderPartModelComposite.create({
    required String documentUuid,
    required String name,
    required String partNumber,
    required double price,
    double quantity = 1.0,
    String? brand,
    String? supplierName,
    int? deliveryDays,
    int lineNumber = 0,
    Map<String, dynamic> data = const {},
  }) {
    return OrderPartModelComposite._(
      ItemCoreData(
        uuid: const Uuid().v4(),
        name: name,
        itemType: BaseItemType.part, // Явно указываем тип
        lineNumber: lineNumber,
        data: data,
      ),
      DocumentItemSpecificData(
        price: price,
        quantity: quantity,
        isCompleted: false, // По умолчанию не завершено (не получено)
      ),
      PartSpecificData(
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

  // --- Реализация интерфейса IItemEntity ---
  @override
  String get uuid => _coreData.uuid;
  @override
  String get name => _coreData.name;
  @override
  BaseItemType get itemType => _coreData.itemType;
  @override
  int get lineNumber => _coreData.lineNumber;
  @override
  Map<String, dynamic> get data => _coreData.data;

  @override
  bool containsSearchText(String searchText) {
    final lowercaseSearch = searchText.toLowerCase();
    return name.toLowerCase().contains(lowercaseSearch) ||
        _partData.partNumber.toLowerCase().contains(lowercaseSearch) ||
        (_partData.brand?.toLowerCase().contains(lowercaseSearch) ?? false);
  }

  @override
  T? getValue<T>(String key) {
    // Реализация getValue, как была в BaseItemEntity
    final value = data[key];
    if (value == null) return null;
    if (value is T) return value;
    // ... (логика преобразования типов) ...
    return null;
  }

  @override
  OrderPartModelComposite withUpdatedData(Map<String, dynamic> newData) {
    return OrderPartModelComposite._(
      _coreData.copyWith(data: {..._coreData.data, ...newData}),
      _docItemData,
      _partData,
    );
  }

  // --- Реализация интерфейса IDocumentItemEntity ---
  @override
  double? get price => _docItemData.price;
  @override
  double? get quantity => _docItemData.quantity;
  @override
  bool get isCompleted => _partData.isReceived; // Завершено = Получено
  @override
  BaseItemType get documentItemType => BaseItemType.part;

  @override
  double? get totalPrice =>
      (price != null && quantity != null) ? price! * quantity! : price;

  // --- Специфичные геттеры для OrderPart ---
  String get documentUuid => _partData.documentUuid;
  String get partNumber => _partData.partNumber;
  String? get brand => _partData.brand;
  bool get isOrdered => _partData.isOrdered;
  bool get isReceived => _partData.isReceived;

  // --- Публичные геттеры для доступа к внутренним данным ---
  ItemCoreData get coreData => _coreData;
  DocumentItemSpecificData get docItemData => _docItemData;
  PartSpecificData get partData => _partData;

  // --- Иммутабельные методы обновления статусов ---
  OrderPartModelComposite withOrderStatus(bool newIsOrdered) {
    return OrderPartModelComposite._(
      _coreData,
      _docItemData,
      _partData.copyWith(isOrdered: newIsOrdered),
    );
  }

  OrderPartModelComposite withReceiveStatus(bool newIsReceived) {
    return OrderPartModelComposite._(
      _coreData,
      _docItemData.copyWith(
          isCompleted: newIsReceived), // Обновляем и isCompleted
      _partData.copyWith(isReceived: newIsReceived),
    );
  }

  // --- Сериализация/Десериализация ---
  Map<String, dynamic> toJson() {
    // Собрать JSON из _coreData, _docItemData, _partData
    throw UnimplementedError(
        "toJson не реализован для OrderPartModelComposite");
  }

  factory OrderPartModelComposite.fromJson(Map<String, dynamic> json) {
    // Разобрать JSON и создать экземпляры _coreData, _docItemData, _partData
    throw UnimplementedError(
        "fromJson не реализован для OrderPartModelComposite");
  }
}
