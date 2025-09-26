import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Основной текст различных размеров с адаптивной типографикой
class BodyText extends StatelessWidget {
  final String text;
  final BodyTextSize size;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool adaptive;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final double? height;
  final bool selectable;

  const BodyText(
    this.text, {
    super.key,
    this.size = BodyTextSize.medium,
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

  const BodyText.large(
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
  }) : size = BodyTextSize.large;

  const BodyText.medium(
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
  }) : size = BodyTextSize.medium;

  const BodyText.small(
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
  }) : size = BodyTextSize.small;

  /// Создает выделенный/жирный текст
  const BodyText.bold(
    this.text, {
    super.key,
    this.size = BodyTextSize.medium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.decoration,
    this.height,
    this.selectable = false,
  }) : fontWeight = FontWeight.bold;

  /// Создает курсивный текст
  const BodyText.italic(
    this.text, {
    super.key,
    this.size = BodyTextSize.medium,
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

  /// Создает ссылку-подобный текст
  const BodyText.link(
    this.text, {
    super.key,
    this.size = BodyTextSize.medium,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.height,
    this.selectable = false,
  })  : color = null, // Будет использован цвет primary из темы
        decoration = TextDecoration.underline;

  /// Создает перечёркнутый текст
  const BodyText.strikethrough(
    this.text, {
    super.key,
    this.size = BodyTextSize.medium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
    this.height,
    this.selectable = false,
  }) : decoration = TextDecoration.lineThrough;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = _getBaseStyle(theme);
    final adaptiveStyle = adaptive ? _getAdaptiveStyle(context, baseStyle) : baseStyle;

    final finalStyle = adaptiveStyle?.copyWith(
      color: color ?? (decoration == TextDecoration.underline
          ? theme.colorScheme.primary
          : null),
      fontWeight: fontWeight,
      decoration: decoration,
      height: height,
      fontStyle: null,
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
    switch (size) {
      case BodyTextSize.large:
        return theme.textTheme.bodyLarge;
      case BodyTextSize.medium:
        return theme.textTheme.bodyMedium;
      case BodyTextSize.small:
        return theme.textTheme.bodySmall;
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
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }
}


/// Размеры основного текста
enum BodyTextSize {
  large,  // Крупный текст
  medium, // Обычный текст
  small,  // Мелкий текст
}

/// Расширения для строк для удобного создания текста
extension BodyTextExtensions on String {
  /// Создает крупный текст
  Widget asBodyLarge({
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
    return BodyText.large(
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

  /// Создает обычный текст
  Widget asBodyMedium({
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
    return BodyText.medium(
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

  /// Создает мелкий текст
  Widget asBodySmall({
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
    return BodyText.small(
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

  /// Создает жирный текст
  Widget asBold({
    BodyTextSize size = BodyTextSize.medium,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    TextDecoration? decoration,
    double? height,
    bool selectable = false,
  }) {
    return BodyText.bold(
      this,
      size: size,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      decoration: decoration,
      height: height,
      selectable: selectable,
    );
  }

  /// Создает ссылку-подобный текст
  Widget asLink({
    BodyTextSize size = BodyTextSize.medium,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
    double? height,
    bool selectable = false,
  }) {
    return BodyText.link(
      this,
      size: size,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
      height: height,
      selectable: selectable,
    );
  }
}