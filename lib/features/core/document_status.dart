import 'package:flutter/material.dart';

/// Статус документа (enum)
enum DocumentStatus {
  draft('черновик', Colors.blueGrey),
  newDoc('новый', Colors.blue),
  posted('проведен', Colors.green),
  cancelled('отменен', Colors.red),
  // Добавляем статусы из старого OrderStatus для совместимости
  inProgress('в работе', Colors.orange),
  waitingForParts('ожидание запчастей', Colors.purple),
  readyForPickup('готов к выдаче', Colors.teal),
  completed('завершен', Colors.grey), // Используем цвет posted для завершенного
  unknown('неизвестен', Colors.grey); // Статус по умолчанию

  final String value;
  final Color color;

  const DocumentStatus(this.value, this.color);

  /// Отображаемое имя статуса (для UI)
  String get displayName {
    // Можно добавить логику для локализации, если потребуется
    // Например, используя context.t.documentStatus.newDoc и т.д.
    // Пока просто возвращаем value с заглавной буквы
    if (value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1);
  }

  /// Получить статус из строки
  static DocumentStatus fromString(String? value) {
    if (value == null) return DocumentStatus.unknown;
    final lowerValue = value.toLowerCase();
    for (final status in DocumentStatus.values) {
      if (status.value == lowerValue || status.name == lowerValue) {
        return status;
      }
    }
    // Дополнительные проверки для старых значений, если они отличаются
    switch (lowerValue) {
      case 'new':
        return DocumentStatus.newDoc;
      case 'in_progress':
        return DocumentStatus.inProgress;
      case 'waiting_for_parts':
        return DocumentStatus.waitingForParts;
      case 'ready_for_pickup':
        return DocumentStatus.readyForPickup;
      case 'черновик':
        return DocumentStatus.draft;
    }
    return DocumentStatus.unknown;
  }
}
