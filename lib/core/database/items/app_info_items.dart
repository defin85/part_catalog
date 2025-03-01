import 'package:drift/drift.dart';

/// {@template app_info_items}
/// Таблица для хранения метаданных приложения.
/// {@endtemplate}
class AppInfoItems extends Table {
  TextColumn get key => text().named('key')();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
