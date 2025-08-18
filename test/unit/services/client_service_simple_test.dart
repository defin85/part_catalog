import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/features/references/clients/services/client_service.dart';

import '../../mocks/mock_services.mocks.dart';

void main() {
  group('ClientService Simple Tests', () {
    late MockAppDatabase mockDatabase;
    late ClientService clientService;
    late MockClientsDao mockClientsDao;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockClientsDao = MockClientsDao();

      when(mockDatabase.clientsDao).thenReturn(mockClientsDao);
      clientService = ClientService(mockDatabase);
    });

    test('should initialize successfully', () {
      expect(clientService, isNotNull);
    });

    test('should call getAllClients with default parameters', () async {
      // Arrange
      when(mockClientsDao.getAllClients(includeDeleted: false))
          .thenAnswer((_) async => []);

      // Act
      await clientService.getAllClients();

      // Assert
      verify(mockClientsDao.getAllClients(includeDeleted: false)).called(1);
    });

    test('should call getAllClients with includeDeleted true', () async {
      // Arrange
      when(mockClientsDao.getAllClients(includeDeleted: true))
          .thenAnswer((_) async => []);

      // Act
      await clientService.getAllClients(includeDeleted: true);

      // Assert
      verify(mockClientsDao.getAllClients(includeDeleted: true)).called(1);
    });

    test('should handle getAllClients exception', () async {
      // Arrange
      when(mockClientsDao.getAllClients(includeDeleted: false))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => clientService.getAllClients(),
        throwsException,
      );
    });

    test('should call getClientByUuid', () async {
      // Arrange
      const testUuid = 'test-uuid';
      when(mockClientsDao.getClientByUuid(testUuid))
          .thenAnswer((_) async => null);

      // Act
      final result = await clientService.getClientByUuid(testUuid);

      // Assert
      expect(result, isNull);
      verify(mockClientsDao.getClientByUuid(testUuid)).called(1);
    });

    test('should call searchClients', () async {
      // Arrange
      const query = 'test';
      when(mockClientsDao.searchClients(query)).thenAnswer((_) async => []);

      // Act
      await clientService.searchClients(query);

      // Assert
      verify(mockClientsDao.searchClients(query)).called(1);
    });

    test('should call isCodeUnique without excludeUuid', () async {
      // Arrange
      const code = 'TEST001';
      when(mockClientsDao.isCodeUnique(code, excludeUuid: null))
          .thenAnswer((_) async => true);

      // Act
      final result = await clientService.isCodeUnique(code);

      // Assert
      expect(result, isTrue);
      verify(mockClientsDao.isCodeUnique(code, excludeUuid: null)).called(1);
    });

    test('should call isCodeUnique with excludeUuid', () async {
      // Arrange
      const code = 'TEST001';
      const excludeUuid = 'exclude-123';
      when(mockClientsDao.isCodeUnique(code, excludeUuid: excludeUuid))
          .thenAnswer((_) async => false);

      // Act
      final result =
          await clientService.isCodeUnique(code, excludeUuid: excludeUuid);

      // Assert
      expect(result, isFalse);
      verify(mockClientsDao.isCodeUnique(code, excludeUuid: excludeUuid))
          .called(1);
    });
  });
}