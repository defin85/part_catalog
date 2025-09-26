import 'package:flutter/material.dart';

/// Material Design 3 макет с поддерживающей панелью
/// Используется для дополнительного контента или навигации рядом с основным содержимым
class SupportingPaneLayout extends StatefulWidget {
  /// Основное содержимое
  final Widget body;

  /// Поддерживающая панель (боковая панель)
  final Widget supportingPane;

  /// Позиция поддерживающей панели
  final SupportingPanePosition position;

  /// Ширина поддерживающей панели
  final double paneWidth;

  /// Минимальная ширина для показа панели
  final double minWidthToShowPane;

  /// Показывать панель изначально (на подходящих экранах)
  final bool initiallyExpanded;

  /// Может ли пользователь скрывать панель
  final bool collapsible;

  /// Показывать разделитель между панелями
  final bool showDivider;

  /// Режим отображения панели
  final SupportingPaneMode mode;

  /// Callback для изменения состояния панели
  final void Function(bool isExpanded)? onToggle;

  /// Длительность анимации
  final Duration animationDuration;

  /// Кривая анимации
  final Curve animationCurve;

  const SupportingPaneLayout({
    super.key,
    required this.body,
    required this.supportingPane,
    this.position = SupportingPanePosition.end,
    this.paneWidth = 280,
    this.minWidthToShowPane = 840,
    this.initiallyExpanded = true,
    this.collapsible = true,
    this.showDivider = true,
    this.mode = SupportingPaneMode.adaptive,
    this.onToggle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<SupportingPaneLayout> createState() => _SupportingPaneLayoutState();
}

class _SupportingPaneLayoutState extends State<SupportingPaneLayout>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late bool _isExpanded;
  bool _isWideScreen = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePane() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onToggle?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _isWideScreen = constraints.maxWidth >= widget.minWidthToShowPane;

        switch (widget.mode) {
          case SupportingPaneMode.adaptive:
            return _isWideScreen
                ? _buildSideBySideLayout(constraints)
                : _buildOverlayLayout(constraints);
          case SupportingPaneMode.sideBySide:
            return _buildSideBySideLayout(constraints);
          case SupportingPaneMode.overlay:
            return _buildOverlayLayout(constraints);
          case SupportingPaneMode.hidden:
            return widget.body;
        }
      },
    );
  }

  Widget _buildSideBySideLayout(BoxConstraints constraints) {
    final effectivePaneWidth = _isExpanded
        ? widget.paneWidth.clamp(200.0, constraints.maxWidth * 0.4)
        : 0.0;

    final children = <Widget>[
      // Основное содержимое
      Expanded(
        child: widget.body,
      ),

      // Разделитель
      if (_isExpanded && widget.showDivider)
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),

      // Поддерживающая панель
      AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return SizedBox(
            width: effectivePaneWidth * _slideAnimation.value,
            child: _slideAnimation.value > 0.1
                ? Opacity(
                    opacity: _slideAnimation.value,
                    child: widget.supportingPane,
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    ];

    return Row(
      children: widget.position == SupportingPanePosition.start
          ? children.reversed.toList()
          : children,
    );
  }

  Widget _buildOverlayLayout(BoxConstraints constraints) {
    return Stack(
      children: [
        // Основное содержимое
        widget.body,

        // Поддерживающая панель как оверлей
        if (_isExpanded)
          Positioned(
            top: 0,
            bottom: 0,
            left: widget.position == SupportingPanePosition.start ? 0 : null,
            right: widget.position == SupportingPanePosition.end ? 0 : null,
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    widget.position == SupportingPanePosition.start
                        ? (-widget.paneWidth * (1 - _slideAnimation.value))
                        : (widget.paneWidth * (1 - _slideAnimation.value)),
                    0,
                  ),
                  child: SizedBox(
                    width: widget.paneWidth,
                    child: Material(
                      elevation: 8,
                      color: Theme.of(context).colorScheme.surface,
                      child: widget.supportingPane,
                    ),
                  ),
                );
              },
            ),
          ),

        // Затемняющий фон для overlay режима
        if (_isExpanded && widget.mode == SupportingPaneMode.overlay)
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return GestureDetector(
                onTap: _togglePane,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3 * _slideAnimation.value),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Контроллер для управления поддерживающей панелью
class SupportingPaneController extends ChangeNotifier {
  bool _isExpanded = true;

  bool get isExpanded => _isExpanded;

  void expand() {
    if (!_isExpanded) {
      _isExpanded = true;
      notifyListeners();
    }
  }

  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      notifyListeners();
    }
  }

  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}

/// Позиция поддерживающей панели
enum SupportingPanePosition {
  start,  // Слева (LTR) или справа (RTL)
  end,    // Справа (LTR) или слева (RTL)
}

/// Режим отображения поддерживающей панели
enum SupportingPaneMode {
  adaptive,   // Автоматически выбирать между sideBySide и overlay
  sideBySide, // Всегда рядом с основным содержимым
  overlay,    // Всегда как оверлей поверх основного содержимого
  hidden,     // Скрыта
}

/// Виджет кнопки для переключения поддерживающей панели
class SupportingPaneToggleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isExpanded;
  final SupportingPanePosition position;
  final String? tooltip;

  const SupportingPaneToggleButton({
    super.key,
    this.onPressed,
    required this.isExpanded,
    this.position = SupportingPanePosition.end,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String defaultTooltip;

    if (position == SupportingPanePosition.start) {
      icon = isExpanded ? Icons.first_page : Icons.last_page;
      defaultTooltip = isExpanded ? 'Скрыть панель' : 'Показать панель';
    } else {
      icon = isExpanded ? Icons.last_page : Icons.first_page;
      defaultTooltip = isExpanded ? 'Скрыть панель' : 'Показать панель';
    }

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip ?? defaultTooltip,
    );
  }
}

/// Компонент заголовка для поддерживающей панели
class SupportingPaneHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final EdgeInsets? padding;

  const SupportingPaneHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.onClose,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (actions != null) ...actions!,
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              iconSize: 20,
            ),
        ],
      ),
    );
  }
}