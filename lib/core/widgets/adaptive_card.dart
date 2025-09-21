import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Контекст размещения карточки для умного выбора стиля
enum AdaptiveCardContext {
  /// Главная карточка на экране
  primary,
  /// Карточка в списке
  list,
  /// Карточка в сетке
  grid,
  /// Карточка внутри другой карточки
  nested,
  /// Карточка в модальном окне
  modal,
  /// Карточка в боковой панели
  sidebar,
}

/// Адаптивная карточка с умным скруглением и отступами
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final AdaptiveCardContext context;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool isSelectable;
  final bool isSelected;
  final bool showHoverEffect;
  final double? customBorderRadius;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.context = AdaptiveCardContext.primary,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.border,
    this.boxShadow,
    this.onTap,
    this.isSelectable = false,
    this.isSelected = false,
    this.showHoverEffect = true,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildCard(context, ScreenSize.small),
      medium: (context, constraints) => _buildCard(context, ScreenSize.medium),
      large: (context, constraints) => _buildCard(context, ScreenSize.large),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  Widget _buildCard(BuildContext context, ScreenSize screenSize) {
    final theme = Theme.of(context);
    final cardStyle = _getCardStyle(screenSize);

    Widget card = Container(
      margin: margin ?? cardStyle.margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(customBorderRadius ?? cardStyle.borderRadius),
        border: border ?? _getBorder(theme),
        boxShadow: boxShadow ?? _getBoxShadow(theme, cardStyle),
      ),
      child: Padding(
        padding: padding ?? cardStyle.padding,
        child: child,
      ),
    );

    // Добавляем интерактивность если нужно
    if (onTap != null || isSelectable) {
      card = _wrapWithInteraction(card, theme, cardStyle);
    }

    return card;
  }

  Widget _wrapWithInteraction(Widget card, ThemeData theme, _CardStyle cardStyle) {
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(customBorderRadius ?? cardStyle.borderRadius),
          hoverColor: showHoverEffect ? theme.colorScheme.primary.withValues(alpha: 0.04) : null,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: card,
        ),
      );
    } else if (isSelectable) {
      return Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius ?? cardStyle.borderRadius),
            border: isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: card,
        ),
      );
    }
    return card;
  }

  _CardStyle _getCardStyle(ScreenSize screenSize) {
    switch (context) {
      case AdaptiveCardContext.primary:
        return _getPrimaryCardStyle(screenSize);
      case AdaptiveCardContext.list:
        return _getListCardStyle(screenSize);
      case AdaptiveCardContext.grid:
        return _getGridCardStyle(screenSize);
      case AdaptiveCardContext.nested:
        return _getNestedCardStyle(screenSize);
      case AdaptiveCardContext.modal:
        return _getModalCardStyle(screenSize);
      case AdaptiveCardContext.sidebar:
        return _getSidebarCardStyle(screenSize);
    }
  }

  _CardStyle _getPrimaryCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 16,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 4,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 20,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 6,
        );
    }
  }

  _CardStyle _getListCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 8,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 1,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          elevation: 2,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          elevation: 3,
        );
    }
  }

  _CardStyle _getGridCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          elevation: 2,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 16,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(12),
          elevation: 3,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 16,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          elevation: 4,
        );
    }
  }

  _CardStyle _getNestedCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 8,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          elevation: 0,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 10,
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.all(10),
          elevation: 1,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(12),
          elevation: 2,
        );
    }
  }

  _CardStyle _getModalCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 16,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          elevation: 8,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 20,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(24),
          elevation: 12,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 24,
          padding: EdgeInsets.all(32),
          margin: EdgeInsets.all(32),
          elevation: 16,
        );
    }
  }

  _CardStyle _getSidebarCardStyle(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return const _CardStyle(
          borderRadius: 8,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 1,
        );
      case ScreenSize.medium:
        return const _CardStyle(
          borderRadius: 10,
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
        );
      case ScreenSize.large:
        return const _CardStyle(
          borderRadius: 12,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 3,
        );
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (isSelected) {
      return theme.colorScheme.primaryContainer.withValues(alpha: 0.12);
    }
    return theme.cardColor;
  }

  Border? _getBorder(ThemeData theme) {
    if (context == AdaptiveCardContext.nested) {
      return Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.12),
        width: 1,
      );
    }
    return null;
  }

  List<BoxShadow> _getBoxShadow(ThemeData theme, _CardStyle cardStyle) {
    if (elevation != null && elevation! > 0) {
      return [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.15),
          blurRadius: elevation! * 2,
          offset: Offset(0, elevation! / 2),
        ),
      ];
    }

    if (cardStyle.elevation > 0) {
      return [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.1),
          blurRadius: cardStyle.elevation * 1.5,
          offset: Offset(0, cardStyle.elevation * 0.5),
        ),
      ];
    }

    return [];
  }
}

/// Внутренний класс для хранения стилей карточки
class _CardStyle {
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double elevation;

  const _CardStyle({
    required this.borderRadius,
    required this.padding,
    required this.margin,
    required this.elevation,
  });
}

/// Расширения для удобного использования
extension AdaptiveCardExtensions on Widget {
  /// Оборачивает виджет в AdaptiveCard
  Widget asAdaptiveCard({
    AdaptiveCardContext context = AdaptiveCardContext.primary,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    bool isSelectable = false,
    bool isSelected = false,
  }) {
    return AdaptiveCard(
      context: context,
      padding: padding,
      margin: margin,
      onTap: onTap,
      isSelectable: isSelectable,
      isSelected: isSelected,
      child: this,
    );
  }
}