import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/s.dart';
import 'package:part_catalog/core/providers/locale_provider.dart';
import 'package:part_catalog/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных с проверкой таблиц
  final database = AppDatabase();
  await database.ensureDatabaseReady();

  // Регистрация в service_locator
  setupLocator(); // предполагаем, что это регистрирует database

  runApp(
    // Провайдер для управления локалью
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
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
