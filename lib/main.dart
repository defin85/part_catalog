import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_router.dart';
import 'package:part_catalog/core/observers/provider_observer.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/debug/db_check.dart';
import 'package:part_catalog/core/utils/file_logger.dart';
import 'package:part_catalog/core/logging/app_logger.dart';

// Используем slang для локализации

void main() {
  // Выполнение в защищенной зоне для перехвата всех ошибок
  runZonedGuarded(() async {
    // Загружаем переменные окружения
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();

    // Отключаем отображение overflow в debug режиме
    debugPaintSizeEnabled = false;

    // Игнорируем overflow ошибки в debug режиме
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('RenderFlex overflowed')) {
        return Container(); // Возвращаем пустой контейнер для overflow ошибок
      }
      return ErrorWidget(details.exception);
    };
    // Инициализируем файловый логгер (путь к папке приложения)
    await FileLogger.init();

    // Настраиваем FlutterError для перехвата ошибок Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final logger = appLogger; // Используем общий AppLogger
      logger.e(
        'Flutter error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Перехват debugPrint, чтобы сообщения попадали в журнал
    AppLogger.hookDebugPrint();

    // Инициализация Slang (устанавливаем локаль устройства по умолчанию)
    LocaleSettings.useDeviceLocale();

    // Создаем экземпляр базы данных один раз
    final database = AppDatabase();

    // Передаем существующий экземпляр в setupLocator
    setupLocator(database);

    // Проверяем содержимое таблицы supplier_settings в debug режиме
    await checkSupplierSettingsTable();

    // Оборачиваем приложение в ProviderScope и TranslationProvider
    runApp(
      ProviderScope(
        observers: [AppProviderObserver()],
        child: TranslationProvider(
          child: const MyApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    // Ловим все необработанные исключения в зоне
    final logger = appLogger; // Используем общий AppLogger
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем текущую локаль из провайдера
    final currentLocale = ref.watch(localeProvider);

    // Используем MaterialApp.router для интеграции с GoRouter
    return MaterialApp.router(
      // Передаем конфигурацию роутера
      routerConfig: router,

      // Отключаем строгую обрезку для предотвращения overflow на 1 пиксель
      debugShowCheckedModeBanner: false,

      // Обработчик ошибок builder для игнорирования overflow
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },

      // Настройки локализации из Slang
      locale: currentLocale.flutterLocale, // Используем локаль из провайдера
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
        // Базовые настройки AppBar
        appBarTheme: const AppBarTheme(
          toolbarHeight: kToolbarHeight + 8.0, // Стандартная высота + запас
        ),
        // Дополнительные настройки темы...
      ),
      // Убрали home, так как начальный маршрут задается в GoRouter (initialLocation)
    );
  }
}
