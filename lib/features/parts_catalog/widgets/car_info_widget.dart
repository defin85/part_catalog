import 'package:flutter/material.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart'; // Import ApiClientPartsCatalogs
import 'package:part_catalog/features/parts_catalog/models/car_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart'; // Import get_it

/// {@template car_info_widget}
/// Виджет для отображения информации об автомобиле по VIN или FRAME.
/// {@endtemplate}
class CarInfoWidget extends StatefulWidget {
  /// {@macro car_info_widget}
  const CarInfoWidget({super.key, required this.vinOrFrame});

  /// VIN или FRAME автомобиля.
  final String vinOrFrame;

  @override
  State<CarInfoWidget> createState() => _CarInfoWidgetState();
}

class _CarInfoWidgetState extends State<CarInfoWidget> {
  //late ApiClientPartsCatalogs apiClient; // No need to declare here
  List<CarInfo> carInfos = [];
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final logger = Logger();
  late Future<List<CarInfo>> _carInfoFuture;

  @override
  void initState() {
    super.initState();
    _carInfoFuture = fetchCarInfo();
  }

  /// Получает информацию об автомобиле из API.
  Future<List<CarInfo>> fetchCarInfo() async {
    try {
      final apiClient = GetIt.instance<
          ApiClientPartsCatalogs>(); // Get ApiClientPartsCatalogs from get_it
      return await apiClient.getCarInfo(
          widget.vinOrFrame, null, apiKey, language);
    } catch (e) {
      logger.e('Error fetching car info: $e');
      return Future.error(e); // Пробрасываем ошибку для FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarInfo>>(
      future: _carInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          carInfos = snapshot.data!;
          if (carInfos.isEmpty) {
            return const Center(child: Text('No car info found.'));
          }
          return ListView.builder(
            itemCount: carInfos.length,
            itemBuilder: (context, index) {
              final carInfo = carInfos[index];
              return CarInfoCard(
                  carInfo:
                      carInfo); // Используем отдельный виджет для отображения информации об автомобиле
            },
          );
        } else {
          return const Center(child: Text('No car info available.'));
        }
      },
    );
  }
}

/// {@template car_info_card}
/// Виджет для отображения карточки с информацией об автомобиле.
/// {@endtemplate}
class CarInfoCard extends StatelessWidget {
  /// {@macro car_info_card}
  const CarInfoCard({super.key, required this.carInfo});

  /// Информация об автомобиле.
  final CarInfo carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${carInfo.title ?? 'N/A'}'),
            Text('Catalog ID: ${carInfo.catalogId ?? 'N/A'}'),
            Text('Brand: ${carInfo.brand ?? 'N/A'}'),
            Text('Model ID: ${carInfo.modelId ?? 'N/A'}'),
            Text('Car ID: ${carInfo.carId ?? 'N/A'}'),
            Text('VIN: ${carInfo.vin ?? 'N/A'}'),
            Text('Frame: ${carInfo.frame ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
