import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/organisms/lists/searchable_list.dart';

/// Информация о странице
class PageInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PageInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  PageInfo copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PageInfo(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}

/// Список с поддержкой пагинации
/// Может работать в режиме бесконечной прокрутки или с традиционными кнопками навигации
class PaginatedList<T> extends StatefulWidget {
  /// Элементы текущей страницы
  final List<T> items;

  /// Информация о пагинации
  final PageInfo pageInfo;

  /// Билдер для создания элемента списка
  final Widget Function(T item) itemBuilder;

  /// Функция загрузки страницы
  final Future<void> Function(int page)? onPageChanged;

  /// Функция загрузки следующей страницы (для infinite scroll)
  final Future<void> Function()? onLoadNext;

  /// Тип пагинации
  final PaginationType paginationType;

  /// Состояние загрузки
  final bool isLoading;

  /// Загружается ли следующая страница
  final bool isLoadingNext;

  /// Ошибка
  final String? error;

  /// Остальные параметры из SearchableList
  final Widget Function()? loadingBuilder;
  final Widget Function()? emptyStateBuilder;
  final Widget Function(String error)? errorBuilder;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool showSeparators;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Настройки для пагинации с кнопками
  final bool showPageNumbers;
  final int maxPageButtons;
  final bool showFirstLast;
  final bool showPreviousNext;

  /// Настройки для бесконечной прокрутки
  final double loadMoreThreshold;

  const PaginatedList({
    super.key,
    required this.items,
    required this.pageInfo,
    required this.itemBuilder,
    this.onPageChanged,
    this.onLoadNext,
    this.paginationType = PaginationType.buttons,
    this.isLoading = false,
    this.isLoadingNext = false,
    this.error,
    this.loadingBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.onRefresh,
    this.scrollController,
    this.padding,
    this.physics,
    this.showSeparators = false,
    this.separatorBuilder,
    this.showPageNumbers = true,
    this.maxPageButtons = 5,
    this.showFirstLast = true,
    this.showPreviousNext = true,
    this.loadMoreThreshold = 200.0,
  });

  @override
  State<PaginatedList<T>> createState() => _PaginatedListState<T>();
}

/// Тип пагинации
enum PaginationType {
  /// Кнопки навигации по страницам
  buttons,
  /// Бесконечная прокрутка
  infinite,
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    if (widget.paginationType == PaginationType.infinite) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (widget.paginationType != PaginationType.infinite) return;
    if (widget.isLoadingNext || !widget.pageInfo.hasNextPage) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= widget.loadMoreThreshold) {
      widget.onLoadNext?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildList(),
        ),
        if (widget.paginationType == PaginationType.buttons)
          _buildPaginationControls(),
        if (widget.paginationType == PaginationType.infinite &&
            widget.isLoadingNext)
          _buildLoadingNext(),
      ],
    );
  }

  Widget _buildList() {
    Widget listContent = SearchableList<T>(
      items: widget.items,
      itemBuilder: widget.itemBuilder,
      loadingBuilder: widget.loadingBuilder,
      emptyStateBuilder: widget.emptyStateBuilder,
      errorBuilder: widget.errorBuilder,
      isLoading: widget.isLoading,
      error: widget.error,
      onRefresh: widget.onRefresh,
      scrollController: _scrollController,
      padding: widget.padding,
      physics: widget.physics,
      showSeparators: widget.showSeparators,
      separatorBuilder: widget.separatorBuilder,
    );

    return listContent;
  }

  Widget _buildPaginationControls() {
    if (widget.pageInfo.totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPageInfo(),
          const SizedBox(height: 16),
          _buildPageButtons(),
        ],
      ),
    );
  }

  Widget _buildPageInfo() {
    final start = (widget.pageInfo.currentPage - 1) * widget.pageInfo.itemsPerPage + 1;
    final end = (start + widget.items.length - 1).clamp(start, widget.pageInfo.totalItems);

    return Text(
      'Показано $start-$end из ${widget.pageInfo.totalItems}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildPageButtons() {
    final buttons = <Widget>[];

    // Первая страница
    if (widget.showFirstLast && widget.pageInfo.currentPage > 2) {
      buttons.add(_buildPageButton(1, 'Первая'));
      if (widget.pageInfo.currentPage > 3) {
        buttons.add(_buildEllipsis());
      }
    }

    // Предыдущая
    if (widget.showPreviousNext && widget.pageInfo.hasPreviousPage) {
      buttons.add(_buildPageButton(
        widget.pageInfo.currentPage - 1,
        'Назад',
        icon: Icons.chevron_left,
      ));
    }

    // Страницы вокруг текущей
    if (widget.showPageNumbers) {
      final startPage = (widget.pageInfo.currentPage - widget.maxPageButtons ~/ 2)
          .clamp(1, widget.pageInfo.totalPages);
      final endPage = (startPage + widget.maxPageButtons - 1)
          .clamp(1, widget.pageInfo.totalPages);

      for (int page = startPage; page <= endPage; page++) {
        buttons.add(_buildPageButton(page, page.toString()));
      }
    }

    // Следующая
    if (widget.showPreviousNext && widget.pageInfo.hasNextPage) {
      buttons.add(_buildPageButton(
        widget.pageInfo.currentPage + 1,
        'Далее',
        icon: Icons.chevron_right,
      ));
    }

    // Последняя страница
    if (widget.showFirstLast &&
        widget.pageInfo.currentPage < widget.pageInfo.totalPages - 1) {
      if (widget.pageInfo.currentPage < widget.pageInfo.totalPages - 2) {
        buttons.add(_buildEllipsis());
      }
      buttons.add(_buildPageButton(widget.pageInfo.totalPages, 'Последняя'));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }

  Widget _buildPageButton(int page, String label, {IconData? icon}) {
    final isCurrentPage = page == widget.pageInfo.currentPage;

    return SizedBox(
      height: 40,
      child: isCurrentPage
          ? FilledButton(
              onPressed: null,
              child: icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16),
                        const SizedBox(width: 4),
                        Text(label),
                      ],
                    )
                  : Text(label),
            )
          : OutlinedButton(
              onPressed: widget.isLoading ? null : () => _changePage(page),
              child: icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16),
                        const SizedBox(width: 4),
                        Text(label),
                      ],
                    )
                  : Text(label),
            ),
    );
  }

  Widget _buildEllipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('...'),
    );
  }

  Widget _buildLoadingNext() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Загрузка...'),
        ],
      ),
    );
  }

  void _changePage(int page) {
    widget.onPageChanged?.call(page);
  }
}