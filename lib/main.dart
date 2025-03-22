import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/s.dart';
import 'package:part_catalog/core/providers/locale_provider.dart';
import 'package:part_catalog/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // Выполнение в защищенной зоне для перехвата всех ошибок
  runZonedGuarded(() async {
    // Загружаем переменные окружения
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();

    // Настраиваем FlutterError для перехвата ошибок Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final logger = Logger();
      logger.e(
        'Flutter error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Создаем экземпляр базы данных один раз
    final database = AppDatabase();
    await database.ensureDatabaseReady();

    // Передаем существующий экземпляр в setupLocator
    setupLocator(database);

    runApp(
      ChangeNotifierProvider(
        create: (_) => locator<LocaleProvider>(),
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    // Ловим все необработанные исключения
    final logger = Logger();
    logger.e(
      'Unhandled error',
      error: error,
      stackTrace: stackTrace,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущую локаль из провайдера
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      // Поддерживаемые локали
      supportedLocales: S.supportedLocales,
      // Используем локаль из провайдера
      locale: localeProvider.locale,
      // Делегаты локализации
      localizationsDelegates: S.localizationDelegates,
      // Заголовок приложения через локализацию
      title: 'Part Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
