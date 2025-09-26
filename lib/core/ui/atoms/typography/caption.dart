import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Мелкий текст для подписей, меток и дополнительной информации
class Caption extends StatelessWidget {
  final String text;
  final CaptionVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool adaptive;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final double? height;
  final bool selectable;

  const Caption(
    this.text, {
    super.key,
    this.variant = CaptionVariant.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  });

  /// Создает обычную подпись
  const Caption.normal(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  }) : variant = CaptionVariant.normal;

  /// Создает подпись-этикетку
  const Caption.label(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  }) : variant = CaptionVariant.label;

  /// Создает подпись для ошибок
  const Caption.error(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  })  : color = null, // Будет использован errorColor
        variant = CaptionVariant.error;

  /// Создает подпись для успеха
  const Caption.success(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  })  : color = null, // Будет использован цвет успеха
        variant = CaptionVariant.success;

  /// Создает подпись для предупреждений
  const Caption.warning(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  })  : color = null, // Будет использован цвет предупреждения
        variant = CaptionVariant.warning;

  /// Создает приглушенную подпись
  const Caption.muted(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.decoration,
    this.height,
    this.selectable = false,
  })  : color = null, // Будет использован приглушенный цвет
        variant = CaptionVariant.muted;

  /// Создает подпись с жирным шрифтом
  const Caption.bold(
    this.text, {
    super.key,
    this.variant = CaptionVariant.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.decoration,
    this.height,
    this.selectable = false,
  }) : fontWeight = FontWeight.w600;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = _getBaseStyle(theme);
    final adaptiveStyle = adaptive ? _getAdaptiveStyle(context, baseStyle) : baseStyle;

    final finalStyle = adaptiveStyle?.copyWith(
      color: color ?? _getVariantColor(context),
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
    );

    if (selectable) {
      return SelectableText(
        text,
        style: finalStyle,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? _getBaseStyle(ThemeData theme) {
    switch (variant) {
      case CaptionVariant.label:
        return theme.textTheme.labelLarge;
      case CaptionVariant.normal:
      case CaptionVariant.error:
      case CaptionVariant.success:
      case CaptionVariant.warning:
      case CaptionVariant.muted:
        return theme.textTheme.labelMedium;
    }
  }

  Color? _getVariantColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CaptionVariant.normal:
      case CaptionVariant.label:
        return colorScheme.onSurfaceVariant;
      case CaptionVariant.error:
        return colorScheme.error;
      case CaptionVariant.success:
        return Colors.green.shade700;
      case CaptionVariant.warning:
        return Colors.orange.shade700;
      case CaptionVariant.muted:
        return colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    }
  }

  TextStyle? _getAdaptiveStyle(BuildContext context, TextStyle? baseStyle) {
    if (baseStyle == null) return null;

    // Адаптивный размер шрифта в зависимости от размера экрана
    double scaleFactor = 1.0;

    if (AppBreakpoints.isMobile(context)) {
      scaleFactor = 0.95; // Немного меньше на мобильных
    } else if (AppBreakpoints.isDesktop(context)) {
      scaleFactor = 1.05; // Немного больше на десктопе
    }

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 12) * scaleFactor,
    );
  }
}

/// Варианты подписей
enum CaptionVariant {
  normal,   // Обычная подпись
  label,    // Этикетка (немного крупнее)
  error,    // Ошибка (красный)
  success,  // Успех (зелёный)
  warning,  // Предупреждение (оранжевый)
  muted,    // Приглушенная (полупрозрачная)
}

/// Расширения для строк для удобного создания подписей
extension CaptionExtensions on String {
  /// Создает обычную подпись
  Widget asCaption({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.normal(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает подпись-этикетку
  Widget asLabel({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.label(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает подпись для ошибки
  Widget asErrorCaption({
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.error(
      this,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает подпись для успеха
  Widget asSuccessCaption({
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.success(
      this,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает подпись для предупреждения
  Widget asWarningCaption({
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.warning(
      this,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает приглушенную подпись
  Widget asMutedCaption({
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return Caption.muted(
      this,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }
}