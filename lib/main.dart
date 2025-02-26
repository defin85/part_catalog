import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/parts_catalog/models/catalog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/features/parts_catalog/widgets/car_info_widget.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/screens/clients_screen.dart';

/// {@template main_app}
/// Главное приложение.
/// {@endtemplate}
void main() async {
  await dotenv.load();
  setupLocator();
  runApp(const MainApp());
}

/// {@template main_app}
/// Главный виджет приложения.
/// {@endtemplate}
class MainApp extends StatelessWidget {
  /// {@macro main_app}
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ApiClientPartsCatalogs apiClient;
  List<Catalog> catalogs = [];
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final Logger logger = Logger();
  String vinOrFrame = '';

  @override
  void initState() {
    super.initState();
    apiClient = locator<ApiClientPartsCatalogs>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      catalogs = await apiClient.getCatalogs(apiKey, language);
      setState(() {});
    } on DioException catch (e) {
      logger.e('Error fetching data: ${e.message}');
      if (e.response != null) {
        logger.e('Status code: ${e.response?.statusCode}');
        logger.e('Response data: ${e.response?.data}');
      } else {
        logger.e('Request failed without a response.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Catalog'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Part Catalog Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsScreen()),
                );
              },
            ),
          ],
        ),
        // Добавьте другие пункты меню здесь
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter VIN or Frame',
              ),
              onChanged: (value) {
                vinOrFrame = value;
              },
            ),
            Expanded(
              child: CarInfoWidget(vinOrFrame: vinOrFrame),
            ),
          ],
        ),
      ),
    );
  }
}
