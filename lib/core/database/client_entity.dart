import 'package:drift/drift.dart';

class Clients extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get contactInfo => text()();
  TextColumn get additionalInfo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
