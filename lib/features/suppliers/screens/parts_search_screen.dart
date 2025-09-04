import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/parts_search_providers.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_api_providers.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/widgets/part_price_list_item.dart';
import 'package:part_catalog/features/suppliers/utils/connection_error_handler.dart';
import 'package:part_catalog/features/suppliers/utils/user_friendly_exception.dart';

class PartsSearchScreen extends ConsumerStatefulWidget {
  const PartsSearchScreen({super.key});

  @override
  ConsumerState<PartsSearchScreen> createState() => _PartsSearchScreenState();
}

class _PartsSearchScreenState extends ConsumerState<PartsSearchScreen> {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _didInitFromProvider = false;

  @override
  void dispose() {
    _articleController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // При возврате на экран восстанавливаем значения полей из провайдера
    if (!_didInitFromProvider) {
      final params = ref.read(partsSearchStateProvider);
      if (params != null) {
        _articleController.text = params.articleNumber;
        _brandController.text = params.brand ?? '';
      }
      _didInitFromProvider = true;
    }
  }

  void _performSearch() {
    if (_formKey.currentState?.validate() ?? false) {
      final params = PartsSearchParams(
        articleNumber: _articleController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
      );

      ref.read(partsSearchStateProvider.notifier).state = params;
    }
  }

  void _clearSearch() {
    _articleController.clear();
    _brandController.clear();
    ref.read(partsSearchStateProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final searchParams = ref.watch(partsSearchStateProvider);
    final supplierConfigsAsync = ref.watch(supplierConfigsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.suppliers.partsSearch.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: t.suppliers.partsSearch.clearSearch,
            onPressed: _clearSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (supplierConfigsAsync.isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Загрузка конфигураций поставщиков…',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Форма поиска
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      t.suppliers.partsSearch.searchParameters,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Поле артикула
                    TextFormField(
                      controller: _articleController,
                      decoration: InputDecoration(
                        labelText: t.suppliers.partsSearch.articleNumber,
                        hintText: t.suppliers.partsSearch.articleNumberHint,
                        prefixIcon: const Icon(Icons.qr_code),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.suppliers.partsSearch.articleNumberRequired;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _performSearch(),
                    ),
                    const SizedBox(height: 16),

                    // Поле бренда
                    TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: t.suppliers.partsSearch.brand,
                        hintText: t.suppliers.partsSearch.brandHint,
                        prefixIcon: const Icon(Icons.business),
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _performSearch(),
                    ),
                    const SizedBox(height: 16),

                    // Кнопка поиска
                    ElevatedButton.icon(
                      onPressed: _performSearch,
                      icon: const Icon(Icons.search),
                      label: Text(t.suppliers.partsSearch.search),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Результаты поиска
          Expanded(
            child: _buildSearchResults(searchParams),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(PartsSearchParams? searchParams) {
    final t = context.t;

    if (searchParams == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              t.suppliers.partsSearch.enterArticleToSearch,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    final optimizedParams = OptimizedPartsSearchParams(
      articleNumber: searchParams.articleNumber,
      brand: searchParams.brand,
    );
    final searchResultsAsync =
        ref.watch(optimizedPartsSearchProvider(optimizedParams));

    return searchResultsAsync.when(
      data: (parts) {
        if (parts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  t.suppliers.partsSearch.noPartsFound,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.suppliers.partsSearch.tryDifferentArticle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок результатов
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                t.suppliers.partsSearch.foundResults(count: parts.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // Список результатов
            Expanded(
              child: ListView.separated(
                itemCount: parts.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final part = parts[index];
                  return PartPriceListItem(
                    part: part,
                    onTap: () => _showPartDetails(part),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        // Преобразуем ошибку в понятное пользователю сообщение
        final readable = error is UserFriendlyException
            ? error.toString()
            : ConnectionErrorHandler.getReadableErrorMessage(error);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                t.suppliers.partsSearch.searchError,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                readable,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _performSearch,
                child: Text(t.suppliers.partsSearch.retrySearch),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPartDetails(PartPriceModel part) {
    final t = context.t;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(part.name.isEmpty ? part.article : part.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(t.suppliers.partsSearch.article, part.article),
              _buildDetailRow(t.suppliers.partsSearch.brand, part.brand),
              if (part.name.isNotEmpty)
                _buildDetailRow(t.suppliers.partsSearch.name, part.name),
              _buildDetailRow(t.suppliers.partsSearch.price,
                  '${part.price.toStringAsFixed(2)} ₽'),
              _buildDetailRow(
                  t.suppliers.partsSearch.quantity, part.quantity.toString()),
              _buildDetailRow(t.suppliers.partsSearch.deliveryDays,
                  t.suppliers.partsSearch.daysCount(days: part.deliveryDays)),
              _buildDetailRow(
                  t.suppliers.partsSearch.supplier, part.supplierName),
              if (part.originalArticle != null)
                _buildDetailRow(t.suppliers.partsSearch.originalArticle,
                    part.originalArticle!),
              if (part.comment != null && part.comment!.isNotEmpty)
                _buildDetailRow(t.suppliers.partsSearch.comment, part.comment!),
              if (part.priceUpdatedAt != null)
                _buildDetailRow(
                    t.suppliers.partsSearch.priceUpdated,
                    MaterialLocalizations.of(context)
                        .formatCompactDate(part.priceUpdatedAt!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.common.close),
          ),
          ElevatedButton.icon(
            onPressed: () => _addPartToOrder(part),
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(t.suppliers.partsSearch.addToOrder),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _addPartToOrder(PartPriceModel part) async {
    // Закрываем диалог с деталями
    Navigator.of(context).pop();

    // Получаем список активных заказов
    final ordersAsync = ref.read(ordersListProvider);

    ordersAsync.when(
      data: (orders) {
        // Фильтруем только незавершенные заказы
        final activeOrders = orders
            .where((order) =>
                !order.isDeleted &&
                order.status != DocumentStatus.completed &&
                order.status != DocumentStatus.cancelled)
            .toList();

        if (activeOrders.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.suppliers.partsSearch.noActiveOrders),
              action: SnackBarAction(
                label: t.common.createNew,
                onPressed: () {
                  // TODO: Переход к созданию нового заказа
                },
              ),
            ),
          );
          return;
        }

        // Показываем диалог выбора заказа
        _showOrderSelectionDialog(activeOrders, part);
      },
      loading: () {},
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.errors.loadingError(entity: t.orders.orders)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  void _showOrderSelectionDialog(
      List<OrderModelComposite> orders, PartPriceModel part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.suppliers.partsSearch.selectOrder),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(order.displayName),
                subtitle: Text(
                  '${t.orders.client}: ${order.clientId ?? t.common.notSpecified}',
                ),
                trailing: Chip(
                  label: Text(order.status.displayName),
                  backgroundColor: order.status.color.withValues(alpha: 0.2),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _addPartToSelectedOrder(order, part);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _addPartToSelectedOrder(
      OrderModelComposite order, PartPriceModel part) async {
    if (!mounted) return;

    try {
      // Используем OrderService для добавления запчасти в заказ
      final orderService = ref.read(orderServiceProvider);
      await orderService.createAndAddPart(
        orderUuid: order.uuid,
        partNumber: part.article,
        name: part.name.isEmpty ? part.article : part.name,
        price: part.price,
        brand: part.brand,
        quantity: 1.0,
        supplierName: part.supplierName,
        deliveryDays: part.deliveryDays,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.suppliers.partsSearch
              .partAddedToOrder(orderName: order.displayName)),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.errors.savingError(entity: t.orders.orderItem)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
