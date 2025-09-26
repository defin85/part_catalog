import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/atoms/inputs/text_input.dart';

/// Выпадающий список (dropdown) с унифицированным дизайном
class DropdownInput<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final T? value;
  final List<DropdownInputItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final InputSize size;
  final Widget? prefixIcon;
  final bool isExpanded;
  final String? Function(T?)? validator;
  final int? maxLines;

  const DropdownInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.size = InputSize.medium,
    this.prefixIcon,
    this.isExpanded = true,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items.map((item) => item.toDropdownMenuItem()).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      style: _getTextStyle(context),
      decoration: _buildDecoration(context),
      icon: const Icon(Icons.keyboard_arrow_down),
      iconSize: _getIconSize(),
      menuMaxHeight: 300,
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: _getFillColor(colorScheme),
      contentPadding: _getContentPadding(),
      border: _getBorder(colorScheme),
      enabledBorder: _getBorder(colorScheme),
      focusedBorder: _getFocusedBorder(colorScheme),
      errorBorder: _getErrorBorder(colorScheme),
      focusedErrorBorder: _getErrorBorder(colorScheme),
      disabledBorder: _getDisabledBorder(colorScheme),
      helperStyle: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.error,
      ),
      labelStyle: theme.textTheme.bodyLarge?.copyWith(
        color: errorText != null
            ? colorScheme.error
            : colorScheme.onSurfaceVariant,
      ),
      hintStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    );
  }

  Color _getFillColor(ColorScheme colorScheme) {
    if (!enabled) {
      return colorScheme.surfaceContainerHighest.withValues(alpha: 0.12);
    }
    if (errorText != null) {
      return colorScheme.errorContainer.withValues(alpha: 0.08);
    }
    return colorScheme.surfaceContainerHighest;
  }

  OutlineInputBorder _getBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: enabled
            ? colorScheme.outline
            : colorScheme.outline.withValues(alpha: 0.12),
        width: 1,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: errorText != null ? colorScheme.error : colorScheme.primary,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _getDisabledBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: colorScheme.outline.withValues(alpha: 0.12),
        width: 1,
      ),
    );
  }

  EdgeInsets _getContentPadding() {
    switch (size) {
      case InputSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case InputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case InputSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        );
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    switch (size) {
      case InputSize.small:
        return theme.textTheme.bodySmall;
      case InputSize.medium:
        return theme.textTheme.bodyLarge;
      case InputSize.large:
        return theme.textTheme.headlineSmall;
    }
  }

  double _getIconSize() {
    switch (size) {
      case InputSize.small:
        return AppSizes.iconSm;
      case InputSize.medium:
        return AppSizes.iconMd;
      case InputSize.large:
        return AppSizes.iconLg;
    }
  }
}

/// Элемент выпадающего списка
class DropdownInputItem<T> {
  final T value;
  final String text;
  final Widget? icon;
  final bool enabled;
  final String? subtitle;

  const DropdownInputItem({
    required this.value,
    required this.text,
    this.icon,
    this.enabled = true,
    this.subtitle,
  });

  DropdownMenuItem<T> toDropdownMenuItem() {
    return DropdownMenuItem<T>(
      value: value,
      enabled: enabled,
      child: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Удобные конструкторы для создания элементов списка
extension DropdownInputItemExtensions on String {
  DropdownInputItem<String> asDropdownItem({
    Widget? icon,
    bool enabled = true,
    String? subtitle,
  }) {
    return DropdownInputItem<String>(
      value: this,
      text: this,
      icon: icon,
      enabled: enabled,
      subtitle: subtitle,
    );
  }
}