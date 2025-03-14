# part_catalog

## 1. Техническое задание:

Приложение предназначено для работников станции технического обслуживания автомобилей (СТО) и должно обеспечивать:

*   Учёт клиентов (физические и юридические лица).
*   Учёт ремонтируемого автотранспорта.
*   Учёт заявок (заказ-нарядов), оформляемых работником СТО, с информацией о:
    *   Дате.
    *   Автомобиле.
    *   Клиенте.
    *   Произведенной работе.
    *   Использованных запчастях и материалах.
*   Подбор запчастей для ремонта автомобиля с использованием `ApiClientPartsCatalogs`.
*   Отправку подобранных запчастей (артикулов) в другой RestAPI поставщика запчастей для получения информации о ценах и сроках поставки.
*   Возврат полученных данных о ценах и сроках поставки в заказ-наряд для дальнейшей передачи в заказ поставщику.

## 2. Архитектура приложения:

**Слои:**

*   **UI (Presentation Layer):** Содержит виджеты Flutter, экраны и логику пользовательского интерфейса.
*   **Business Logic Layer (BLL):** Управляет бизнес-логикой приложения, взаимодействует с API, обрабатывает данные и управляет состоянием. Можно использовать Provider, BLoC или Riverpod для управления состоянием.
*   **Data Layer:** Содержит репозитории, API-клиенты (например, `ApiClientPartsCatalogs`) и модели данных. Отвечает за получение и отправку данных.
*   **Core:** Содержит общие компоненты, такие как сервис-локатор, утилиты и модели данных.

**Управление состоянием:**

Используйте Provider, BLoC или Riverpod для управления состоянием приложения. Это поможет вам разделить логику пользовательского интерфейса и бизнес-логику, а также упростить тестирование и поддержку.

**Сервис-локатор:**

Используйте `get_it` (как вы уже делаете) для внедрения зависимостей и обеспечения доступа к общим сервисам, таким как `ApiClientPartsCatalogs`.

**API-клиенты:**

*   `ApiClientPartsCatalogs` для взаимодействия с API каталогов запчастей.
*   Отдельный API-клиент для взаимодействия с API поставщика запчастей (для получения цен и сроков поставки).

**Модели данных:**

* **Client** - модель клиента, содержит:
  * id: уникальный идентификатор
  * type: тип клиента (ClientType)
  * name: ФИО/наименование
  * contactInfo: контактная информация
  * additionalInfo: дополнительная информация

* **ClientType** - перечисление, определяющее тип клиента:
  * physical - Физическое лицо
  * legal - Юридическое лицо
  * individualEntrepreneur - Индивидуальный предприниматель
  * other - Другое
  * С расширениями:
    * displayName - получение человекочитаемого названия
    * fromString - создание из строкового представления
    * toShortString - получение короткого строкового представления

*   Новые модели для представления клиентов, автомобилей, заказ-нарядов, позиций в заказ-наряде, поставщиков и т.д.

**Локальная база данных (опционально):**

Используйте SQLite (через `sqflite`) или Hive для локального хранения данных, таких как клиенты, автомобили и заказ-наряды. Это позволит приложению работать в автономном режиме и повысит производительность.

## 3. Структура пользовательского интерфейса:

**Главный экран:**

*   Навигационная панель или Drawer для доступа к основным разделам приложения.
*   Разделы:
    *   **Клиенты:** Управление клиентами (добавление, редактирование, просмотр).
    *   **Автомобили:** Управление автомобилями (добавление, редактирование, просмотр).
    *   **Заказ-наряды:** Создание, редактирование, просмотр заказ-нарядов.
    *   **Подбор запчастей:** Интеграция с `ApiClientPartsCatalogs` для поиска и выбора запчастей
    *   **Поставщики:** Управление поставщиками (опционально).
    *   **Настройки:** Настройки приложения (например, API-ключи, язык).

**Экран управления клиентами:**

*   Список клиентов.
*   Кнопка "Добавить клиента".
*   Форма для добавления/редактирования клиента (ФИО, контактные данные, тип клиента - физическое/юридическое лицо).

**Экран управления автомобилями:**

*   Список автомобилей.
*   Кнопка "Добавить автомобиль".
*   Форма для добавления/редактирования автомобиля (VIN, марка, модель, год выпуска, клиент-владелец).

**Экран управления заказ-нарядами:**

*   Список заказ-нарядов.
*   Кнопка "Создать заказ-наряд".
*   Форма для создания/редактирования заказ-наряда:
    *   Дата.
    *   Клиент.
    *   Автомобиль.
    *   Описание проблемы.
    *   Список работ.
    *   Список запчастей (с возможностью добавления из `ApiClientPartsCatalogs` и получения цен от API поставщика).
    *   Общая стоимость.
    *   Статус (например, "Создан", "В работе", "Завершен").

**Экран подбора запчастей:**

*   Интеграция с `CarInfoWidget` для поиска автомобиля по VIN/FRAME.
*   Список каталогов.
*   Список групп запчастей.
*   Список запчастей.
*   Возможность добавления запчастей в заказ-наряд.

**Компоненты пользовательского интерфейса:**

*   Используйте Material Design или Cupertino (в зависимости от платформы) для создания единообразного и привлекательного пользовательского интерфейса.
*   Используйте `TextField` для ввода данных.
*   Используйте `DropdownButton` или `Autocomplete` для выбора клиентов, автомобилей и запчастей.
*   Используйте `ListView` или `GridView` для отображения списков данных.
*   Используйте `Card` для отображения информации об отдельных элементах (например, клиенте, автомобиле, запчасти).
*   Используйте `AlertDialog` для отображения сообщений об ошибках и подтверждений.
*   Используйте `ProgressIndicator` для отображения индикаторов загрузки.

## 4. Особенности реализации и улучшения:

**База данных:**

*   Добавлена система мягкого удаления записей (soft delete) через поле `deletedAt`
*   Реализован механизм синхронизации схемы БД с автоматическим добавлением отсутствующих таблиц и колонок
*   Добавлено логирование SQL-запросов и транзакций через декоратор `DatabaseLogger`
*   Использование индексов для оптимизации запросов

**DAO и сервисы:**

*   Для каждой таблицы создан соответствующий DAO-класс с методами доступа к данным
*   Сервисные классы инкапсулируют бизнес-логику и преобразуют модели таблиц в бизнес-модели
*   Реализованы потоки (Stream) для реактивного обновления UI

**Оптимизации:**

*   Исключение избыточных обновлений UI через использование реактивных потоков
*   Использование индексов для оптимизации запросов
*   Сокращение числа запросов к БД через агрегирующие методы (например, `getCarsWithOwners`)

**Безопасная работа с асинхронным кодом:**

* Применение паттерна сохранения состояния (state retention) для объектов, зависящих от контекста
* Защита вызовов `setState()` и доступа к контексту проверкой `mounted`
* Использование `addPostFrameCallback` для инициации асинхронных операций после отрисовки фрейма
* Применение паттерна "try-catch-finally" для эффективной обработки ошибок в асинхронных операциях
* Обеспечение плавной деградации интерфейса при асинхронных сбоях

## 5. Интеграция с API поставщика запчастей:

*   Создайте отдельный API-клиент (например, `SupplierApiClient`) для взаимодействия с API поставщика запчастей.
*   Определите модели данных для представления цен и сроков поставки запчастей.
*   В экране управления заказ-нарядами добавьте возможность отправки списка артикулов запчастей в `SupplierApiClient` и отображения полученных цен и сроков поставки.

```
lib/
  features/
    suppliers/
      api/
        base_supplier_api_client.dart  # Общий интерфейс для клиента и сервера
        implementations/               # Общие реализации
          autodoc_api_client.dart
          exist_api_client.dart
          emex_api_client.dart
      models/                         # Общие модели данных
        base/
          part_price_response.dart
      repositories/                   # Общие репозитории
        supplier_repository.dart
  core/
    config/
      app_config.dart                 # Общая конфигурация
    utils/
      logger_config.dart              # Общее логирование
  client/                             # Код только для клиента
    client_service_locator.dart
    ui/
      screens/
        supplier_screen.dart
  server/                             # Код только для сервера
    proxy_server.dart
    server_service_locator.dart
    cache/
      redis_cache_manager.dart
```

**Базовый интерфейс:**
```dart
abstract class SupplierApiClient {
  Future<List<PartPriceModel>> getPricesByArticle(String article);
  // Общие методы для всех API
}
```

**Конкретные реализации:**
```dart
class AutodocApiClient implements SupplierApiClient {
  final Dio _dio;
  
  AutodocApiClient(this._dio);
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    // Реализация для Autodoc
  }
}
```

**Базовые модели:**
```dart
class PartPriceModel {
  final String partNumber;
  final String name;
  final double price;
  final int deliveryDays;
  final String supplierName;
  
  PartPriceModel({
    required this.partNumber,
    required this.name,
    required this.price,
    required this.deliveryDays,
    required this.supplierName,
  });
  
  // Можно добавить фабрику для создания из JSON
}
```
**Специфичные модели поставщика:**
```dart
class AutodocPriceResponse {
  final List<AutodocPartItem> items;
  
  AutodocPriceResponse({required this.items});
  
  factory AutodocPriceResponse.fromJson(Map<String, dynamic> json) {
    // Парсинг специфичного JSON от Autodoc
  }
  
  // Метод преобразования в общий формат
  List<PartPriceModel> toPartPriceModels() {
    return items.map((item) => PartPriceModel(
      partNumber: item.number,
      name: item.description,
      price: item.price,
      deliveryDays: item.deliveryTime,
      supplierName: 'Autodoc',
    )).toList();
  }
}
```

**Фабрики и сервисы-агрегаторы:**
```dart
/// Агрегирующий сервис для работы со всеми API поставщиков
class SuppliersService {
  /// Коллекция клиентов API поставщиков, где ключ - идентификатор поставщика, 
  /// а значение - экземпляр API-клиента
  final Map<String, SupplierApiClient> _clients;

  /// Создает сервис с указанной коллекцией API-клиентов поставщиков
  SuppliersService(this._clients);

  /// Получает цены на запчасть по артикулу у всех поставщиков одновременно
  ///
  /// Возвращает карту, где ключ - идентификатор поставщика, 
  /// а значение - список найденных предложений
  Future<Map<String, List<PartPriceModel>>> getAllPricesByArticle(String article) async {
    final results = <String, List<PartPriceModel>>{};
    
    await Future.wait(_clients.entries.map((entry) async {
      try {
        final prices = await entry.value.getPricesByArticle(article);
        results[entry.key] = prices;
      } catch (e, stackTrace) {
        AppLoggers.suppliersLogger.e(
          'Ошибка получения цен от поставщика ${entry.key}', 
          e, 
          stackTrace
        );
        results[entry.key] = [];
      }
    }));
    
    return results;
  }
  
  /// Получает лучшие цены для каждой запчасти по артикулу
  /// 
  /// Объединяет результаты от всех поставщиков и находит лучшие предложения
  Future<List<PartPriceModel>> getBestPricesByArticle(String article) async {
    final allPricesMap = await getAllPricesByArticle(article);
    
    // Объединяем все результаты от разных поставщиков в один список
    final allPrices = allPricesMap.values.expand((prices) => prices).toList();
    
    if (allPrices.isEmpty) {
      return [];
    }
    
    // Группируем предложения по артикулу и названию (для аналогов)
    final groupedPrices = <String, List<PartPriceModel>>{};
    
    for (final price in allPrices) {
      final key = '${price.partNumber}_${price.name.toLowerCase()}';
      groupedPrices.putIfAbsent(key, () => []).add(price);
    }
    
    // Находим лучшие предложения (с минимальной ценой) в каждой группе
    final bestPrices = groupedPrices.values.map((pricesList) {
      return pricesList.reduce((best, current) => 
        current.price < best.price ? current : best
      );
    }).toList();
    
    // Сортируем по цене (от меньшей к большей)
    bestPrices.sort((a, b) => a.price.compareTo(b.price));
    
    return bestPrices;
  }
  
  /// Возвращает список доступных поставщиков
  List<String> getAvailableSuppliers() {
    return _clients.keys.toList();
  }
  
  /// Проверяет, доступен ли указанный поставщик
  bool isSupplierAvailable(String supplierName) {
    return _clients.containsKey(supplierName);
  }
}
```

**DI и регистрация в сервис-локаторе:**
```dart
void setupSupplierServices() {
  // Регистрируем отдельные API клиенты
  locator.registerLazySingleton<AutodocApiClient>(
    () => AutodocApiClient(locator<Dio>())
  );
  
  locator.registerLazySingleton<ExistApiClient>(
    () => ExistApiClient(locator<Dio>())
  );
  
  locator.registerLazySingleton<EmexApiClient>(
    () => EmexApiClient(locator<Dio>())
  );
  
  // Регистрируем агрегирующий сервис с Map всех поставщиков
  locator.registerLazySingleton<SuppliersService>(
    () => SuppliersService({
      'autodoc': locator<AutodocApiClient>(),
      'exist': locator<ExistApiClient>(),
      'emex': locator<EmexApiClient>(),
    }),
  );
}
```

## 6. Примерная структура проекта:

```
lib/
  features/
    parts_catalog/
      api/
      models/
      screens/
      widgets/
    clients/
      models/
      screens/
      services/
    vehicles/
    orders/
    suppliers/
  core/
    service_locator.dart
    database/
    utils/
  main.dart
```

## 7. Текущий статус реализации

**Реализовано:**
* Базовая структура проекта по предметным областям (features)
* API-клиент для каталога запчастей (`ApiClientPartsCatalogs`)
* Основные модели для работы с каталогом запчастей
* База данных (Drift) с таблицами `ClientsItems` и `CarsItems`
* DAO-классы для работы с данными
* Сервисные классы для клиентов и автомобилей
* Реактивные экраны для работы с клиентами и автомобилями
* Механизм синхронизации схемы БД
* Система логирования SQL-запросов

