import 'package:flutter/material.dart';

/// Карточка с полями формы
/// Обертывает поля в красивую карточку с заголовком и управлением состоянием
class FormCard extends StatelessWidget {
  /// Заголовок карточки
  final String? title;

  /// Иконка карточки
  final IconData? icon;

  /// Содержимое карточки
  final List<Widget> children;

  /// Действия в заголовке
  final List<Widget>? actions;

  /// Паддинг содержимого
  final EdgeInsetsGeometry? contentPadding;

  /// Elevation карточки
  final double? elevation;

  /// Цвет фона
  final Color? backgroundColor;

  /// Граница карточки
  final BorderSide? border;

  /// Радиус скругления
  final BorderRadius? borderRadius;

  /// Есть ли ошибки в карточке
  final bool hasErrors;

  /// Неактивна ли карточка
  final bool isDisabled;

  /// Обработчик нажатия на карточку
  final VoidCallback? onTap;

  /// Показывать ли тень
  final bool showShadow;

  /// Компактный режим (меньше отступов)
  final bool compact;

  const FormCard({
    super.key,
    this.title,
    this.icon,
    required this.children,
    this.actions,
    this.contentPadding,
    this.elevation,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.hasErrors = false,
    this.isDisabled = false,
    this.onTap,
    this.showShadow = true,
    this.compact = false,
  });

  /// Создает простую карточку без заголовка
  const FormCard.simple({
    super.key,
    required this.children,
    this.contentPadding,
    this.elevation,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.hasErrors = false,
    this.isDisabled = false,
    this.onTap,
    this.showShadow = true,
    this.compact = false,
  }) : title = null,
       icon = null,
       actions = null;

  /// Создает компактную карточку с уменьшенными отступами
  const FormCard.compact({
    super.key,
    this.title,
    this.icon,
    required this.children,
    this.actions,
    this.contentPadding,
    this.elevation,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.hasErrors = false,
    this.isDisabled = false,
    this.onTap,
    this.showShadow = true,
  }) : compact = true;

  @override
  Widget build(BuildContext context) {
    final cardColor = backgroundColor ??
        (isDisabled
            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
            : Theme.of(context).colorScheme.surface);

    final cardBorder = _getBorder(context);
    final cardElevation = showShadow ? (elevation?.toDouble() ?? 1.0) : 0.0;

    Widget card = Card(
      elevation: cardElevation,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        side: cardBorder,
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );

    if (isDisabled) {
      card = Opacity(
        opacity: 0.6,
        child: card,
      );
    }

    return card;
  }

  Widget _buildHeader(BuildContext context) {
    final headerPadding = compact
        ? const EdgeInsets.fromLTRB(12, 12, 12, 8)
        : const EdgeInsets.fromLTRB(16, 16, 16, 8);

    return Padding(
      padding: headerPadding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: compact ? 20 : 24,
              color: _getIconColor(context),
            ),
            SizedBox(width: compact ? 8 : 12),
          ],
          Expanded(
            child: Text(
              title!,
              style: (compact
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                color: hasErrors
                    ? Theme.of(context).colorScheme.error
                    : isDisabled
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (actions != null) ...actions!,
          if (hasErrors)
            Icon(
              Icons.error_outline,
              size: compact ? 18 : 20,
              color: Theme.of(context).colorScheme.error,
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final defaultContentPadding = compact
        ? const EdgeInsets.fromLTRB(12, 0, 12, 12)
        : const EdgeInsets.fromLTRB(16, 0, 16, 16);

    final effectiveContentPadding = contentPadding ?? defaultContentPadding;

    // Если есть заголовок, уменьшаем верхний отступ содержимого
    final adjustedPadding = title != null
        ? effectiveContentPadding.copyWith(top: 0)
        : effectiveContentPadding;

    return Padding(
      padding: adjustedPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildChildrenWithSpacing(),
      ),
    );
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return children;

    final List<Widget> spacedChildren = [];
    final spacing = compact ? 8.0 : 12.0;

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);

      // Добавляем отступ между элементами, но не после последнего
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }

    return spacedChildren;
  }

  BorderSide _getBorder(BuildContext context) {
    if (border != null) return border!;

    if (hasErrors) {
      return BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 1.5,
      );
    }

    if (isDisabled) {
      return BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        width: 1,
      );
    }

    return BorderSide(
      color: Theme.of(context).colorScheme.outlineVariant,
      width: 1,
    );
  }

  Color _getIconColor(BuildContext context) {
    if (hasErrors) return Theme.of(context).colorScheme.error;
    if (isDisabled) return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    return Theme.of(context).colorScheme.primary;
  }
}

/// Утилитарные расширения для EdgeInsetsGeometry
extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
  EdgeInsetsGeometry copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (this is EdgeInsets) {
      final current = this as EdgeInsets;
      return EdgeInsets.only(
        left: left ?? current.left,
        top: top ?? current.top,
        right: right ?? current.right,
        bottom: bottom ?? current.bottom,
      );
    }
    return this;
  }
}