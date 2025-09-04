import 'package:logger/logger.dart';

import 'app_log_store.dart';

/// Выход `logger` в память: сохраняет события в [AppLogStore].
class InMemoryLogOutput extends LogOutput {
  final AppLogStore store;

  InMemoryLogOutput(this.store);

  @override
  void output(OutputEvent event) {
    final origin = event.origin; // LogEvent c подробностями
    store.add(
      LogRecord(
        time: DateTime.now(),
        level: origin.level,
        message: origin.message.toString(),
        error: origin.error,
        stackTrace: origin.stackTrace,
      ),
    );
  }
}
