import 'package:drift/drift.dart';
import 'client_entity.dart'; // Добавляем импорт файла с таблицей Clients

class Cars extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(Clients, #id)();
  TextColumn get vin => text().nullable()();
  TextColumn get make => text()();
  TextColumn get model => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get licensePlate => text().nullable()();
  TextColumn get additionalInfo => text().nullable()();
}
