import 'package:flutter/material.dart';

/// Централизованная типографика приложения
/// Основана на Material Design 3 типографической системе
class AppTypography {
  AppTypography._();

  // =======================
  // ОСНОВНЫЕ ШРИФТЫ
  // =======================

  /// Основное семейство шрифтов
  static const String primaryFontFamily = 'Roboto';

  /// Моноширинное семейство шрифтов (для кода, номеров)
  static const String monospaceFontFamily = 'Roboto Mono';

  // =======================
  // DISPLAY СТИЛИ (Большие заголовки)
  // =======================

  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 57,
    height: 1.12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 45,
    height: 1.16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 36,
    height: 1.22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // =======================
  // HEADLINE СТИЛИ (Заголовки)
  // =======================

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    height: 1.29,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // =======================
  // TITLE СТИЛИ (Заголовки разделов)
  // =======================

  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // =======================
  // LABEL СТИЛИ (Метки, кнопки)
  // =======================

  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    height: 1.45,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // =======================
  // BODY СТИЛИ (Основной текст)
  // =======================

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // =======================
  // СПЕЦИАЛЬНЫЕ СТИЛИ
  // =======================

  /// Стиль для кода и моноширинного текста
  static const TextStyle code = TextStyle(
    fontFamily: monospaceFontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Стиль для номеров (VIN, номера запчастей)
  static const TextStyle number = TextStyle(
    fontFamily: monospaceFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Стиль для цен и валют
  static const TextStyle price = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  /// Стиль для статусных индикаторов
  static const TextStyle status = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Стиль для подсказок и placeholder
  static const TextStyle hint = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  /// Стиль для ошибок
  static const TextStyle error = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // =======================
  // СПЕЦИФИЧНЫЕ СТИЛИ ДЛЯ ПРИЛОЖЕНИЯ
  // =======================

  /// Стиль для имен клиентов
  static const TextStyle clientName = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  /// Стиль для марок и моделей автомобилей
  static const TextStyle vehicleName = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Стиль для номеров заказов
  static const TextStyle orderNumber = TextStyle(
    fontFamily: monospaceFontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Стиль для названий запчастей
  static const TextStyle partName = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 15,
    height: 1.47,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  /// Стиль для артикулов запчастей
  static const TextStyle partCode = TextStyle(
    fontFamily: monospaceFontFamily,
    fontSize: 13,
    height: 1.38,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );

  // =======================
  // УТИЛИТАРНЫЕ МЕТОДЫ
  // =======================

  /// Создать TextTheme для приложения
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );

  /// Получить стиль с определенным цветом
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Получить стиль с определенным весом
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Получить стиль с определенным размером
  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }

  /// Получить жирный стиль
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.bold);
  }

  /// Получить курсивный стиль
  static TextStyle italic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }

  /// Получить подчеркнутый стиль
  static TextStyle underlined(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.underline);
  }

  /// Получить зачеркнутый стиль
  static TextStyle strikethrough(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.lineThrough);
  }

  /// Получить стиль для определенного состояния
  static TextStyle getStateStyle(String state) {
    switch (state.toLowerCase()) {
      case 'success':
        return status.copyWith(color: const Color(0xFF4CAF50));
      case 'warning':
        return status.copyWith(color: const Color(0xFFFF9800));
      case 'error':
        return status.copyWith(color: const Color(0xFFF44336));
      case 'info':
        return status.copyWith(color: const Color(0xFF2196F3));
      default:
        return status;
    }
  }

  /// Адаптивные размеры для разных экранов
  static double getAdaptiveSize({
    required double mobile,
    required double tablet,
    required double desktop,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return mobile;
    } else if (width < 1200) {
      return tablet;
    } else {
      return desktop;
    }
  }
}