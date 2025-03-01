import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

/// {@template database_logger}
/// Декоратор QueryExecutor, который добавляет логирование SQL-запросов.
/// {@endtemplate}
class DatabaseLogger extends QueryExecutorUser {
  /// {@macro database_logger}
  DatabaseLogger(this.executor, this.logger, {required this.version});

  final Logger logger;
  final QueryExecutor executor;
  final int version;

  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      await executor.runCustom(statement,
          args ?? []); // Исправлено: добавлен дефолтный пустой список
      logger.d(
          'SQL [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''}');
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  Future<List<Map<String, Object?>>> runSelect(String statement,
      [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runSelect(statement, args ?? []); // Исправлено
      logger.d(
          'SQL [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> ${result.length} rows');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  @override
  int get schemaVersion => version;

  @override
  Future<void> beforeOpen(QueryExecutor user, OpeningDetails details) async {
    logger.i(
        'Opening database v${details.versionNow} (previous: ${details.versionBefore})');
    // Если executor реализует QueryExecutorUser, можно делегировать вызов:
    if (executor is QueryExecutorUser) {
      await (executor as QueryExecutorUser).beforeOpen(user, details);
    }
  }

  Future<int> runInsert(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runInsert(statement, args ?? []); // Исправлено
      logger.d(
          'SQL INSERT [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> ID: $result');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  Future<int> runUpdate(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runUpdate(statement, args ?? []); // Исправлено
      logger.d(
          'SQL UPDATE [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> $result rows affected');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }
}
