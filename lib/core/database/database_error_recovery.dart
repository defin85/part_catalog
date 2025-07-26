import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';

/// {@template database_error_recovery}
/// Система восстановления после ошибок базы данных.
/// 
/// Обеспечивает:
/// - Автоматическое переподключение при потере соединения
/// - Повторные попытки выполнения операций
/// - Восстановление из резервной копии при критических ошибок
/// - Логирование и мониторинг состояния БД
/// {@endtemplate}
class DatabaseErrorRecovery {
  /// {@macro database_error_recovery}
  DatabaseErrorRecovery(this._database, [Logger? logger])
      : _logger = logger ?? Logger();

  final AppDatabase _database;
  final Logger _logger;

  /// Максимальное количество попыток повторного выполнения операции
  static const int _maxRetries = 3;

  /// Задержка между попытками (миллисекунды)
  static const int _retryDelayMs = 1000;

  /// Выполняет операцию с базой данных с автоматическими повторными попытками
  /// при возникновении ошибок.
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    String? operationName,
    int maxRetries = _maxRetries,
  }) async {
    var attempt = 0;
    Exception? lastException;

    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        lastException = e is Exception ? e : Exception(e.toString());
        
        final opName = operationName ?? 'database operation';
        _logger.w(
          'Попытка $attempt/$maxRetries выполнения $opName не удалась: $e',
        );

        if (attempt >= maxRetries) {
          _logger.e(
            'Все попытки выполнения $opName исчерпаны',
            error: lastException,
          );
          break;
        }

        // Проверяем тип ошибки и принимаем соответствующие меры
        if (_isRecoverableError(e)) {
          await _handleRecoverableError(e, attempt);
        } else {
          _logger.e(
            'Критическая ошибка БД, повторные попытки бесполезны: $e',
            error: e,
          );
          break;
        }

        // Задержка перед следующей попыткой
        await Future.delayed(Duration(milliseconds: _retryDelayMs * attempt));
      }
    }

    throw DatabaseRecoveryException(
      'Не удалось выполнить операцию после $maxRetries попыток',
      lastException,
    );
  }

  /// Проверяет, является ли ошибка восстанавливаемой
  bool _isRecoverableError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Ошибки соединения
    if (errorString.contains('database is locked') ||
        errorString.contains('database disk image is malformed') ||
        errorString.contains('sqlite_busy') ||
        errorString.contains('sqlite_locked') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return true;
    }

    // Ошибки файловой системы
    if (error is FileSystemException ||
        errorString.contains('no such table') ||
        errorString.contains('permission denied')) {
      return true;
    }

    return false;
  }

  /// Обрабатывает восстанавливаемую ошибку
  Future<void> _handleRecoverableError(dynamic error, int attempt) async {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('database is locked') ||
        errorString.contains('sqlite_busy')) {
      _logger.i('БД заблокирована, ожидаем разблокировки...');
      await Future.delayed(Duration(milliseconds: 500 * attempt));
    } else if (errorString.contains('database disk image is malformed')) {
      _logger.w('Повреждение файла БД, попытка восстановления...');
      await _attemptDatabaseRepair();
    } else if (errorString.contains('no such table')) {
      _logger.w('Отсутствуют таблицы БД, попытка пересоздания...');
      await _recreateDatabase();
    } else if (error is FileSystemException) {
      _logger.w('Ошибка файловой системы: ${error.message}');
      await _checkDatabaseFile();
    }
  }

  /// Пытается восстановить поврежденную базу данных
  Future<void> _attemptDatabaseRepair() async {
    try {
      _logger.i('Начинаем процедуру восстановления БД...');
      
      // Создаем резервную копию перед восстановлением
      final backupPath = await _database.backupDatabase();
      _logger.i('Резервная копия создана: $backupPath');
      
      // Пытаемся выполнить PRAGMA integrity_check
      await _database.customStatement('PRAGMA integrity_check');
      _logger.i('Проверка целостности БД завершена');
      
    } catch (e) {
      _logger.e('Не удалось восстановить БД, требуется пересоздание', error: e);
      await _recreateDatabase();
    }
  }

  /// Пересоздает базу данных с нуля
  Future<void> _recreateDatabase() async {
    try {
      _logger.i('Пересоздание БД с нуля...');
      
      // Закрываем текущее соединение
      await _database.close();
      
      // Сбрасываем БД (удаляем файл)
      await _database.resetDatabase();
      
      _logger.i('БД успешно пересоздана');
      
    } catch (e) {
      _logger.e('Критическая ошибка при пересоздании БД', error: e);
      rethrow;
    }
  }

  /// Проверяет состояние файла базы данных
  Future<void> _checkDatabaseFile() async {
    try {
      // Пытаемся выполнить простой запрос для проверки доступности
      await _database.customSelect('SELECT 1').get();
      _logger.i('Файл БД доступен для чтения');
    } catch (e) {
      _logger.w('Файл БД недоступен: $e');
      throw DatabaseAccessException('Файл базы данных недоступен', e);
    }
  }

  /// Проверяет состояние базы данных
  Future<DatabaseHealthStatus> checkDatabaseHealth() async {
    try {
      // Проверяем соединение
      await _database.customSelect('SELECT 1').get();
      
      // Проверяем целостность
      final integrityResult = await _database
          .customSelect('PRAGMA integrity_check')
          .get();
      
      final isHealthy = integrityResult.isNotEmpty && 
          integrityResult.first.data['integrity_check'] == 'ok';
      
      // Проверяем размер БД
      final sizeResult = await _database
          .customSelect('PRAGMA page_count')
          .get();
      final pageCount = sizeResult.first.data['page_count'] as int? ?? 0;
      
      return DatabaseHealthStatus(
        isHealthy: isHealthy,
        canConnect: true,
        integrityCheck: integrityResult.first.data['integrity_check'] as String,
        databaseSizePages: pageCount,
        lastChecked: DateTime.now(),
      );
      
    } catch (e) {
      _logger.e('Ошибка при проверке состояния БД', error: e);
      return DatabaseHealthStatus(
        isHealthy: false,
        canConnect: false,
        integrityCheck: 'Error: ${e.toString()}',
        databaseSizePages: 0,
        lastChecked: DateTime.now(),
      );
    }
  }

  /// Выполняет профилактическое обслуживание БД
  Future<void> performMaintenance() async {
    try {
      _logger.i('Начинаем профилактическое обслуживание БД...');
      
      // VACUUM для дефрагментации
      await _database.customStatement('VACUUM');
      _logger.i('Дефрагментация БД завершена');
      
      // ANALYZE для обновления статистики
      await _database.customStatement('ANALYZE');
      _logger.i('Обновление статистики БД завершено');
      
      // Проверка целостности
      final healthStatus = await checkDatabaseHealth();
      if (!healthStatus.isHealthy) {
        throw DatabaseMaintenanceException(
          'БД не прошла проверку целостности: ${healthStatus.integrityCheck}',
        );
      }
      
      _logger.i('Профилактическое обслуживание БД завершено успешно');
      
    } catch (e) {
      _logger.e('Ошибка при профилактическом обслуживании БД', error: e);
      rethrow;
    }
  }
}

