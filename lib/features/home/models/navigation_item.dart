import 'package:flutter/material.dart';

/// Модель, объединяющая экран и его метаданные для навигации
class NavigationItem {
  /// Экран для отображения
  final Widget screen;

  /// Иконка для элемента навигации
  final IconData icon;

  /// Функция для получения заголовка с учетом локализации
  final String? Function(BuildContext) titleGetter;

  const NavigationItem({
    required this.screen,
    required this.icon,
    required this.titleGetter,
  });
}
