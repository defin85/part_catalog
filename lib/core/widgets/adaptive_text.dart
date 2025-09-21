import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Режим масштабирования текста
enum TextScalingMode {
  /// Фиксированные размеры для каждого breakpoint
  fixed,
  /// Пропорциональное масштабирование от базового размера
  proportional,
  /// Автоматическое масштабирование по содержимому
  automatic,
  /// Масштабирование по системным настройкам accessibility
  accessibility,
}

/// Стиль текста для разных типов содержимого
enum AdaptiveTextStyle {
  /// Заголовок страницы
  headline,
  /// Подзаголовок
  subheadline,
  /// Основной текст
  body,
  /// Второстепенный текст
  bodySecondary,
  /// Подпись или мелкий текст
  caption,
  /// Текст кнопок
  button,
  /// Текст ярлыков
  label,
  /// Кастомный стиль
  custom,
}

/// Конфигурация для адаптивного текста
class AdaptiveTextConfig {
  /// Базовый размер шрифта
  final double? baseSize;

  /// Размеры для разных экранов
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  /// Множители масштабирования
  final double? mobileScale;
  final double? tabletScale;
  final double? desktopScale;

  /// Ограничения размеров
  final double? minSize;
  final double? maxSize;

  /// Параметры автоматического масштабирования
  final bool adaptToWidth;
  final bool adaptToHeight;
  final int? maxLines;
  final double? minFontScale;
  final double? maxFontScale;

  const AdaptiveTextConfig({
    this.baseSize,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.mobileScale,
    this.tabletScale,
    this.desktopScale,
    this.minSize,
    this.maxSize,
    this.adaptToWidth = false,
    this.adaptToHeight = false,
    this.maxLines,
    this.minFontScale = 0.8,
    this.maxFontScale = 1.5,
  });

  /// Предустановленные конфигурации
  static const AdaptiveTextConfig headline = AdaptiveTextConfig(
    mobileSize: 24,
    tabletSize: 28,
    desktopSize: 32,
    minSize: 20,
    maxSize: 40,
  );

  static const AdaptiveTextConfig subheadline = AdaptiveTextConfig(
    mobileSize: 18,
    tabletSize: 20,
    desktopSize: 24,
    minSize: 16,
    maxSize: 28,
  );

  static const AdaptiveTextConfig body = AdaptiveTextConfig(
    mobileSize: 14,
    tabletSize: 15,
    desktopSize: 16,
    minSize: 12,
    maxSize: 18,
  );

  static const AdaptiveTextConfig bodySecondary = AdaptiveTextConfig(
    mobileSize: 12,
    tabletSize: 13,
    desktopSize: 14,
    minSize: 10,
    maxSize: 16,
  );

  static const AdaptiveTextConfig caption = AdaptiveTextConfig(
    mobileSize: 10,
    tabletSize: 11,
    desktopSize: 12,
    minSize: 9,
    maxSize: 14,
  );

  static const AdaptiveTextConfig button = AdaptiveTextConfig(
    mobileSize: 14,
    tabletSize: 15,
    desktopSize: 16,
    minSize: 12,
    maxSize: 18,
  );

  static const AdaptiveTextConfig label = AdaptiveTextConfig(
    mobileSize: 12,
    tabletSize: 13,
    desktopSize: 14,
    minSize: 10,
    maxSize: 16,
  );
}

/// Адаптивный текст с автоматическим масштабированием
class AdaptiveText extends StatelessWidget {
  final String text;
  final AdaptiveTextStyle textStyle;
  final TextScalingMode scalingMode;
  final AdaptiveTextConfig? config;
  final TextStyle? customStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;

  const AdaptiveText(
    this.text, {
    super.key,
    this.textStyle = AdaptiveTextStyle.body,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
  });

  /// Конструктор для заголовков
  const AdaptiveText.headline(
    this.text, {
    super.key,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.maxLines,
  }) : textStyle = AdaptiveTextStyle.headline,
       textDirection = null,
       locale = null,
       softWrap = null,
       overflow = null,
       semanticsLabel = null,
       textWidthBasis = null,
       textHeightBehavior = null,
       fontStyle = null,
       letterSpacing = null,
       wordSpacing = null,
       height = null;

  /// Конструктор для подзаголовков
  const AdaptiveText.subheadline(
    this.text, {
    super.key,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.maxLines,
  }) : textStyle = AdaptiveTextStyle.subheadline,
       textDirection = null,
       locale = null,
       softWrap = null,
       overflow = null,
       semanticsLabel = null,
       textWidthBasis = null,
       textHeightBehavior = null,
       fontStyle = null,
       letterSpacing = null,
       wordSpacing = null,
       height = null;

