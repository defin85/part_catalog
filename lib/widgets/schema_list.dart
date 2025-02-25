import 'package:flutter/material.dart';
import 'package:part_catalog/api/api_client.dart';
import 'package:part_catalog/models/schemas_response.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

/// {@template schema_list}
/// Виджет для отображения списка схем.
/// {@endtemplate}
class SchemaList extends StatefulWidget {
  /// {@macro schema_list}
  const SchemaList({
    super.key,
    required this.catalogId,
    required this.carId,
  });

  /// Идентификатор каталога.
  final String catalogId;

  /// Идентификатор автомобиля.
  final String carId;

  @override
  State<SchemaList> createState() => _SchemaListState();
}

class _SchemaListState extends State<SchemaList> {
  late ApiClient apiClient;
  SchemasResponse? schemasResponse;
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final logger = Logger();
  late Future<SchemasResponse?> _schemasFuture; // Future for schemas

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    apiClient = ApiClient(dio, baseUrl: '/v1');
    _schemasFuture = fetchSchemas(); // Initialize the future
  }

  /// Получает схемы из API.
  Future<SchemasResponse?> fetchSchemas() async {
    try {
      return await apiClient.getSchemas(
        widget.catalogId,
        widget.carId,
        null,
        null,
        null,
        null,
        null,
        apiKey,
        language,
      );
    } catch (e) {
      logger.e('Error fetching schemas: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SchemasResponse?>(
      future: _schemasFuture, // Use the initialized future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final schemas = snapshot.data?.list;
          if (schemas == null || schemas.isEmpty) {
            return const Center(child: Text('No schemas available.'));
          }
          return ListView.builder(
            itemCount: schemas.length,
            itemBuilder: (context, index) {
              final schema = schemas[index];
              return ListTile(
                title: Text(schema.name),
                subtitle: Text(schema.description ?? ''),
              );
            },
          );
        } else {
          return const Center(child: Text('No schemas available.'));
        }
      },
    );
  }
}
