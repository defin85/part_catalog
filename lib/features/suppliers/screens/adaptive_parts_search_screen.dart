import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/widgets/adaptive_card.dart';
import 'package:part_catalog/core/widgets/adaptive_container.dart';
import 'package:part_catalog/core/widgets/adaptive_text.dart';
import 'package:part_catalog/core/widgets/adaptive_icon.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_api_providers.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/widgets/part_price_list_item.dart';

/// Полностью адаптивный экран поиска запчастей
class AdaptivePartsSearchScreen extends ConsumerStatefulWidget {
  const AdaptivePartsSearchScreen({super.key});

  @override
  ConsumerState<AdaptivePartsSearchScreen> createState() => _AdaptivePartsSearchScreenState();
}

class _AdaptivePartsSearchScreenState extends ConsumerState<AdaptivePartsSearchScreen> {
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

    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileLayout(enabledSuppliers),
      medium: (context, constraints) => _buildTabletLayout(enabledSuppliers),
      large: (context, constraints) => _buildDesktopLayout(enabledSuppliers),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile Layout - вертикальный стек с вкладками
  Widget _buildMobileLayout(List<dynamic> enabledSuppliers) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Поиск запчастей'.asAdaptiveHeadline(),
            '🚀 Адаптивный поиск'.asAdaptiveCaption(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Форма поиска
          AdaptiveCard(
            context: AdaptiveCardContext.primary,
            child: _buildSearchForm(enabledSuppliers, ScreenSize.small),
          ),
          // Результаты поиска
          Expanded(
            child: _buildSearchResults(ScreenSize.small),
          ),
        ],
      ),
    );
  }

  /// Tablet Layout - горизонтальный layout
  Widget _buildTabletLayout(List<dynamic> enabledSuppliers) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.search.asAdaptiveNavigationIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: 'Поиск запчастей (Адаптивный)'.asAdaptiveHeadline(),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Левая панель - форма поиска
          AdaptiveContainer.sidebar(
            child: _buildSearchForm(enabledSuppliers, ScreenSize.medium),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - результаты
          Expanded(
            flex: 2,
            child: _buildSearchResults(ScreenSize.medium),
          ),
        ],
      ),
    );
  }

  /// Desktop Layout - трехколоночный layout
  Widget _buildDesktopLayout(List<dynamic> enabledSuppliers) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.search.asAdaptiveNavigationIcon(),
            const SizedBox(width: 16),
            'Поиск запчастей'.asAdaptiveHeadline(),
            const Spacer(),
            '🚀 Адаптивный интерфейс'.asAdaptiveBodySecondary(),
          ],
        ),
        actions: [
          Icons.settings.asAdaptiveActionIcon(
            onTap: () => _showAdvancedSettings(enabledSuppliers),
            semanticLabel: 'Дополнительные настройки',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - форма поиска
          AdaptiveContainer.sidebar(
            child: _buildSearchForm(enabledSuppliers, ScreenSize.large),
          ),
          const VerticalDivider(width: 1),
          // Центральная панель - результаты
          Expanded(
            flex: 2,
            child: _buildSearchResults(ScreenSize.large),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - детали и аналитика
          AdaptiveContainer(
            sizeConfig: const AdaptiveSizeConfig(
              desktopWidth: 300,
              minWidth: 250,
              maxWidth: 400,
            ),
            child: _buildSidePanel(ScreenSize.large),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm(List<dynamic> enabledSuppliers, ScreenSize screenSize) {
    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок формы
            if (screenSize != ScreenSize.small) ...[
              'Параметры поиска'.asAdaptiveSubheadline(),
              SizedBox(height: _getSpacing(screenSize)),
            ],

            // Основные поля поиска
            TextFormField(
              controller: _articleController,
              decoration: InputDecoration(
                labelText: 'Номер запчасти',
                hintText: 'Введите артикул',
                border: const OutlineInputBorder(),
                prefixIcon: Icons.search.asAdaptiveButtonIcon(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите номер запчасти';
                }
                return null;
              },
              onFieldSubmitted: (_) => _performSearch(),
            ),

            SizedBox(height: _getSpacing(screenSize)),

            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: 'Бренд (опционально)',
                hintText: 'Например: Bosch, Febi',
                border: const OutlineInputBorder(),
                prefixIcon: Icons.business.asAdaptiveButtonIcon(),
              ),
              onFieldSubmitted: (_) => _performSearch(),
            ),

            SizedBox(height: _getSpacing(screenSize) * 1.5),

            // Кнопки действий
            _buildActionButtons(screenSize),

            SizedBox(height: _getSpacing(screenSize)),

            // Настройки поиска
            _buildSearchSettings(enabledSuppliers, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ScreenSize screenSize) {
    if (screenSize == ScreenSize.large) {
      // Desktop: вертикальные кнопки
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _performSearch,
            icon: Icons.search.asAdaptiveButtonIcon(),
            label: 'Найти'.asAdaptiveBody(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _clearSearch,
            child: 'Очистить'.asAdaptiveBody(),
          ),
        ],
      );
    } else {
      // Mobile/Tablet: горизонтальные кнопки
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _performSearch,
              icon: Icons.search.asAdaptiveButtonIcon(),
              label: 'Найти'.asAdaptiveBody(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: 'Очистить'.asAdaptiveBody(),
          ),
        ],
      );
    }
  }

  Widget _buildSearchSettings(List<dynamic> enabledSuppliers, ScreenSize screenSize) {
    return AdaptiveCard(
      context: AdaptiveCardContext.nested,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Настройки поиска'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
          SizedBox(height: _getSpacing(screenSize) * 0.5),

          CheckboxListTile(
            title: 'Использовать кеш'.asAdaptiveBody(),
            subtitle: 'Быстрее повторные запросы'.asAdaptiveCaption(),
            value: _useCache,
            onChanged: (value) => setState(() {
              _useCache = value ?? true;
            }),
          ),

          if (enabledSuppliers.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: EdgeInsets.all(_getSpacing(screenSize) * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Поставщики (включено: ${enabledSuppliers.length})'
                      .asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
                  SizedBox(height: _getSpacing(screenSize) * 0.5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: enabledSuppliers
                        .map((supplier) => FilterChip(
                              label: supplier.displayName.toString().asAdaptiveCaption(),
                              selected: _selectedSuppliers.contains(supplier.supplierCode),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSuppliers.add(supplier.supplierCode);
                                  } else {
                                    _selectedSuppliers.remove(supplier.supplierCode);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults(ScreenSize screenSize) {
    final searchParams = PartsSearchParams(
      articleNumber: _articleController.text.trim(),
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      supplierCodes: _selectedSuppliers.isEmpty ? null : _selectedSuppliers,
      useCache: _useCache,
    );

    if (_articleController.text.trim().isEmpty) {
      return _buildEmptyState(screenSize);
    }

    final searchResult = ref.watch(partsSearchProvider(searchParams));

    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: searchResult.when(
        data: (results) => _buildResultsList(results, screenSize),
        loading: () => _buildLoadingIndicator(screenSize),
        error: (error, stack) => _buildErrorWidget(error, screenSize),
      ),
    );
  }

  Widget _buildResultsList(List<PartPriceModel> results, ScreenSize screenSize) {
    if (results.isEmpty) {
      return _buildNoResultsState(screenSize);
    }

    return Column(
      children: [
        // Заголовок результатов
        AdaptiveCard(
          context: AdaptiveCardContext.list,
          child: Row(
            children: [
              Icons.rocket_launch.asAdaptiveIcon(
                context: AdaptiveIconContext.decorative,
              ),
              SizedBox(width: _getSpacing(screenSize) * 0.5),
              'Найдено: ${results.length}'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
              const Spacer(),
              if (_useCache) ...[
                Icons.cached.asAdaptiveIcon(
                  context: AdaptiveIconContext.decorative,
                  color: Colors.green,
                ),
                SizedBox(width: _getSpacing(screenSize) * 0.25),
                'Кеш активен'.asAdaptiveCaption(color: Colors.green),
              ],
            ],
          ),
        ),

        // Список результатов
        Expanded(
          child: _buildAdaptiveResultsList(results, screenSize),
        ),
      ],
    );
  }

  Widget _buildAdaptiveResultsList(List<PartPriceModel> results, ScreenSize screenSize) {
    if (screenSize == ScreenSize.large) {
      // Desktop: сетка
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) => AdaptiveCard(
          context: AdaptiveCardContext.grid,
          child: PartPriceListItem(part: results[index]),
        ),
      );
    } else {
      // Mobile/Tablet: список
      return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => AdaptiveCard(
          context: AdaptiveCardContext.list,
          child: PartPriceListItem(part: results[index]),
        ),
      );
    }
  }

  Widget _buildLoadingIndicator(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: _getSpacing(screenSize)),
          'Поиск запчастей...'.asAdaptiveBody(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.search.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Введите номер запчасти для поиска'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Используйте форму поиска выше'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.search_off.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Ничего не найдено'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Попробуйте изменить параметры поиска'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object error, ScreenSize screenSize) {
    return Center(
      child: AdaptiveCard(
        context: AdaptiveCardContext.modal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icons.error_outline.asAdaptiveIcon(
              context: AdaptiveIconContext.decorative,
              customSize: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: _getSpacing(screenSize)),
            'Ошибка поиска'.asAdaptiveSubheadline(),
            SizedBox(height: _getSpacing(screenSize) * 0.5),
            error.toString().asAdaptiveCaption(
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _getSpacing(screenSize)),
            ElevatedButton(
              onPressed: _performSearch,
              child: 'Повторить'.asAdaptiveBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel(ScreenSize screenSize) {
    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Быстрые действия'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Быстрые кнопки
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showSearchHistory(),
                icon: Icons.history.asAdaptiveButtonIcon(),
                label: 'История поиска'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _showFavorites(),
                icon: Icons.star.asAdaptiveButtonIcon(),
                label: 'Избранное'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _exportResults(),
                icon: Icons.download.asAdaptiveButtonIcon(),
                label: 'Экспорт'.asAdaptiveBody(),
              ),
            ],
          ),

          const Divider(),

          'Статистика'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Статистика поиска
          'Поисков сегодня: 42'.asAdaptiveCaption(),
          'Найдено товаров: 1,234'.asAdaptiveCaption(),
          'Активных поставщиков: 5'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  void _showAdvancedSettings(List<dynamic> enabledSuppliers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: 'Дополнительные настройки'.asAdaptiveSubheadline(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Здесь будут расширенные настройки поиска'.asAdaptiveBody(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: 'Закрыть'.asAdaptiveBody(),
          ),
        ],
      ),
    );
  }

  void _showSearchHistory() {
    // TODO: Реализовать историю поиска
  }

  void _showFavorites() {
    // TODO: Реализовать избранное
  }

  void _exportResults() {
    // TODO: Реализовать экспорт результатов
  }

  double _getSpacing(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return 12.0;
      case ScreenSize.medium:
        return 16.0;
      case ScreenSize.large:
        return 20.0;
    }
  }
}