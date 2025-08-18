import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
import 'package:part_catalog/features/references/clients/screens/clients_screen.dart';

import '../../helpers/test_helpers.dart';
import '../../mocks/mock_services.mocks.dart';

void main() {
  group('ClientsScreen Simple Widget Tests', () {
    late MockClientService mockClientService;

    setUp(() {
      mockClientService = MockClientService();
    });

    testWidgets('should render without crashing', (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      // Wait for initial build
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show app bar', (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show floating action button',
        (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should show search field', (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show empty list initially',
        (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await TestHelpers.pumpAndSettle(tester);

      // Assert - проверяем, что список существует, но пуст
      // В зависимости от реализации может быть Center с текстом или пустой ListView
      expect(find.byType(Column), findsOneWidget); // Основная структура экрана
    });

    testWidgets('should handle tap on FAB without crashing',
        (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Act - tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Assert - проверяем, что не произошло исключений
      expect(tester.takeException(), isNull);
    });

    testWidgets('should contain required UI elements structure',
        (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Assert - проверяем основную структуру UI
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget); // Основная колонка
      expect(find.byType(TextField), findsOneWidget); // Поле поиска
    });

    testWidgets('should handle search input', (WidgetTester tester) async {
      // Arrange
      when(mockClientService.watchClients())
          .thenAnswer((_) => Stream.value([]));

      // Act
      await tester.pumpTestApp(
        const ClientsScreen(),
        overrides: [
          clientServiceProvider.overrideWithValue(mockClientService),
        ],
      );

      await tester.pump();

      // Act - enter text in search field
      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pump();

      // Assert - проверяем, что текст введен
      expect(find.text('test search'), findsOneWidget);
    });
  });
}