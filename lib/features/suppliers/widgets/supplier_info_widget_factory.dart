import 'package:flutter/material.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/widgets/autotrade_info_widget.dart';
import 'package:part_catalog/features/suppliers/widgets/base_supplier_info_widget.dart';

/// Фабрика для создания виджетов информации о поставщиках
/// Каждый поставщик имеет свой специфический виджет с уникальной структурой данных
class SupplierInfoWidgetFactory {
  
  /// Создает виджет информации для указанного поставщика
  static Widget? createInfoWidget({
    required String supplierCode,
    required Map<String, dynamic> supplierData,
  }) {
    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        return _createArmtekWidget(supplierData);
      
      case 'autotrade':
        return _createAutotradeWidget(supplierData);
      
      case 'exist':
        return _createExistWidget(supplierData);
        
      default:
        // Для неизвестных поставщиков возвращаем базовый виджет
        return _createGenericWidget(supplierCode, supplierData);
    }
  }
  
  /// Создает виджет для Armtek
  static Widget _createArmtekWidget(Map<String, dynamic> data) {
    try {
      print('=== Armtek Widget Creation Debug ===');
      print('Data keys: ${data.keys}');
      print('Structure exists: ${data.containsKey('structure')}');
      print('Structure type: ${data['structure']?.runtimeType}');
      print('Structure content: ${data['structure']}');
      
      // Извлекаем структуру пользователя из переданных данных
      UserStructureRoot structure;
      
      if (data['structure'] != null && data['structure'] is UserStructureRoot) {
        // Если это уже объект UserStructureRoot - используем напрямую
        structure = data['structure'] as UserStructureRoot;
        print('Structure is UserStructureRoot object with ${structure.rgTab?.length ?? 0} payers');
      } else {
        print('Creating empty structure - no valid UserStructureRoot object found');
        print('Structure type: ${data['structure']?.runtimeType}');
        structure = UserStructureRoot(rgTab: []);
      }
      
      // Извлекаем списки брендов и складов (если доступны)
      List<BrandItem>? brandList;
      List<StoreItem>? storeList;
      
      if (data['brandList'] != null) {
        if (data['brandList'] is List<BrandItem>) {
          brandList = data['brandList'] as List<BrandItem>;
          print('Brand list is already List<BrandItem> with ${brandList.length} items');
        } else if (data['brandList'] is List) {
          try {
            brandList = (data['brandList'] as List).map((item) => BrandItem.fromJson(item)).toList();
            print('Brand list converted from JSON with ${brandList.length} items');
          } catch (e) {
            print('Failed to convert brand list from JSON: $e');
            brandList = null;
          }
        }
      }
      
      if (data['storeList'] != null) {
        if (data['storeList'] is List<StoreItem>) {
          storeList = data['storeList'] as List<StoreItem>;
          print('Store list is already List<StoreItem> with ${storeList.length} items');
        } else if (data['storeList'] is List) {
          try {
            storeList = (data['storeList'] as List).map((item) => StoreItem.fromJson(item)).toList();
            print('Store list converted from JSON with ${storeList.length} items');
          } catch (e) {
            print('Failed to convert store list from JSON: $e');
            storeList = null;
          }
        }
      }
      
      print('Creating ArmtekInfoMasterDetail widget...');
      return ArmtekInfoMasterDetail(
        structure: structure,
        brandList: brandList,
        storeList: storeList,
      );
    } catch (e, stackTrace) {
      // В случае ошибки возвращаем базовый виджет с отладочной информацией
      print('ERROR: Ошибка парсинга данных Armtek: $e');
      print('Stack trace: $stackTrace');
      print('Raw data: $data');
      
      return GenericSupplierInfoWidget(
        supplierCode: 'armtek',
        supplierData: {
          'error': 'Ошибка парсинга данных Armtek: $e',
          'errorStackTrace': stackTrace.toString(),
          'dataKeys': data.keys.toList(),
          'structureType': data['structure']?.runtimeType.toString() ?? 'null',
          'structureContent': data['structure']?.toString() ?? 'null',
          'rawData': data,
        },
      );
    }
  }
  
  /// Создает виджет для Autotrade
  static Widget _createAutotradeWidget(Map<String, dynamic> data) {
    return AutotradeInfoWidget(
      autotradeData: data,
    );
  }
  
  /// Создает виджет для Exist
  /// TODO: Реализовать после создания ExistInfoWidget
  static Widget _createExistWidget(Map<String, dynamic> data) {
    return _createGenericWidget('exist', data);
  }
  
  /// Создает базовый виджет для неизвестных поставщиков
  static Widget _createGenericWidget(String supplierCode, Map<String, dynamic> data) {
    return GenericSupplierInfoWidget(
      supplierCode: supplierCode,
      supplierData: data,
    );
  }
  
  /// Проверяет, поддерживается ли поставщик
  static bool isSupported(String supplierCode) {
    return ['armtek', 'autotrade', 'exist'].contains(supplierCode.toLowerCase());
  }
  
  /// Возвращает список поддерживаемых поставщиков
  static List<String> getSupportedSuppliers() {
    return ['armtek', 'autotrade', 'exist'];
  }
}

