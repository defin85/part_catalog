import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';

import '../../mocks/mock_services.mocks.dart';

void main() {
  group('ClientService Basic Tests', () {
    late MockAppDatabase mockDatabase;
    late ClientService clientService;
    late MockClientsDao mockClientsDao;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockClientsDao = MockClientsDao();
      
      // Настраиваем мок базы данных для возврата мок DAO
      when(mockDatabase.clientsDao).thenReturn(mockClientsDao);
      
      clientService = ClientService(mockDatabase);
    });

    group('Service Initialization', () {
      test('should initialize successfully with database', () {
        // Arrange & Act
        final service = ClientService(mockDatabase);
        
        // Assert
        expect(service, isNotNull);
      });
    });

    group('getAllClients', () {
      test('should call DAO getAllClients method', () async {
        // Arrange
        when(mockClientsDao.getAllClients(includeDeleted: any))
            .thenAnswer((_) async => []);

        // Act
        await clientService.getAllClients();

        // Assert
        verify(mockClientsDao.getAllClients(includeDeleted: false)).called(1);
      });

      test('should call DAO with includeDeleted parameter', () async {
        // Arrange
        when(mockClientsDao.getAllClients(includeDeleted: any))
            .thenAnswer((_) async => []);

        // Act
        await clientService.getAllClients(includeDeleted: true);

        // Assert
        verify(mockClientsDao.getAllClients(includeDeleted: true)).called(1);
      });

      test('should propagate exceptions from DAO', () async {
        // Arrange
        when(mockClientsDao.getAllClients(includeDeleted: any))
            .thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => clientService.getAllClients(),
          throwsException,
        );
      });
    });

    group('getClientByUuid', () {
      test('should call DAO getClientByUuid method', () async {
        // Arrange
        const testUuid = 'test-uuid-123';
        when(mockClientsDao.getClientByUuid(testUuid))
            .thenAnswer((_) async => null);

        // Act
        await clientService.getClientByUuid(testUuid);

        // Assert
        verify(mockClientsDao.getClientByUuid(testUuid)).called(1);
      });

      test('should return null when DAO returns null', () async {
        // Arrange
        const testUuid = 'test-uuid-123';
        when(mockClientsDao.getClientByUuid(testUuid))
            .thenAnswer((_) async => null);

        // Act
        final result = await clientService.getClientByUuid(testUuid);

        // Assert
        expect(result, isNull);
      });
    });

    group('searchClients', () {
      test('should call DAO searchClients method', () async {
        // Arrange
        const searchQuery = 'test query';
        when(mockClientsDao.searchClients(searchQuery))
            .thenAnswer((_) async => []);

        // Act
        await clientService.searchClients(searchQuery);

        // Assert
        verify(mockClientsDao.searchClients(searchQuery)).called(1);
      });
    });

    group('isCodeUnique', () {
      test('should call DAO isCodeUnique method', () async {
        // Arrange
        const testCode = 'TEST001';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .thenAnswer((_) async => true);

        // Act
        await clientService.isCodeUnique(testCode);

        // Assert
        verify(mockClientsDao.isCodeUnique(testCode, excludeUuid: null)).called(1);
      });

      test('should pass excludeUuid parameter to DAO', () async {
        // Arrange
        const testCode = 'TEST001';
        const excludeUuid = 'exclude-uuid';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: excludeUuid))
            .thenAnswer((_) async => true);

        // Act
        await clientService.isCodeUnique(testCode, excludeUuid: excludeUuid);

        // Assert
        verify(mockClientsDao.isCodeUnique(testCode, excludeUuid: excludeUuid)).called(1);
      });

      test('should return DAO result', () async {
        // Arrange
        const testCode = 'TEST001';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .thenAnswer((_) async => true);

        // Act
        final result = await clientService.isCodeUnique(testCode);

        // Assert
        expect(result, isTrue);
      });
    });
  });
}