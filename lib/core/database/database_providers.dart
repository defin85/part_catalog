import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/database_error_recovery.dart';
import 'package:part_catalog/core/service_locator.dart';

/// Провайдер для системы восстановления после ошибок БД
final databaseErrorRecoveryProvider = Provider<DatabaseErrorRecovery>((ref) {
  final database = locator<AppDatabase>();
  return DatabaseErrorRecovery(database);
});

/// Провайдер для проверки состояния БД
final databaseHealthProvider = FutureProvider<DatabaseHealthStatus>((ref) async {
  final errorRecovery = ref.watch(databaseErrorRecoveryProvider);
  return errorRecovery.checkDatabaseHealth();
});

/// Провайдер для автоматического периодического обслуживания БД
final databaseMaintenanceProvider = Provider<DatabaseMaintenanceService>((ref) {
  final errorRecovery = ref.watch(databaseErrorRecoveryProvider);
  return DatabaseMaintenanceService(errorRecovery);
});

/// Сервис для автоматического обслуживания БД
class DatabaseMaintenanceService {
  DatabaseMaintenanceService(this._errorRecovery);
  
  final DatabaseErrorRecovery _errorRecovery;
  
  /// Выполняет полное профилактическое обслуживание БД
  Future<void> performFullMaintenance() async {
    await _errorRecovery.performMaintenance();
  }
  
  /// Проверяет здоровье БД и возвращает статус
  Future<DatabaseHealthStatus> checkHealth() async {
    return _errorRecovery.checkDatabaseHealth();
  }
  
  /// Выполняет быструю проверку БД (только соединение)
  Future<bool> quickHealthCheck() async {
    try {
      final status = await _errorRecovery.checkDatabaseHealth();
      return status.canConnect;
    } catch (e) {
      return false;
    }
  }
}