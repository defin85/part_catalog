import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Заголовки различных уровней с адаптивной типографикой
class Heading extends StatelessWidget {
  final String text;
  final HeadingLevel level;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool adaptive;
  final FontWeight? fontWeight;

  const Heading(
    this.text, {
    super.key,
    this.level = HeadingLevel.h1,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  });

  const Heading.h1(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h1;

  const Heading.h2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h2;

  const Heading.h3(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h3;

  const Heading.h4(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h4;

  const Heading.h5(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h5;

  const Heading.h6(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = true,
    this.fontWeight,
  }) : level = HeadingLevel.h6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = _getBaseStyle(theme);
    final adaptiveStyle = adaptive ? _getAdaptiveStyle(context, baseStyle) : baseStyle;

    return Text(
      text,
      style: adaptiveStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? _getBaseStyle(ThemeData theme) {
    switch (level) {
      case HeadingLevel.h1:
        return theme.textTheme.displayLarge;
      case HeadingLevel.h2:
        return theme.textTheme.displayMedium;
      case HeadingLevel.h3:
        return theme.textTheme.displaySmall;
      case HeadingLevel.h4:
        return theme.textTheme.headlineLarge;
      case HeadingLevel.h5:
        return theme.textTheme.headlineMedium;
      case HeadingLevel.h6:
        return theme.textTheme.headlineSmall;
    }
  }

  TextStyle? _getAdaptiveStyle(BuildContext context, TextStyle? baseStyle) {
    if (baseStyle == null) return null;

    // Адаптивный размер шрифта в зависимости от размера экрана
    double scaleFactor = 1.0;

    if (AppBreakpoints.isMobile(context)) {
      scaleFactor = 0.9; // Меньше на мобильных
    } else if (AppBreakpoints.isDesktop(context)) {
      scaleFactor = 1.1; // Больше на десктопе
    }
    // Планшеты используют базовый размер (scaleFactor = 1.0)

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 16) * scaleFactor,
    );
  }
}

/// Уровни заголовков
enum HeadingLevel {
  h1, // Самый крупный заголовок
  h2, // Заголовок секции
  h3, // Подзаголовок
  h4, // Заголовок карточки
  h5, // Заголовок поля
  h6, // Мелкий заголовок
}

/// Расширения для строк для удобного создания заголовков
extension HeadingExtensions on String {
  /// Создает заголовок H1
  Widget asH1({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h1(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }

  /// Создает заголовок H2
  Widget asH2({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h2(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }

  /// Создает заголовок H3
  Widget asH3({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h3(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }

  /// Создает заголовок H4
  Widget asH4({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h4(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }

  /// Создает заголовок H5
  Widget asH5({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h5(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }

  /// Создает заголовок H6
  Widget asH6({
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool adaptive = true,
    FontWeight? fontWeight,
  }) {
    return Heading.h6(
      this,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      adaptive: adaptive,
      fontWeight: fontWeight,
    );
  }
}