**В процессе:**
* Улучшение UI клиентов и автомобилей
* Интеграция каталога запчастей с заказ-нарядами
* Разработка заказ-нарядов

**Следующие шаги:**
* Завершение базового функционала клиентов и автомобилей
* Переход к разработке заказ-нарядов
* Интеграция выбора запчастей в заказ-наряды

## 8. Соглашения по кодированию и шаблоны

**Именование:**
* Файлы: snake_case (например, `car_info_widget.dart`)
* Классы: PascalCase (например, `ApiClientPartsCatalogs`)
* Методы и переменные: camelCase (например, `getClientById`)
* Константы: SCREAMING_SNAKE_CASE (например, `API_BASE_URL`)

**Суффиксы/Префиксы**
* Модели: суффикс `Model` - `CarModel`, `OrderModel`
* Абстракции/Интерфейсы: префикс `I` или суффикс `Interface` - `IApiClient` или `ApiClientInterface`
* Миксины: суффикс `Mixin` - `LoggingMixin`
* Репозитории: суффикс `Repository` - `PartsRepository`
* Провайдеры: суффикс `Provider` - `AuthProvider`
* API-клиенты: суффикс `ApiClient` - `AutodocApiClient`

**Структура файлов:**
* Один класс на файл, когда это возможно
* Файлы с моделями данных должны содержать класс и его вспомогательные методы
* Имена файлов должны соответствовать основному классу в них

**Документация:**
* Используйте документационные комментарии `///` для публичных API
* Используйте dart-doc теги `{@template}` и `{@macro}` для переиспользуемых описаний

**Архитектурные особенности:**
* DAO классы отвечают только за доступ к данным
* Сервисные классы преобразуют модели БД в бизнес-модели и обратно
* Бизнес-логика сосредоточена в сервисных классах
* UI использует реактивные потоки для отображения данных

**Асинхронные операции и BuildContext:**

* Избегайте использования `BuildContext` после асинхронных операций без проверки `mounted`
* Сохраняйте ссылки на объекты, зависящие от контекста, перед асинхронными операциями:
  ```dart
  // Правильно:
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  
  try {
    final result = await someAsyncOperation();
    if (mounted) {
      // Безопасное использование setState
      setState(() { ... });
      // Используем сохраненные ранее ссылки
      scaffoldMessenger.showSnackBar(...);
    }
  } catch (error) {
    if (mounted) {
      // Используем сохраненные ссылки вместо получения новых
      scaffoldMessenger.showSnackBar(...);
      navigator.pop();
    }
  }
  ```

* В widget-тестах используйте `tester.pumpAndSettle()` после асинхронных операций
* Используйте `WidgetsBinding.instance.addPostFrameCallback` для запуска асинхронных операций после построения интерфейса
* При использовании `FutureBuilder` и `StreamBuilder`, всегда обрабатывайте состояния загрузки (ConnectionState.waiting) и ошибки

**Примеры:**

Пример сервиса:
```dart
/// {@template client_service}
/// Сервис для управления клиентами в базе данных.
/// {@endtemplate}
class ClientService {
  /// {@macro client_service}
  ClientService(this._database);
  
  final AppDatabase _database;
  
  /// Возвращает список всех клиентов.
  Future<List<Client>> getClients() async {
    // реализация
  }
}
```

## 9. Приоритеты и план разработки

1. **Этап 1: Фундамент (текущий)**
   * Настройка базы данных ✅
   * Базовая структура проекта ✅
   * API-клиенты для внешних сервисов ✅

2. **Этап 2: CRUD-операции для основных сущностей**
   * Реализация моделей данных для всех сущностей
   * Реализация репозиториев/сервисов для работы с данными
   * Базовые экраны для работы с сущностями

3. **Этап 3: Интеграция каталога запчастей**
   * Доработка экранов для выбора запчастей
   * Интеграция с заказ-нарядами

4. **Этап 4: Интеграция с API поставщиков**
   * Реализация API-клиента для поставщиков
   * Интеграция с заказ-нарядами

5. **Этап 5: Улучшение UX/UI и оптимизация**
   * Улучшение дизайна
   * Оптимизация производительности
   * Добавление функций поиска и фильтрации

## 10. Используемые технологии и зависимости

* **Основные:**
  * Flutter - фреймворк UI
  * Dart - язык программирования

* **Управление состоянием:**
  * Provider/BLoC/Riverpod (выбрать предпочтительный)

* **База данных:**
  * Drift (SQLite) - для хранения локальных данных

* **Сетевые запросы:**
  * Dio - HTTP-клиент для работы с API

* **Внедрение зависимостей:**
  * get_it - сервис-локатор

* **Кодогенерация:**
  * freezed - для иммутабельных моделей данных
  * json_serializable - для сериализации JSON
  * drift_dev - для генерации кода базы данных

* **Утилиты:**
  * flutter_dotenv - для переменных окружения
  * logger - для логирования
  * path_provider - для доступа к директориям файловой системы

## 11. Структура базы данных

База данных реализована с использованием Drift ORM для работы с SQLite. Определения таблиц находятся в директории `lib/core/database/items/`:

### Таблицы базы данных:

* **ClientsItems** - хранение информации о клиентах
  * id: уникальный идентификатор (INTEGER, PRIMARY KEY)
  * type: тип клиента (TEXT)
    * Возможные значения (через перечисление ClientType):
      * physical - Физическое лицо
      * legal - Юридическое лицо
      * individualEntrepreneur - Индивидуальный предприниматель
      * other - Другое
  * name: наименование клиента (TEXT)
  * contactInfo: контактная информация (TEXT)
  * additionalInfo: дополнительная информация (TEXT, nullable)
  * deletedAt: метка мягкого удаления (DATETIME, nullable)

* **CarsItems** - хранение информации об автомобилях
  * id: уникальный идентификатор (INTEGER, PRIMARY KEY)
  * clientId: владелец автомобиля (INTEGER, FOREIGN KEY → ClientsItems.id)
  * vin: VIN-код автомобиля (TEXT, nullable)
  * make: марка автомобиля (TEXT)
  * model: модель автомобиля (TEXT)
  * year: год выпуска (INTEGER, nullable)
  * licensePlate: госномер (TEXT, nullable)
  * additionalInfo: дополнительная информация (TEXT, nullable)
  * deletedAt: метка мягкого удаления (DATETIME, nullable)

* **AppInfoItems** - служебная таблица для метаданных приложения
  * key: ключ (TEXT, PRIMARY KEY)
  * value: значение (TEXT)

### Преобразования данных:

При работе с базой данных используется двухуровневая архитектура моделей:
1. Модели таблиц в БД - классы с суффиксом "Items" в директории `lib/core/database/items/`
2. Бизнес-модели - классы в директориях `lib/features/*/models/`

Преобразование между ними выполняется в сервисных классах через методы `_mapToModel` и `_mapToCompanion`.

### Маппинг между моделями:

**Маппинг между моделями базы данных и бизнес-моделями:**

| Модель БД (Items) | Бизнес-модель     |	Сервисный класс |	Методы преобразования |
|-------------------|-------------------|-----------------|-----------------------|
| ClientsItem       | Client            |	ClientService   |_mapToModel(ClientsItem) → Client<br>_mapToCompanion(Client, {withId}) → ClientsItemsCompanion
| CarsItem	        | CarModel          |	CarService      |_mapToModel(CarsItem) → CarModel<br>_mapToCompanion(CarModel) → CarsItemsCompanion
| CarWithOwner	    | CarWithOwnerModel |	CarService	    |_mapWithOwnerToModel(CarWithOwner) → CarWithOwnerModel
| OrdersItem        |	OrderModel        |	OrderService    |	_mapToModel(OrdersItem) → OrderModel<br>_mapToCompanion(OrderModel) → OrdersItemsCompanion
| OrderPartsItem    |	OrderPartModel    |	OrderService    |	_mapPartToModel(OrderPartsItem) → OrderPartModel<br>_mapPartToCompanion(OrderPartModel) → OrderPartsItemsCompanion
| OrderServicesItem |	OrderServiceModel |	OrderService    |	_mapServiceToModel(OrderServicesItem) → OrderServiceModel<br>_mapServiceToCompanion(OrderServiceModel) → OrderServicesItemsCompanion  
| SupplierItem      |	SupplierModel     |	SupplierService |	_mapToModel(SupplierItem) → SupplierModel<br>_mapToCompanion(SupplierModel) → SupplierItemsCompanion

**Пример маппинга для моделей клиентов:**

| ClientsItem (БД)        |	Client (Бизнес)         |	Примечания        |
| id: int	                |	id: int                 |	Первичный ключ    |
| type: String	          |	type: ClientType	      |	Преобразуется с использованием ClientTypeExtension.fromString()
| name: String	          |	name: String	          |	Имя/наименование  |
| contactInfo: String	    |	contactInfo: String	    |	Контактная информация |
| additionalInfo: String?	|	additionalInfo: String?	|	Дополнительная информация (nullable)  |
| deletedAt: DateTime?    |	-                       |	Не отражается в бизнес-модели, используется только для фильтрации  |

**Пример маппинга для моделей автомобилей:**

| CarsItem (БД)           | CarModel (Бизнес)       |	Примечания  |
| id: int	                |	id: String	            |	Преобразуется в строку для совместимости с UI |
| clientId: int	          |	clientId: String	      |	Преобразуется в строку для совместимости с UI |
| vin: String?            |	vin: String             |	Пустая строка вместо null для упрощения работы в UI |
| make: String	          |	make: String	          |	Марка автомобиля |
| model: String	          |	model: String	          |	Модель автомобиля |
| year: int?	            |	year: int               |	0 вместо null для упрощения работы в UI |
| licensePlate: String?	  |	 licensePlate: String	  |	Пустая строка вместо null для упрощения работы в UI |
| additionalInfo: String?	|	additionalInfo: String	|	Пустая строка вместо null для упрощения работы в UI |
| deletedAt: DateTime?    |	-                       |	Не отражается в бизнес-модели, используется только для фильтрации |

**Сложные маппинги**
CarWithOwner → CarWithOwnerModel
```dart
CarWithOwnerModel _mapWithOwnerToModel(CarWithOwner item) {
  return CarWithOwnerModel(
    car: _mapToModel(item.car),  // Использует базовое преобразование CarsItem → CarModel
    ownerName: item.ownerName,
    ownerType: item.ownerType,
  );
}
```
### Рекомендации по реализации маппинга:

**Разделение приватных/публичных методов:**

  * Методы маппинга внутри сервисов делать приватными (_mapToModel)
  * Для сложных случаев, когда требуется преобразование вне сервисов, создать публичные методы в отдельных классах

**Обработка null значений:**

  * В бизнес-моделях использовать пустые строки вместо null для текстовых полей
  * Для числовых полей использовать значения по умолчанию (0, -1) вместо null
  * Оснастить методы маппинга проверками null

**Обработка ошибок:**

  * Добавить логирование при неожиданных ситуациях в методы маппинга
  * Использовать значения по умолчанию при отсутствии данных

**Обеспечение корректности типов:**

  * При преобразовании числовых идентификаторов в строки использовать явное преобразование
  * При обратном преобразовании использовать обработку исключений

### Особенности работы с данными:

* Использование реактивных потоков через `watchActiveClients()` и `watchAllCars()`
* Мягкое удаление через установку поля `deletedAt` вместо физического удаления записей
* Каскадное удаление автомобилей при удалении клиента (на уровне бизнес-логики)
* Использование транзакций для атомарных операций с несколькими таблицами
* Оптимизация запросов через индексы

## 12. Кроссплатформенная адаптация UI

Приложение должно корректно работать как на мобильных устройствах (Android, iOS), так и на десктопных платформах (Windows, macOS, Linux). Это требует адаптивного подхода к разработке интерфейса.

### Адаптивные компоненты UI:

**Списки:**
  * Для мобильных устройств: использовать `ListView` с карточками (`Card`) для элементов списка, с поддержкой свайпа для основных действий
  * Для десктопных платформ: использовать `DataTable` с возможностью сортировки, фильтрации и горизонтальной прокрутки

**Навигация:**
  * Для мобильных устройств: `BottomNavigationBar` или `Drawer`
  * Для десктопных платформ: постоянно видимая боковая панель (`Sidebar`) и верхняя навигация

**Формы:**
  * Для мобильных устройств: однострочные поля и последовательная компоновка (один элемент под другим)
  * Для десктопных платформ: многоколоночный макет с горизонтальным группированием полей

**Модальные окна:**
  * Для мобильных устройств: полноэкранные страницы или модальные нижние листы (`BottomSheet`)
  * Для десктопных платформ: диалоговые окна (`Dialog`) и всплывающие панели

### Определение типа платформы:

```dart
bool isDesktopPlatform(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.windows ||
         platform == TargetPlatform.macOS ||
         platform == TargetPlatform.linux;
}
```

**Пример адаптивного виджета списка:**
```dart
class AdaptiveListView extends StatelessWidget {
  final List<dynamic> items;
  final List<DataColumn> columns;
  final Widget Function(BuildContext, dynamic) mobileItemBuilder;
  final DataRow Function(dynamic) desktopRowBuilder;

  const AdaptiveListView({
    Key? key,
    required this.items,
    required this.columns,
    required this.mobileItemBuilder,
    required this.desktopRowBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDesktopPlatform(context)) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: items.map((item) => desktopRowBuilder(item)).toList(),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => mobileItemBuilder(context, items[index]),
      );
    }
  }
}
```