  /// Конструктор для основного текста
  const AdaptiveText.body(
    this.text, {
    super.key,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
  }) : textStyle = AdaptiveTextStyle.body,
       textDirection = null,
       locale = null,
       softWrap = null,
       semanticsLabel = null,
       textWidthBasis = null,
       textHeightBehavior = null,
       fontStyle = null,
       letterSpacing = null,
       wordSpacing = null,
       height = null;

  /// Конструктор для второстепенного текста
  const AdaptiveText.bodySecondary(
    this.text, {
    super.key,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
  }) : textStyle = AdaptiveTextStyle.bodySecondary,
       textDirection = null,
       locale = null,
       softWrap = null,
       semanticsLabel = null,
       textWidthBasis = null,
       textHeightBehavior = null,
       fontStyle = null,
       letterSpacing = null,
       wordSpacing = null,
       height = null;

  /// Конструктор для подписей
  const AdaptiveText.caption(
    this.text, {
    super.key,
    this.scalingMode = TextScalingMode.fixed,
    this.config,
    this.customStyle,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
  }) : textStyle = AdaptiveTextStyle.caption,
       textDirection = null,
       locale = null,
       softWrap = null,
       semanticsLabel = null,
       textWidthBasis = null,
       textHeightBehavior = null,
       fontStyle = null,
       letterSpacing = null,
       wordSpacing = null,
       height = null;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildText(context, constraints, ScreenSize.small),
      medium: (context, constraints) => _buildText(context, constraints, ScreenSize.medium),
      large: (context, constraints) => _buildText(context, constraints, ScreenSize.large),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  Widget _buildText(BuildContext context, BoxConstraints constraints, ScreenSize screenSize) {
    final effectiveConfig = config ?? _getDefaultConfig();
    final calculatedSize = _calculateFontSize(context, constraints, screenSize, effectiveConfig);
    final effectiveStyle = _buildTextStyle(context, calculatedSize);

    switch (scalingMode) {
      case TextScalingMode.automatic:
        return _buildAutoFitText(effectiveStyle, constraints, effectiveConfig);
      case TextScalingMode.accessibility:
        return _buildAccessibilityText(context, effectiveStyle);
      default:
        return _buildRegularText(effectiveStyle);
    }
  }