/// Базовый виджет для неизвестных поставщиков
class GenericSupplierInfoWidget extends BaseSupplierInfoWidget {
  const GenericSupplierInfoWidget({
    super.key,
    required super.supplierCode,
    super.supplierData,
  });

  @override
  BaseSupplierInfoWidgetState createState() => _GenericSupplierInfoWidgetState();
}

class _GenericSupplierInfoWidgetState extends BaseSupplierInfoWidgetState<GenericSupplierInfoWidget> {
  
  @override
  List<InfoCardData> buildInfoCards(Translations t) {
    final cards = <InfoCardData>[];
    
    // Базовая информация
    cards.add(InfoCardData(
      icon: Icons.info,
      title: 'Общая информация',
      count: 1,
      color: Colors.blue,
      subtitle: 'Настройки API',
      onTap: () => selectItem('overview', widget.supplierData),
    ));
    
    // Можно добавить анализ supplierData и создать карточки на основе найденных данных
    if (widget.supplierData != null) {
      final data = widget.supplierData!;
      
      // Ищем массивы данных
      data.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          cards.add(InfoCardData(
            icon: _getIconForKey(key),
            title: _getTitleForKey(key),
            count: value.length,
            color: _getColorForKey(key),
            onTap: () => selectItem(key, value),
          ));
        }
      });
    }
    
    return cards;
  }

  @override
  Widget buildDetailView(String itemType, Object? item, Translations t) {
    switch (itemType) {
      case 'overview':
        return _buildOverview(t);
      default:
        if (item is List) {
          return _buildGenericList(itemType, item, t);
        } else if (item is Map) {
          return _buildGenericMap(itemType, item, t);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Детали для $itemType',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (item != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(item.toString()),
                  ),
              ],
            ),
          );
        }
    }
  }
  
  Widget _buildOverview(Translations t) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Поставщик: ${widget.supplierCode}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              if (widget.supplierData != null && widget.supplierData!.containsKey('error')) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Ошибка загрузки данных',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.supplierData!['error']?.toString() ?? 'Неизвестная ошибка',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red.shade800,
                        ),
                      ),
                      if (widget.supplierData!.containsKey('dataKeys')) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Переданные ключи данных:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.supplierData!['dataKeys']?.toString() ?? 'Нет данных',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                      if (widget.supplierData!.containsKey('structureType')) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Тип структуры: ${widget.supplierData!['structureType']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                      if (widget.supplierData!.containsKey('structureContent')) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Содержимое структуры:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: Text(
                              widget.supplierData!['structureContent']?.toString() ?? 'Нет данных',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Text(
                  'Этот поставщик пока не имеет специализированного виджета отображения данных.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Отображается базовая информация.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              
              if (widget.supplierData != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Доступные данные:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...widget.supplierData!.keys.where((key) => key != 'error' && key != 'rawData').map((key) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('• $key: ${widget.supplierData![key]?.runtimeType}'),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGenericList(String title, List items, Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${items.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGenericMap(String title, Map map, Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...map.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(entry.value.toString()),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'brands':
      case 'brandlist':
        return Icons.branding_watermark;
      case 'stores':
      case 'storelist':
        return Icons.warehouse;
      case 'contacts':
        return Icons.contacts;
      case 'contracts':
        return Icons.description;
      case 'users':
        return Icons.people;
      default:
        return Icons.list;
    }
  }
  
  String _getTitleForKey(String key) {
    switch (key.toLowerCase()) {
      case 'brands':
      case 'brandlist':
        return 'Бренды';
      case 'stores':
      case 'storelist':
        return 'Склады';
      case 'contacts':
        return 'Контакты';
      case 'contracts':
        return 'Договоры';
      case 'users':
        return 'Пользователи';
      default:
        return key;
    }
  }
  
  Color _getColorForKey(String key) {
    switch (key.toLowerCase()) {
      case 'brands':
      case 'brandlist':
        return Colors.deepPurple;
      case 'stores':
      case 'storelist':
        return Colors.indigo;
      case 'contacts':
        return Colors.green;
      case 'contracts':
        return Colors.orange;
      case 'users':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}