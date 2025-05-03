import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/features/home/screens/home_screen.dart';
import 'package:part_catalog/features/references/clients/screens/clients_screen.dart'; // Пример
import 'package:part_catalog/features/references/vehicles/screens/cars_screen.dart'; // Пример
import 'package:part_catalog/features/documents/orders/screens/orders_screen.dart'; // Пример
// Импортируйте другие экраны...
import 'app_routes.dart';

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
            return const ClientsScreen(); // Экран списка клиентов
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
            return const OrdersScreen(); // Экран списка заказов
          },
        ),
        // Добавьте GoRoute для других разделов здесь
      ],
    ),

    // Можно добавить другие маршруты верхнего уровня,
    // которые не используют ShellRoute (например, экран логина, настроек)
    // GoRoute(
    //   path: '/settings',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SettingsScreen();
    //   },
    // ),
  ],

  // Обработка ошибок навигации (опционально)
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Ошибка навигации')),
    body: Center(child: Text('Страница не найдена: ${state.error}')),
  ),
);
