import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/core/database/daos/clients_dao.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/core/document_specific_data.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/part_specific_data.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

import 'order_service_test.mocks.dart';

// Генерируемые моки
@GenerateMocks([AppDatabase, OrdersDao, ClientsDao, CarsDao])
void main() {
  late OrderService orderService;
  late MockAppDatabase mockDatabase;
  late MockOrdersDao mockOrdersDao;
  late MockClientsDao mockClientsDao;
  late MockCarsDao mockCarsDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockOrdersDao = MockOrdersDao();
    mockClientsDao = MockClientsDao();
    mockCarsDao = MockCarsDao();
    orderService = OrderService(mockDatabase);

    when(mockDatabase.ordersDao).thenReturn(mockOrdersDao);
    when(mockDatabase.clientsDao).thenReturn(mockClientsDao);
    when(mockDatabase.carsDao).thenReturn(mockCarsDao);
  });

  group('OrderService', () {
    test('getOrders returns an empty list when no orders are available',
        () async {
      // Arrange
      when(mockOrdersDao.getActiveOrderUuids()).thenAnswer((_) async => []);

      // Act
      final result = await orderService.getOrders();

      // Assert
      expect(result, isEmpty);
      verify(mockOrdersDao.getActiveOrderUuids()).called(1);
    });

    test('getOrders returns a list of orders when orders are available',
        () async {
      // Arrange
      const orderUuid = 'test-uuid';
      final orderHeaderData = OrderHeaderData(
        coreData: EntityCoreData(
          uuid: orderUuid,
          code: '123',
          displayName: 'Test Order',
          createdAt: DateTime.now(),
        ),
        docData: DocumentSpecificData(
          documentDate: DateTime.now(),
          status: DocumentStatus.newDoc,
        ),
        orderData: const OrderSpecificData(
          clientId: 'client-uuid',
          carId: 'car-uuid',
        ),
      );

      when(mockOrdersDao.getActiveOrderUuids())
          .thenAnswer((_) async => [orderUuid]);
      when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
          .thenAnswer((_) async => orderHeaderData);
      when(mockOrdersDao.getOrderItems(orderUuid)).thenAnswer((_) async => []);

      // Act
      final result = await orderService.getOrders();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.uuid, orderUuid);
      verify(mockOrdersDao.getActiveOrderUuids()).called(1);
      verify(mockOrdersDao.getOrderHeaderByUuid(orderUuid)).called(1);
      verify(mockOrdersDao.getOrderItems(orderUuid)).called(1);
    });

    group('createNewOrder', () {
      test('should create and save a new order successfully', () async {
        // Arrange
        const clientUuid = 'client-uuid';
        const carUuid = 'car-uuid';
        final clientCoreData = EntityCoreData(
            uuid: clientUuid,
            code: 'client-001',
            displayName: 'Test Client',
            createdAt: DateTime.now());
        final carCoreData = EntityCoreData(
            uuid: carUuid,
            code: 'car-001',
            displayName: 'Test Car',
            createdAt: DateTime.now());

        when(mockClientsDao.getClientCoreData(clientUuid))
            .thenAnswer((_) async => clientCoreData);
        when(mockCarsDao.getCarCoreData(carUuid))
            .thenAnswer((_) async => carCoreData);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        final result = await orderService.createNewOrder(
            clientUuid: clientUuid, carUuid: carUuid);

        // Assert
        expect(result, isA<OrderModelComposite>());
        expect(result.clientId, clientUuid);
        expect(result.carId, carUuid);

        verify(mockClientsDao.getClientCoreData(clientUuid)).called(1);
        verify(mockCarsDao.getCarCoreData(carUuid)).called(1);
        verify(mockOrdersDao.saveFullOrderData(
          any,
          any,
          any,
          any,
        )).called(1);
      });

      test('should throw an exception if client is not found', () async {
        // Arrange
        const clientUuid = 'non-existent-client-uuid';
        const carUuid = 'car-uuid';

        when(mockClientsDao.getClientCoreData(clientUuid))
            .thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => orderService.createNewOrder(
              clientUuid: clientUuid, carUuid: carUuid),
          throwsA(isA<Exception>()),
        );
        verify(mockClientsDao.getClientCoreData(clientUuid)).called(1);
        verifyNever(mockCarsDao.getCarCoreData(any));
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });

      test('should throw an exception if car is not found', () async {
        // Arrange
        const clientUuid = 'client-uuid';
        const carUuid = 'non-existent-car-uuid';
        final clientCoreData = EntityCoreData(
            uuid: clientUuid,
            code: 'client-001',
            displayName: 'Test Client',
            createdAt: DateTime.now());

        when(mockClientsDao.getClientCoreData(clientUuid))
            .thenAnswer((_) async => clientCoreData);
        when(mockCarsDao.getCarCoreData(carUuid)).thenAnswer((_) async => null);

        // Act
        try {
          await orderService.createNewOrder(
              clientUuid: clientUuid, carUuid: carUuid);
          fail('should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }

        // Assert
        verify(mockClientsDao.getClientCoreData(clientUuid)).called(1);
        verify(mockCarsDao.getCarCoreData(carUuid)).called(1);
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });
    });

    group('updateOrder', () {
      test('should update the modified date and save the order', () async {
        // Arrange
        final initialOrder = OrderModelComposite.create(
          code: 'order-001',
          displayName: 'Initial Order',
          documentDate: DateTime.now(),
          clientId: 'client-1',
          carId: 'car-1',
        );

        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await Future.delayed(
            const Duration(milliseconds: 10)); // Add a small delay
        await orderService.updateOrder(initialOrder);

        // Assert
        final verification = verify(mockOrdersDao.saveFullOrderData(
          captureAny,
          any,
          any,
          any,
        ));

        verification.called(1);

        final capturedCoreData = verification.captured.first as EntityCoreData;
        expect(capturedCoreData.uuid, initialOrder.uuid);
        expect(capturedCoreData.modifiedAt, isNotNull);
        expect(capturedCoreData.modifiedAt!.isAfter(initialOrder.createdAt),
            isTrue);
      });
    });

    group('deleteOrder', () {
      test('should mark order as deleted and update it', () async {
        // Arrange
        const orderUuid = 'order-to-delete-uuid';
        final now = DateTime.now();
        final orderHeaderData = OrderHeaderData(
          coreData: EntityCoreData(
            uuid: orderUuid,
            code: '123',
            displayName: 'Test Order',
            createdAt: now,
          ),
          docData: DocumentSpecificData(
            documentDate: now,
            status: DocumentStatus.newDoc,
          ),
          orderData: const OrderSpecificData(
            clientId: 'client-uuid',
            carId: 'car-uuid',
          ),
        );

        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeaderData);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.deleteOrder(orderUuid);

        // Assert
        final verification = verify(mockOrdersDao.saveFullOrderData(
          captureAny,
          any,
          any,
          any,
        ));

        verification.called(1);

        final capturedCoreData = verification.captured.first as EntityCoreData;
        expect(capturedCoreData.isDeleted, isTrue);
        expect(capturedCoreData.deletedAt, isNotNull);
      });

      test('should throw an exception if order to delete is not found',
          () async {
        // Arrange
        const orderUuid = 'non-existent-order-uuid';
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => orderService.deleteOrder(orderUuid),
          throwsA(isA<Exception>()),
        );

        verify(mockOrdersDao.getOrderHeaderByUuid(orderUuid)).called(1);
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });
    });

    group('changeOrderStatus', () {
      test('should update the status of an existing order', () async {
        // Arrange
        const orderUuid = 'order-status-uuid';
        const initialStatus = DocumentStatus.newDoc;
        const newStatus = DocumentStatus.inProgress;
        final now = DateTime.now();

        final orderHeaderData = OrderHeaderData(
          coreData: EntityCoreData(
            uuid: orderUuid,
            code: '123',
            displayName: 'Test Order',
            createdAt: now,
          ),
          docData: DocumentSpecificData(
            documentDate: now,
            status: initialStatus,
          ),
          orderData: const OrderSpecificData(
            clientId: 'client-uuid',
            carId: 'car-uuid',
          ),
        );

        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeaderData);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.changeOrderStatus(orderUuid, newStatus);

        // Assert
        final verification = verify(mockOrdersDao.saveFullOrderData(
          any,
          captureAny,
          any,
          any,
        ));

        verification.called(1);

        final capturedDocData =
            verification.captured.first as DocumentSpecificData;
        expect(capturedDocData.status, newStatus);
      });

      test('should throw an exception if order to change status is not found',
          () async {
        // Arrange
        const orderUuid = 'non-existent-order-uuid';
        const newStatus = DocumentStatus.completed;
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => orderService.changeOrderStatus(orderUuid, newStatus),
          throwsA(isA<Exception>()),
        );

        verify(mockOrdersDao.getOrderHeaderByUuid(orderUuid)).called(1);
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });
    });

    group('Order Item Management', () {
      const orderUuid = 'order-item-management-uuid';
      final now = DateTime.now();

      // Helper to create a base order for tests
      OrderHeaderData createTestOrderHeader(DocumentStatus status) {
        return OrderHeaderData(
          coreData: EntityCoreData(
            uuid: orderUuid,
            code: '123',
            displayName: 'Test Order',
            createdAt: now,
          ),
          docData: DocumentSpecificData(
            documentDate: now,
            status: status,
          ),
          orderData: const OrderSpecificData(
            clientId: 'client-uuid',
            carId: 'car-uuid',
          ),
        );
      }

      test('addItemToOrder should add a new part to an existing order',
          () async {
        // Arrange
        final orderHeader = createTestOrderHeader(DocumentStatus.newDoc);
        final newPart = OrderPartModelComposite.create(
          documentUuid: orderUuid,
          partNumber: 'PN-123',
          name: 'Test Part',
          price: 100.0,
        );

        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.addItemToOrder(orderUuid, newPart);

        // Assert
        final verification =
            verify(mockOrdersDao.saveFullOrderData(any, any, any, captureAny));
        verification.called(1);

        final capturedItems = verification.captured.first
            as List<Tuple3<ItemCoreData, DocumentItemSpecificData, dynamic>>;
        expect(capturedItems, hasLength(1));
        expect(capturedItems.first.item1.uuid, newPart.uuid);
      });

      test('updateOrderItem should update an existing part in an order',
          () async {
        // Arrange
        final partToUpdate = OrderPartModelComposite.create(
          documentUuid: orderUuid,
          partNumber: 'PN-123',
          name: 'Original Part Name',
          price: 100.0,
        );
        final updatedPart = OrderPartModelComposite.fromData(
          partToUpdate.coreData.copyWith(name: 'Updated Part Name'),
          partToUpdate.docItemData,
          partToUpdate.partData,
        );

        final orderHeader = createTestOrderHeader(DocumentStatus.newDoc);
        final initialItemData = partToUpdate.getAllData();

        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid)).thenAnswer((_) async => [
              FullOrderItemData(
                coreData: initialItemData.item1,
                docItemData: initialItemData.item2,
                partData: initialItemData.item3 as PartSpecificData?,
                serviceData: null,
                itemType: BaseItemType.part,
              )
            ]);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.updateOrderItem(orderUuid, updatedPart);

        // Assert
        final verification =
            verify(mockOrdersDao.saveFullOrderData(any, any, any, captureAny));
        verification.called(1);

        final capturedItems = verification.captured.first
            as List<Tuple3<ItemCoreData, DocumentItemSpecificData, dynamic>>;
        expect(capturedItems, hasLength(1));
        expect(capturedItems.first.item1.uuid, updatedPart.uuid);
        final capturedCoreData = capturedItems.first.item1;
        expect(capturedCoreData.name, 'Updated Part Name');
      });

      test('removeItemFromOrder should remove an existing part from an order',
          () async {
        // Arrange
        final partToRemove = OrderPartModelComposite.create(
          documentUuid: orderUuid,
          partNumber: 'PN-123',
          name: 'Part To Remove',
          price: 100.0,
        );
        final orderHeader = createTestOrderHeader(DocumentStatus.newDoc);
        final initialItemData = partToRemove.getAllData();

        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid)).thenAnswer((_) async => [
              FullOrderItemData(
                coreData: initialItemData.item1,
                docItemData: initialItemData.item2,
                partData: initialItemData.item3 as PartSpecificData?,
                serviceData: null,
                itemType: BaseItemType.part,
              )
            ]);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.removeItemFromOrder(partToRemove.uuid, orderUuid);

        // Assert
        final verification =
            verify(mockOrdersDao.saveFullOrderData(any, any, any, captureAny));
        verification.called(1);

        final capturedItems = verification.captured.first
            as List<Tuple3<ItemCoreData, DocumentItemSpecificData, dynamic>>;
        expect(capturedItems, isEmpty);
      });
    });

    group('provesti and otmenit', () {
      const orderUuid = 'provesti-otmenit-uuid';
      final now = DateTime.now();

      OrderHeaderData createTestOrderHeader({bool isPosted = false}) {
        return OrderHeaderData(
          coreData: EntityCoreData(
            uuid: orderUuid,
            code: 'PO-123',
            displayName: 'Test Order for Posting',
            createdAt: now,
          ),
          docData: DocumentSpecificData(
            documentDate: now,
            status: DocumentStatus
                .completed, // Assume it must be completed to be posted
            isPosted: isPosted,
          ),
          orderData: const OrderSpecificData(
            clientId: 'client-uuid',
            carId: 'car-uuid',
          ),
        );
      }

      test('provesti should mark order as posted', () async {
        // Arrange
        final orderHeader = createTestOrderHeader(isPosted: false);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.provesti(orderUuid);

        // Assert
        final verification =
            verify(mockOrdersDao.saveFullOrderData(any, captureAny, any, any));
        verification.called(1);
        final capturedDocData =
            verification.captured.first as DocumentSpecificData;
        expect(capturedDocData.isPosted, isTrue);
      });

      test('otmenit should mark order as not posted', () async {
        // Arrange
        final orderHeader = createTestOrderHeader(isPosted: true);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);
        when(mockOrdersDao.saveFullOrderData(any, any, any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await orderService.otmenit(orderUuid);

        // Assert
        final verification =
            verify(mockOrdersDao.saveFullOrderData(any, captureAny, any, any));
        verification.called(1);
        final capturedDocData =
            verification.captured.first as DocumentSpecificData;
        expect(capturedDocData.isPosted, isFalse);
      });

      test('provesti should do nothing if order is already posted', () async {
        // Arrange
        final orderHeader = createTestOrderHeader(isPosted: true);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);

        // Act
        await orderService.provesti(orderUuid);

        // Assert
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });

      test('otmenit should do nothing if order is not posted', () async {
        // Arrange
        final orderHeader = createTestOrderHeader(isPosted: false);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid))
            .thenAnswer((_) async => orderHeader);
        when(mockOrdersDao.getOrderItems(orderUuid))
            .thenAnswer((_) async => []);

        // Act
        await orderService.otmenit(orderUuid);

        // Assert
        verifyNever(mockOrdersDao.saveFullOrderData(any, any, any, any));
      });
    });

    group('Search and Filter', () {
      const orderUuid1 = 'search-uuid-1';
      const orderUuid2 = 'search-uuid-2';
      final now = DateTime.now();

      final orderHeader1 = OrderHeaderData(
        coreData: EntityCoreData(
            uuid: orderUuid1,
            code: 'S-001',
            displayName: 'First Order',
            createdAt: now),
        docData: DocumentSpecificData(
            documentDate: now, status: DocumentStatus.inProgress),
        orderData:
            const OrderSpecificData(clientId: 'client-1', carId: 'car-1'),
      );
      final orderHeader2 = OrderHeaderData(
        coreData: EntityCoreData(
            uuid: orderUuid2,
            code: 'S-002',
            displayName: 'Second Order',
            createdAt: now),
        docData: DocumentSpecificData(
            documentDate: now, status: DocumentStatus.completed),
        orderData:
            const OrderSpecificData(clientId: 'client-2', carId: 'car-2'),
      );

      test('getOrdersByStatus should return orders with the specified status',
          () async {
        // Arrange
        const statusToFetch = DocumentStatus.inProgress;
        when(mockOrdersDao.getOrderUuidsByStatus(statusToFetch))
            .thenAnswer((_) async => [orderUuid1]);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid1))
            .thenAnswer((_) async => orderHeader1);
        when(mockOrdersDao.getOrderItems(orderUuid1))
            .thenAnswer((_) async => []);

        // Act
        final result = await orderService.getOrdersByStatus(statusToFetch);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.uuid, orderUuid1);
        expect(result.first.status, statusToFetch);
        verify(mockOrdersDao.getOrderUuidsByStatus(statusToFetch)).called(1);
      });

      test('searchOrders should return orders matching the query', () async {
        // Arrange
        const query = 'First';
        when(mockOrdersDao.searchOrderUuids(query))
            .thenAnswer((_) async => [orderUuid1]);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid1))
            .thenAnswer((_) async => orderHeader1);
        when(mockOrdersDao.getOrderItems(orderUuid1))
            .thenAnswer((_) async => []);

        // Act
        final result = await orderService.searchOrders(query);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.uuid, orderUuid1);
        verify(mockOrdersDao.searchOrderUuids(query)).called(1);
      });

      test('getOrdersByClientUuid should return orders for a specific client',
          () async {
        // Arrange
        const clientId = 'client-1';
        when(mockOrdersDao.getOrderUuidsByClientUuid(clientId))
            .thenAnswer((_) async => [orderUuid1]);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid1))
            .thenAnswer((_) async => orderHeader1);
        when(mockOrdersDao.getOrderItems(orderUuid1))
            .thenAnswer((_) async => []);

        // Act
        final result = await orderService.getOrdersByClientUuid(clientId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.clientId, clientId);
        verify(mockOrdersDao.getOrderUuidsByClientUuid(clientId)).called(1);
      });

      test('getOrdersByCarUuid should return orders for a specific car',
          () async {
        // Arrange
        const carId = 'car-2';
        when(mockOrdersDao.getOrderUuidsByCarUuid(carId))
            .thenAnswer((_) async => [orderUuid2]);
        when(mockOrdersDao.getOrderHeaderByUuid(orderUuid2))
            .thenAnswer((_) async => orderHeader2);
        when(mockOrdersDao.getOrderItems(orderUuid2))
            .thenAnswer((_) async => []);

        // Act
        final result = await orderService.getOrdersByCarUuid(carId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.carId, carId);
        verify(mockOrdersDao.getOrderUuidsByCarUuid(carId)).called(1);
      });
    });
  });
}