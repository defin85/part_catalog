import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/core/database/daos/clients_dao.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';

import '../../fixtures/test_data.dart';
import '../../mocks/mock_services.mocks.dart';

void main() {
  group('ClientService Tests', () {
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

    group('getAllClients', () {
      test('should return list of clients when database has data', () async {
        // Arrange
        final mockClientData = [
          ClientFullData(
            coreData: TestData.testClientPhysical.coreData,
            clientData: TestData.testClientPhysical.clientData,
          ),
        ];
        when(mockClientsDao.getAllClients(includeDeleted: false))
            .thenAnswer((_) async => mockClientData);

        // Act
        final result = await clientService.getAllClients();

        // Assert
        expect(result.length, equals(1));
        expect(result.first.displayName,
            equals(TestData.testClientPhysical.displayName));
        verify(mockClientsDao.getAllClients(includeDeleted: false)).called(1);
      });

      test('should return empty list when database is empty', () async {
        // Arrange
        when(mockClientsDao.getAllClients(includeDeleted: false))
            .thenAnswer((_) async => []);

        // Act
        final result = await clientService.getAllClients();

        // Assert
        expect(result, isEmpty);
        verify(mockClientsDao.getAllClients(includeDeleted: false)).called(1);
      });

      test('should throw exception when database operation fails', () async {
        // Arrange
        when(mockClientsDao.getAllClients(includeDeleted: false))
            .thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => clientService.getAllClients(),
          throwsException,
        );
        verify(mockClientsDao.getAllClients(includeDeleted: false)).called(1);
      });
    });

    group('getClientByUuid', () {
      test('should return client when client exists', () async {
        // Arrange
        final mockClientData = ClientFullData(
          coreData: TestData.testClientPhysical.coreData,
          clientData: TestData.testClientPhysical.clientData,
        );
        when(mockClientsDao.getClientByUuid(TestData.testClientPhysical.uuid))
            .thenAnswer((_) async => mockClientData);

        // Act
        final result = await clientService
            .getClientByUuid(TestData.testClientPhysical.uuid);

        // Assert
        expect(result, isNotNull);
        expect(result!.uuid, equals(TestData.testClientPhysical.uuid));
        verify(mockClientsDao.getClientByUuid(TestData.testClientPhysical.uuid))
            .called(1);
      });

      test('should return null when client does not exist', () async {
        // Arrange
        const nonExistentUuid = 'non-existent-uuid';
        when(mockClientsDao.getClientByUuid(nonExistentUuid))
            .thenAnswer((_) async => null);

        // Act
        final result = await clientService.getClientByUuid(nonExistentUuid);

        // Assert
        expect(result, isNull);
        verify(mockClientsDao.getClientByUuid(nonExistentUuid)).called(1);
      });
    });

    group('addClient', () {
      test('should add client successfully', () async {
        // Arrange
        final clientToAdd = TestData.testClientPhysical;
        when(mockClientsDao.insertClient(any, any)).thenAnswer((_) async => 1);

        // Act
        await clientService.addClient(clientToAdd);

        // Assert
        verify(mockClientsDao.insertClient(any, any)).called(1);
      });

      test('should throw exception when insert fails', () async {
        // Arrange
        final clientToAdd = TestData.testClientPhysical;
        when(mockClientsDao.insertClient(any, any))
            .thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () => clientService.addClient(clientToAdd),
          throwsException,
        );
        verify(mockClientsDao.insertClient(any, any)).called(1);
      });
    });

    group('updateClient', () {
      test('should update client successfully', () async {
        // Arrange
        final clientToUpdate = TestData.testClientPhysical;
        when(mockClientsDao.updateClientByUuid(any, any))
            .thenAnswer((_) async => 1);

        // Act
        await clientService.updateClient(clientToUpdate);

        // Assert
        verify(mockClientsDao.updateClientByUuid(any, any)).called(1);
      });

      test('should throw exception when update fails', () async {
        // Arrange
        final clientToUpdate = TestData.testClientPhysical;
        when(mockClientsDao.updateClientByUuid(any, any))
            .thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => clientService.updateClient(clientToUpdate),
          throwsException,
        );
        verify(mockClientsDao.updateClientByUuid(any, any)).called(1);
      });
    });

    group('deleteClient', () {
      test('should delete client successfully', () async {
        // Arrange
        const clientUuid = 'test-uuid';
        final mockClientData = ClientFullData(
          coreData: TestData.testClientPhysical.coreData,
          clientData: TestData.testClientPhysical.clientData,
        );
        when(mockClientsDao.getClientByUuid(clientUuid))
            .thenAnswer((_) async => mockClientData);
        when(mockClientsDao.updateClientByUuid(any, any))
            .thenAnswer((_) async => 1);

        // Act
        await clientService.deleteClient(clientUuid);

        // Assert
        verify(mockClientsDao.getClientByUuid(clientUuid)).called(1);
        verify(mockClientsDao.updateClientByUuid(any, any)).called(1);
      });

      test('should return early when client not found', () async {
        // Arrange
        const clientUuid = 'test-uuid';
        when(mockClientsDao.getClientByUuid(clientUuid))
            .thenAnswer((_) async => null);

        // Act
        await clientService.deleteClient(clientUuid);

        // Assert
        verify(mockClientsDao.getClientByUuid(clientUuid)).called(1);
        verifyNever(mockClientsDao.updateClientByUuid(any, any));
      });
    });

    group('searchClients', () {
      test('should return filtered clients when search query matches',
          () async {
        // Arrange
        const searchQuery = 'иван';
        final expectedResults = [
          ClientFullData(
            coreData: TestData.testClientPhysical.coreData,
            clientData: TestData.testClientPhysical.clientData,
          ),
        ];

        when(mockClientsDao.searchClients(searchQuery))
            .thenAnswer((_) async => expectedResults);

        // Act
        final result = await clientService.searchClients(searchQuery);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.uuid, equals(TestData.testClientPhysical.uuid));
        verify(mockClientsDao.searchClients(searchQuery)).called(1);
      });

      test('should return empty list when no clients match search', () async {
        // Arrange
        const searchQuery = 'nonexistentname';
        when(mockClientsDao.searchClients(searchQuery))
            .thenAnswer((_) async => []);

        // Act
        final result = await clientService.searchClients(searchQuery);

        // Assert
        expect(result, isEmpty);
        verify(mockClientsDao.searchClients(searchQuery)).called(1);
      });

      test('should return all clients when search query is empty', () async {
        // Arrange
        const searchQuery = '';
        final allClients = [
          ClientFullData(
            coreData: TestData.testClientPhysical.coreData,
            clientData: TestData.testClientPhysical.clientData,
          ),
        ];
        when(mockClientsDao.searchClients(searchQuery))
            .thenAnswer((_) async => allClients);

        // Act
        final result = await clientService.searchClients(searchQuery);

        // Assert
        expect(result, hasLength(1));
        verify(mockClientsDao.searchClients(searchQuery)).called(1);
      });
    });

    group('isCodeUnique', () {
      test('should return true when code is unique', () async {
        // Arrange
        const testCode = 'UNIQUE001';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .thenAnswer((_) async => true);

        // Act
        final result = await clientService.isCodeUnique(testCode);

        // Assert
        expect(result, isTrue);
        verify(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .called(1);
      });

      test('should return false when code already exists', () async {
        // Arrange
        const testCode = 'EXISTING001';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .thenAnswer((_) async => false);

        // Act
        final result = await clientService.isCodeUnique(testCode);

        // Assert
        expect(result, isFalse);
        verify(mockClientsDao.isCodeUnique(testCode, excludeUuid: null))
            .called(1);
      });

      test('should exclude specified uuid when checking uniqueness', () async {
        // Arrange
        const testCode = 'TEST001';
        const excludeUuid = 'uuid-to-exclude';
        when(mockClientsDao.isCodeUnique(testCode, excludeUuid: excludeUuid))
            .thenAnswer((_) async => true);

        // Act
        final result = await clientService.isCodeUnique(testCode,
            excludeUuid: excludeUuid);

        // Assert
        expect(result, isTrue);
        verify(mockClientsDao.isCodeUnique(testCode, excludeUuid: excludeUuid))
            .called(1);
      });
    });
  });
}