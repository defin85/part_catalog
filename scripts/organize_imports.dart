#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';

/// Скрипт для организации импортов в Dart файлах
///
/// Группирует импорты в следующем порядке:
/// 1. Dart SDK импорты
/// 2. Flutter импорты
/// 3. Внешние пакеты
/// 4. Локальные импорты проекта
/// 5. Относительные импорты
///
/// Использование: dart scripts/organize_imports.dart [путь]

void main(List<String> args) {
  final path = args.isEmpty ? 'lib' : args[0];
  final directory = Directory(path);

  if (!directory.existsSync()) {
    print('Директория $path не найдена');
    exit(1);
  }

  print('Организация импортов в $path...');
  _processDirectory(directory);
  print('Готово!');
}

void _processDirectory(Directory dir) {
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      _organizeImportsInFile(entity);
    }
  }
}

void _organizeImportsInFile(File file) {
  final lines = file.readAsLinesSync();
  final imports = <String, List<String>>{
    'dart': [],
    'flutter': [],
    'package': [],
    'project': [],
    'relative': [],
  };

  final otherLines = <String>[];
  var inImportSection = true;

  for (final line in lines) {
    if (line.startsWith('import ')) {
      final importLine = line.trim();

      if (importLine.contains('dart:')) {
        imports['dart']!.add(importLine);
      } else if (importLine.contains('package:flutter/')) {
        imports['flutter']!.add(importLine);
      } else if (importLine.contains('package:part_catalog/')) {
        imports['project']!.add(importLine);
      } else if (importLine.contains('package:')) {
        imports['package']!.add(importLine);
      } else {
        imports['relative']!.add(importLine);
      }
    } else if (line.startsWith('export ')) {
      // Пропускаем export statements
      otherLines.add(line);
    } else if (line.trim().isEmpty && inImportSection) {
      // Пропускаем пустые строки в секции импортов
      continue;
    } else {
      inImportSection = false;
      otherLines.add(line);
    }
  }

  // Сортируем импорты в каждой группе
  imports.forEach((key, list) {
    list.sort();
  });

  // Собираем файл обратно
  final result = <String>[];

  // Добавляем импорты в правильном порядке
  void addImports(List<String> importList) {
    if (importList.isNotEmpty) {
      result.addAll(importList);
    }
  }

  addImports(imports['dart']!);
  if (imports['dart']!.isNotEmpty &&
      (imports['flutter']!.isNotEmpty ||
          imports['package']!.isNotEmpty ||
          imports['project']!.isNotEmpty ||
          imports['relative']!.isNotEmpty)) {
    result.add('');
  }

  addImports(imports['flutter']!);
  if (imports['flutter']!.isNotEmpty &&
      (imports['package']!.isNotEmpty ||
          imports['project']!.isNotEmpty ||
          imports['relative']!.isNotEmpty)) {
    result.add('');
  }

  addImports(imports['package']!);
  if (imports['package']!.isNotEmpty &&
      (imports['project']!.isNotEmpty || imports['relative']!.isNotEmpty)) {
    result.add('');
  }

  addImports(imports['project']!);
  if (imports['project']!.isNotEmpty && imports['relative']!.isNotEmpty) {
    result.add('');
  }

  addImports(imports['relative']!);

  // Добавляем пустую строку после импортов
  if (result.isNotEmpty && otherLines.isNotEmpty) {
    result.add('');
  }

  // Добавляем остальной код
  result.addAll(otherLines);

  // Записываем обратно в файл
  if (result.join('\n') != lines.join('\n')) {
    file.writeAsStringSync(result.join('\n'));
    print('Организованы импорты в ${file.path}');
  }
}
