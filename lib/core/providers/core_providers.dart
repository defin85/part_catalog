import 'package:flutter_riverpod/flutter_riverpod.dart'; // Импортируем базовый Ref
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/utils/logger_config.dart';

part 'core_providers.g.dart';

// --- Провайдеры для логгеров ---

// Общий логгер приложения (для ядра, UI и т.д.)
@Riverpod(keepAlive: true)
Logger coreLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.core;
}

// Логгер для модуля клиентов
@Riverpod(keepAlive: true)
Logger clientsLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.clients;
}

// Логгер для модуля автомобилей
@Riverpod(keepAlive: true)
Logger vehiclesLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.vehicles;
}

// Логгер для модуля заказ-нарядов
@Riverpod(keepAlive: true)
Logger ordersLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.orders;
}

// Логгер для модуля поставщиков
@Riverpod(keepAlive: true)
Logger suppliersLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.suppliers;
}

// Логгер для сетевых операций (если нужен отдельно)
@Riverpod(keepAlive: true)
Logger networkLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.network;
}

// Логгер для базы данных (если нужен отдельно)
@Riverpod(keepAlive: true)
Logger databaseLogger(Ref ref) {
  // Используем базовый Ref
  return AppLoggers.database;
}

// --- Другие общие провайдеры ---
// ...
