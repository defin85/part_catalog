import 'package:flutter/material.dart';

/// Material Design 3 макет ленты (Feed Layout)
/// Используется для отображения потока контента как новости, посты, уведомления
class FeedLayout extends StatefulWidget {
  /// Элементы ленты
  final List<Widget> items;

  /// Билдер для создания элементов ленты
  final Widget Function(BuildContext context, int index)? itemBuilder;

  /// Количество элементов (используется с itemBuilder)
  final int? itemCount;

  /// Заголовок ленты
  final Widget? header;

  /// Футер ленты
  final Widget? footer;

  /// Виджет для пустого состояния
  final Widget? emptyState;

  /// Виджет загрузки
  final Widget? loadingWidget;

  /// Индикатор ошибки
  final Widget? errorWidget;

  /// Контроллер прокрутки
  final ScrollController? scrollController;

  /// Отступы контента
  final EdgeInsets? padding;

  /// Разделитель между элементами
  final Widget? separator;

  /// Режим отображения (список или сетка)
  final FeedDisplayMode displayMode;

  /// Количество колонок для сетки
  final int gridColumns;

  /// Соотношение сторон для элементов сетки
  final double gridAspectRatio;

  /// Расстояние между элементами сетки
  final double gridSpacing;

  /// Callback для обновления (pull-to-refresh)
  final Future<void> Function()? onRefresh;

  /// Callback для загрузки больше данных
  final Future<void> Function()? onLoadMore;

  /// Показывать ли индикатор загрузки в конце
  final bool showLoadMoreIndicator;

  /// Состояние загрузки
  final FeedState state;

  /// Длительность анимации
  final Duration animationDuration;

  const FeedLayout({
    super.key,
    this.items = const [],
    this.itemBuilder,
    this.itemCount,
    this.header,
    this.footer,
    this.emptyState,
    this.loadingWidget,
    this.errorWidget,
    this.scrollController,
    this.padding,
    this.separator,
    this.displayMode = FeedDisplayMode.list,
    this.gridColumns = 2,
    this.gridAspectRatio = 1.0,
    this.gridSpacing = 8.0,
    this.onRefresh,
    this.onLoadMore,
    this.showLoadMoreIndicator = false,
    this.state = FeedState.loaded,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<FeedLayout> createState() => _FeedLayoutState();
}

class _FeedLayoutState extends State<FeedLayout> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (widget.onLoadMore == null) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || widget.onLoadMore == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (widget.state) {
      case FeedState.loading:
        return _buildLoadingState();
      case FeedState.error:
        return _buildErrorState();
      case FeedState.empty:
        return _buildEmptyState();
      case FeedState.loaded:
        return _buildLoadedState();
    }
  }

  Widget _buildLoadingState() {
    return widget.loadingWidget ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Widget _buildErrorState() {
    return widget.errorWidget ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Произошла ошибка при загрузке',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        );
  }

  Widget _buildEmptyState() {
    return widget.emptyState ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'Нет элементов для отображения',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
  }

  Widget _buildLoadedState() {
    final effectiveItemCount = widget.itemCount ?? widget.items.length;

    if (effectiveItemCount == 0) {
      return _buildEmptyState();
    }

    Widget content;

    switch (widget.displayMode) {
      case FeedDisplayMode.list:
        content = _buildListView(effectiveItemCount);
        break;
      case FeedDisplayMode.grid:
        content = _buildGridView(effectiveItemCount);
        break;
    }

    if (widget.onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildListView(int itemCount) {
    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: _getEffectiveItemCount(itemCount),
      separatorBuilder: (context, index) {
        if (_isHeaderIndex(index) || _isFooterIndex(index, itemCount)) {
          return const SizedBox.shrink();
        }
        return widget.separator ?? const SizedBox(height: 8);
      },
      itemBuilder: (context, index) => _buildItemAtIndex(index, itemCount),
    );
  }

  Widget _buildGridView(int itemCount) {
    return GridView.builder(
      controller: _scrollController,
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridColumns,
        childAspectRatio: widget.gridAspectRatio,
        crossAxisSpacing: widget.gridSpacing,
        mainAxisSpacing: widget.gridSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(context, index);
        }
        return widget.items[index];
      },
    );
  }

