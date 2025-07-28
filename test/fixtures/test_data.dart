import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/core/document_status.dart';

/// Тестовые данные для использования в тестах
class TestData {
  // Тестовые клиенты
  static final ClientModelComposite testClientPhysical =
      ClientModelComposite.create(
    code: 'TEST001',
    displayName: 'Иван Петров',
    type: ClientType.physical,
    contactInfo: '+7 (900) 123-45-67',
    additionalInfo: 'Тестовый физический клиент',
  );

  static final ClientModelComposite testClientLegal =
      ClientModelComposite.create(
    code: 'TEST002',
    displayName: 'ООО "Тест Компани"',
    type: ClientType.legal,
    contactInfo: 'test@company.ru',
    additionalInfo: 'Тестовая юридическая компания',
  );

  static final ClientModelComposite testClientEntrepreneur =
      ClientModelComposite.create(
    code: 'TEST003',
    displayName: 'ИП Сидоров А.Б.',
    type: ClientType.individualEntrepreneur,
    contactInfo: '+7 (900) 987-65-43',
    additionalInfo: null,
  );

  // Список тестовых клиентов
  static final List<ClientModelComposite> testClients = [
    testClientPhysical,
    testClientLegal,
    testClientEntrepreneur,
  ];

  // Тестовые автомобили
  static final CarModelComposite testCar1 = CarModelComposite.create(
    code: 'CAR001',
    displayName: 'Toyota Camry (А123БВ77)',
    licensePlate: 'А123БВ77',
    make: 'Toyota',
    model: 'Camry',
    year: 2020,
    vin: '1HGBH41JXMN109186',
    clientId: testClientPhysical.uuid,
    additionalInfo: 'Тестовый автомобиль 1',
  );

  static final CarModelComposite testCar2 = CarModelComposite.create(
    code: 'CAR002',
    displayName: 'BMW X5 (В456ГД77)',
    licensePlate: 'В456ГД77',
    make: 'BMW',
    model: 'X5',
    year: 2019,
    vin: '2HGBH41JXMN109187',
    clientId: testClientLegal.uuid,
    additionalInfo: null,
  );

  static final List<CarModelComposite> testCars = [
    testCar1,
    testCar2,
  ];

  // Тестовые заказ-наряды
  static final OrderModelComposite testOrder1 = OrderModelComposite.create(
    code: 'ORD-001',
    displayName: 'Заказ-наряд ORD-001',
    documentDate: DateTime.now(),
    description: 'Замена масла и фильтров',
    clientId: testClientPhysical.uuid,
    carId: testCar1.uuid,
    status: DocumentStatus.newDoc,
  );

  static final OrderModelComposite testOrder2 = OrderModelComposite.create(
    code: 'ORD-002',
    displayName: 'Заказ-наряд ORD-002',
    documentDate: DateTime.now(),
    description: 'Диагностика двигателя',
    clientId: testClientLegal.uuid,
    carId: testCar2.uuid,
    status: DocumentStatus.inProgress,
  );

  static final List<OrderModelComposite> testOrders = [
    testOrder1,
    testOrder2,
  ];

  // Методы для создания копий с изменениями
  static ClientModelComposite createTestClient({
    String? code,
    String? displayName,
    ClientType? type,
    String? contactInfo,
    String? additionalInfo,
  }) {
    return ClientModelComposite.create(
      code: code ?? 'TEST_${DateTime.now().millisecondsSinceEpoch}',
      displayName: displayName ?? 'Тестовый клиент',
      type: type ?? ClientType.physical,
      contactInfo: contactInfo ?? '+7 (900) 000-00-00',
      additionalInfo: additionalInfo,
    );
  }

  static CarModelComposite createTestCar({
    String? code,
    String? displayName,
    String? licensePlate,
    String? make,
    String? model,
    int? year,
    String? vin,
    String? clientId,
    String? additionalInfo,
  }) {
    return CarModelComposite.create(
      code: code ?? 'CAR_${DateTime.now().millisecondsSinceEpoch}',
      displayName: displayName ?? 'Test Car',
      licensePlate: licensePlate ?? 'Т000ЕС77',
      make: make ?? 'Test Make',
      model: model ?? 'Test Model',
      year: year ?? 2023,
      vin: vin ?? 'TEST_VIN_${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId ?? testClientPhysical.uuid,
      additionalInfo: additionalInfo,
    );
  }