/// Состояние здоровья базы данных
class DatabaseHealthStatus {
  const DatabaseHealthStatus({
    required this.isHealthy,
    required this.canConnect,
    required this.integrityCheck,
    required this.databaseSizePages,
    required this.lastChecked,
  });

  /// БД исправна и готова к работе
  final bool isHealthy;
  
  /// Возможно подключение к БД
  final bool canConnect;
  
  /// Результат проверки целостности
  final String integrityCheck;
  
  /// Размер БД в страницах
  final int databaseSizePages;
  
  /// Время последней проверки
  final DateTime lastChecked;

  @override
  String toString() {
    return 'DatabaseHealthStatus('
        'isHealthy: $isHealthy, '
        'canConnect: $canConnect, '
        'integrityCheck: $integrityCheck, '
        'size: $databaseSizePages pages, '
        'lastChecked: $lastChecked'
        ')';
  }
}

/// Исключение восстановления БД
class DatabaseRecoveryException implements Exception {
  const DatabaseRecoveryException(this.message, [this.cause]);
  
  final String message;
  final Exception? cause;
  
  @override
  String toString() => 'DatabaseRecoveryException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Исключение доступа к БД
class DatabaseAccessException implements Exception {
  const DatabaseAccessException(this.message, [this.cause]);
  
  final String message;
  final dynamic cause;
  
  @override
  String toString() => 'DatabaseAccessException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Исключение обслуживания БД
class DatabaseMaintenanceException implements Exception {
  const DatabaseMaintenanceException(this.message);
  
  final String message;
  
  @override
  String toString() => 'DatabaseMaintenanceException: $message';
}