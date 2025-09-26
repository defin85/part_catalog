import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';
import 'package:part_catalog/core/ui/molecules/loading_overlay.dart';

/// Универсальный список с поддержкой поиска
/// Используется для отображения отфильтрованных данных с автоматическим
/// управлением состояниями загрузки и пустого списка
class SearchableList<T> extends StatelessWidget {
  /// Элементы для отображения
  final List<T> items;

  /// Билдер для создания элемента списка
  final Widget Function(T item) itemBuilder;

  /// Билдер для состояния загрузки
  final Widget Function()? loadingBuilder;

  /// Билдер для пустого состояния
  final Widget Function()? emptyStateBuilder;

  /// Билдер для состояния ошибки
  final Widget Function(String error)? errorBuilder;

  /// Состояние загрузки
  final bool isLoading;

  /// Ошибка для отображения
  final String? error;

  /// Функция для обновления данных (pull-to-refresh)
  final Future<void> Function()? onRefresh;

  /// Прокрутка до конца списка (для пагинации)
  final VoidCallback? onScrolledToEnd;

  /// Контроллер прокрутки
  final ScrollController? scrollController;

  /// Паддинг списка
  final EdgeInsets? padding;

  /// Физика прокрутки
  final ScrollPhysics? physics;

  /// Разделители между элементами
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Использовать ли разделители
  final bool showSeparators;

  /// Анимировать ли появление элементов
  final bool animateItems;

  /// Длительность анимации
  final Duration animationDuration;

  /// Задержка между анимациями элементов
  final Duration animationStagger;

  const SearchableList({
    super.key,
    required this.items,
    required this.itemBuilder,
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
    this.separatorBuilder,
    this.showSeparators = false,
    this.animateItems = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationStagger = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    Widget child = _buildContent(context);

    // Обертка для pull-to-refresh
    if (onRefresh != null) {
      child = RefreshIndicator(
        onRefresh: onRefresh!,
        child: child,
      );
    }

    // Оверлей загрузки
    if (isLoading) {
      child = LoadingOverlay(
        isLoading: isLoading,
        child: child,
      );
    }

    return child;
  }

  Widget _buildContent(BuildContext context) {
    // Отображение ошибки
    if (error != null) {
      return errorBuilder?.call(error!) ??
        _buildDefaultError(context, error!);
    }

    // Отображение пустого списка
    if (items.isEmpty && !isLoading) {
      return emptyStateBuilder?.call() ??
        _buildDefaultEmptyState(context);
    }

    // Отображение списка
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final scrollControllerToUse = scrollController ?? ScrollController();

    // Подписка на скролл для пагинации
    if (onScrolledToEnd != null && scrollController == null) {
      scrollControllerToUse.addListener(() {
        if (scrollControllerToUse.position.pixels >=
            scrollControllerToUse.position.maxScrollExtent - 100) {
          onScrolledToEnd!();
        }
      });
    }

    if (showSeparators && separatorBuilder != null) {
      return ListView.separated(
        controller: scrollControllerToUse,
        padding: padding ?? const EdgeInsets.all(16),
        physics: physics,
        itemCount: items.length,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) => _buildItem(context, index),
      );
    }

    return ListView.builder(
      controller: scrollControllerToUse,
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItem(context, index),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = items[index];
    final itemWidget = itemBuilder(item);

    if (!animateItems) {
      return itemWidget;
    }

    // Анимация появления элементов
    return AnimatedSlide(
      duration: animationDuration,
      offset: Offset.zero,
      child: AnimatedOpacity(
        duration: animationDuration,
        opacity: 1.0,
        child: itemWidget,
      ),
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context) {
    return const EmptyStateMessage(
      icon: Icon(Icons.search_off),
      title: 'Нет результатов',
      subtitle: 'Попробуйте изменить критерии поиска',
    );
  }

  Widget _buildDefaultError(BuildContext context, String error) {
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
            'Произошла ошибка',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (onRefresh != null)
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Попробовать снова'),
            ),
        ],
      ),
    );
  }
}