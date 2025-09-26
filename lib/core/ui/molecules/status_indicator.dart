import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Индикатор статуса с различными вариантами отображения
class StatusIndicator extends StatelessWidget {
  final String text;
  final StatusType status;
  final StatusStyle style;
  final StatusSize size;
  final IconData? icon;
  final bool showIcon;
  final bool animated;
  final VoidCallback? onTap;

  const StatusIndicator({
    super.key,
    required this.text,
    required this.status,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  });

  /// Создает статус успеха
  const StatusIndicator.success(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  }) : status = StatusType.success;

  /// Создает статус ошибки
  const StatusIndicator.error(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  }) : status = StatusType.error;

  /// Создает статус предупреждения
  const StatusIndicator.warning(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  }) : status = StatusType.warning;

  /// Создает информационный статус
  const StatusIndicator.info(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  }) : status = StatusType.info;

  /// Создает нейтральный статус
  const StatusIndicator.neutral(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.showIcon = true,
    this.animated = false,
    this.onTap,
  }) : status = StatusType.neutral;

  /// Создает индикатор процесса
  const StatusIndicator.processing(
    this.text, {
    super.key,
    this.style = StatusStyle.filled,
    this.size = StatusSize.medium,
    this.icon,
    this.animated = true,
    this.onTap,
  })  : status = StatusType.processing,
        showIcon = true;

  @override
  Widget build(BuildContext context) {
    Widget child = _buildContent(context);

    if (animated) {
      child = _wrapWithAnimation(child);
    }

    if (onTap != null) {
      child = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: child,
      );
    }

    return child;
  }

  Widget _buildContent(BuildContext context) {
    final colors = _getColors(context);

    return Container(
      padding: _getPadding(),
      decoration: _getDecoration(colors),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            _buildIcon(colors),
            SizedBox(width: _getIconSpacing()),
          ],
          _buildText(colors),
        ],
      ),
    );
  }

  Widget _buildIcon(StatusColors colors) {
    final iconData = icon ?? _getDefaultIcon();
    final iconSize = _getIconSize();

    if (status == StatusType.processing && animated) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(colors.foreground),
        ),
      );
    }

    return Icon(
      iconData,
      size: iconSize,
      color: colors.foreground,
    );
  }

  Widget _buildText(StatusColors colors) {
    return Text(
      text,
      style: _getTextStyle().copyWith(color: colors.foreground),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _wrapWithAnimation(Widget child) {
    if (status == StatusType.processing) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        child: child,
      );
    }
    return child;
  }

  StatusColors _getColors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (status) {
      case StatusType.success:
        return StatusColors(
          background: style == StatusStyle.filled
              ? Colors.green.shade100
              : Colors.transparent,
          foreground: style == StatusStyle.filled
              ? Colors.green.shade800
              : Colors.green.shade700,
          border: Colors.green.shade300,
        );

      case StatusType.error:
        return StatusColors(
          background: style == StatusStyle.filled
              ? colorScheme.errorContainer
              : Colors.transparent,
          foreground: style == StatusStyle.filled
              ? colorScheme.onErrorContainer
              : colorScheme.error,
          border: colorScheme.error,
        );

      case StatusType.warning:
        return StatusColors(
          background: style == StatusStyle.filled
              ? Colors.orange.shade100
              : Colors.transparent,
          foreground: style == StatusStyle.filled
              ? Colors.orange.shade800
              : Colors.orange.shade700,
          border: Colors.orange.shade300,
        );

      case StatusType.info:
        return StatusColors(
          background: style == StatusStyle.filled
              ? colorScheme.primaryContainer
              : Colors.transparent,
          foreground: style == StatusStyle.filled
              ? colorScheme.onPrimaryContainer
              : colorScheme.primary,
          border: colorScheme.primary,
        );

      case StatusType.neutral:
        return StatusColors(
          background: style == StatusStyle.filled
              ? colorScheme.surfaceContainerHighest
              : Colors.transparent,
          foreground: colorScheme.onSurface,
          border: colorScheme.outline,
        );

      case StatusType.processing:
        return StatusColors(
          background: style == StatusStyle.filled
              ? colorScheme.secondaryContainer
              : Colors.transparent,
          foreground: style == StatusStyle.filled
              ? colorScheme.onSecondaryContainer
              : colorScheme.secondary,
          border: colorScheme.secondary,
        );
    }
  }

  BoxDecoration _getDecoration(StatusColors colors) {
    switch (style) {
      case StatusStyle.filled:
        return BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        );

      case StatusStyle.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
        );

      case StatusStyle.text:
        return const BoxDecoration();
    }
  }

  IconData _getDefaultIcon() {
    switch (status) {
      case StatusType.success:
        return Icons.check_circle;
      case StatusType.error:
        return Icons.error;
      case StatusType.warning:
        return Icons.warning;
      case StatusType.info:
        return Icons.info;
      case StatusType.neutral:
        return Icons.circle;
      case StatusType.processing:
        return Icons.hourglass_empty;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case StatusSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case StatusSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case StatusSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case StatusSize.small:
        return AppRadius.sm;
      case StatusSize.medium:
        return AppRadius.md;
      case StatusSize.large:
        return AppRadius.lg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case StatusSize.small:
        return AppSizes.iconXs;
      case StatusSize.medium:
        return AppSizes.iconSm;
      case StatusSize.large:
        return AppSizes.iconMd;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case StatusSize.small:
        return AppSpacing.xs;
      case StatusSize.medium:
        return AppSpacing.sm;
      case StatusSize.large:
        return AppSpacing.md;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case StatusSize.small:
        return const TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
      case StatusSize.medium:
        return const TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
      case StatusSize.large:
        return const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
    }
  }
}

