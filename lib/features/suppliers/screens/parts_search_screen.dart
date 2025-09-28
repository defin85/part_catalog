import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_api_providers.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Экран поиска запчастей с использованием новых UI компонентов
class PartsSearchScreen extends ConsumerStatefulWidget {
  const PartsSearchScreen({super.key});

  @override
  ConsumerState<PartsSearchScreen> createState() => _PartsSearchScreenState();
}

class _PartsSearchScreenState extends ConsumerState<PartsSearchScreen> with NotificationsMixin {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _useCache = true;
  final List<String> _selectedSuppliers = [];

  @override
  void dispose() {
    _articleController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_formKey.currentState?.validate() ?? false) {
      final articleNumber = _articleController.text.trim();
      final brand = _brandController.text.trim().isEmpty ? null : _brandController.text.trim();

      final optimizedParams = PartsSearchParams(
        articleNumber: articleNumber,
        brand: brand,
        supplierCodes: _selectedSuppliers.isEmpty ? null : _selectedSuppliers,
        useCache: _useCache,
      );

      ref.read(partsSearchProvider(optimizedParams));
    }
  }

  void _clearSearch() {
    _articleController.clear();
    _brandController.clear();
    setState(() {
      _selectedSuppliers.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final enabledSuppliers = ref.watch(enabledSupplierConfigsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск запчастей'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildSearchForm(enabledSuppliers),
            const SizedBox(height: AppSpacing.lg),
            _buildSearchResults(),
          ],
        ),
      ),
      persistentFooterButtons: [
        SecondaryButton(
          onPressed: _clearSearch,
          text: 'Очистить',
          icon: const Icon(Icons.clear),
        ),
        PrimaryButton(
          onPressed: _performSearch,
          text: 'Найти',
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _buildSearchForm(List<dynamic> enabledSuppliers) {
    return FormSection(
      title: 'Параметры поиска',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Артикул
              TextInput(
                controller: _articleController,
                label: 'Артикул запчасти',
                hint: 'Введите артикул',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Артикул обязателен для заполнения';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Бренд
              TextInput(
                controller: _brandController,
                label: 'Бренд (опционально)',
                hint: 'Введите бренд',
              ),
              const SizedBox(height: AppSpacing.md),
              // Настройки поиска
              _buildSearchOptions(enabledSuppliers),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchOptions(List<dynamic> enabledSuppliers) {
    return FormCard(
      title: 'Настройки поиска',
      children: [
        // Выбор поставщиков
        if (enabledSuppliers.isNotEmpty) ...[
          const Caption('Поставщики:', fontWeight: FontWeight.w600),
          const SizedBox(height: AppSpacing.sm),
          FilterChipGroup(
            filters: [
              ChipFilter(
                id: 'all',
                label: 'Все',
                isSelected: _selectedSuppliers.isEmpty,
              ),
              ...enabledSuppliers.map((supplier) => ChipFilter(
                id: supplier.code,
                label: supplier.displayName ?? supplier.code,
                isSelected: _selectedSuppliers.contains(supplier.code),
              )),
            ],
            onFiltersChanged: (selectedIds) {
              setState(() {
                _selectedSuppliers
                  ..clear()
                  ..addAll(selectedIds.where((id) => id != 'all'));
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        // Опция кэширования
        Row(
          children: [
            Switch(
              value: _useCache,
              onChanged: (value) {
                setState(() {
                  _useCache = value;
                });
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Caption('Использовать кэш'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final searchParams = PartsSearchParams(
      articleNumber: _articleController.text.trim(),
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      supplierCodes: _selectedSuppliers.isEmpty ? null : _selectedSuppliers,
      useCache: _useCache,
    );

    final searchAsync = ref.watch(partsSearchProvider(searchParams));

    return FormSection(
      title: 'Результаты поиска',
      children: [
        searchAsync.when(
          data: (results) => _buildResultsList(results),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => EmptyStateMessage(
            icon: const Icon(Icons.error_outline),
            title: 'Ошибка поиска',
            subtitle: error.toString(),
            action: ElevatedButton.icon(
              onPressed: _performSearch,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsList(List<PartPriceModel> results) {
    if (results.isEmpty) {
      return const EmptyStateMessage(
        icon: Icon(Icons.search_off),
        title: 'Запчасти не найдены',
        subtitle: 'Попробуйте изменить параметры поиска',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final part = results[index];
        return Card(
          child: ListTile(
            title: Text(part.article),
            subtitle: Text('${part.brand} - ${part.price} ₽'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => _addToCart(part),
                ),
                IconButton(
                  icon: const Icon(Icons.compare),
                  onPressed: () => _addToCompare(part),
                ),
              ],
            ),
            onTap: () => showInfoMessage(context, 'Выбрана запчасть ${part.article}'),
          ),
        );
      },
    );
  }


  // Действия
  void _addToCart(PartPriceModel part) {
    showSuccessMessage(context, '${part.article} добавлен в корзину');
  }

  void _addToCompare(PartPriceModel part) {
    showInfoMessage(context, '${part.article} добавлен к сравнению');
  }
}

