import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Расширенная иконочная кнопка с дополнительными опциями
/// Поддерживает различные размеры, варианты отображения и состояния
class IconButtonExtended extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconButtonSize size;
  final IconButtonVariant variant;
  final Color? color;
  final Color? backgroundColor;
  final bool isSelected;
  final bool isLoading;
  final Widget? badge;

  const IconButtonExtended({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = IconButtonSize.medium,
    this.variant = IconButtonVariant.standard,
    this.color,
    this.backgroundColor,
    this.isSelected = false,
    this.isLoading = false,
    this.badge,
  });

  /// Создает кнопку с бейджем (например, для уведомлений)
  const IconButtonExtended.withBadge({
    super.key,
    required this.icon,
    required this.badge,
    this.onPressed,
    this.tooltip,
    this.size = IconButtonSize.medium,
    this.variant = IconButtonVariant.standard,
    this.color,
    this.backgroundColor,
    this.isSelected = false,
    this.isLoading = false,
  });

  /// Создает переключаемую кнопку (toggle)
  const IconButtonExtended.toggle({
    super.key,
    required this.icon,
    required this.isSelected,
    this.onPressed,
    this.tooltip,
    this.size = IconButtonSize.medium,
    this.color,
    this.backgroundColor,
    this.isLoading = false,
    this.badge,
  }) : variant = IconButtonVariant.filled;

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButton(context);

    if (badge != null) {
      button = Badge(
        label: badge,
        child: button,
      );
    }

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(BuildContext context) {
    final iconSize = _getIconSize();
    final buttonSize = _getButtonSize();

    final iconWidget = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Icon(icon, size: iconSize);

    switch (variant) {
      case IconButtonVariant.standard:
        return IconButton(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          iconSize: iconSize,
          color: color,
          constraints: BoxConstraints.tightFor(
            width: buttonSize,
            height: buttonSize,
          ),
        );

      case IconButtonVariant.filled:
        return IconButton.filled(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          iconSize: iconSize,
          color: color,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null),
            foregroundColor: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : color,
            minimumSize: Size(buttonSize, buttonSize),
            maximumSize: Size(buttonSize, buttonSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );

      case IconButtonVariant.outlined:
        return IconButton.outlined(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          iconSize: iconSize,
          color: color,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: color,
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            minimumSize: Size(buttonSize, buttonSize),
            maximumSize: Size(buttonSize, buttonSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );

      case IconButtonVariant.tonal:
        return IconButton.filledTonal(
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
          iconSize: iconSize,
          color: color,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ??
                (isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null),
            foregroundColor: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : color,
            minimumSize: Size(buttonSize, buttonSize),
            maximumSize: Size(buttonSize, buttonSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case IconButtonSize.small:
        return AppSizes.iconSm;
      case IconButtonSize.medium:
        return AppSizes.iconMd;
      case IconButtonSize.large:
        return AppSizes.iconLg;
      case IconButtonSize.extraLarge:
        return AppSizes.iconXl;
    }
  }

  double _getButtonSize() {
    switch (size) {
      case IconButtonSize.small:
        return 36.0;
      case IconButtonSize.medium:
        return 48.0;
      case IconButtonSize.large:
        return 56.0;
      case IconButtonSize.extraLarge:
        return 72.0;
    }
  }
}

/// Размеры иконочных кнопок
enum IconButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Варианты стилизации иконочных кнопок
enum IconButtonVariant {
  standard,  // Обычная кнопка
  filled,    // С заливкой
  outlined,  // С границей
  tonal,     // С тональной заливкой
}