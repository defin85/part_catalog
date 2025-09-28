import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:part_catalog/features/documents/orders/screens/orders_screen.dart';
import 'package:part_catalog/features/home/screens/home_screen.dart';
import 'package:part_catalog/features/references/clients/screens/clients_screen.dart';
import 'package:part_catalog/features/references/vehicles/screens/cars_screen.dart';
import 'package:part_catalog/features/settings/api_control_center/screens/api_control_center_screen.dart';
import 'package:part_catalog/features/suppliers/screens/deprecated_supplier_config_screen.dart';
import 'package:part_catalog/features/suppliers/screens/supplier_config_wizard_screen.dart';
import 'package:part_catalog/features/suppliers/screens/parts_search_screen.dart';
import 'package:part_catalog/features/logs/screens/logs_screen.dart';

import 'app_routes.dart';

// Импортируйте другие экраны...

/// Конфигурация GoRouter для приложения
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.clients, // Начальный экран при запуске
  debugLogDiagnostics: true, // Включить логирование для отладки

  routes: [
    // ShellRoute для основной навигации с BottomNavigationBar/NavigationBar
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // HomeScreen выступает в роли оболочки
        return HomeScreen(child: child);
      },
      routes: <RouteBase>[
        // Маршруты для каждого раздела в Shell
        GoRoute(
          path: AppRoutes.clients,
          builder: (BuildContext context, GoRouterState state) {
            return const ClientsScreen(); // Рефакторенный экран списка клиентов с новой архитектурой
          },
          // Можно добавить вложенные маршруты для деталей клиента и т.д.
          // routes: <RouteBase>[
          //   GoRoute(
          //     path: 'details/:clientId', // Пример вложенного маршрута
          //     builder: (BuildContext context, GoRouterState state) {
          //       final clientId = state.pathParameters['clientId']!;
          //       return ClientDetailsScreen(clientId: clientId);
          //     },
          //   ),
          // ],
        ),
        GoRoute(
          path: AppRoutes.vehicles,
          builder: (BuildContext context, GoRouterState state) {
            return const CarsScreen(); // Экран списка автомобилей
          },
        ),
        GoRoute(
          path: AppRoutes.orders,
          builder: (BuildContext context, GoRouterState state) {
            return const OrdersScreen(); // Экран заказов с новой архитектурой
          },
        ),
        GoRoute(
          path: AppRoutes.partsSearch,
          builder: (BuildContext context, GoRouterState state) {
            return const PartsSearchScreen(); // Экран поиска запчастей
          },
        ),
        GoRoute(
          path: AppRoutes.apiControlCenter,
          builder: (BuildContext context, GoRouterState state) {
            return const ApiControlCenterScreen();
          },
          routes: const <RouteBase>[
            // Вложенные маршруты для ApiControlCenterScreen
            // TODO: Добавить новые маршруты для настроек поставщиков
          ],
        ),
        GoRoute(
          path: AppRoutes.logs,
          builder: (BuildContext context, GoRouterState state) {
            return const LogsScreen();
          },
        ),
        // Добавьте GoRoute для других разделов здесь
      ],
    ),


    // Маршрут для улучшенного экрана настройки поставщиков
    GoRoute(
      path: '${AppRoutes.supplierConfigImproved}/:supplierCode',
      builder: (BuildContext context, GoRouterState state) {
        final supplierCode = state.pathParameters['supplierCode'];
        // Новый улучшенный экран с лучшей организацией интерфейса
        return ImprovedSupplierConfigScreen(supplierCode: supplierCode);
      },
    ),

    // Маршрут для мастера настройки поставщиков
    GoRoute(
      path: AppRoutes.supplierWizard,
      name: 'supplierWizardRoot',
      builder: _buildSupplierWizard,
      routes: [
        GoRoute(
          path: ':supplierCode',
          name: 'supplierWizardWithCode',
          builder: _buildSupplierWizard,
        ),
      ],
    ),
  ],

  // Обработка ошибок навигации (опционально)
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Ошибка навигации')),
    body: Center(child: Text('Страница не найдена: ${state.error}')),
  ),
);

Widget _buildSupplierWizard(BuildContext context, GoRouterState state) {
  final extraCode = state.extra is String ? state.extra as String : null;
  final pathCode = state.pathParameters['supplierCode'];
  final queryCode = state.uri.queryParameters['code'];
  final supplierCode = extraCode ?? pathCode ?? queryCode;

  return SupplierConfigWizardScreen(supplierCode: supplierCode);
}
