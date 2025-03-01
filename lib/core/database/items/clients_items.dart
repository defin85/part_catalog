import 'package:drift/drift.dart';

/// {@template clients_items}
/// Таблица клиентов для хранения в базе данных.
/// {@endtemplate}
class ClientsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get contactInfo => text()();
  TextColumn get additionalInfo => text().nullable()();
  DateTimeColumn get deletedAt =>
      dateTime().nullable()(); // Для поддержки мягкого удаления

  // Не нужно явно задавать primaryKey при использовании autoIncrement
}
