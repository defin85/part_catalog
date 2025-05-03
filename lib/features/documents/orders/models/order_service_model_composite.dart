import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/service_specific_data.dart'; // Импорт новой модели
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:uuid/uuid.dart';

class OrderServiceModelComposite implements IDocumentItemEntity {
  final ItemCoreData _coreData;
  final DocumentItemSpecificData _docItemData;
  final ServiceSpecificData _serviceData; // Используем новую модель

  // Приватный конструктор
  OrderServiceModelComposite._(
      this._coreData, this._docItemData, this._serviceData);

  // Новый публичный фабричный конструктор для создания из данных
  factory OrderServiceModelComposite.fromData(
    ItemCoreData coreData,
    DocumentItemSpecificData docItemData,
    ServiceSpecificData serviceData,
  ) {
    // Можно добавить проверки на соответствие типов и данных, если нужно
    if (coreData.itemType != BaseItemType.service) {
      throw ArgumentError(
          'ItemCoreData must have itemType BaseItemType.service for OrderServiceModelComposite');
    }
    return OrderServiceModelComposite._(coreData, docItemData, serviceData);
  }

  // Фабричный конструктор для создания новой услуги
  factory OrderServiceModelComposite.create({
    required String documentUuid,
    required String name,
    String? description, // <--- Добавлен параметр
    required double price,
    double quantity =
        1.0, // Услуги тоже могут иметь количество (например, нормо-часы)
    double? duration,
    String? performedBy,
    int lineNumber = 0,
    Map<String, dynamic> data = const {},
  }) {
    return OrderServiceModelComposite._(
      ItemCoreData(
        uuid: const Uuid().v4(),
        name: name,
        itemType: BaseItemType.service, // Явно указываем тип
        lineNumber: lineNumber,
        data: data,
      ),
      DocumentItemSpecificData(
        price: price,
        quantity: quantity,
        isCompleted: false, // По умолчанию не завершено
      ),
      ServiceSpecificData(
        documentUuid: documentUuid,
        description: description, // <--- Используем параметр
        duration: duration,
        performedBy: performedBy,
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
        (_serviceData.performedBy?.toLowerCase().contains(lowercaseSearch) ??
            false);
  }

  @override
  T? getValue<T>(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is T) return value;
    // ... (логика преобразования типов, если нужна) ...
    return null;
  }

  @override
  OrderServiceModelComposite withUpdatedData(Map<String, dynamic> newData) {
    return OrderServiceModelComposite._(
      _coreData.copyWith(data: {..._coreData.data, ...newData}),
      _docItemData,
      _serviceData,
    );
  }

  // --- Реализация интерфейса IDocumentItemEntity ---
  @override
  double? get price => _docItemData.price;
  @override
  double? get quantity => _docItemData.quantity;
  @override
  bool get isCompleted => _docItemData.isCompleted;
  @override
  BaseItemType get documentItemType => BaseItemType.service;

  @override
  double? get totalPrice =>
      (price != null && quantity != null) ? price! * quantity! : price;

  // --- Специфичные геттеры для OrderService ---
  String get documentUuid => _serviceData.documentUuid;
  String? get description => _serviceData.description;
  double? get duration => _serviceData.duration;
  String? get performedBy => _serviceData.performedBy;

  // --- Публичные геттеры для доступа к внутренним данным ---
  ItemCoreData get coreData => _coreData;
  DocumentItemSpecificData get docItemData => _docItemData;
  ServiceSpecificData get serviceData => _serviceData;

  // --- Иммутабельные методы обновления статусов ---
  OrderServiceModelComposite withCompletionStatus(bool newIsCompleted) {
    return OrderServiceModelComposite._(
      _coreData,
      _docItemData.copyWith(isCompleted: newIsCompleted),
      _serviceData,
    );
  }

  // --- Сериализация/Десериализация ---
  Map<String, dynamic> toJson() {
    // Собрать JSON из _coreData, _docItemData, _serviceData
    return {
      ..._coreData.toJson(),
      ..._docItemData.toJson(),
      ..._serviceData.toJson(),
    };
  }

  factory OrderServiceModelComposite.fromJson(Map<String, dynamic> json) {
    // Разобрать JSON и создать экземпляры _coreData, _docItemData, _serviceData
    return OrderServiceModelComposite._(
      ItemCoreData.fromJson(json),
      DocumentItemSpecificData.fromJson(json),
      ServiceSpecificData.fromJson(json),
    );
  }
}
