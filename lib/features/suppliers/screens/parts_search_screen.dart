import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/parts_search_providers.dart';
import 'package:part_catalog/features/suppliers/widgets/part_price_list_item.dart';

class PartsSearchScreen extends ConsumerStatefulWidget {
  const PartsSearchScreen({super.key});

  @override
  ConsumerState<PartsSearchScreen> createState() => _PartsSearchScreenState();
}

class _PartsSearchScreenState extends ConsumerState<PartsSearchScreen> {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _articleController.dispose();
    _brandController.dispose();
    super.dispose();
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

    final searchResultsAsync = ref.watch(partsSearchProvider(searchParams));

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
                error.toString(),
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
              _buildDetailRow(
                t.suppliers.partsSearch.price, 
                '${part.price.toStringAsFixed(2)} ₽'
              ),
              _buildDetailRow(
                t.suppliers.partsSearch.quantity, 
                part.quantity.toString()
              ),
              _buildDetailRow(
                t.suppliers.partsSearch.deliveryDays, 
                t.suppliers.partsSearch.daysCount(days: part.deliveryDays)
              ),
              _buildDetailRow(t.suppliers.partsSearch.supplier, part.supplierName),
              if (part.originalArticle != null)
                _buildDetailRow(t.suppliers.partsSearch.originalArticle, part.originalArticle!),
              if (part.comment != null && part.comment!.isNotEmpty)
                _buildDetailRow(t.suppliers.partsSearch.comment, part.comment!),
              if (part.priceUpdatedAt != null)
                _buildDetailRow(
                  t.suppliers.partsSearch.priceUpdated, 
                  MaterialLocalizations.of(context).formatCompactDate(part.priceUpdatedAt!)
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.common.close),
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
}