  Widget _buildRegularText(TextStyle style) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  Widget _buildAutoFitText(TextStyle style, BoxConstraints constraints, AdaptiveTextConfig config) {
    return LayoutBuilder(
      builder: (context, localConstraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: textDirection ?? TextDirection.ltr,
          maxLines: maxLines,
        );

        textPainter.layout(maxWidth: localConstraints.maxWidth);

        double scaleFactor = 1.0;
        if (config.adaptToWidth && textPainter.width > localConstraints.maxWidth) {
          scaleFactor = localConstraints.maxWidth / textPainter.width;
        }
        if (config.adaptToHeight &&
            localConstraints.maxHeight.isFinite &&
            textPainter.height > localConstraints.maxHeight) {
          final heightScaleFactor = localConstraints.maxHeight / textPainter.height;
          scaleFactor = scaleFactor.clamp(0.0, heightScaleFactor);
        }

        // Применяем ограничения масштабирования
        scaleFactor = scaleFactor.clamp(
          config.minFontScale ?? 0.8,
          config.maxFontScale ?? 1.5,
        );

        final adjustedStyle = style.copyWith(
          fontSize: (style.fontSize ?? 16) * scaleFactor,
        );

        return Text(
          text,
          style: adjustedStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
        );
      },
    );
  }

  Widget _buildAccessibilityText(BuildContext context, TextStyle style) {
    final mediaQuery = MediaQuery.of(context);
    final accessibilityScale = mediaQuery.textScaler.scale(1.0);

    final adjustedStyle = style.copyWith(
      fontSize: (style.fontSize ?? 16) * accessibilityScale,
    );

    return Text(
      text,
      style: adjustedStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  double _calculateFontSize(
    BuildContext context,
    BoxConstraints constraints,
    ScreenSize screenSize,
    AdaptiveTextConfig config
  ) {
    double? fontSize;

    switch (scalingMode) {
      case TextScalingMode.fixed:
        fontSize = _getFixedFontSize(screenSize, config);
        break;
      case TextScalingMode.proportional:
        fontSize = _getProportionalFontSize(constraints, screenSize, config);
        break;
      case TextScalingMode.automatic:
      case TextScalingMode.accessibility:
        fontSize = _getFixedFontSize(screenSize, config);
        break;
    }

    // Применяем ограничения
    if (config.minSize != null) fontSize = fontSize.clamp(config.minSize!, double.infinity);
    if (config.maxSize != null) fontSize = fontSize.clamp(0, config.maxSize!);

    return fontSize;
  }

  double _getFixedFontSize(ScreenSize screenSize, AdaptiveTextConfig config) {
    switch (screenSize) {
      case ScreenSize.small:
        return config.mobileSize ?? config.baseSize ?? 14;
      case ScreenSize.medium:
        return config.tabletSize ?? config.mobileSize ?? config.baseSize ?? 15;
      case ScreenSize.large:
        return config.desktopSize ?? config.tabletSize ?? config.mobileSize ?? config.baseSize ?? 16;
    }
  }

  double _getProportionalFontSize(
    BoxConstraints constraints,
    ScreenSize screenSize,
    AdaptiveTextConfig config
  ) {
    final baseSize = config.baseSize ?? _getFixedFontSize(screenSize, config);
    double scale = 1.0;

    switch (screenSize) {
      case ScreenSize.small:
        scale = config.mobileScale ?? 1.0;
        break;
      case ScreenSize.medium:
        scale = config.tabletScale ?? config.mobileScale ?? 1.1;
        break;
      case ScreenSize.large:
        scale = config.desktopScale ?? config.tabletScale ?? config.mobileScale ?? 1.2;
        break;
    }

    return baseSize * scale;
  }

  TextStyle _buildTextStyle(BuildContext context, double fontSize) {
    final theme = Theme.of(context);
    TextStyle baseStyle;

    switch (textStyle) {
      case AdaptiveTextStyle.headline:
        baseStyle = theme.textTheme.headlineMedium ?? const TextStyle();
        break;
      case AdaptiveTextStyle.subheadline:
        baseStyle = theme.textTheme.headlineSmall ?? const TextStyle();
        break;
      case AdaptiveTextStyle.body:
        baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();
        break;
      case AdaptiveTextStyle.bodySecondary:
        baseStyle = theme.textTheme.bodySmall ?? const TextStyle();
        break;
      case AdaptiveTextStyle.caption:
        baseStyle = theme.textTheme.labelSmall ?? const TextStyle();
        break;
      case AdaptiveTextStyle.button:
        baseStyle = theme.textTheme.labelLarge ?? const TextStyle();
        break;
      case AdaptiveTextStyle.label:
        baseStyle = theme.textTheme.labelMedium ?? const TextStyle();
        break;
      case AdaptiveTextStyle.custom:
        baseStyle = customStyle ?? const TextStyle();
        break;
    }

    return baseStyle.copyWith(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
    );
  }

  AdaptiveTextConfig _getDefaultConfig() {
    switch (textStyle) {
      case AdaptiveTextStyle.headline:
        return AdaptiveTextConfig.headline;
      case AdaptiveTextStyle.subheadline:
        return AdaptiveTextConfig.subheadline;
      case AdaptiveTextStyle.body:
        return AdaptiveTextConfig.body;
      case AdaptiveTextStyle.bodySecondary:
        return AdaptiveTextConfig.bodySecondary;
      case AdaptiveTextStyle.caption:
        return AdaptiveTextConfig.caption;
      case AdaptiveTextStyle.button:
        return AdaptiveTextConfig.button;
      case AdaptiveTextStyle.label:
        return AdaptiveTextConfig.label;
      case AdaptiveTextStyle.custom:
        return const AdaptiveTextConfig();
    }
  }
}

/// Расширения для удобного использования
extension AdaptiveTextExtensions on String {
  /// Создает адаптивный заголовок
  Widget asAdaptiveHeadline({
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight = FontWeight.bold,
    int? maxLines,
  }) {
    return AdaptiveText.headline(
      this,
      textAlign: textAlign,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
    );
  }

  /// Создает адаптивный подзаголовок
  Widget asAdaptiveSubheadline({
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight = FontWeight.w600,
    int? maxLines,
  }) {
    return AdaptiveText.subheadline(
      this,
      textAlign: textAlign,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
    );
  }

  /// Создает адаптивный основной текст
  Widget asAdaptiveBody({
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AdaptiveText.body(
      this,
      textAlign: textAlign,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Создает адаптивный второстепенный текст
  Widget asAdaptiveBodySecondary({
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AdaptiveText.bodySecondary(
      this,
      textAlign: textAlign,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Создает адаптивную подпись
  Widget asAdaptiveCaption({
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AdaptiveText.caption(
      this,
      textAlign: textAlign,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}