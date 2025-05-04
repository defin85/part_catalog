import 'package:flutter_riverpod/flutter_riverpod.dart'; // Импортируем базовый Ref
import 'package:logger/logger.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

// --- Провайдеры для логгеров ---

// Общий логгер приложения (для ядра, UI и т.д.)
@Riverpod(keepAlive: true)
Logger coreLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.coreLogger;
}

// Логгер для модуля клиентов
@Riverpod(keepAlive: true)
Logger clientsLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.clientsLogger;
}

// Логгер для модуля автомобилей
@Riverpod(keepAlive: true)
Logger vehiclesLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.vehiclesLogger;
}

// Логгер для модуля заказ-нарядов
@Riverpod(keepAlive: true)
Logger ordersLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.ordersLogger;
}

// Логгер для модуля поставщиков
@Riverpod(keepAlive: true)
Logger suppliersLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.suppliersLogger;
}

// Логгер для сетевых операций (если нужен отдельно)
@Riverpod(keepAlive: true)
Logger networkLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.networkLogger;
}

// Логгер для базы данных (если нужен отдельно)
@Riverpod(keepAlive: true)
Logger databaseLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.databaseLogger;
}

// --- Другие общие провайдеры ---
// ...