  Widget _buildItemAtIndex(int index, int itemCount) {
    // Заголовок
    if (widget.header != null && index == 0) {
      return widget.header!;
    }

    // Футер
    if (widget.footer != null && index == _getEffectiveItemCount(itemCount) - 1) {
      return Column(
        children: [
          widget.footer!,
          if (_isLoadingMore) _buildLoadMoreIndicator(),
        ],
      );
    }

    // Индикатор загрузки больше данных
    if (widget.showLoadMoreIndicator &&
        index == _getEffectiveItemCount(itemCount) - 1) {
      return Column(
        children: [
          _buildContentItem(index, itemCount),
          if (_isLoadingMore) _buildLoadMoreIndicator(),
        ],
      );
    }

    return _buildContentItem(index, itemCount);
  }

  Widget _buildContentItem(int index, int itemCount) {
    final contentIndex = _getContentIndex(index);

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, contentIndex);
    }

    if (contentIndex >= 0 && contentIndex < widget.items.length) {
      return widget.items[contentIndex];
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }

  int _getEffectiveItemCount(int baseCount) {
    int count = baseCount;
    if (widget.header != null) count++;
    if (widget.footer != null) count++;
    return count;
  }

  int _getContentIndex(int index) {
    int contentIndex = index;
    if (widget.header != null) contentIndex--;
    return contentIndex;
  }

  bool _isHeaderIndex(int index) {
    return widget.header != null && index == 0;
  }

  bool _isFooterIndex(int index, int itemCount) {
    return widget.footer != null && index == _getEffectiveItemCount(itemCount) - 1;
  }
}

/// Состояние ленты
enum FeedState {
  loading,  // Начальная загрузка
  loaded,   // Данные загружены
  empty,    // Нет данных
  error,    // Ошибка загрузки
}

/// Режим отображения ленты
enum FeedDisplayMode {
  list,  // Вертикальный список
  grid,  // Сетка
}

/// Контроллер для управления лентой
class FeedController extends ChangeNotifier {
  FeedState _state = FeedState.loaded;
  List<dynamic> _items = [];
  String? _error;

  FeedState get state => _state;
  List<dynamic> get items => List.unmodifiable(_items);
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;
  bool get isLoading => _state == FeedState.loading;
  bool get hasError => _state == FeedState.error;

  void setLoading() {
    _state = FeedState.loading;
    _error = null;
    notifyListeners();
  }

  void setLoaded(List<dynamic> items) {
    _items = List.from(items);
    _state = _items.isEmpty ? FeedState.empty : FeedState.loaded;
    _error = null;
    notifyListeners();
  }

  void setError(String error) {
    _state = FeedState.error;
    _error = error;
    notifyListeners();
  }

  void addItems(List<dynamic> newItems) {
    _items.addAll(newItems);
    _state = _items.isEmpty ? FeedState.empty : FeedState.loaded;
    notifyListeners();
  }

  void insertItem(int index, dynamic item) {
    _items.insert(index, item);
    _state = FeedState.loaded;
    notifyListeners();
  }

  void removeItem(dynamic item) {
    _items.remove(item);
    _state = _items.isEmpty ? FeedState.empty : FeedState.loaded;
    notifyListeners();
  }

  void removeItemAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _state = _items.isEmpty ? FeedState.empty : FeedState.loaded;
      notifyListeners();
    }
  }

  void updateItem(int index, dynamic item) {
    if (index >= 0 && index < _items.length) {
      _items[index] = item;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _state = FeedState.empty;
    _error = null;
    notifyListeners();
  }

  void refresh() {
    setLoading();
    // Здесь должна быть логика обновления данных
  }
}

/// Элемент ленты с базовой структурой
class FeedItem extends StatelessWidget {
  final Widget? avatar;
  final String? title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const FeedItem({
    super.key,
    this.avatar,
    this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с аватаром
              if (avatar != null || title != null || subtitle != null)
                Row(
                  children: [
                    if (avatar != null) ...[
                      avatar!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

              // Контент
              if (content != null) ...[
                if (avatar != null || title != null || subtitle != null)
                  const SizedBox(height: 12),
                content!,
              ],

              // Действия
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}