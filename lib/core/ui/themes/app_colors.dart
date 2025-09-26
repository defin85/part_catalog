import 'package:flutter/material.dart';

/// Централизованная палитра цветов приложения
/// Основана на Material Design 3 принципах
class AppColors {
  AppColors._();

  // =======================
  // ОСНОВНАЯ ПАЛИТРА
  // =======================

  /// Основной цвет приложения
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryContainer = Color(0xFFBBDEFB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0D47A1);

  /// Вторичный цвет
  static const Color secondary = Color(0xFF03A9F4);
  static const Color secondaryContainer = Color(0xFFE1F5FE);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF01579B);

  /// Третичный цвет
  static const Color tertiary = Color(0xFF4CAF50);
  static const Color tertiaryContainer = Color(0xFFE8F5E8);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF1B5E20);

  // =======================
  // ПОВЕРХНОСТИ И ФОНЫ
  // =======================

  /// Фоновые цвета для светлой темы
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);

  /// Фоновые цвета для темной темы
  static const Color surfaceDark = Color(0xFF1C1B1F);
  static const Color surfaceVariantDark = Color(0xFF49454F);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // =======================
  // СЛУЖЕБНЫЕ ЦВЕТА
  // =======================

  /// Цвета состояний
  static const Color success = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFE8F5E8);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF1B5E20);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color onWarningContainer = Color(0xFFE65100);

  static const Color error = Color(0xFFF44336);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFB71C1C);

  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color onInfoContainer = Color(0xFF0D47A1);

  // =======================
  // ГРАНИЦЫ И РАЗДЕЛИТЕЛИ
  // =======================

  /// Цвета границ
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2D2D2D);

  // =======================
  // СПЕЦИАЛЬНЫЕ ЦВЕТА
  // =======================

  /// Цвета для разных типов контента
  static const Color client = Color(0xFF2196F3);
  static const Color vehicle = Color(0xFF4CAF50);
  static const Color order = Color(0xFFFF9800);
  static const Color supplier = Color(0xFF9C27B0);
  static const Color part = Color(0xFF607D8B);

  /// Цвета приоритетов
  static const Color priorityHigh = Color(0xFFF44336);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityLow = Color(0xFF4CAF50);

  /// Цвета статусов заказов
  static const Color statusNew = Color(0xFF2196F3);
  static const Color statusInProgress = Color(0xFFFF9800);
  static const Color statusCompleted = Color(0xFF4CAF50);
  static const Color statusCancelled = Color(0xFFF44336);
  static const Color statusOnHold = Color(0xFF9E9E9E);

  // =======================
  // ГРАДИЕНТЫ
  // =======================

  /// Градиенты для специальных элементов
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // =======================
  // УТИЛИТАРНЫЕ МЕТОДЫ
  // =======================

  /// Получить цвет статуса по названию
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'новый':
        return statusNew;
      case 'inprogress':
      case 'в_работе':
        return statusInProgress;
      case 'completed':
      case 'завершен':
        return statusCompleted;
      case 'cancelled':
      case 'отменен':
        return statusCancelled;
      case 'onhold':
      case 'приостановлен':
        return statusOnHold;
      default:
        return info;
    }
  }

  /// Получить цвет приоритета
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'высокий':
        return priorityHigh;
      case 'medium':
      case 'средний':
        return priorityMedium;
      case 'low':
      case 'низкий':
        return priorityLow;
      default:
        return info;
    }
  }

  /// Получить контрастный цвет для текста
  static Color getContrastColor(Color backgroundColor) {
    // Используем алгоритм расчета яркости для определения контраста
    final brightness = ((backgroundColor.r * 255.0).round() * 299 +
        (backgroundColor.g * 255.0).round() * 587 +
        (backgroundColor.b * 255.0).round() * 114) / 1000;

    return brightness > 128 ? Colors.black : Colors.white;
  }

  /// Получить полупрозрачную версию цвета
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Создать ColorScheme для светлой темы
  static ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: primary,
    primaryContainer: primaryContainer,
    onPrimary: onPrimary,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    secondaryContainer: secondaryContainer,
    onSecondary: onSecondary,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiary: onTertiary,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    errorContainer: errorContainer,
    onError: onError,
    onErrorContainer: onErrorContainer,
    surface: surfaceLight,
    surfaceContainerHighest: surfaceVariantLight,
    onSurface: onSurfaceLight,
    onSurfaceVariant: onSurfaceVariantLight,
    outline: outline,
    outlineVariant: outlineVariant,
  );

  /// Создать ColorScheme для темной темы
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: primary,
    primaryContainer: Color(0xFF0D47A1),
    onPrimary: onPrimary,
    onPrimaryContainer: Color(0xFFBBDEFB),
    secondary: secondary,
    secondaryContainer: Color(0xFF01579B),
    onSecondary: onSecondary,
    onSecondaryContainer: Color(0xFFE1F5FE),
    tertiary: tertiary,
    tertiaryContainer: Color(0xFF1B5E20),
    onTertiary: onTertiary,
    onTertiaryContainer: Color(0xFFE8F5E8),
    error: error,
    errorContainer: Color(0xFFB71C1C),
    onError: onError,
    onErrorContainer: Color(0xFFFFEBEE),
    surface: surfaceDark,
    surfaceContainerHighest: surfaceVariantDark,
    onSurface: onSurfaceDark,
    onSurfaceVariant: onSurfaceVariantDark,
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
  );
}