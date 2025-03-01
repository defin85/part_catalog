import 'dart:convert';
import 'package:drift/drift.dart';

/// {@template json_converter}
/// Конвертер для преобразования объектов в JSON и обратно для хранения в базе данных.
/// {@endtemplate}
class JsonConverter<T> extends TypeConverter<T, String> {
  /// {@macro json_converter}
  /// [fromJson] - функция, преобразующая JSON-объект в объект типа T
  const JsonConverter(this.fromJson);

  /// Функция для преобразования JSON-объекта в объект типа T
  final T Function(Map<String, dynamic>) fromJson;

  @override
  T fromSql(String fromDb) {
    return fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(T value) {
    return json.encode(value);
  }
}

// Примечание: OrderItems должен быть определен в отдельном файле
// например в lib/features/orders/models/order_entity.dart

// Пример использования в таблице:
/*
class OrderItems extends Table {
  // ...другие колонки...

  // Хранение дополнительных опций как JSON
  TextColumn get options => text().map(JsonConverter<Map<String, dynamic>>(
        (json) => json,
      ))();
}
*/