  static OrderModelComposite createTestOrder({
    String? code,
    String? displayName,
    String? description,
    String? clientId,
    String? carId,
    DocumentStatus? status,
  }) {
    return OrderModelComposite.create(
      code: code ?? 'TEST-${DateTime.now().millisecondsSinceEpoch}',
      displayName: displayName ?? 'Тестовый заказ-наряд',
      documentDate: DateTime.now(),
      description: description ?? 'Тестовый заказ-наряд',
      clientId: clientId ?? testClientPhysical.uuid,
      carId: carId ?? testCar1.uuid,
      status: status ?? DocumentStatus.newDoc,
    );
  }

  // Методы для получения списков с различными сценариями
  static List<ClientModelComposite> getEmptyClientsList() => [];
  
  static List<ClientModelComposite> getSingleClientList() => [testClientPhysical];
  
  static List<ClientModelComposite> getLargeClientsList() => List.generate(
    100,
    (index) => createTestClient(
      code: 'TEST${index.toString().padLeft(3, '0')}',
      displayName: 'Тестовый клиент $index',
    ),
  );

  // Методы для поиска
  static List<ClientModelComposite> searchClients(String query) {
    return testClients.where((client) =>
      client.displayName.toLowerCase().contains(query.toLowerCase()) ||
      client.code.toLowerCase().contains(query.toLowerCase()) ||
      client.contactInfo.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Интеграционные тестовые данные
  static final Map<String, dynamic> integrationTestData = {
    'orders': {
      'empty': [],
      'loading': null,
      'error': Exception('Ошибка загрузки заказов'),
      'sample': testOrders,
    },
    'clients': {
      'empty': [],
      'loading': null,
      'error': Exception('Ошибка загрузки клиентов'),
      'sample': testClients,
    },
    'cars': {
      'empty': [],
      'loading': null,
      'error': Exception('Ошибка загрузки автомобилей'),
      'sample': testCars,
    },
  };

  // Сценарии для интеграционных тестов
  static const Map<String, Map<String, dynamic>> integrationScenarios = {
    'happy_path': {
      'description': 'Успешный путь пользователя',
      'steps': [
        'Открыть список клиентов',
        'Выбрать клиента',
        'Создать новый заказ',
        'Добавить услуги и запчасти',
        'Сохранить заказ',
      ],
    },
    'error_handling': {
      'description': 'Обработка ошибок',
      'steps': [
        'Отсутствие интернет соединения',
        'Ошибка сервера',
        'Некорректные данные',
        'Тайм-аут операции',
      ],
    },
    'edge_cases': {
      'description': 'Граничные случаи',
      'steps': [
        'Пустые списки данных',
        'Очень длинные строки',
        'Специальные символы',
        'Максимальные значения',
      ],
    },
  };

  // Тестовые пользовательские сценарии
  static final List<Map<String, dynamic>> userJourneys = [
    {
      'name': 'Создание заказа от начала до конца',
      'steps': [
        {'action': 'navigate_to', 'screen': 'clients'},
        {'action': 'select_client', 'clientId': testClientPhysical.uuid},
        {'action': 'create_order', 'data': {'description': 'Ремонт двигателя'}},
        {'action': 'add_service', 'data': {'name': 'Диагностика', 'price': 1500}},
        {'action': 'add_part', 'data': {'name': 'Масло', 'price': 800}},
        {'action': 'save_order'},
        {'action': 'verify_order_created'},
      ],
    },
    {
      'name': 'Поиск и редактирование клиента',
      'steps': [
        {'action': 'navigate_to', 'screen': 'clients'},
        {'action': 'search', 'query': 'Иван'},
        {'action': 'select_client', 'clientId': testClientPhysical.uuid},
        {'action': 'edit_client', 'data': {'phone': '+7 (900) 111-22-33'}},
        {'action': 'save_client'},
        {'action': 'verify_client_updated'},
      ],
    },
  ];
}