**Пример использования:**
```dart
AdaptiveListView(
  items: clients,
  columns: [
    DataColumn(label: Text('Имя')),
    DataColumn(label: Text('Тип')),
    DataColumn(label: Text('Контакт')),
    DataColumn(label: Text('Действия')),
  ],
  mobileItemBuilder: (context, client) => ClientCard(
    client: client,
    onTap: () => _editClient(client),
  ),
  desktopRowBuilder: (client) => DataRow(
    cells: [
      DataCell(Text(client.name)),
      DataCell(Text(client.type.displayName)),
      DataCell(Text(client.contactInfo)),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editClient(client),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteClient(client),
          ),
        ],
      )),
    ],
  ),
)
```

**Макет экрана:**
* Для мобильных устройств: Scaffold с AppBar и BottomNavigationBar
* Для десктопных платформ: разделенный макет с постоянной боковой панелью:
  * Левая панель: список сущностей с возможностью фильтрации и поиска
  * Верхняя панель: заголовок экрана и кнопки навигации
  * Правая панель: детали сущности
```dart
Widget build(BuildContext context) {
  if (isDesktopPlatform(context)) {
    return Scaffold(
      body: Row(
        children: [
          NavigationSidebar(
            currentIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  } else {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _navigationItems,
      ),
    );
  }
}
```
**Рекомендации по адаптивной вёрстке:**
* Используйте LayoutBuilder и MediaQuery для определения доступного пространства
* Применяйте Flex, Expanded и Flexible для построения адаптивных макетов
* Учитывайте плотность пикселей и различные размеры экранов
* Тестируйте UI на различных размерах экрана и ориентациях
* Используйте константы для определения пороговых значений:

```dart
class AdaptiveBreakpoints {
  static const double small = 600.0;
  static const double medium = 900.0;
  static const double large = 1200.0;
}

enum ScreenSize {
  small,   // < 600
  medium,  // 600 - 900
  large,   // 900 - 1200
  extraLarge  // > 1200
}

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < AdaptiveBreakpoints.small) return ScreenSize.small;
  if (width < AdaptiveBreakpoints.medium) return ScreenSize.medium;
  if (width < AdaptiveBreakpoints.large) return ScreenSize.large;
  return ScreenSize.extraLarge;
}
```
## 13. Логирование и обработка ошибок

### Структура логирования

В проекте используется иерархическая система логирования, основанная на библиотеке `logger`. Логгеры сконфигурированы для разных компонентов системы с разными уровнями детализации:

```dart
// lib/core/utils/logger_config.dart
import 'package:logger/logger.dart';

class AppLoggers {
  // Основные логгеры по слоям приложения
  static final Logger coreLogger =
      Logger(printer: PrettyPrinter(methodCount: 2), level: Level.trace);
  static final Logger networkLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.info);
  static final Logger databaseLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.debug);
  static final Logger uiLogger =
      Logger(printer: PrettyPrinter(methodCount: 0), level: Level.warning);

  // Логгеры для конкретных компонентов
  static Logger clientsLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger vehiclesLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger suppliersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger ordersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
}
```
**Уровни логирования**

При использовании логгеров следуйте этим рекомендациям по уровням:

* trace - Самые подробные сообщения, используйте для временной отладки
* debug - Детальная информация о выполняемых операциях (SQL-запросы, маппинг моделей)
* info - Общая информация о работе приложения (успешно выполненные операции)
* warning - Неожиданные ситуации, но не влияющие на работу приложения
* error - Ошибки, которые нарушают нормальное функционирование компонентов
* fatal - Критические ошибки, приводящие к невозможности продолжения работы

**Стандарты логирования**
* Структурированные логи:
```dart
logger.i('Запрос успешно выполнен', {'url': url, 'responseTime': responseTime});
```
* Именование событий:
```dart
logger.d('DATABASE:QUERY:START', {'query': query});
logger.d('DATABASE:QUERY:END', {'duration': duration});
```
* Контекст операций:
```dart
final logContext = {'clientId': client.id, 'operation': 'update'};
try {
  logger.i('Начало обновления клиента', logContext);
  // операция
  logger.i('Клиент успешно обновлен', logContext);
} catch (e) {
  logger.e('Ошибка обновления клиента', e, StackTrace.current, logContext);
}
```
**Не логируйте конфиденциальные данные:**
* Пароли
* API-ключи
* Персональные данные клиентов
* Номера банковских карт

### Многоуровневая обработка ошибок

Проект использует многоуровневый подход к обработке ошибок:

**Глобальные обработчики для Flutter и Dart:**
```dart
// lib/main.dart
void main() {
  // Настройка перехвата ошибок Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLoggers.coreLogger.e(
      'Flutter error: ${details.exception}', 
      details.exception, 
      details.stack
    );
    
    // В релизе можно отправлять в сервис аналитики
    if (!kDebugMode) {
      // Отправка в аналитику
    }
  };
  
  // Запуск в защищенной зоне
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    AppLoggers.coreLogger.e('Unhandled error', error, stackTrace);
  });
}
```
**Обработка ошибок в асинхронных операциях:**
```dart
Future<void> _loadData() async {
  try {
    final data = await _repository.loadData();
    setState(() => _data = data);
  } catch (e) {
    AppLoggers.uiLogger.e('Ошибка загрузки данных', e);
    // Показать диалог с ошибкой
  }
}
```
**Обработка ошибок в сетевых запросах:**
```dart
try {
  final response = await _client.get(url);
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw NetworkException('Ошибка запроса: ${response.statusCode}');
  }
} on DioError catch (e) {
  AppLoggers.networkLogger.e('Ошибка сети', e);
  throw NetworkException('Ошибка сети: ${e.message}');
}
```
**Обработка ошибок в базе данных:**
```dart
try {
  await _database.transaction(() async {
    // операция с БД
  });
} catch (e, stackTrace) {
  AppLoggers.databaseLogger.e('Ошибка транзакции', e, stackTrace);
  throw DatabaseException('Не удалось выполнить операцию', cause: e);
}
```
**Пользовательские обработчики для UI:**
```dart
// Кастомизация отображения ошибок через MaterialApp.builder
MaterialApp(
  builder: (context, widget) {
    Widget errorWidget = ErrorScreen(
      message: 'Произошла ошибка в приложении',
      onRetry: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      ),
    );
    
    if (widget is Scaffold || widget is Navigator) {
      ErrorWidget.builder = (FlutterErrorDetails details) => 
        Scaffold(body: Center(child: errorWidget));
    }
    
    return widget ?? const SizedBox.shrink();
  },
)
```

### Иерархия исключений

**Используйте иерархию пользовательских исключений, которые предоставляют контекст ошибки:**

```dart
/// Базовый класс для всех исключений приложения
abstract class AppException implements Exception {
  final String message;
  final dynamic cause;
  
  const AppException(this.message, {this.cause});
  
  @override
  String toString() => '$runtimeType: $message${cause != null ? ', cause: $cause' : ''}';
}

/// Исключение, связанное с базой данных
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}

/// Исключение, связанное с сетевыми запросами
class NetworkException extends AppException {
  final int? statusCode;
  
  const NetworkException(super.message, {this.statusCode, super.cause});
  
  @override
  String toString() => '${super.toString()}${statusCode != null ? ', statusCode: $statusCode' : ''}';
}

/// Исключение, связанное с бизнес-логикой
class BusinessLogicException extends AppException {
  const BusinessLogicException(super.message, {super.cause});
}
```

### Обработка асинхронных ошибок в UI

**Обработка ошибок в StateWidget:**
```dart
@override
void initState() {
  super.initState();
  _loadData();
}

Future<void> _loadData() async {
  try {
    setState(() => _isLoading = true);
    final data = await _service.getData();
    if (mounted) {
      setState(() {
        _data = data;
        _isLoading = false;
      });
    }
  } catch (e, stackTrace) {
    AppLoggers.uiLogger.e('Ошибка загрузки данных', e, stackTrace);
    if (mounted) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}
```
**Обработка ошибок в AsyncValue (при использовании Riverpod):**
```dart
@override
Widget build(BuildContext context) {
  final dataState = ref.watch(dataProvider);
  
  return dataState.when(
    data: (data) => DataListWidget(data: data),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) => ErrorWidget(
      message: error.toString(),
      onRetry: () => ref.refresh(dataProvider),
    ),
  );
}
```
**ErrorBoundary для изоляции ошибок:**
```dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace) fallback;
  
  const ErrorBoundary({
    Key? key,
    required this.child,
    required this.fallback,
  }) : super(key: key);
  
  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
Widget build(BuildContext context) {
  // Создаем обработчик ошибок только один раз при построении виджета
  ErrorWidget.builder = (FlutterErrorDetails details) {
    onError(details.exception, details.stack ?? StackTrace.current);
    return const SizedBox.shrink(); // Или другой фолбэк-виджет
  };
  
  // Возвращаем дочерний виджет
  return child;
}
}
// Пример упрощённой реализации:
class ErrorCatcher extends StatelessWidget {
  final Widget child;
  final Function(Object error, StackTrace stackTrace) onError;
  
  const ErrorCatcher({
    Key? key,
    required this.child,
    required this.onError,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Устанавливаем глобальный обработчик ошибок виджетов
    ErrorWidget.builder = (FlutterErrorDetails details) {
      onError(details.exception, details.stack ?? StackTrace.current);
      return const SizedBox.shrink();  // Или возвращать запасной виджет
  };
  
  // Возвращаем дочерний виджет
  return child;
}
```
### Мониторинг и аналитика

Для релизных сборок рекомендуется интеграция с сервисами мониторинга ошибок:

**Подключение Firebase Crashlytics:**
```dart
Future<void> initCrashlytics() async {
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  // Регистрация неперехваченных ошибок зоны
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
```
**Логирование бизнес-событий для аналитики:**
```dart
// Успешное создание заказ-наряда
FirebaseAnalytics.instance.logEvent(
  name: 'order_created',
  parameters: {
    'client_id': order.clientId,
    'car_id': order.carId,
    'total_amount': order.totalAmount,
  },
);
```

### Рекомендации по отображению ошибок пользователю

**Общие принципы:**

* Используйте понятный язык без технических деталей
* Предлагайте решение или альтернативные действия
* Обеспечьте возможность повторить операцию
* Для технической информации предлагайте функцию "Отправить отчет"

**Типы UI для разных ошибок:**

