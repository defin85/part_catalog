import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Запись журнала регистрации (аналог 1С), хранится в памяти.
class LogRecord {
  final DateTime time;
  final Level level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final String? tag; // источник/тег (опционально)

  LogRecord({
    required this.time,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.tag,
  });
}

/// Кольцевой буфер логов с уведомлением слушателей.
class AppLogStore extends ChangeNotifier {
  AppLogStore({this.capacity = 2000});

  final int capacity;
  final List<LogRecord> _records = <LogRecord>[];
  bool _paused = false;
  bool _dirty = false;
  bool _notifyScheduled = false;

  List<LogRecord> get records => List.unmodifiable(_records);
  bool get paused => _paused;

  void add(LogRecord record) {
    if (_paused) return;
    _records.add(record);
    if (_records.length > capacity) {
      final overflow = _records.length - capacity;
      _records.removeRange(0, overflow);
    }
    _scheduleNotify();
  }

  void clear() {
    _records.clear();
    _scheduleNotify();
  }

  void setPaused(bool value) {
    _paused = value;
    _scheduleNotify();
  }

  void _scheduleNotify() {
    _dirty = true;
    if (_notifyScheduled) return;
    _notifyScheduled = true;
    // Оповещаем в микрозадаче, когда текущий build закончен,
    // чтобы не нарушать правило Riverpod «не модифицировать провайдер при инициализации».
    scheduleMicrotask(() {
      if (!_dirty) {
        _notifyScheduled = false;
        return;
      }
      _dirty = false;
      _notifyScheduled = false;
      notifyListeners();
    });
  }
}

/// Глобальный экземпляр стора для простого доступа/интеграции.
final AppLogStore appLogStore = AppLogStore();
