import 'dart:convert';
import 'dart:io';
import 'code_graph_builder.dart';

Future<void> main() async {
  final builder = CodeGraphBuilder();
  final projectDir = '../../lib'; // Путь к директории lib относительно скрипта

  print('Starting analysis of directory: $projectDir');
  await builder.analyzeDirectory(projectDir);

  // Сохраняем результат в JSON файл
  final outputFile = File('project_graph.json');
  final jsonEncoder = JsonEncoder.withIndent('  ');
  final jsonGraph = jsonEncoder.convert(builder.toJson());
  await outputFile.writeAsString(jsonGraph);

  print('Graph saved to ${outputFile.path}');
}
