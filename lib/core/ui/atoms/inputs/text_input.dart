import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Базовое текстовое поле ввода
/// Стандартизированное поле с поддержкой различных состояний и валидации
class TextInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final InputSize size;
  final String? Function(String?)? validator;
  final bool autofocus;

  const TextInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.size = InputSize.medium,
    this.validator,
    this.autofocus = false,
  });

  /// Создает поле для пароля
  const TextInput.password({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.size = InputSize.medium,
    this.validator,
    this.autofocus = false,
  })  : obscureText = true,
        keyboardType = TextInputType.visiblePassword,
        textCapitalization = TextCapitalization.none,
        maxLines = 1,
        minLines = null,
        prefixText = null,
        suffixText = null;

  /// Создает многострочное поле
  const TextInput.multiline({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.newline,
    this.textCapitalization = TextCapitalization.sentences,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.size = InputSize.medium,
    this.validator,
    this.autofocus = false,
  })  : obscureText = false,
        keyboardType = TextInputType.multiline,
        prefixText = null,
        suffixText = null;

  /// Создает поле для поиска
  const TextInput.search({
    super.key,
    this.hint = 'Поиск...',
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.search,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.suffixIcon,
    this.size = InputSize.medium,
    this.autofocus = false,
  })  : label = null,
        helperText = null,
        errorText = null,
        keyboardType = TextInputType.text,
        textCapitalization = TextCapitalization.none,
        obscureText = false,
        maxLines = 1,
        minLines = null,
        prefixIcon = const Icon(Icons.search),
        prefixText = null,
        suffixText = null,
        validator = null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? value : null,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      autofocus: autofocus,
      style: _getTextStyle(context),
      decoration: _buildDecoration(context),
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
      suffixIcon: suffixIcon,
      prefixText: prefixText,
      suffixText: suffixText,
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
}

/// Размеры полей ввода
enum InputSize {
  small,
  medium,
  large,
}