import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
// services.dart импортируется через material.dart

/// Улучшенные accessibility утилиты для адаптивного UI
class AccessibilityHelpers {
  /// Создает семантически правильный заголовок
  static Widget createHeading({
    required String text,
    required int level, // 1-6, как в HTML
    TextStyle? style,
    bool isLive = false,
  }) {
    return Semantics(
      header: true,
      sortKey: OrdinalSortKey(level.toDouble()),
      liveRegion: isLive,
      child: Text(
        text,
        style: style,
        semanticsLabel: 'Заголовок уровня $level: $text',
      ),
    );
  }

  /// Создает доступную кнопку с правильными семантиками
  static Widget createAccessibleButton({
    required String label,
    required VoidCallback? onPressed,
    String? hint,
    String? tooltip,
    Widget? icon,
    bool isPressed = false,
    bool isExpanded = false,
  }) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      hint: hint,
      onTap: onPressed,
      child: Tooltip(
        message: tooltip ?? label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon,
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Создает доступный текстовый input
  static Widget createAccessibleTextField({
    required String label,
    String? hint,
    String? errorText,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    final labelText = isRequired ? '$label *' : label;

    return Semantics(
      textField: true,
      label: labelText,
      hint: hint,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
          errorText: errorText,
          border: const OutlineInputBorder(),
          // Указываем required для screen readers
          suffixIcon: isRequired
              ? const Icon(Icons.star, size: 8, color: Colors.red)
              : null,
        ),
      ),
    );
  }

  /// Создает группу радио-кнопок с accessibility
  static Widget createAccessibleRadioGroup<T>({
    required String groupLabel,
    required List<T> values,
    required List<String> labels,
    required T? selectedValue,
    required ValueChanged<T?> onChanged,
    String? hint,
  }) {
    return Semantics(
      container: true,
      label: groupLabel,
      hint: hint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final label = labels[index];

            return Semantics(
              inMutuallyExclusiveGroup: true,
              checked: selectedValue == value,
              child: CheckboxListTile(
                title: Text(label),
                value: selectedValue == value,
                onChanged: (bool? checked) {
                  if (checked == true) {
                    onChanged(value);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Создает доступный чекбокс
  static Widget createAccessibleCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    String? hint,
    bool isRequired = false,
  }) {
    final labelText = isRequired ? '$label *' : label;

    return Semantics(
      checked: value,
      hint: hint,
      child: CheckboxListTile(
        title: Text(labelText),
        value: value,
        onChanged: onChanged,
        // semanticLabel убран для совместимости
      ),
    );
  }

  /// Создает доступный слайдер
  static Widget createAccessibleSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    int? divisions,
    String Function(double)? semanticFormatterCallback,
  }) {
    return Semantics(
      slider: true,
      label: label,
      // Убираем value, increasedValue, decreasedValue - они требуют String?
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            semanticFormatterCallback: semanticFormatterCallback,
          ),
        ],
      ),
    );
  }

  /// Создает доступную навигационную область
  static Widget createNavigationRegion({
    required String label,
    required List<Widget> children,
    String? hint,
  }) {
    return Semantics(
      container: true,
      label: 'Навигация: $label',
      hint: hint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// Создает область с live updates для screen readers
  static Widget createLiveRegion({
    required Widget child,
    bool isPolite = true,
    String? label,
  }) {
    return Semantics(
      liveRegion: true,
      // polite = false означает assertive mode
      child: Container(
        child: child,
      ),
    );
  }

  /// Создает доступный dropdown
  static Widget createAccessibleDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? hint,
    bool isRequired = false,
  }) {
    final labelText = isRequired ? '$label *' : label;

    return Semantics(
      button: true,
      hint: hint ?? 'Выберите значение из списка',
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
        items: items,
        onChanged: onChanged,
        hint: Text(hint ?? 'Выберите...'),
      ),
    );
  }

  /// Создает доступную карточку с правильной навигацией
  static Widget createAccessibleCard({
    required Widget child,
    VoidCallback? onTap,
    String? semanticLabel,
    String? hint,
    bool isSelected = false,
  }) {
    return Semantics(
      container: true,
      button: onTap != null,
      selected: isSelected,
      label: semanticLabel,
      hint: hint,
      onTap: onTap,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }

  /// Создает доступную таблицу
  static Widget createAccessibleTable({
    required String caption,
    required List<String> headers,
    required List<List<String>> rows,
    List<String>? rowHeaders,
  }) {
    return Semantics(
      container: true,
      label: 'Таблица: $caption',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(),
            children: [
              // Заголовки
              TableRow(
                children: headers.map((header) =>
                  Semantics(
                    header: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        header,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ).toList(),
              ),
              // Строки данных
              ...rows.asMap().entries.map((entry) {
                final row = entry.value;

                return TableRow(
                  children: row.asMap().entries.map((cellEntry) {
                    final cellIndex = cellEntry.key;
                    final cellData = cellEntry.value;

                    // Первая колонка может быть заголовком строки
                    final isRowHeader = cellIndex == 0 && rowHeaders != null;

                    return Semantics(
                      header: isRowHeader,
                      label: isRowHeader
                          ? 'Заголовок строки: $cellData'
                          : '${headers[cellIndex]}: $cellData',
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(cellData),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Утилита для фокуса на элементе
  static void focusOnElement(BuildContext context, FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  /// Утилита для объявления изменений screen reader'у
  static void announceChange(String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Проверяет, включены ли accessibility сервисы
  static bool isAccessibilityEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Получает текущий accessibility mode (заглушка для совместимости)
  static bool getAccessibilityFeatures(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }
}

/// Миксин для виджетов с accessibility поддержкой
mixin AccessibilityMixin {
  /// Объявляет изменение для screen readers
  void announceToScreenReader(String message) {
    AccessibilityHelpers.announceChange(message);
  }

  /// Фокусируется на элементе
  void focusElement(BuildContext context, FocusNode focusNode) {
    AccessibilityHelpers.focusOnElement(context, focusNode);
  }

  /// Проверяет accessibility settings
  bool isAccessibilityEnabled(BuildContext context) {
    return AccessibilityHelpers.isAccessibilityEnabled(context);
  }
}

/// Extension для удобной работы с accessibility
extension AccessibilityExtension on BuildContext {
  /// Объявляет сообщение для screen readers
  void announceAccessibilityChange(String message) {
    AccessibilityHelpers.announceChange(message);
  }

  /// Проверяет, включена ли accessibility навигация
  bool get isAccessibilityEnabled =>
      MediaQuery.of(this).accessibleNavigation;

  /// Проверяет accessibility features (упрощенная версия)
  bool get hasAccessibilityFeatures =>
      MediaQuery.of(this).accessibleNavigation;
}