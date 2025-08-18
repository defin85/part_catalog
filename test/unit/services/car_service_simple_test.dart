import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/models/car_specific_data.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';

import '../../mocks/mock_services.mocks.dart';
import '../../test_config.dart';

void main() {
  group('CarService Simple Unit Tests', () {
    late CarService carService;
    late MockAppDatabase mockDatabase;
    late MockCarsDao mockCarsDao;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockCarsDao = MockCarsDao();
      carService = CarService(mockDatabase);
    });

    group('watchActiveCars', () {
      test('should return stream of empty list', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        when(mockCarsDao.watchAllActiveCars())
            .thenAnswer((_) => Stream.value([]));

        // Act
        final stream = carService.watchActiveCars();
        final result = await stream.first;

        // Assert
        expect(result, isEmpty);
        verify(mockCarsDao.watchAllActiveCars()).called(1);
      });

      test('should call dao watchAllActiveCars method', () {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        when(mockCarsDao.watchAllActiveCars())
            .thenAnswer((_) => Stream.value([]));

        // Act
        carService.watchActiveCars();

        // Assert
        verify(mockCarsDao.watchAllActiveCars()).called(1);
      });
    });

    group('watchActiveClientCars', () {
      test('should call dao with correct client uuid', () {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const clientUuid = TestConstants.testUuid1;
        when(mockCarsDao.watchActiveClientCars(any))
            .thenAnswer((_) => Stream.value([]));

        // Act
        carService.watchActiveClientCars(clientUuid);

        // Assert
        verify(mockCarsDao.watchActiveClientCars(clientUuid)).called(1);
      });

      test('should handle different client uuids', () {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const clientUuid1 = TestConstants.testUuid1;
        const clientUuid2 = TestConstants.testUuid2;
        when(mockCarsDao.watchActiveClientCars(any))
            .thenAnswer((_) => Stream.value([]));

        // Act
        carService.watchActiveClientCars(clientUuid1);
        carService.watchActiveClientCars(clientUuid2);

        // Assert
        verify(mockCarsDao.watchActiveClientCars(clientUuid1)).called(1);
        verify(mockCarsDao.watchActiveClientCars(clientUuid2)).called(1);
      });
    });

    group('getCarByUuid', () {
      test('should return null when car not found', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const carUuid = TestConstants.testUuid1;
        when(mockCarsDao.getCarByUuid(any)).thenAnswer((_) async => null);

        // Act
        final result = await carService.getCarByUuid(carUuid);

        // Assert
        expect(result, isNull);
        verify(mockCarsDao.getCarByUuid(carUuid)).called(1);
      });

      test('should call dao with correct car uuid', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const carUuid = TestConstants.testUuid1;
        when(mockCarsDao.getCarByUuid(any)).thenAnswer((_) async => null);

        // Act
        await carService.getCarByUuid(carUuid);

        // Assert
        verify(mockCarsDao.getCarByUuid(carUuid)).called(1);
      });
    });

    group('addCar', () {
      test('should throw exception when car uuid is empty', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        final mockCar = MockCarModelComposite();
        when(mockCar.uuid).thenReturn('');

        // Act & Assert
        expect(
          () async => await carService.addCar(mockCar),
          throwsException,
        );
      });

      test('should call dao insertCar when car has valid uuid', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        final mockCar = MockCarModelComposite();
        final mockCoreData = MockEntityCoreData();
        final mockCarData = MockCarSpecificData();

        when(mockCar.uuid).thenReturn(TestConstants.testUuid1);
        when(mockCar.coreData).thenReturn(mockCoreData);
        when(mockCar.carData).thenReturn(mockCarData);
        when(mockCarsDao.insertCar(any, any)).thenAnswer((_) async => 1);

        // Act
        final result = await carService.addCar(mockCar);

        // Assert
        expect(result, equals(TestConstants.testUuid1));
        verify(mockCarsDao.insertCar(mockCoreData, mockCarData)).called(1);
      });
    });

    group('isVinUnique', () {
      test('should return true when vin not found', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const vin = 'TEST123456789VIN';
        when(mockCarsDao.getCarByVin(any)).thenAnswer((_) async => null);

        // Act
        final result = await carService.isVinUnique(vin);

        // Assert
        expect(result, isTrue);
        verify(mockCarsDao.getCarByVin(vin)).called(1);
      });

      test('should call dao with correct vin parameter', () async {
        // Arrange
        when(mockDatabase.carsDao).thenReturn(mockCarsDao);
        const vin = 'TEST123456789VIN';
        when(mockCarsDao.getCarByVin(any)).thenAnswer((_) async => null);

        // Act
        await carService.isVinUnique(vin);

        // Assert
        verify(mockCarsDao.getCarByVin(vin)).called(1);
      });
    });
  });
}

// Простые моки для тестирования
class MockCarModelComposite extends Mock implements CarModelComposite {
  @override
  String get uuid =>
      super.noSuchMethod(Invocation.getter(#uuid), returnValue: '');

  @override
  EntityCoreData get coreData =>
      super.noSuchMethod(Invocation.getter(#coreData),
          returnValue: MockEntityCoreData());

  @override
  CarSpecificData get carData => super.noSuchMethod(Invocation.getter(#carData),
      returnValue: MockCarSpecificData());
}

class MockEntityCoreData extends Mock implements EntityCoreData {}

class MockCarSpecificData extends Mock implements CarSpecificData {}