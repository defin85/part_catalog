import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:part_catalog/core/ui/atoms/inputs/text_input.dart';

/// Поле выбора даты с унифицированным дизайном
class DatePickerInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final bool enabled;
  final InputSize size;
  final Widget? prefixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final DatePickerMode mode;
  final String? Function(DateTime?)? validator;
  final bool showClearButton;

  const DatePickerInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.size = InputSize.medium,
    this.prefixIcon,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.mode = DatePickerMode.date,
    this.validator,
    this.showClearButton = true,
  });

  /// Создает поле для выбора только даты
  const DatePickerInput.dateOnly({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.size = InputSize.medium,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.showClearButton = true,
  })  : prefixIcon = const Icon(Icons.calendar_today),
        dateFormat = null,
        mode = DatePickerMode.date;

  /// Создает поле для выбора времени
  const DatePickerInput.timeOnly({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.size = InputSize.medium,
    this.validator,
    this.showClearButton = true,
  })  : prefixIcon = const Icon(Icons.access_time),
        firstDate = null,
        lastDate = null,
        dateFormat = null,
        mode = DatePickerMode.time;

  /// Создает поле для выбора даты и времени
  const DatePickerInput.dateTime({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.size = InputSize.medium,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.showClearButton = true,
  })  : prefixIcon = const Icon(Icons.event),
        dateFormat = null,
        mode = DatePickerMode.dateTime;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: _formatDate(context),
    );

    return TextInput(
      label: label,
      hint: hint ?? _getDefaultHint(),
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      onTap: enabled ? () => _showPicker(context) : null,
      readOnly: true,
      enabled: enabled,
      size: size,
      prefixIcon: prefixIcon ?? _getDefaultIcon(),
      suffixIcon: _buildSuffixIcon(context),
      validator: validator != null ? (text) => validator!(value) : null,
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (!enabled || (!showClearButton && value == null)) {
      return null;
    }

    if (showClearButton && value != null) {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => onChanged?.call(null),
        tooltip: 'Очистить',
      );
    }

    return const Icon(Icons.keyboard_arrow_down);
  }

  Widget _getDefaultIcon() {
    switch (mode) {
      case DatePickerMode.date:
        return const Icon(Icons.calendar_today);
      case DatePickerMode.time:
        return const Icon(Icons.access_time);
      case DatePickerMode.dateTime:
        return const Icon(Icons.event);
    }
  }

  String _getDefaultHint() {
    switch (mode) {
      case DatePickerMode.date:
        return 'Выберите дату';
      case DatePickerMode.time:
        return 'Выберите время';
      case DatePickerMode.dateTime:
        return 'Выберите дату и время';
    }
  }

  String _formatDate(BuildContext context) {
    if (value == null) return '';

    final format = dateFormat ?? _getDefaultDateFormat();
    return format.format(value!);
  }

  DateFormat _getDefaultDateFormat() {
    switch (mode) {
      case DatePickerMode.date:
        return DateFormat('dd.MM.yyyy');
      case DatePickerMode.time:
        return DateFormat('HH:mm');
      case DatePickerMode.dateTime:
        return DateFormat('dd.MM.yyyy HH:mm');
    }
  }

  Future<void> _showPicker(BuildContext context) async {
    DateTime? selectedDate = value ?? DateTime.now();
    TimeOfDay? selectedTime = value != null
        ? TimeOfDay.fromDateTime(value!)
        : TimeOfDay.now();

    switch (mode) {
      case DatePickerMode.date:
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          onChanged?.call(pickedDate);
        }
        break;

      case DatePickerMode.time:
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          final now = DateTime.now();
          final dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          onChanged?.call(dateTime);
        }
        break;

      case DatePickerMode.dateTime:
        // Сначала выбираем дату
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          // Затем выбираем время
          if (context.mounted) {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              final dateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              onChanged?.call(dateTime);
            }
          }
        }
        break;
    }
  }
}

/// Режимы выбора даты
enum DatePickerMode {
  date,     // Только дата
  time,     // Только время
  dateTime, // Дата и время
}

/// Расширения для удобной работы с датами
extension DateTimeExtensions on DateTime {
  /// Возвращает дату без времени (00:00:00)
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// Возвращает время как Duration от начала дня
  Duration get timeOfDay {
    return Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
      milliseconds: millisecond,
    );
  }

  /// Объединяет дату с новым временем
  DateTime withTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  /// Проверяет, является ли дата сегодняшней
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Проверяет, является ли дата вчерашней
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
           month == yesterday.month &&
           day == yesterday.day;
  }

  /// Проверяет, является ли дата завтрашней
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
           month == tomorrow.month &&
           day == tomorrow.day;
  }
}