import 'dart:convert';

import 'package:drift/drift.dart';

/// {@template drift_json_converter}
/// Конвертер для преобразования объектов в JSON-строку и обратно
/// для хранения в базе данных с использованием Drift.
/// {@endtemplate}
class DriftJsonConverter<T> extends TypeConverter<T, String> {
  /// {@macro drift_json_converter}
  /// [fromJsonInConverter] - функция, преобразующая JSON-объект (Map&lt;String, dynamic&gt;) в объект типа T.
  /// Имя изменено с fromJson, чтобы избежать конфликта с методом fromJson в freezed классах.
  final T Function(Map<String, dynamic> json) fromJsonInConverter;

  const DriftJsonConverter(this.fromJsonInConverter);

  @override
  T fromSql(String fromDb) {
    return fromJsonInConverter(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(T value) {
    return json.encode(value);
  }
}

// Пример использования в таблице Drift:
/*
class YourTableClass extends Table {
  // ...другие колонки...

  // Хранение сложных данных как JSON
  TextColumn get complexData => text().map(DriftJsonConverter<YourComplexDataType>(
        (json) => YourComplexDataType.fromJson(json), // Используем fromJson модели
      ))();
}
*/