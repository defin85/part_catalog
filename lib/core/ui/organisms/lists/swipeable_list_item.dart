import 'package:flutter/material.dart';

/// Элемент списка со свайпами для быстрых действий
/// Поддерживает настраиваемые действия слева и справа
class SwipeableListItem extends StatefulWidget {
  final Widget child;
  final List<SwipeAction>? leftActions;
  final List<SwipeAction>? rightActions;
  final double actionButtonWidth;
  final Duration animationDuration;
  final VoidCallback? onSwipeStarted;
  final VoidCallback? onSwipeEnded;
  final bool dismissible;
  final DismissDirection? dismissDirection;
  final VoidCallback? onDismissed;
  final String? dismissConfirmationText;

  const SwipeableListItem({
    super.key,
    required this.child,
    this.leftActions,
    this.rightActions,
    this.actionButtonWidth = 80,
    this.animationDuration = const Duration(milliseconds: 250),
    this.onSwipeStarted,
    this.onSwipeEnded,
    this.dismissible = false,
    this.dismissDirection,
    this.onDismissed,
    this.dismissConfirmationText,
  });

  @override
  State<SwipeableListItem> createState() => _SwipeableListItemState();
}

class _SwipeableListItemState extends State<SwipeableListItem>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  double _dragOffset = 0;
  bool _isDragging = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    if (_isAnimating) return;

    _isDragging = true;
    _animationController.stop();
    widget.onSwipeStarted?.call();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isAnimating) return;

    final deltaX = details.delta.dx;
    final newOffset = _dragOffset + deltaX;

    // Проверяем, есть ли действия в соответствующем направлении
    final canSwipeLeft = widget.rightActions != null && widget.rightActions!.isNotEmpty;
    final canSwipeRight = widget.leftActions != null && widget.leftActions!.isNotEmpty;

    if (newOffset > 0 && !canSwipeRight) return;
    if (newOffset < 0 && !canSwipeLeft) return;

    setState(() {
      _dragOffset = newOffset.clamp(
        -widget.actionButtonWidth * (widget.rightActions?.length ?? 0).toDouble(),
        widget.actionButtonWidth * (widget.leftActions?.length ?? 0).toDouble(),
      );
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;
    widget.onSwipeEnded?.call();

    final velocity = details.velocity.pixelsPerSecond.dx;
    final threshold = widget.actionButtonWidth * 0.4;

    double targetOffset = 0;

    if (_dragOffset.abs() > threshold || velocity.abs() > 800) {
      if (_dragOffset > 0 && widget.leftActions != null) {
        targetOffset = widget.actionButtonWidth * widget.leftActions!.length;
      } else if (_dragOffset < 0 && widget.rightActions != null) {
        targetOffset = -widget.actionButtonWidth * widget.rightActions!.length;
      }
    }

    _animateToOffset(targetOffset);
  }

  void _animateToOffset(double targetOffset) {
    if (_isAnimating) return;

    _isAnimating = true;
    final startOffset = _dragOffset;

    _slideAnimation = Tween<Offset>(
      begin: Offset(startOffset / MediaQuery.of(context).size.width, 0),
      end: Offset(targetOffset / MediaQuery.of(context).size.width, 0),
    ).animate(_animationController);

    _animationController.forward(from: 0).then((_) {
      setState(() {
        _dragOffset = targetOffset;
        _isAnimating = false;
      });
    });
  }

  void _handleActionTap(SwipeAction action) {
    if (action.closesOnTap) {
      _animateToOffset(0);
    }
    action.onTap();
  }

  void _resetSwipe() {
    _animateToOffset(0);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        // Фоновые действия
        if (_dragOffset != 0) _buildActionBackground(),

        // Основной контент
        GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          onTap: _dragOffset != 0 ? _resetSwipe : null,
          child: Transform.translate(
            offset: _isDragging
              ? Offset(_dragOffset, 0)
              : _slideAnimation.value * MediaQuery.of(context).size.width,
            child: widget.child,
          ),
        ),
      ],
    );

    // Добавляем Dismissible если нужно
    if (widget.dismissible) {
      content = Dismissible(
        key: UniqueKey(),
        direction: widget.dismissDirection ?? DismissDirection.horizontal,
        confirmDismiss: widget.dismissConfirmationText != null
          ? (direction) => _showDismissConfirmation()
          : null,
        onDismissed: (direction) => widget.onDismissed?.call(),
        child: content,
      );
    }

    return content;
  }

  Widget _buildActionBackground() {
    return Positioned.fill(
      child: Row(
        children: [
          // Левые действия
          if (_dragOffset > 0 && widget.leftActions != null)
            ...widget.leftActions!.map((action) => _buildActionButton(action, true)),

          const Spacer(),

          // Правые действия
          if (_dragOffset < 0 && widget.rightActions != null)
            ...widget.rightActions!.reversed.map((action) => _buildActionButton(action, false)),
        ],
      ),
    );
  }

  Widget _buildActionButton(SwipeAction action, bool isLeft) {
    return Container(
      width: widget.actionButtonWidth,
      color: action.backgroundColor,
      child: InkWell(
        onTap: () => _handleActionTap(action),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action.icon,
              color: action.iconColor ?? Colors.white,
              size: action.iconSize ?? 24,
            ),
            if (action.label != null) ...[
              const SizedBox(height: 4),
              Text(
                action.label!,
                style: TextStyle(
                  color: action.textColor ?? Colors.white,
                  fontSize: action.fontSize ?? 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDismissConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Text(widget.dismissConfirmationText!),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

/// Действие для свайпа
class SwipeAction {
  final IconData icon;
  final String? label;
  final Color backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final VoidCallback onTap;
  final bool closesOnTap;

  const SwipeAction({
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    this.label,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    this.closesOnTap = true,
  });

  /// Создает действие удаления
  SwipeAction.delete({
    required VoidCallback onTap,
    String? label,
    Color? backgroundColor,
  }) : this(
    icon: Icons.delete,
    label: label ?? 'Удалить',
    backgroundColor: backgroundColor ?? Colors.red,
    onTap: onTap,
  );

  /// Создает действие редактирования
  SwipeAction.edit({
    required VoidCallback onTap,
    String? label,
    Color? backgroundColor,
  }) : this(
    icon: Icons.edit,
    label: label ?? 'Изменить',
    backgroundColor: backgroundColor ?? Colors.blue,
    onTap: onTap,
  );

  /// Создает действие архивирования
  SwipeAction.archive({
    required VoidCallback onTap,
    String? label,
    Color? backgroundColor,
  }) : this(
    icon: Icons.archive,
    label: label ?? 'Архив',
    backgroundColor: backgroundColor ?? Colors.orange,
    onTap: onTap,
  );

  /// Создает действие избранного
  SwipeAction.favorite({
    required VoidCallback onTap,
    String? label,
    bool isFavorite = false,
    Color? backgroundColor,
  }) : this(
    icon: isFavorite ? Icons.favorite : Icons.favorite_border,
    label: label ?? (isFavorite ? 'Убрать' : 'В избранное'),
    backgroundColor: backgroundColor ?? Colors.pink,
    onTap: onTap,
  );

  /// Создает действие поделиться
  SwipeAction.share({
    required VoidCallback onTap,
    String? label,
    Color? backgroundColor,
  }) : this(
    icon: Icons.share,
    label: label ?? 'Поделиться',
    backgroundColor: backgroundColor ?? Colors.green,
    onTap: onTap,
  );

  /// Создает действие копирования
  SwipeAction.copy({
    required VoidCallback onTap,
    String? label,
    Color? backgroundColor,
  }) : this(
    icon: Icons.copy,
    label: label ?? 'Копировать',
    backgroundColor: backgroundColor ?? Colors.teal,
    onTap: onTap,
  );
}

/// Простая реализация списка со свайпами
class SwipeableList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final List<SwipeAction> Function(T item, int index)? leftActionsBuilder;
  final List<SwipeAction> Function(T item, int index)? rightActionsBuilder;
  final void Function(T item, int index)? onItemDismissed;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final Widget? separator;

  const SwipeableList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.leftActionsBuilder,
    this.rightActionsBuilder,
    this.onItemDismissed,
    this.scrollController,
    this.padding,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: padding,
      itemCount: items.length,
      separatorBuilder: (context, index) => separator ?? const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];

        return SwipeableListItem(
          leftActions: leftActionsBuilder?.call(item, index),
          rightActions: rightActionsBuilder?.call(item, index),
          dismissible: onItemDismissed != null,
          onDismissed: () => onItemDismissed?.call(item, index),
          child: itemBuilder(context, item, index),
        );
      },
    );
  }
}