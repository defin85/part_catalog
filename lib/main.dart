import 'package:flutter/material.dart';
import 'package:part_catalog/api/api_client.dart';
import 'package:part_catalog/models/catalog.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/widgets/car_info_widget.dart'; // Import CarInfoWidget

/// {@template main_app}
/// Главное приложение.
/// {@endtemplate}
void main() async {
  await dotenv.load();
  runApp(const MainApp());
}

/// {@template main_app}
/// Главный виджет приложения.
/// {@endtemplate}
class MainApp extends StatefulWidget {
  /// {@macro main_app}
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ApiClient apiClient;
  List<Catalog> catalogs = [];
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final logger = Logger();
  String vinOrFrame = ''; // Add a field for VIN or Frame input

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    apiClient = ApiClient(dio, baseUrl: '/v1');
    fetchData();
  }

  /// Получает данные из API.
  Future<void> fetchData() async {
    try {
      catalogs = await apiClient.getCatalogs(apiKey, language);
      setState(() {});
    } catch (e) {
      logger.e('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Part Catalog'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Text field for VIN or Frame input
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter VIN or Frame',
                ),
                onChanged: (value) {
                  vinOrFrame = value;
                },
              ),
              // Display CarInfoWidget
              Expanded(
                child: CarInfoWidget(vinOrFrame: vinOrFrame),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