* Небольшие ошибки: SnackBar с кнопкой действия
* Ошибки формы: Встроенные сообщения под полями ввода
* Ошибки загрузки: Плейсхолдер с кнопкой повторной загрузки
* Критические ошибки: Полноэкранный виджет с объяснением и вариантами действий
* Пример виджета для отображения ошибок сетевого запроса:
```dart
class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    required this.message,
    required this.onRetry,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Проблема соединения',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 14. Тестирование

Для обеспечения качества и надежности приложения применяется многоуровневое тестирование.

### Unit-тесты

Unit-тесты проверяют работу отдельных компонентов и функций в изоляции от остальных частей системы.

**Инструменты:**
* `test` пакет для основных тестов
* `mockito` и `mocktail` для создания моков
* `fake_async` для тестирования асинхронного кода

**Структура:**
* Тесты размещаются в директории `test/` в соответствующих подпапках, отражающих структуру проекта
* Файлы тестов имеют суффикс `_test.dart`

**Пример теста сервиса:**
```dart
void main() {
  late ClientService clientService;
  late MockAppDatabase mockDatabase;
  late MockClientsDao mockClientsDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockClientsDao = MockClientsDao();
    
    when(mockDatabase.clientsDao).thenReturn(mockClientsDao);
    
    clientService = ClientService(mockDatabase);
  });

  group('ClientService', () {
    test('getClients должен возвращать список клиентов', () async {
      // Arrange
      final clientItems = [
        ClientsCompanion.insert(
          name: 'Иванов Иван',
          type: 'physical',
          contactInfo: '+7 999 123 45 67',
        ),
      ];
      
      when(mockClientsDao.getActiveClients()).thenAnswer(
        (_) => Future.value(clientItems),
      );

      // Act
      final clients = await clientService.getClients();

      // Assert
      expect(clients.length, 1);
      expect(clients[0].name, 'Иванов Иван');
      expect(clients[0].type, ClientType.physical);
      verify(mockClientsDao.getActiveClients()).called(1);
    });

    test('deleteClient должен помечать клиента как удаленный', () async {
      // Arrange
      const clientId = 1;
      
      // Act
      await clientService.deleteClient(clientId);

      // Assert
      verify(mockClientsDao.softDeleteClient(clientId)).called(1);
    });
  });
}
```

### Тестирование репозиториев:

**Пример теста репозитория:**
```dart
void main() {
  late SupplierRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = SupplierRepository(mockDio);
  });

  group('SupplierRepository', () {
    test('getPricesByArticle должен корректно обрабатывать ответ API', () async {
      // Arrange
      const article = '123456';
      final responseData = {
        'items': [
          {
            'number': article,
            'name': 'Тестовая деталь',
            'price': 1000.0,
            'delivery_days': 3,
          }
        ]
      };
      
      when(mockDio.get('api/prices/$article')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: 'api/prices/$article'),
          data: responseData,
          statusCode: 200,
        ),
      );

      // Act
      final result = await repository.getPricesByArticle(article);

      // Assert
      expect(result.length, 1);
      expect(result[0].partNumber, article);
      expect(result[0].price, 1000.0);
      verify(mockDio.get('api/prices/$article')).called(1);
    });

    test('getPricesByArticle должен обрабатывать ошибки', () async {
      // Arrange
      const article = '123456';
      
      when(mockDio.get('api/prices/$article')).thenThrow(
        DioError(
          requestOptions: RequestOptions(path: 'api/prices/$article'),
          error: 'Ошибка сети',
          type: DioErrorType.connectTimeout,
        ),
      );

      // Act & Assert
      expect(
        () => repository.getPricesByArticle(article),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

### Widget-тесты

Widget-тесты проверяют корректную работу UI компонентов и их взаимодействие с данными.

**Инструменты:**
  * flutter_test пакет
  * network_image_mock для мока сетевых изображений
  * golden_toolkit для снепшот-тестирования

**Структура:**
* Тесты размещаются в директории `test/widgets/`
* Для каждого экрана или компонента создается отдельный тест-файл

**Пример теста виджета:**
```dart
void main() {
  late MockClientService mockClientService;

  setUp(() {
    mockClientService = MockClientService();
    
    // Регистрация мока в сервис-локаторе для тестов
    GetIt.instance.registerSingleton<ClientService>(mockClientService);
  });
  
  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('ClientsScreen отображает список клиентов', 
    (WidgetTester tester) async {
    // Arrange
    final clients = [
      Client(
        id: 1,
        name: 'Иванов Иван',
        type: ClientType.physical,
        contactInfo: '+7 999 123 45 67',
      ),
      Client(
        id: 2,
        name: 'ООО "Рога и Копыта"',
        type: ClientType.legal,
        contactInfo: '+7 495 123 45 67',
      ),
    ];
    
    when(mockClientService.watchClients()).thenAnswer(
      (_) => Stream.value(clients),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ClientsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Иванов Иван'), findsOneWidget);
    expect(find.text('ООО "Рога и Копыта"'), findsOneWidget);
    expect(find.text('+7 999 123 45 67'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget); // Иконка для физ. лица
    expect(find.byIcon(Icons.business), findsOneWidget); // Иконка для юр. лица
  });

  testWidgets('ClientsScreen показывает индикатор загрузки и сообщение об ошибке',
    (WidgetTester tester) async {
    // Arrange - эмулируем загрузку, а затем ошибку
    when(mockClientService.watchClients()).thenAnswer(
      (_) => Stream.error('Ошибка загрузки данных'),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ClientsScreen(),
      ),
    );

    // Assert - сначала должен показаться индикатор загрузки
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Дожидаемся обработки ошибки
    await tester.pumpAndSettle();
    
    // Теперь должно показаться сообщение об ошибке
    expect(find.text('Ошибка загрузки данных'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Кнопка "Повторить"
  });
  
  testWidgets('Кнопка добавления клиента открывает диалог',
    (WidgetTester tester) async {
    // Arrange
    when(mockClientService.watchClients()).thenAnswer(
      (_) => Stream.value([]),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ClientsScreen(),
      ),
    );
    await tester.pumpAndSettle();
    
    // Нажимаем на кнопку добавления
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Добавление клиента'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets); // Должны быть поля ввода
    expect(find.byType(DropdownButton<ClientType>), findsOneWidget); // Выбор типа клиента
  });
}
```
**Snapshot-тестирование:**
```dart
void main() {
  setUpAll(() {
    // Настройка размеров для голден-тестов
    goldenFileComparator = GoldenFileComparator();
  });

  testWidgets('ClientCard выглядит корректно для физического лица',
    (WidgetTester tester) async {
    // Arrange
    final client = Client(
      id: 1,
      name: 'Иванов Иван',
      type: ClientType.physical,
      contactInfo: '+7 999 123 45 67',
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: ClientCard(
              client: client,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    
    // Assert
    await expectLater(
      find.byType(ClientCard),
      matchesGoldenFile('goldens/client_card_physical.png'),
    );
  });

  testWidgets('ClientCard выглядит корректно для юридического лица',
    (WidgetTester tester) async {
    // Arrange
    final client = Client(
      id: 2,
      name: 'ООО "Рога и Копыта"',
      type: ClientType.legal,
      contactInfo: '+7 495 123 45 67',
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: ClientCard(
              client: client,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    
    // Assert
    await expectLater(
      find.byType(ClientCard),
      matchesGoldenFile('goldens/client_card_legal.png'),
    );
  });
}
```
### Интеграционные тесты

Интеграционные тесты проверяют взаимодействие между различными компонентами системы.

**Инструменты:**
* integration_test пакет
* flutter_driver

**Структура:**
* Тесты размещаются в директории `integration_test/`
* Для каждого основного сценария создается отдельный тест-файл

**Пример интеграционного теста:**
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Интеграционные тесты основных сценариев', () {
    testWidgets('Создание и редактирование клиента', 
      (WidgetTester tester) async {
      // Запуск приложения
      app.main();
      await tester.pumpAndSettle();

      // Переход на экран клиентов
      await tester.tap(find.text('Клиенты'));
      await tester.pumpAndSettle();

      // Добавление нового клиента
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      // Заполнение формы
      await tester.enterText(
        find.widgetWithText(TextField, 'ФИО/Наименование'),
        'Тестовый Клиент',
      );
      
      await tester.enterText(
        find.widgetWithText(TextField, 'Контактная информация'),
        '+7 999 888 77 66',
      );
      
      // Выбор типа клиента из выпадающего списка
      await tester.tap(find.byType(DropdownButton<ClientType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Физическое лицо').last);
      await tester.pumpAndSettle();
      
      // Сохранение клиента
      await tester.tap(find.widgetWithText(ElevatedButton, 'Сохранить'));
      await tester.pumpAndSettle();

      // Проверка, что клиент добавлен и отображается в списке
      expect(find.text('Тестовый Клиент'), findsOneWidget);
      expect(find.text('+7 999 888 77 66'), findsOneWidget);

      // Редактирование клиента
      await tester.tap(find.text('Тестовый Клиент'));
      await tester.pumpAndSettle();
      
      // Изменение данных
      await tester.enterText(
        find.widgetWithText(TextField, 'ФИО/Наименование'),
        'Тестовый Клиент Изменённый',
      );
      
      // Сохранение изменений
      await tester.tap(find.widgetWithText(ElevatedButton, 'Сохранить'));
      await tester.pumpAndSettle();

      // Проверка, что данные обновлены
      expect(find.text('Тестовый Клиент Изменённый'), findsOneWidget);
    });
    
    testWidgets('Добавление автомобиля клиенту', 
      (WidgetTester tester) async {
      // Запуск приложения
      app.main();
      await tester.pumpAndSettle();

      // Переход на экран автомобилей
      await tester.tap(find.text('Автомобили'));
      await tester.pumpAndSettle();

      // Добавление нового автомобиля
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      // Заполнение формы
      await tester.enterText(
        find.widgetWithText(TextField, 'Марка'),
        'Toyota',
      );
      
      await tester.enterText(
        find.widgetWithText(TextField, 'Модель'),
        'Camry',
      );
      
      // Выбор клиента из выпадающего списка
      await tester.tap(find.byType(DropdownButton<Client>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Тестовый Клиент Изменённый').last);
      await tester.pumpAndSettle();
      
      // Сохранение автомобиля
      await tester.tap(find.widgetWithText(ElevatedButton, 'Сохранить'));
      await tester.pumpAndSettle();

      // Проверка, что автомобиль добавлен и отображается в списке
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Camry'), findsOneWidget);
      expect(find.text('Тестовый Клиент Изменённый'), findsOneWidget);
    });
  });
}
```
### Моки и стабы

Для изоляции тестируемых компонентов от внешних зависимостей используются моки и стабы.

**Определения:**
* Мок - имитирует поведение реального объекта и записывает вызванные методы
* Стаб - возвращает предопределенные значения без записи вызовов
* Фейк - имитирует поведение реального объекта с упрощенной реализацией

**Инструменты:**
* mockito - для создания моков и стабов с кодогенерацией
* mocktail - для создания моков без кодогенерации
* Ручные моки для сложных случаев

**Пример определения моков с Mockito:**
```dart
@GenerateMocks([AppDatabase, ClientsDao, CarService])
void main() {
  // Тесты...
}
```
**Пример ручного мока:**
```dart
class MockSupplierApiClient implements SupplierApiClient {
  final Map<String, List<PartPriceModel>> _mockResponses = {};
  
  void setMockResponse(String article, List<PartPriceModel> response) {
    _mockResponses[article] = response;
  }
  
  void setMockError(String article, Exception error) {
    _mockErrors[article] = error;
  }
  
  final Map<String, Exception> _mockErrors = {};

  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    if (_mockErrors.containsKey(article)) {
      throw _mockErrors[article]!;
    }
    
    return _mockResponses[article] ?? [];
  }
}
```
### Паттерны тестирования:

**Arrange-Act-Assert (AAA):**
  * Arrange - подготовка данных и зависимостей
  * Act - выполнение тестируемого действия
  * Assert - проверка результатов

**Given-When-Then (BDD стиль):**
  * Given - начальное состояние системы
  * When - действие пользователя или системы
  * Then - ожидаемый результат

**Настройка конвейера CI/CD**

Для автоматического запуска тестов при каждом коммите настроен конвейер CI/CD:

**GitHub Actions:**
```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Analyze code
        run: flutter analyze
        
      - name: Run unit and widget tests
        run: flutter test
        
      - name: Run integration tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 29
          script: flutter test integration_test
          
      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```
**Рекомендации по тестированию:**
  * Пирамида тестирования: больше unit-тестов, меньше интеграционных тестов
  * Полезные моки: используйте setUp и tearDown для настройки и очистки моков
  * Тестирование граничных условий: пустые списки, null значения, ошибки сети
  
**Золотые правила:**
  * Тесты должны быть независимыми и изолированными
  * Избегайте лишних зависимостей в тестах
  * Используйте параметризованные тесты для схожих случаев
  * Тестируйте как позитивные, так и негативные сценарии
  * Держите тесты актуальными при изменении кода

## 15. CI/CD и развертывание приложения

Для обеспечения качества кода и автоматизации процесса доставки приложения используется полный CI/CD конвейер.

### Конвейер непрерывной интеграции (CI)

В проекте используется GitHub Actions для автоматизации процессов CI/CD. Основной конвейер включает:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Analyze code
        run: flutter analyze
        
      - name: Run unit and widget tests
        run: flutter test
        
      - name: Run integration tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 29
          script: flutter test integration_test
          
      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```
### Автоматическая сборка приложения (CD)

Процесс непрерывной доставки включает автоматическую сборку приложения для разных платформ:
```yaml
name: Flutter CD

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
          channel: 'stable'
          
      - name: Install dependencies
        run: flutter pub get
      
      - name: Setup Keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Build App Bundle
        run: flutter build appbundle --release
        
      - name: Upload APK artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
          
      - name: Upload App Bundle artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release-bundle
          path: build/app/outputs/bundle/release/app-release.aab
          
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
          channel: 'stable'
          
      - name: Install dependencies
        run: flutter pub get
      
      - name: Enable Windows platform
        run: flutter config --enable-windows-desktop
        
      - name: Build Windows application
        run: flutter build windows --release
        
      - name: Create Windows Installer
        uses: joncloud/makensis-action@v3.6
        with:
          script-file: windows/installer.nsi
          
      - name: Upload Windows artifact
        uses: actions/upload-artifact@v3
        with:
          name: windows-installer
          path: build/windows/part_catalog_setup.exe
          
  create-release:
    needs: [build-android, build-windows]
    runs-on: ubuntu-latest
    steps:
      - name: Download all artifacts
        uses: actions/download-artifact@v3
        
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            app-release/app-release.apk
            app-release-bundle/app-release.aab
            windows-installer/part_catalog_setup.exe
          draft: false
          prerelease: false
```
### Стратегия выпуска версий

В проекте используется следующая стратегия версионирования и ветвления:

### Ветки:

  * main - стабильная ветка для релизных версий
  * develop - ветка для активной разработки и будущих релизов
  * feature/* - ветки для разработки новых функций
  * bugfix/* - ветки для исправления ошибок
  * release/* - ветки подготовки релизов

### Версионирование:

  * Используется семантическое версионирование (MAJOR.MINOR.PATCH)
  * Релизы помечаются тегами v* (например, v1.0.0)
  * Предварительные версии помечаются суффиксами (v1.0.0-beta.1)

### Окружения развертывания

Приложение разворачивается в трёх окружениях:

**Разработка (dev):**

  * Собирается автоматически при каждом коммите в develop
  * Содержит экспериментальные функции и инструменты отладки
  * Подключено к тестовым API-эндпоинтам
  * Доступно только внутренней команде разработки

**Тестирование (staging):**

  * Собирается из ветки release/* перед выпуском новой версии
  * Максимально приближено к продакшену
  * Подключено к тестовым API-эндпоинтам, но с реальными данными
  * Доступно тестировщикам и ключевым заказчикам

**Продакшен (prod):**

  * Собирается из ветки main после выпуска тега
  * Оптимизировано для производительности
  * Отключены все отладочные инструменты
  * Подключено к рабочим API-эндпоинтам

**Конфигурация окружений**

Для разных окружений используются различные конфигурации:

```dart
// lib/core/config/app_config.dart
enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final String sentryDsn;
  
  static late final AppConfig _instance;
  
  factory AppConfig.instance() => _instance;
  
  AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.sentryDsn,
  });
  
  static void init(Environment env) {
    switch (env) {
      case Environment.dev:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: 'https://dev-api.example.com',
          enableLogging: true,
          sentryDsn: 'https://dev-sentry-key@sentry.io/123',
        );
        break;
      case Environment.staging:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: 'https://staging-api.example.com',
          enableLogging: true,
          sentryDsn: 'https://staging-sentry-key@sentry.io/456',
        );
        break;
      case Environment.prod:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: 'https://api.example.com',
          enableLogging: false,
          sentryDsn: 'https://prod-sentry-key@sentry.io/789',
        );
        break;
    }
  }
  
  bool get isProduction => environment == Environment.prod;
  bool get isDevelopment => environment == Environment.dev;
}
```

### Управление конфигурацией

Конфигурации для разных окружений определяются через Flutter command-line arguments и файлы .env:

```bash
# Запуск в dev окружении
flutter run --dart-define=ENVIRONMENT=dev
# Сборка релизной версии для prod
flutter build apk --release --dart-define=ENVIRONMENT=prod
```

**Загрузка конфигурации при запуске:**
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация конфигурации окружения
  final envName = const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  final env = Environment.values.firstWhere(
    (e) => e.toString() == 'Environment.$envName',
    orElse: () => Environment.dev,
  );
  AppConfig.init(env);
  
  // Загрузка .env файла для секретных ключей
  await dotenv.load(fileName: '.env.${envName}');
  
  // Инициализация систем мониторинга только для non-dev окружений
  if (!AppConfig.instance().isDevelopment) {
    await initMonitoring();
  }
  
  runApp(const MyApp());
}
```

### Процесс распространения и обновления

**Android:**

  * Публикация в Google Play Store через Google Play Console
  * Настроено поэтапное развертывание (10% → 50% → 100%)
  * Автоматическое обновление с использованием in-app updates API

**Windows:**

  * Публикация на официальном сайте и GitHub Releases
  * Встроенная система проверки обновлений
  * Автоматическое скачивание и установка обновлений

**Мониторинг после выпуска:**

  * Отслеживание метрик использования и стабильности через Firebase Analytics и Crashlytics
  * Dashboard с ключевыми показателями использования приложения
  * Оповещения о критических ошибках для оперативного реагирования

**Инфраструктура для бэкенда**

Хотя приложение в основном работает с внешними API, для некоторых функций используется собственный бэкенд:

  * Размещение: Google Cloud Platform
  * Автоматизация инфраструктуры: Terraform
  * Деплой бэкенда: Cloud Build и Cloud Run
  * Мониторинг: Stackdriver Logging и Monitoring

**Документирование релизов**

Для каждого релиза создаются:

  * Список изменений (changelog)
  * Скриншоты новых функций
  * Обучающие материалы для конечных пользователей
  * Технические заметки для команды поддержки

**Рекомендации по развертыванию:**
  * Постепенное развертывание: используйте поэтапное развертывание для минимизации рисков
  * Feature flags: используйте флаги функций для контролируемого включения/выключения функциональности
  * Канарейные релизы: тестируйте критические изменения на небольшой группе пользователей
  * Автоматизация: максимально автоматизируйте процесс сборки и публикации
  * Мониторинг: всегда отслеживайте ключевые метрики после релиза

## 16. Документация

### Типы документации в проекте

**Техническая документация:**
* API-документация (генерируемая из doc-комментариев)
* Архитектурный обзор и принципы проектирования
* Руководство для разработчиков
* Инструкции по настройке окружения разработки

**Пользовательская документация:**
* Руководство пользователя 
* Инструкции для пользователей-администраторов
* FAQ (часто задаваемые вопросы)
* Руководства по устранению неполадок

**Процессная документация:**
* Чек-листы для тестирования
* Планы релизов
* Процедуры развертывания

### Унификация стиля комментариев в коде

В Flutter/Dart проекте важно придерживаться единого стиля комментариев для обеспечения читаемости кода и качественной документации. Вот рекомендуемый подход:

**Рекомендуемый стиль комментариев**

Для документации API (публичные методы, классы, поля):

```dart
/// Представляет информацию о клиенте автосервиса.
///
/// Содержит основные данные о клиенте, такие как имя, тип и контактная информация.
/// Используется для отображения в списке клиентов и передачи данных между слоями приложения.
///
/// См. также [ClientType], [CarModel].
class Client {
  /// Уникальный идентификатор клиента.
  final int id;
  
  /// Имя или наименование организации клиента.
  final String name;
  
  /// Тип клиента (физическое, юридическое лицо и т.д.).
  final ClientType type;
  
  /// Контактная информация клиента (телефон, email).
  final String contactInfo;
  
  /// Создает экземпляр [Client] с заданными параметрами.
  ///
  /// [id] должен быть положительным числом.
  /// [name] не должно быть пустой строкой.
  /// [type] должен быть одним из значений [ClientType].
  /// [contactInfo] должно содержать действительную контактную информацию.
  Client({
    required this.id,
    required this.name,
    required this.type,
    required this.contactInfo,
  });
  
  /// Преобразует экземпляр [Client] в Map для сохранения в БД.
  Map<String, dynamic> toMap() {
    // Реализация метода
  }
}
```

Для внутренних комментариев (приватные методы, реализация методов):

```dart
void _processClientData(Client client) {
  // Проверяем тип клиента и применяем соответствующую логику
  if (client.type == ClientType.legal) {
    _applyBusinessRules(client);
  }
  
  // Сохраняем время последнего обновления
  _lastUpdated = DateTime.now();
  
  // TODO: Добавить валидацию контактных данных
  
  // FIXME: Исправить проблему с дублированием клиентов
}
```

Пример применения разных стилей в одном файле:

```dart
/// Service for managing clients in the database.
/// 
/// Provides methods to create, update, delete and query clients.
/// Uses [AppDatabase] for data storage operations.
class ClientService {
  // Зависимость на базу данных
  final AppDatabase _database;
  
  /// Creates a new client service with the given database.
  ClientService(this._database);
  
  /// Returns all active clients from the database.
  /// 
  /// Active clients are those that have not been soft-deleted.
  /// Returns an empty list if no clients are found.
  Future<List<Client>> getClients() async {
    // Запрашиваем записи из DAO
    final items = await _database.clientsDao.getActiveClients();
    
    // Преобразуем элементы таблицы в бизнес-модели
    return items.map(_mapToModel).toList();
  }
  
  // Вспомогательный метод для преобразования записей БД в бизнес-модели
  Client _mapToModel(ClientsCompanion item) {
    // Получаем тип клиента из строкового представления
    final clientType = ClientType.fromString(item.type);
    
    // Преобразуем запись таблицы в бизнес-модель
    return Client(
      id: item.id,
      name: item.name,
      type: clientType, 
      contactInfo: item.contactInfo,
    );
  }
  
  /// Deletes a client by ID (soft delete).
  /// 
  /// Sets the [deletedAt] field to current timestamp.
  /// Returns true if the client was successfully deleted.
  Future<bool> deleteClient(int clientId) async {
    try {
      // Выполняем мягкое удаление через DAO
      await _database.clientsDao.softDeleteClient(clientId);
      return true;
    } catch (e, stack) {
      // Логируем ошибку и возвращаем false
      AppLoggers.clientsLogger.e('Failed to delete client', e, stack);
      return false;
    }
  }
}
```
**Ключевые моменты унификации:**
  * Для документации API (публичные члены):
    * Используйте тройной слеш  для документации
    * Добавляйте пустую строку между абзацами
    * Используйте ссылки на другие классы и методы в квадратных скобках [ClassName]
    * Документируйте все публичные методы, классы и поля

  * Для внутренних комментариев:
    * Используйте двойной слеш  для однострочных комментариев
    * Распологайте комментарий перед блоком кода, который он описывает
    * Для многострочных внутренних комментариев используйте //  в начале каждой строки
    * Используйте стандартные маркеры: // TODO:, // FIXME:, // NOTE: для особых заметок

### Стандарты технической документации

**API-документация:**
* Используйте документационные комментарии `///` для всех публичных API
* Документируйте каждый параметр и возвращаемое значение
* Добавляйте примеры использования для сложных методов
* Укажите возможные исключения

```dart
/// Получает данные о клиенте из базы данных.
/// 
/// Параметр [clientId] должен быть положительным числом.
/// 
/// Возвращает объект [Client] с данными клиента.
/// 
/// Выбрасывает [DatabaseException], если клиент не найден или произошла ошибка БД.
/// 
/// Пример использования:
/// ```dart
/// final client = await clientService.getClient(1);
/// print(client.name);  // Вывод: Иванов Иван
/// ```
Future<Client> getClient(int clientId) async {
  // реализация
}
```
**Диаграммы архитектуры:**

  * Используйте PlantUML или Mermaid для диаграмм
  * Храните диаграммы в директории /docs/diagrams/
  * Создавайте диаграммы для:
    * Общей архитектуры приложения
    * Потоков данных
    * Структуры базы данных
    * Жизненных циклов ключевых процессов

**README-файлы:**

  * Главный README.md в корне проекта с общим описанием
  * README.md в каждой ключевой директории с объяснением её назначения
  * Включайте информацию о:
    * Назначении компонента/модуля
    * Зависимостях
    * Особенностях использования
    * Примерах кода

### Организация документации

**Структура каталогов:**

```plaintext
docs/
  architecture/
    overview.md
    data_flow.md
    api_design.md
  diagrams/
    architecture.puml
    database_schema.puml
    auth_flow.puml
  setup/
    development_environment.md
    testing_environment.md
  guides/
    coding_style.md
    testing.md
  user/
    installation.md
    basic_usage.md
    admin_guide.md
  api/
    generated/  # Автоматически генерируемая API-документация
```

### Генерация документации

**Автоматическая генерация API-документации:**

```yaml
// Запуск генерации документации
// flutter pub global run dartdoc

// Настройка dartdoc в pubspec.yaml
// dartdoc:
//   include: ['lib/features', 'lib/core']
//   exclude: ['lib/generated']
```

**Генерация диаграмм:**

```
# Генерация PNG из файла PlantUML
puml generate docs/diagrams/architecture.puml

# Интеграция с CI/CD для автоматической генерации диаграмм
# при изменении исходных файлов
```

### Поддержание документации в актуальном состоянии

**Правило одновременного обновления:**
  * При изменении кода обновляйте соответствующую документацию

**Проверка в PR:**
  * Добавьте пункт "Обновлена документация" в шаблон пулл-реквестов

**Регулярный аудит:**
  * Раз в квартал проводите аудит документации на актуальность

**Автоматические проверки:**
  * Настройте линтеры для проверки doc-комментариев
  * Используйте GitHub Actions для автоматической проверки
  * Добавьте задачу в CI/CD для проверки наличия doc-комментариев перед слиянием PR

### Публикация документации

**Внутренняя документация:**

  * Настройка GitHub Pages для публикации документации из ветки main
  * Автоматическая сборка и публикация после мержа в main

```yaml
    name: Deploy Documentation
  
  on:
    push:
      branches: [ main ]
      paths:
        - 'docs/**'
        - 'lib/**/*.dart'  # Для обновления API-документации
  
  jobs:
    build-and-deploy:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        
        - name: Set up Flutter
          uses: subosito/flutter-action@v2
          
        - name: Generate API Documentation
          run: flutter pub global run dartdoc
          
        - name: Generate Diagrams
          run: |
            apt-get update && apt-get install -y graphviz
            pip install plantuml-markdown
            for file in docs/diagrams/*.puml; do
              plantuml -png $file
            done
        
        - name: Deploy to GitHub Pages
          uses: JamesIves/github-pages-deploy-action@v4
          with:
            folder: docs
```

**Пользовательская документация:**

  * Экспорт в PDF для оффлайн-использования
  * Интеграция с системой помощи в приложении
  * Синхронизация с веб-сайтом продукта

### Рекомендации по написанию документации

**Ясность:** используйте простой язык и короткие предложения
**Структура:** разделяйте большие документы на логические секции с подзаголовками
**Примеры:** включайте практические примеры для сложных концепций
**Обновления:** отмечайте дату последнего обновления в каждом документе
**Форматирование:** используйте Markdown для удобства чтения и редактирования
**Единый стиль:** разработайте и соблюдайте единый стиль документации

### Шаблоны документации

**Шаблон модуля:**

```markdown
# Название модуля

## Описание
Краткое описание назначения и функциональности модуля.

## Архитектура
Как модуль вписывается в общую архитектуру приложения.

## Компоненты
* Component1 - описание
* Component2 - описание

## Зависимости
* Зависимость1 - зачем нужна
* Зависимость2 - зачем нужна

## Примеры использования
```dart
// Пример кода
```
### Особенности и ограничения

Специфические моменты, о которых нужно знать при работе с модулем.

## 17. Адаптивная архитектура взаимодействия с API поставщиков

Для обеспечения гибкости взаимодействия с API поставщиков запчастей в проекте реализован адаптивный подход, позволяющий работать как в режиме прямого подключения (standalone), так и через прокси-сервер.

### Режимы работы API

#### Поддерживаемые режимы:

| Режим | Описание | Применение |
|-------|----------|------------|
| `ApiConnectionMode.direct` | Прямое подключение к API поставщиков | Разработка, тестирование, автономное использование |
| `ApiConnectionMode.proxy` | Взаимодействие через прокси-сервер | Продакшн, корпоративные развертывания с ограничениями безопасности |
| `ApiConnectionMode.hybrid` | Автоматическое переключение между режимами | Универсальное использование с повышенной отказоустойчивостью |

### Архитектурное решение: Адаптивная реализация с режимами работы

#### 1. Расширенная конфигурация с режимами работы:

```dart
/// Режимы подключения к API поставщиков
enum ApiConnectionMode {
  /// Прямое подключение к API поставщиков (standalone)
  direct,
  
  /// Подключение через прокси-сервер
  proxy,
  
  /// Гибридный режим с автоматическим переключением
  hybrid
}

/// Конфигурация приложения с поддержкой разных режимов API
class AppConfig {
  // Существующие поля...
  
  /// Режим подключения к API поставщиков
  final ApiConnectionMode apiConnectionMode;
  
  /// URL прокси-сервера для соединения в режиме proxy
  final String proxyServerUrl;
  
  /// Учетные данные API поставщиков для режима direct
  final Map<String, ApiCredentials> directApiCredentials;
  
  // Фабричные методы для разных окружений
  factory AppConfig.development() => AppConfig._(
    environment: Environment.dev,
    apiConnectionMode: ApiConnectionMode.direct, // В разработке используем прямое подключение
    apiBaseUrl: 'https://dev-api.example.com',
    // другие параметры
  );
  
  factory AppConfig.production() => AppConfig._(
    environment: Environment.prod,
    apiConnectionMode: ApiConnectionMode.proxy, // В продакшене через прокси
    proxyServerUrl: 'https://api-proxy.example.com',
    // другие параметры
  );
  
  /// Сохраненная конфигурация пользователя
  static Future<AppConfig> fromUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('api_connection_mode') ?? 'proxy';
    
    final baseConfig = AppConfig.production(); // Базовая конфигурация
    
    // Загружаем пользовательские настройки
    return AppConfig._(
      environment: baseConfig.environment,
      apiConnectionMode: _parseConnectionMode(mode), 
      apiBaseUrl: baseConfig.apiBaseUrl,
      proxyServerUrl: prefs.getString('proxy_server_url') ?? baseConfig.proxyServerUrl,
      // другие параметры...
    );
  }
  
  // Приватный конструктор для конфигурации
  AppConfig._({
    required this.environment,
    required this.apiConnectionMode,
    required this.apiBaseUrl,
    this.proxyServerUrl = '',
    this.directApiCredentials = const {},
    // другие параметры...
  });
  
  /// Преобразует строковое представление режима в enum
  static ApiConnectionMode _parseConnectionMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'direct': return ApiConnectionMode.direct;
      case 'hybrid': return ApiConnectionMode.hybrid;
      case 'proxy': 
      default: 
        return ApiConnectionMode.proxy;
    }
  }
}

/// Модель для хранения учетных данных API поставщиков
class ApiCredentials {
  final String apiKey;
  final String apiSecret;
  final Map<String, String> additionalHeaders;
  
  const ApiCredentials({
    required this.apiKey,
    this.apiSecret = '',
    this.additionalHeaders = const {},
  });
}
```
#### 2. Менеджер API-клиентов с поддержкой переключения режимов:

```dart
/// Фабрика для создания API-клиентов с поддержкой разных режимов
class ApiClientManager {
  final AppConfig _config;
  final Dio _dio;
  final AuthManager? _authManager;
  final LocalStorageManager _storageManager;
  
  ApiClientManager(
    this._config,
    this._dio,
    this._storageManager,
    [this._authManager]
  );
  
  /// Создает подходящую реализацию клиента API для указанного поставщика
  Future<SupplierApiClient> createClient(String supplierName) async {
    switch (_config.apiConnectionMode) {
      case ApiConnectionMode.direct:
        return _createDirectClient(supplierName);
        
      case ApiConnectionMode.proxy:
        return _createProxyClient(supplierName);
        
      case ApiConnectionMode.hybrid:
        return _createHybridClient(supplierName);
    }
  }
  
  /// Создает клиент для прямого подключения к API поставщика
  Future<SupplierApiClient> _createDirectClient(String supplierName) async {
    // Проверяем наличие учетных данных
    final credentials = _config.directApiCredentials[supplierName];
    if (credentials == null) {
      throw ConfigurationException('Отсутствуют учетные данные для $supplierName');
    }
    
    // Создаем настроенный экземпляр Dio с учетными данными
    final clientDio = Dio(BaseOptions(
      headers: {
        'X-API-Key': credentials.apiKey,
        ...credentials.additionalHeaders,
      },
    ));
    
    // Выбираем нужную реализацию в зависимости от поставщика
    switch (supplierName) {
      case 'autodoc':
        return AutodocDirectApiClient(clientDio);
      case 'exist':
        return ExistDirectApiClient(clientDio);
      case 'emex':
        return EmexDirectApiClient(clientDio);
      default:
        throw UnsupportedError('Поставщик $supplierName не поддерживается');
    }
  }
  
  /// Создает клиент для подключения через прокси-сервер
  Future<SupplierApiClient> _createProxyClient(String supplierName) async {
    // Получаем токен авторизации для прокси, если нужен
    String? authToken;
    if (_authManager != null) {
      try {
        authToken = await _authManager.getAccessToken();
      } catch (e) {
        AppLoggers.networkLogger.e(
          'Не удалось получить токен авторизации для прокси', e
        );
      }
    }
    
    // Создаем экземпляр Dio с настройками для прокси
    final baseUrl = _config.proxyServerUrl;
    final clientDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: authToken != null 
          ? {'Authorization': 'Bearer $authToken'}
          : {},
    ));
    
    // Создаем прокси-клиент для выбранного поставщика
    return ProxyApiClient(clientDio, supplierName);
  }
  
  /// Создает клиент с гибридным режимом работы (переключение direct/proxy)
  Future<SupplierApiClient> _createHybridClient(String supplierName) async {
    try {
      // Пытаемся создать прямой клиент
      final directClient = await _createDirectClient(supplierName);
      
      // Пытаемся создать прокси-клиент
      final proxyClient = await _createProxyClient(supplierName);
      
      // Создаем гибридный клиент с обоими вариантами
      return HybridApiClient(
        directClient: directClient,
        proxyClient: proxyClient,
        storageManager: _storageManager,
        preferProxy: true, // По умолчанию предпочитаем прокси
      );
    } catch (e) {
      // Если не удалось создать один из клиентов, возвращаем другой
      AppLoggers.networkLogger.w(
        'Не удалось создать гибридный клиент, пробуем прокси', e
      );
      
      try {
        return await _createProxyClient(supplierName);
      } catch (e2) {
        AppLoggers.networkLogger.w(
          'Не удалось создать прокси-клиент, пробуем прямой', e2
        );
        return await _createDirectClient(supplierName);
      }
    }
  }
  
  /// Переключает режим работы с API
  Future<void> switchMode(ApiConnectionMode newMode) async {
    // Сохраняем выбранный режим в настройках пользователя
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_connection_mode', newMode.toString().split('.').last);
    
    // Здесь можно добавить код для перезагрузки конфигурации
  }
}
```
#### 3. Реализация API-клиентов для разных режимов:

```dart
/// Прямой клиент API Autodoc
class AutodocDirectApiClient implements SupplierApiClient {
  final Dio _dio;
  
  AutodocDirectApiClient(this._dio);
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    try {
      // Прямой запрос к API Autodoc
      final response = await _dio.get(
        'https://api.autodoc.com/prices',
        queryParameters: {'article': article},
      );
      
      // Парсинг ответа в специфичном для Autodoc формате
      final autodocResponse = AutodocPriceResponse.fromJson(response.data);
      
      // Преобразование в общий формат
      return autodocResponse.toPartPriceModels();
    } on DioError catch (e) {
      AppLoggers.networkLogger.e('Ошибка прямого запроса к Autodoc API', e);
      throw NetworkException(
        'Ошибка при получении цен от Autodoc',
        statusCode: e.response?.statusCode,
        cause: e,
      );
    }
  }
  
  // Другие методы API...
}

/// Клиент API для работы через прокси-сервер
class ProxyApiClient implements SupplierApiClient {
  final Dio _dio;
  final String _supplierName;
  
  ProxyApiClient(this._dio, this._supplierName);
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    try {
      // Запрос через прокси-сервер с указанием поставщика
      final response = await _dio.get(
        '/api/suppliers/$_supplierName/prices',
        queryParameters: {'article': article},
      );
      
      // Парсинг унифицированного ответа от прокси
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => PartPriceModel.fromJson(item))
            .toList();
      } else {
        throw NetworkException(
          'Прокси-сервер вернул ошибку',
          statusCode: response.statusCode,
        );
      }
    } on DioError catch (e) {
      AppLoggers.networkLogger.e('Ошибка запроса к прокси-серверу', e);
      throw NetworkException(
        'Ошибка при получении цен через прокси',
        statusCode: e.response?.statusCode,
        cause: e,
      );
    }
  }
  
  // Другие методы API...
}

/// Гибридный клиент с возможностью переключения между прямым и прокси-режимом
class HybridApiClient implements SupplierApiClient {
  final SupplierApiClient directClient;
  final SupplierApiClient proxyClient;
  final LocalStorageManager storageManager;
  bool preferProxy;
  
  HybridApiClient({
    required this.directClient,
    required this.proxyClient,
    required this.storageManager,
    this.preferProxy = true,
  });
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    // Пробуем сначала предпочитаемый вариант
    try {
      if (preferProxy) {
        final results = await proxyClient.getPricesByArticle(article);
        
        // Кэшируем результаты для возможной работы офлайн
        await storageManager.cachePrices(article, results);
        return results;
      } else {
        return await directClient.getPricesByArticle(article);
      }
    } catch (e) {
      AppLoggers.networkLogger.w(
        'Ошибка в предпочитаемом режиме, пробуем альтернативный', e
      );
      
      try {
        // Пробуем альтернативный вариант
        if (preferProxy) {
          return await directClient.getPricesByArticle(article);
        } else {
          final results = await proxyClient.getPricesByArticle(article);
          
          // Кэшируем результаты для возможной работы офлайн
          await storageManager.cachePrices(article, results);
          return results;
        }
      } catch (e2) {
        AppLoggers.networkLogger.e(
          'Ошибка в альтернативном режиме, проверяем кэш', e2
        );
        
        // Пробуем получить данные из кэша
        final cachedResults = await storageManager.getCachedPrices(article);
        if (cachedResults.isNotEmpty) {
          return cachedResults;
        }
        
        // Если всё не удалось, пробрасываем исключение
        rethrow;
      }
    }
  }
  
  // Другие методы API...
  
  /// Переключает предпочтительный режим работы
  void togglePreferredMode() {
    preferProxy = !preferProxy;
  }
}
```
#### 4. Локальное хранилище для кэширования и оффлайн-режима:

```dart
/// Менеджер для локального хранения данных
class LocalStorageManager {
  final Box<dynamic> _cacheBox;
  
  LocalStorageManager(this._cacheBox);
  
  // Создание экземпляра с инициализацией Hive
  static Future<LocalStorageManager> create() async {
    await Hive.initFlutter();
    final box = await Hive.openBox('supplier_cache');
    return LocalStorageManager(box);
  }
  
  /// Кэширует результаты запросов о ценах
  Future<void> cachePrices(String article, List<PartPriceModel> prices) async {
    final key = 'prices_$article';
    final data = prices.map((p) => p.toJson()).toList();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    await _cacheBox.put(key, {
      'data': data,
      'timestamp': timestamp,
    });
  }
  
  /// Получает кэшированные цены на запчасти
  Future<List<PartPriceModel>> getCachedPrices(String article) async {
    final key = 'prices_$article';
    final cachedData = _cacheBox.get(key);
    
    if (cachedData == null) {
      return [];
    }
    
    final timestamp = cachedData['timestamp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Если кэш старше 24 часов, считаем его устаревшим
    if (now - timestamp > 24 * 60 * 60 * 1000) {
      await _cacheBox.delete(key);
      return [];
    }
    
    final data = cachedData['data'] as List;
    return data.map((item) => PartPriceModel.fromJson(item)).toList();
  }
  
  /// Очищает кэш для указанного артикула
  Future<void> clearCache(String article) async {
    final key = 'prices_$article';
    await _cacheBox.delete(key);
  }
  
  /// Очищает весь кэш
  Future<void> clearAllCache() async {
    await _cacheBox.clear();
  }
  
  /// Проверяет наличие кэша для артикула
  bool hasCachedData(String article) {
    final key = 'prices_$article';
    return _cacheBox.containsKey(key);
  }
}
```
#### 5. Настройка DI для всех вариантов:

```dart
/// Настройка DI для API клиентов с поддержкой разных режимов
Future<void> setupApiClients() async {
  // Базовые зависимости
  final dio = Dio()..interceptors.add(LogInterceptor());
  
  // Загружаем конфигурацию, включая настройки режима работы
  final config = await AppConfig.fromUserPreferences();
  
  // Локальное хранилище для кэширования
  final storageManager = await LocalStorageManager.create();
  
  // Опциональный менеджер авторизации для прокси
  final authManager = config.apiConnectionMode == ApiConnectionMode.direct 
      ? null 
      : AuthManager();
  
  // Регистрируем менеджер API клиентов
  final apiClientManager = ApiClientManager(
    config,
    dio,
    storageManager,
    authManager,
  );
  locator.registerSingleton<ApiClientManager>(apiClientManager);
  
  // Создаем клиенты для каждого поставщика с выбранным режимом
  final autodocClient = await apiClientManager.createClient('autodoc');
  final existClient = await apiClientManager.createClient('exist');
  final emexClient = await apiClientManager.createClient('emex');
  
  // Регистрируем клиенты в сервис-локаторе
  locator.registerSingleton<SupplierApiClient>(
    autodocClient,
    instanceName: 'autodoc',
  );
  
  locator.registerSingleton<SupplierApiClient>(
    existClient,
    instanceName: 'exist',
  );
  
  locator.registerSingleton<SupplierApiClient>(
    emexClient,
    instanceName: 'emex',
  );
  
  // Регистрируем агрегирующий сервис
  locator.registerSingleton<SuppliersService>(
    SuppliersService({
      'autodoc': locator.get<SupplierApiClient>(instanceName: 'autodoc'),
      'exist': locator.get<SupplierApiClient>(instanceName: 'exist'),
      'emex': locator.get<SupplierApiClient>(instanceName: 'emex'),
    }),
  );
}
```
#### 6. UI для переключения режимов работы:

```dart
class ApiSettingsScreen extends StatefulWidget {
  @override
  _ApiSettingsScreenState createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends State<ApiSettingsScreen> {
  final ApiClientManager _apiClientManager = locator<ApiClientManager>();
  late ApiConnectionMode _selectedMode;
  late TextEditingController _proxyUrlController;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString('api_connection_mode') ?? 'proxy';
    final proxyUrl = prefs.getString('proxy_server_url') ?? '';
    
    setState(() {
      _selectedMode = _parseConnectionMode(modeString);
      _proxyUrlController = TextEditingController(text: proxyUrl);
      _isLoading = false;
    });
  }
  
  ApiConnectionMode _parseConnectionMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'direct': return ApiConnectionMode.direct;
      case 'hybrid': return ApiConnectionMode.hybrid;
      case 'proxy': 
      default: 
        return ApiConnectionMode.proxy;
    }
  }
  
  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    
    try {
      // Сохраняем настройки
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'api_connection_mode', 
        _selectedMode.toString().split('.').last
      );
      await prefs.setString('proxy_server_url', _proxyUrlController.text);
      
      // Обновляем режим в менеджере API
      await _apiClientManager.switchMode(_selectedMode);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Настройки сохранены'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении настроек: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки подключения к API'),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Режим подключения к API поставщиков',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 16),
                
                RadioListTile<ApiConnectionMode>(
                  title: Text('Прямое подключение (Standalone)'),
                  subtitle: Text(
                    'Приложение напрямую обращается к API поставщиков'
                  ),
                  value: ApiConnectionMode.direct,
                  groupValue: _selectedMode,
                  onChanged: (value) {
                    setState(() => _selectedMode = value!);
                  },
                ),
                
                RadioListTile<ApiConnectionMode>(
                  title: Text('Через прокси-сервер'),
                  subtitle: Text(
                    'Все запросы идут через ваш сервер-посредник'
                  ),
                  value: ApiConnectionMode.proxy,
                  groupValue: _selectedMode,
                  onChanged: (value) {
                    setState(() => _selectedMode = value!);
                  },
                ),
                
                RadioListTile<ApiConnectionMode>(
                  title: Text('Гибридный режим'),
                  subtitle: Text(
                    'Автоматическое переключение между режимами при проблемах'
                  ),
                  value: ApiConnectionMode.hybrid,
                  groupValue: _selectedMode,
                  onChanged: (value) {
                    setState(() => _selectedMode = value!);
                  },
                ),
                
                SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _selectedMode != ApiConnectionMode.direct ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 300),
                  child: TextField(
                    controller: _proxyUrlController,
                    decoration: InputDecoration(
                      labelText: 'URL прокси-сервера',
                      hintText: 'https://your-proxy-server.com',
                      enabled: _selectedMode != ApiConnectionMode.direct,
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                if (_selectedMode == ApiConnectionMode.direct)
                  ApiCredentialsForm(),
                
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Сохранить настройки'),
                ),
                
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => locator<LocalStorageManager>().clearAllCache(),
                  child: Text('Очистить кэш API'),
                ),
                
                // Информационный блок
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Информация о режимах',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Прямое подключение: требует наличия учетных данных от каждого поставщика. Подходит для разработки или небольшого объема запросов.\n\n'
                          'Прокси-сервер: все запросы проходят через промежуточный сервер. Обеспечивает безопасное хранение API-ключей и оптимизацию запросов.\n\n'
                          'Гибридный режим: пытается использовать прокси, но при проблемах переключается на прямое подключение.',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
  
  @override
  void dispose() {
    _proxyUrlController.dispose();
    super.dispose();
  }
}

/// Форма для настройки учетных данных для прямого доступа
class ApiCredentialsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Учетные данные API',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        Text(
          'Для прямого подключения введите данные доступа к API:',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 16),
        
        // Autodoc API
        Text('Autodoc', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(labelText: 'API Key'),
        ),
        SizedBox(height: 8),
        
        // Exist API
        Text('Exist', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(labelText: 'API Key'),
        ),
        SizedBox(height: 8),
        
        // Emex API
        Text('Emex', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(labelText: 'API Key'),
        ),
        SizedBox(height: 8),
        
        // Здесь можно добавить других поставщиков
      ],
    );
  }
}
```
## 17. Реализация прокси-сервера на Dart для унификации кода клиента и сервера

Использовать один и тот же код для подключения к RestAPI как на клиенте, так и на сервере, что позволит максимально переиспользовать логику работы с API.

### Архитектурное решение: Shared API Clients

#### 1. Создание shared пакета для общей бизнес-логики:

```dart
/// Общий пакет для доступа к API поставщиков запчастей
library supplier_api;

export 'src/clients/base_supplier_client.dart';
export 'src/clients/autodoc_client.dart';
export 'src/clients/exist_client.dart';
export 'src/clients/emex_client.dart';
export 'src/models/part_price_model.dart';
export 'src/models/supplier_error.dart';
export 'src/exceptions/network_exception.dart';
```
#### 2. Реализация абстракции HTTP-клиента:

```dart
import 'dart:async';

/// Абстрактный интерфейс HTTP-клиента для изоляции от конкретных реализаций
abstract class HttpClientInterface {
  /// Выполняет GET-запрос к указанному URL
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Выполняет POST-запрос к указанному URL
  Future<HttpResponse> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  // Другие необходимые HTTP-методы...
}

/// Универсальный ответ HTTP-запроса
class HttpResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;

  HttpResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });
  
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
```
#### 3. Реализация HTTP-клиента для Flutter:

```dart
import 'package:dio/dio.dart';
import 'http_client_interface.dart';

/// Реализация HTTP-клиента на основе Dio для Flutter-приложения
class DioHttpClient implements HttpClientInterface {
  final Dio _dio;
  
  DioHttpClient(this._dio);
  
  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: _extractHeaders(response.headers),
      );
    } on DioError catch (e) {
      if (e.response != null) {
        return HttpResponse(
          statusCode: e.response?.statusCode ?? 500,
          data: e.response?.data,
          headers: _extractHeaders(e.response?.headers),
        );
      }
      throw NetworkException(e.message);
    }
  }
  
  @override
  Future<HttpResponse> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: _extractHeaders(response.headers),
      );
    } on DioError catch (e) {
      if (e.response != null) {
        return HttpResponse(
          statusCode: e.response?.statusCode ?? 500,
          data: e.response?.data,
          headers: _extractHeaders(e.response?.headers),
        );
      }
      throw NetworkException(e.message);
    }
  }
  
  // Вспомогательный метод для преобразования заголовков Dio в Map
  Map<String, String> _extractHeaders(Headers? headers) {
    if (headers == null) return {};
    
    final result = <String, String>{};
    headers.forEach((name, values) {
      if (values.isNotEmpty) {
        result[name] = values.first;
      }
    });
    return result;
  }
}
```
#### 4. Реализация HTTP-клиента для сервера:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_client_interface.dart';

/// Реализация HTTP-клиента на основе пакета http для Dart-сервера
class ShelfHttpClient implements HttpClientInterface {
  final http.Client _client;
  
  ShelfHttpClient([http.Client? client]) : _client = client ?? http.Client();
  
  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters?.map(
      (key, value) => MapEntry(key, value.toString())
    ));
    
    final response = await _client.get(uri, headers: headers);
    
    return HttpResponse(
      statusCode: response.statusCode,
      data: _parseResponseData(response),
      headers: response.headers,
    );
  }
  
  @override
  Future<HttpResponse> post(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters?.map(
      (key, value) => MapEntry(key, value.toString())
    ));
    
    final bodyJson = data != null ? jsonEncode(data) : null;
    final mergedHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    
    final response = await _client.post(
      uri,
      body: bodyJson,
      headers: mergedHeaders,
    );
    
    return HttpResponse(
      statusCode: response.statusCode,
      data: _parseResponseData(response),
      headers: response.headers,
    );
  }
  
  /// Парсит данные ответа в зависимости от Content-Type
  dynamic _parseResponseData(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    
    if (contentType.contains('application/json')) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    }
    
    return response.body;
  }
  
  void close() {
    _client.close();
  }
}
```
#### 5. Реализация базового клиента для всех поставщиков:

```dart
import '../http/http_client_interface.dart';
import '../models/part_price_model.dart';
import '../models/part_detail_model.dart';
import '../exceptions/network_exception.dart';

/// Базовый интерфейс всех поставщиков запчастей
abstract class SupplierApiClient {
  /// Получает цены на запчасть по артикулу
  Future<List<PartPriceModel>> getPricesByArticle(String article);
  
  /// Поиск запчастей по наименованию
  Future<List<PartInfoModel>> searchPartsByName(String name);
  
  /// Получает детальную информацию о запчасти
  Future<PartDetailModel?> getPartDetails(String articleNumber);
  
  /// Возвращает название поставщика
  String get supplierName;
}

/// Базовая реализация клиента API поставщика
abstract class BaseSupplierClient implements SupplierApiClient {
  final HttpClientInterface httpClient;
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  
  BaseSupplierClient({
    required this.httpClient,
    required this.baseUrl,
    this.defaultHeaders = const {},
  });
  
  /// Формирует полный URL для запроса
  String buildUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    
    final String normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
        
    final String normalizedPath = path.startsWith('/')
        ? path.substring(1)
        : path;
        
    return '$normalizedBaseUrl/$normalizedPath';
  }
  
  /// Выполняет GET-запрос с обработкой ошибок
  Future<HttpResponse> safeGet(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpClient.get(
        buildUrl(path),
        queryParameters: queryParameters,
        headers: {
          ...defaultHeaders,
          ...?headers,
        },
      );
      
      if (!response.isSuccessful) {
        throw NetworkException(
          'Failed to get data from $path',
          statusCode: response.statusCode,
        );
      }
      
      return response;
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw NetworkException('Failed to connect to $supplierName API: $e');
    }
  }
  
  /// Выполняет POST-запрос с обработкой ошибок
  Future<HttpResponse> safePost(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await httpClient.post(
        buildUrl(path),
        data: data,
        queryParameters: queryParameters,
        headers: {
          ...defaultHeaders,
          ...?headers,
        },
      );
      
      if (!response.isSuccessful) {
        throw NetworkException(
          'Failed to post data to $path',
          statusCode: response.statusCode,
        );
      }
      
      return response;
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw NetworkException('Failed to connect to $supplierName API: $e');
    }
  }
}
```
#### 6. Реализация API-клиента для конкретного поставщика:

```dart
import '../http/http_client_interface.dart';
import '../models/part_price_model.dart';
import '../models/part_detail_model.dart';
import '../models/part_info_model.dart';
import 'base_supplier_client.dart';

/// Клиент API для поставщика Autodoc
class AutodocClient extends BaseSupplierClient {
  /// Создает клиент API Autodoc с заданными параметрами
  AutodocClient({
    required HttpClientInterface httpClient,
    required String apiKey,
    String baseUrl = 'https://api.autodoc.ru',
  }) : super(
    httpClient: httpClient,
    baseUrl: baseUrl,
    defaultHeaders: {
      'X-API-Key': apiKey,
      'User-Agent': 'PartCatalog/1.0',
    },
  );
  
  @override
  String get supplierName => 'Autodoc';
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    final response = await safeGet(
      '/api/v1/prices',
      queryParameters: {
        'article': article,
        'includeNonOriginal': true,
      },
    );
    
    final items = List<Map<String, dynamic>>.from(response.data['items'] ?? []);
    
    return items.map((json) {
      return PartPriceModel(
        partNumber: json['number'] ?? '',
        name: json['name'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        deliveryDays: (json['deliveryDays'] as num?)?.toInt() ?? 0,
        supplierName: supplierName,
        brandName: json['brand'] ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        isOriginal: json['isOriginal'] as bool? ?? false,
      );
    }).toList();
  }
  
  @override
  Future<List<PartInfoModel>> searchPartsByName(String name) async {
    final response = await safeGet(
      '/api/v1/search',
      queryParameters: {
        'text': name,
        'limit': 20,
      },
    );
    
    final items = List<Map<String, dynamic>>.from(response.data['items'] ?? []);
    
    return items.map((json) {
      return PartInfoModel(
        partNumber: json['number'] ?? '',
        name: json['name'] ?? '',
        brandName: json['brand'] ?? '',
        isOriginal: json['isOriginal'] as bool? ?? false,
      );
    }).toList();
  }
  
  @override
  Future<PartDetailModel?> getPartDetails(String articleNumber) async {
    final response = await safeGet(
      '/api/v1/parts/$articleNumber',
    );
    
    if (response.data == null) return null;
    
    return PartDetailModel(
      partNumber: response.data['number'] ?? articleNumber,
      name: response.data['name'] ?? '',
      brandName: response.data['brandName'] ?? '',
      description: response.data['description'] ?? '',
      weight: (response.data['weight'] as num?)?.toDouble(),
      properties: Map<String, String>.from(response.data['properties'] ?? {}),
      images: List<String>.from(response.data['images'] ?? []),
      isOriginal: response.data['isOriginal'] as bool? ?? false,
    );
  }
}
```
#### 7. Реализация моделей данных:

```dart
/// Модель цены на запчасть от поставщика
class PartPriceModel {
  final String partNumber;
  final String name;
  final double price;
  final int deliveryDays;
  final String supplierName;
  final String brandName;
  final int quantity;
  final bool isOriginal;
  
  PartPriceModel({
    required this.partNumber,
    required this.name, 
    required this.price,
    required this.deliveryDays,
    required this.supplierName,
    this.brandName = '',
    this.quantity = 0,
    this.isOriginal = false,
  });
  
  // Фабрика для создания из JSON
  factory PartPriceModel.fromJson(Map<String, dynamic> json) {
    return PartPriceModel(
      partNumber: json['partNumber'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      deliveryDays: json['deliveryDays'] as int? ?? 0,
      supplierName: json['supplierName'] ?? '',
      brandName: json['brandName'] ?? '',
      quantity: json['quantity'] as int? ?? 0,
      isOriginal: json['isOriginal'] as bool? ?? false,
    );
  }
  
  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'partNumber': partNumber,
      'name': name,
      'price': price,
      'deliveryDays': deliveryDays,
      'supplierName': supplierName,
      'brandName': brandName,
      'quantity': quantity,
      'isOriginal': isOriginal,
    };
  }
}

// filepath: packages/supplier_api/lib/src/models/part_info_model.dart
/// Модель базовой информации о запчасти
class PartInfoModel {
  final String partNumber;
  final String name;
  final String brandName;
  final bool isOriginal;
  
  PartInfoModel({
    required this.partNumber,
    required this.name,
    required this.brandName,
    this.isOriginal = false,
  });
  
  Map<String, dynamic> toJson() => {
    'partNumber': partNumber,
    'name': name,
    'brandName': brandName,
    'isOriginal': isOriginal,
  };
  
  factory PartInfoModel.fromJson(Map<String, dynamic> json) => PartInfoModel(
    partNumber: json['partNumber'] ?? '',
    name: json['name'] ?? '',
    brandName: json['brandName'] ?? '',
    isOriginal: json['isOriginal'] as bool? ?? false,
  );
}

// filepath: packages/supplier_api/lib/src/models/part_detail_model.dart
/// Детальная информация о запчасти
class PartDetailModel {
  final String partNumber;
  final String name;
  final String brandName;
  final String description;
  final double? weight;
  final Map<String, String> properties;
  final List<String> images;
  final bool isOriginal;
  
  PartDetailModel({
    required this.partNumber,
    required this.name,
    required this.brandName,
    this.description = '',
    this.weight,
    this.properties = const {},
    this.images = const [],
    this.isOriginal = false,
  });
  
  Map<String, dynamic> toJson() => {
    'partNumber': partNumber,
    'name': name,
    'brandName': brandName,
    'description': description,
    'weight': weight,
    'properties': properties,
    'images': images,
    'isOriginal': isOriginal,
  };
  
  factory PartDetailModel.fromJson(Map<String, dynamic> json) => PartDetailModel(
    partNumber: json['partNumber'] ?? '',
    name: json['name'] ?? '',
    brandName: json['brandName'] ?? '',
    description: json['description'] ?? '',
    weight: (json['weight'] as num?)?.toDouble(),
    properties: Map<String, String>.from(json['properties'] ?? {}),
    images: List<String>.from(json['images'] ?? []),
    isOriginal: json['isOriginal'] as bool? ?? false,
  );
}
```
#### 8. Реализация прокси-сервера на Dart:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:supplier_api/supplier_api.dart';
import 'package:http/http.dart' as http;
import 'package:supplier_api/src/http/shelf_http_client.dart';

// Глобальное хранилище API-клиентов поставщиков
final _apiClients = <String, SupplierApiClient>{};

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');
  
  final result = parser.parse(args);
  final port = int.tryParse(result['port'] as String) ?? 8080;

  // Инициализация API клиентов
  await _initApiClients();

  // Создаем маршрутизатор для обработки запросов
  final router = Router();

  // Маршрут для проверки состояния сервера
  router.get('/health', (shelf.Request request) {
    return shelf.Response.ok('OK');
  });

  // Получение цен от поставщика по артикулу
  router.get('/api/suppliers/<supplier>/prices', (shelf.Request request, String supplier) async {
    final article = request.url.queryParameters['article'];
    
    if (article == null || article.isEmpty) {
      return shelf.Response.badRequest(
        body: jsonEncode({'error': 'Article parameter is required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final client = _apiClients[supplier.toLowerCase()];
    if (client == null) {
      return shelf.Response.notFound(
        jsonEncode({'error': 'Unknown supplier: $supplier'}),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final prices = await client.getPricesByArticle(article);
      final jsonData = prices.map((p) => p.toJson()).toList();
      
      return shelf.Response.ok(
        jsonEncode(jsonData),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch prices: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // Поиск запчастей по названию
  router.get('/api/suppliers/<supplier>/search', (shelf.Request request, String supplier) async {
    final query = request.url.queryParameters['query'];
    
    if (query == null || query.isEmpty) {
      return shelf.Response.badRequest(
        body: jsonEncode({'error': 'Query parameter is required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final client = _apiClients[supplier.toLowerCase()];
    if (client == null) {
      return shelf.Response.notFound(
        jsonEncode({'error': 'Unknown supplier: $supplier'}),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final parts = await client.searchPartsByName(query);
      final jsonData = parts.map((p) => p.toJson()).toList();
      
      return shelf.Response.ok(
        jsonEncode(jsonData),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to search parts: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // Получение детальной информации о запчасти
  router.get('/api/suppliers/<supplier>/parts/<articleNumber>', (
    shelf.Request request, String supplier, String articleNumber) async {
    final client = _apiClients[supplier.toLowerCase()];
    if (client == null) {
      return shelf.Response.notFound(
        jsonEncode({'error': 'Unknown supplier: $supplier'}),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final details = await client.getPartDetails(articleNumber);
      
      if (details == null) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'Part not found: $articleNumber'}),
          headers: {'content-type': 'application/json'},
        );
      }
      
      return shelf.Response.ok(
        jsonEncode(details.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch part details: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // Агрегация цен от всех поставщиков по артикулу
  router.get('/api/prices', (shelf.Request request) async {
    final article = request.url.queryParameters['article'];
    
    if (article == null || article.isEmpty) {
      return shelf.Response.badRequest(
        body: jsonEncode({'error': 'Article parameter is required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final results = <String, List<Map<String, dynamic>>>{};
    final errors = <String, String>{};

    final futures = _apiClients.entries.map((entry) async {
      final supplier = entry.key;
      final client = entry.value;
      
      try {
        final prices = await client.getPricesByArticle(article);
        results[supplier] = prices.map((p) => p.toJson()).toList();
      } catch (e) {
        errors[supplier] = 'Error: $e';
      }
    });

    await Future.wait(futures);

    return shelf.Response.ok(
      jsonEncode({
        'results': results,
        'errors': errors,
      }),
      headers: {'content-type': 'application/json'},
    );
  });

  // Настройка middleware для логирования, CORS и др.
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  // Запуск сервера
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Proxy server started on port ${server.port}');
}

// Инициализация API-клиентов поставщиков
Future<void> _initApiClients() async {
  final httpClient = ShelfHttpClient(http.Client());
  
  // Загрузка конфигурации из переменных окружения или файла
  final apiKeys = {
    'autodoc': Platform.environment['AUTODOC_API_KEY'] ?? 'your_default_key',
    'exist': Platform.environment['EXIST_API_KEY'] ?? 'your_default_key',
    'emex': Platform.environment['EMEX_API_KEY'] ?? 'your_default_key',
  };
  
  // Инициализация клиентов поставщиков
  _apiClients['autodoc'] = AutodocClient(
    httpClient: httpClient,
    apiKey: apiKeys['autodoc']!,
  );
  
  _apiClients['exist'] = ExistClient(
    httpClient: httpClient,
    apiKey: apiKeys['exist']!,
  );
  
  _apiClients['emex'] = EmexClient(
    httpClient: httpClient,
    apiKey: apiKeys['emex']!,
  );
}

// Middleware для включения CORS
shelf.Middleware _corsMiddleware() {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final response = await innerHandler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
        ...response.headers,
      });
    };
  };
}
```
#### 9. Реализация клиента для приложения Flutter:

```dart
import 'package:dio/dio.dart';
import 'package:supplier_api/supplier_api.dart';
import 'package:supplier_api/src/http/dio_http_client.dart';
import 'package:part_catalog/core/config/app_config.dart';

/// Фабрика для создания API-клиентов поставщиков с учетом режима работы
class SupplierApiClientFactory {
  final Dio dio;
  final AppConfig config;
  
  SupplierApiClientFactory(this.dio, this.config);
  
  /// Создает клиент API для указанного поставщика
  SupplierApiClient createClient(String supplierName) {
    // Для режима прямого подключения
    if (config.apiConnectionMode == ApiConnectionMode.direct) {
      return _createDirectClient(supplierName);
    }
    
    // Для режима через прокси
    return _createProxyClient(supplierName);
  }
  
  /// Создает клиент с прямым подключением к API поставщика
  SupplierApiClient _createDirectClient(String supplierName) {
    final httpClient = DioHttpClient(dio);
    
    // Проверяем наличие API-ключа для поставщика
    final apiKey = config.directApiCredentials[supplierName.toLowerCase()]?.apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing API key for supplier: $supplierName');
    }
    
    // Создаем соответствующий клиент для поставщика
    switch (supplierName.toLowerCase()) {
      case 'autodoc':
        return AutodocClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      case 'exist':
        return ExistClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      case 'emex':
        return EmexClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      default:
        throw Exception('Unsupported supplier: $supplierName');
    }
  }
  
  /// Создает клиент для работы через прокси-сервер
  SupplierApiClient _createProxyClient(String supplierName) {
    // Проверяем настройки прокси-сервера
    final proxyUrl = config.proxyServerUrl;
    if (proxyUrl.isEmpty) {
      throw Exception('Proxy server URL is not configured');
    }
    
    final httpClient = DioHttpClient(dio);
    
    // Возвращаем клиент, который будет работать через прокси
    return ProxySupplierApiClient(
      httpClient: httpClient,
      baseUrl: proxyUrl,
      supplierName: supplierName.toLowerCase(),
    );
  }
}

/// Клиент API для работы через прокси-сервер
class ProxySupplierApiClient implements SupplierApiClient {
  final DioHttpClient httpClient;
  final String baseUrl;
  final String _supplierName;
  
  ProxySupplierApiClient({
    required this.httpClient,
    required this.baseUrl,
    // filepath: lib/features/suppliers/api/supplier_api_client_factory.dart
import 'package:dio/dio.dart';
import 'package:supplier_api/supplier_api.dart';
import 'package:supplier_api/src/http/dio_http_client.dart';
import 'package:part_catalog/core/config/app_config.dart';

/// Фабрика для создания API-клиентов поставщиков с учетом режима работы
class SupplierApiClientFactory {
  final Dio dio;
  final AppConfig config;
  
  SupplierApiClientFactory(this.dio, this.config);
  
  /// Создает клиент API для указанного поставщика
  SupplierApiClient createClient(String supplierName) {
    // Для режима прямого подключения
    if (config.apiConnectionMode == ApiConnectionMode.direct) {
      return _createDirectClient(supplierName);
    }
    
    // Для режима через прокси
    return _createProxyClient(supplierName);
  }
  
  /// Создает клиент с прямым подключением к API поставщика
  SupplierApiClient _createDirectClient(String supplierName) {
    final httpClient = DioHttpClient(dio);
    
    // Проверяем наличие API-ключа для поставщика
    final apiKey = config.directApiCredentials[supplierName.toLowerCase()]?.apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing API key for supplier: $supplierName');
    }
    
    // Создаем соответствующий клиент для поставщика
    switch (supplierName.toLowerCase()) {
      case 'autodoc':
        return AutodocClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      case 'exist':
        return ExistClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      case 'emex':
        return EmexClient(
          httpClient: httpClient,
          apiKey: apiKey,
        );
      default:
        throw Exception('Unsupported supplier: $supplierName');
    }
  }
  
  /// Создает клиент для работы через прокси-сервер
  SupplierApiClient _createProxyClient(String supplierName) {
    // Проверяем настройки прокси-сервера
    final proxyUrl = config.proxyServerUrl;
    if (proxyUrl.isEmpty) {
      throw Exception('Proxy server URL is not configured');
    }
    
    final httpClient = DioHttpClient(dio);
    
    // Возвращаем клиент, который будет работать через прокси
    return ProxySupplierApiClient(
      httpClient: httpClient,
      baseUrl: proxyUrl,
      supplierName: supplierName.toLowerCase(),
    );
  }
}

/// Клиент API для работы через прокси-сервер
class ProxySupplierApiClient implements SupplierApiClient {
  final DioHttpClient httpClient;
  final String baseUrl;
  final String _supplierName;
  
  ProxySupplierApiClient({
    required this.httpClient,
    required this.baseUrl,
    required String supplierName,
  }) : _supplierName = supplierName;
}
  
  @override
  String get supplierName => _supplierName;
  
  @override
  Future<List<PartPriceModel>> getPricesByArticle(String article) async {
    final response = await httpClient.get(
      '$baseUrl/api/suppliers/$_supplierName/prices?article=$article',
    );
    
    final items = List<Map<String, dynamic>>.from(response.data);
    
    return items.map((json) => PartPriceModel.fromJson(json)).toList();
  }
  
  @override
  Future<List<PartInfoModel>> searchPartsByName(String name) async {
    final response = await httpClient.get(
      '$baseUrl/api/suppliers/$_supplierName/search?query=$name',
    );
    
    final items = List<Map<String, dynamic>>.from(response.data);
    
    return items.map((json) => PartInfoModel.fromJson(json)).toList();
  }
  
  @override
  Future<PartDetailModel?> getPartDetails(String articleNumber) async {
    final response = await httpClient.get(
      '$baseUrl/api/suppliers/$_supplierName/parts/$articleNumber',
    );
    
    if (response.data == null) return null;
    
    return PartDetailModel.fromJson(response.data);
  }
}
```

Реализация улучшения документации проекта part_catalog
План реорганизации документации
Для улучшения файла инструкций предлагаю следующую реорганизацию:

1. Разделение на отдельные документы
Создадим следующую структуру документации в папке docs/:
```plaintext
docs/
├── README.md                     # Основной обзор проекта и навигация
├── architecture/
│   ├── overview.md               # Общая архитектура приложения
│   ├── database_schema.md        # Структура БД и маппинги
│   └── api_integration.md        # Интеграция с внешними API
├── modules/
│   ├── clients.md                # Модуль клиентов
│   ├── vehicles.md               # Модуль автомобилей
│   ├── orders.md                 # Модуль заказ-нарядов
│   └── suppliers/                # Модуль поставщиков
│       ├── overview.md           # Обзор модуля поставщиков
│       ├── direct_api.md         # Прямое подключение к API
│       └── proxy_server.md       # Реализация прокси-сервера
├── guides/
│   ├── code_style.md             # Руководство по стилю кодирования
│   ├── testing.md                # Стратегия и паттерны тестирования
│   ├── error_handling.md         # Стратегия обработки ошибок
│   └── async_programming.md      # Работа с асинхронным кодом
└── references/
    ├── api_reference.md          # Справочник по API проекта
    └── code_examples/            # Папка с полными примерами кода
        ├── api_client.dart       # Полный пример API клиента
        └── proxy_server.dart     # Полный пример прокси-сервера
```