/// Типы статусов
enum StatusType {
  success,     // Успех
  error,       // Ошибка
  warning,     // Предупреждение
  info,        // Информация
  neutral,     // Нейтральный
  processing,  // В процессе
}

/// Стили отображения статуса
enum StatusStyle {
  filled,    // Заливка
  outlined,  // Только границы
  text,      // Только текст
}

/// Размеры статуса
enum StatusSize {
  small,
  medium,
  large,
}

/// Цвета для статуса
class StatusColors {
  final Color background;
  final Color foreground;
  final Color border;

  const StatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

/// Расширения для удобного создания статусов
extension StatusExtensions on String {
  /// Создает статус успеха
  Widget asSuccessStatus({
    StatusStyle style = StatusStyle.filled,
    StatusSize size = StatusSize.medium,
    IconData? icon,
    bool showIcon = true,
    VoidCallback? onTap,
  }) {
    return StatusIndicator.success(
      this,
      style: style,
      size: size,
      icon: icon,
      showIcon: showIcon,
      onTap: onTap,
    );
  }

  /// Создает статус ошибки
  Widget asErrorStatus({
    StatusStyle style = StatusStyle.filled,
    StatusSize size = StatusSize.medium,
    IconData? icon,
    bool showIcon = true,
    VoidCallback? onTap,
  }) {
    return StatusIndicator.error(
      this,
      style: style,
      size: size,
      icon: icon,
      showIcon: showIcon,
      onTap: onTap,
    );
  }

  /// Создает статус предупреждения
  Widget asWarningStatus({
    StatusStyle style = StatusStyle.filled,
    StatusSize size = StatusSize.medium,
    IconData? icon,
    bool showIcon = true,
    VoidCallback? onTap,
  }) {
    return StatusIndicator.warning(
      this,
      style: style,
      size: size,
      icon: icon,
      showIcon: showIcon,
      onTap: onTap,
    );
  }

  /// Создает информационный статус
  Widget asInfoStatus({
    StatusStyle style = StatusStyle.filled,
    StatusSize size = StatusSize.medium,
    IconData? icon,
    bool showIcon = true,
    VoidCallback? onTap,
  }) {
    return StatusIndicator.info(
      this,
      style: style,
      size: size,
      icon: icon,
      showIcon: showIcon,
      onTap: onTap,
    );
  }
}