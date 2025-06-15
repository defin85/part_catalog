import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/navigation/app_router.dart';
import 'package:part_catalog/core/service_locator.dart';
// Используем slang для локализации
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Выполнение в защищенной зоне для перехвата всех ошибок
  runZonedGuarded(() async {
    // Загружаем переменные окружения
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();

    // Настраиваем FlutterError для перехвата ошибок Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final logger = Logger(); // Используем стандартный логгер
      logger.e(
        'Flutter error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Инициализация Slang (устанавливаем локаль устройства по умолчанию)
    LocaleSettings.useDeviceLocale();

    // Создаем экземпляр базы данных один раз
    final database = AppDatabase();

    // Передаем существующий экземпляр в setupLocator
    setupLocator(database);

    // Оборачиваем приложение в ProviderScope и TranslationProvider
    runApp(
      ProviderScope(
        // <--- Обертка для Riverpod
        child: TranslationProvider(
          child: const MyApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    // Ловим все необработанные исключения в зоне
    final logger = Logger(); // Используем стандартный логгер
    logger.e(
      'Unhandled error',
      error: error,
      stackTrace: stackTrace,
    );
    // В режиме отладки можно перебросить ошибку для лучшей видимости
    // if (kDebugMode) {
    //   throw error;
    // }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем MaterialApp.router для интеграции с GoRouter
    return MaterialApp.router(
      // Передаем конфигурацию роутера
      routerConfig: router,

      // Настройки локализации из Slang
      locale: TranslationProvider.of(context)
          .flutterLocale, // Получаем текущую локаль
      supportedLocales: AppLocaleUtils
          .supportedLocales, // Получаем список поддерживаемых локалей
      localizationsDelegates:
          GlobalMaterialLocalizations.delegates, // Стандартные делегаты

      // Заголовок приложения (можно взять из локализации, если нужно)
      title: t.core.appTitle,

      theme: ThemeData(
        // Настройте вашу тему
        primarySwatch: Colors.blue, // Пример
        useMaterial3: true,
        // Дополнительные настройки темы...
      ),
      // Убрали home, так как начальный маршрут задается в GoRouter (initialLocation)
    );
  }
}
