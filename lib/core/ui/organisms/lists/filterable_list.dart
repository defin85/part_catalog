import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/organisms/lists/searchable_list.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';

/// Фильтр для списка
class ListFilter<T> {
  final String id;
  final String label;
  final bool Function(T item) predicate;
  final IconData? icon;
  final Color? color;
  final bool isActive;

  const ListFilter({
    required this.id,
    required this.label,
    required this.predicate,
    this.icon,
    this.color,
    this.isActive = false,
  });

  ListFilter<T> copyWith({
    String? id,
    String? label,
    bool Function(T item)? predicate,
    IconData? icon,
    Color? color,
    bool? isActive,
  }) {
    return ListFilter<T>(
      id: id ?? this.id,
      label: label ?? this.label,
      predicate: predicate ?? this.predicate,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Список с поддержкой фильтрации через чипы
/// Расширяет SearchableList добавляя возможность фильтрации данных
class FilterableList<T> extends StatelessWidget {
  /// Все элементы (до фильтрации)
  final List<T> allItems;

  /// Доступные фильтры
  final List<ListFilter<T>> filters;

  /// Активные фильтры
  final List<String> activeFilterIds;

  /// Билдер для создания элемента списка
  final Widget Function(T item) itemBuilder;

  /// Обработчик изменения фильтров
  final Function(List<String> activeIds)? onFiltersChanged;

  /// Показывать ли панель фильтров
  final bool showFilters;

  /// Текст поиска
  final String? searchQuery;

  /// Функция поиска по тексту
  final bool Function(T item, String query)? searchPredicate;

  /// Сортировка элементов
  final int Function(T a, T b)? comparator;

  /// Группировка элементов
  final String Function(T item)? groupBy;

  /// Билдер для заголовка группы
  final Widget Function(String group, List<T> items)? groupHeaderBuilder;

  /// Остальные параметры из SearchableList
  final Widget Function()? loadingBuilder;
  final Widget Function()? emptyStateBuilder;
  final Widget Function(String error)? errorBuilder;
  final bool isLoading;
  final String? error;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onScrolledToEnd;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool showSeparators;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  const FilterableList({
    super.key,
    required this.allItems,
    required this.filters,
    required this.itemBuilder,
    this.activeFilterIds = const [],
    this.onFiltersChanged,
    this.showFilters = true,
    this.searchQuery,
    this.searchPredicate,
    this.comparator,
    this.groupBy,
    this.groupHeaderBuilder,
    this.loadingBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onScrolledToEnd,
    this.scrollController,
    this.padding,
    this.physics,
    this.showSeparators = false,
    this.separatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final filteredItems = _applyFilters();

    return Column(
      children: [
        if (showFilters && filters.isNotEmpty)
          _buildFilterPanel(context),
        Expanded(
          child: groupBy != null
              ? _buildGroupedList(context, filteredItems)
              : SearchableList<T>(
                  items: filteredItems,
                  itemBuilder: itemBuilder,
                  loadingBuilder: loadingBuilder,
                  emptyStateBuilder: emptyStateBuilder ??
                      () => _buildDefaultEmptyState(context),
                  errorBuilder: errorBuilder,
                  isLoading: isLoading,
                  error: error,
                  onRefresh: onRefresh,
                  onScrolledToEnd: onScrolledToEnd,
                  scrollController: scrollController,
                  padding: padding,
                  physics: physics,
                  showSeparators: showSeparators,
                  separatorBuilder: separatorBuilder,
                ),
        ),
      ],
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: filters.map((filter) => _buildFilterChip(context, filter)).toList(),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, ListFilter<T> filter) {
    final isActive = activeFilterIds.contains(filter.id);

    return FilterChip(
      label: Text(filter.label),
      avatar: filter.icon != null ? Icon(filter.icon, size: 18) : null,
      selected: isActive,
      onSelected: (selected) => _toggleFilter(filter.id, selected),
      backgroundColor: filter.color?.withValues(alpha: 0.1),
      selectedColor: filter.color?.withValues(alpha: 0.2) ??
        Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: filter.color ?? Theme.of(context).colorScheme.primary,
      side: isActive && filter.color != null
          ? BorderSide(color: filter.color!)
          : null,
    );
  }

  Widget _buildGroupedList(BuildContext context, List<T> items) {
    if (items.isEmpty) {
      return emptyStateBuilder?.call() ?? _buildDefaultEmptyState(context);
    }

    final groups = <String, List<T>>{};
    for (final item in items) {
      final group = groupBy!(item);
      groups.putIfAbsent(group, () => []).add(item);
    }

    final sortedGroups = groups.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      itemCount: sortedGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = sortedGroups[groupIndex];
        final groupItems = group.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupHeaderBuilder != null)
              groupHeaderBuilder!(group.key, groupItems)
            else
              _buildDefaultGroupHeader(context, group.key, groupItems),
            const SizedBox(height: 8),
            ...groupItems.map((item) => itemBuilder(item)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDefaultGroupHeader(BuildContext context, String group, List<T> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            group,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${items.length}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context) {
    final hasActiveFilters = activeFilterIds.isNotEmpty;
    final hasSearchQuery = searchQuery?.isNotEmpty == true;

    return EmptyStateMessage(
      icon: Icon(hasActiveFilters || hasSearchQuery
          ? Icons.filter_list_off
          : Icons.inbox_outlined),
      title: hasActiveFilters || hasSearchQuery
          ? 'Нет результатов'
          : 'Список пуст',
      subtitle: hasActiveFilters || hasSearchQuery
          ? 'Попробуйте изменить фильтры или поиск'
          : 'Элементы появятся здесь',
      action: hasActiveFilters
          ? TextButton(
              onPressed: () => onFiltersChanged?.call([]),
              child: const Text('Сбросить фильтры'),
            )
          : null,
    );
  }

  List<T> _applyFilters() {
    var filteredItems = List<T>.from(allItems);

    // Применяем активные фильтры
    for (final filterId in activeFilterIds) {
      final filter = filters.firstWhere((f) => f.id == filterId);
      filteredItems = filteredItems.where(filter.predicate).toList();
    }

    // Применяем текстовый поиск
    if (searchQuery?.isNotEmpty == true && searchPredicate != null) {
      filteredItems = filteredItems
          .where((item) => searchPredicate!(item, searchQuery!))
          .toList();
    }

    // Применяем сортировку
    if (comparator != null) {
      filteredItems.sort(comparator!);
    }

    return filteredItems;
  }

  void _toggleFilter(String filterId, bool isSelected) {
    final newActiveIds = List<String>.from(activeFilterIds);

    if (isSelected) {
      if (!newActiveIds.contains(filterId)) {
        newActiveIds.add(filterId);
      }
    } else {
      newActiveIds.remove(filterId);
    }

    onFiltersChanged?.call(newActiveIds);
  }
}