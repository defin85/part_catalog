# Модуль заказ-нарядов

> Модуль заказ-нарядов обеспечивает создание и управление заказ-нарядами на ремонт автомобилей, включая список работ, запчастей и материалов.

## Содержание
- [Назначение](#назначение)
- [Архитектура](#архитектура)
- [Основные компоненты](#основные-компоненты)
- [Модели данных](#модели-данных)
- [Основные операции](#основные-операции)
- [UI компоненты](#ui-компоненты)
- [Жизненный цикл заказ-наряда](#жизненный-цикл-заказ-наряда)
- [Интеграция с другими модулями](#интеграция-с-другими-модулями)

## Назначение

Модуль заказ-нарядов решает следующие задачи:

- Создание и управление заказ-нарядами на ремонт автомобилей
- Учет выполненных работ и использованных запчастей
- Отслеживание статуса выполнения заказ-нарядов
- Расчет стоимости работ и материалов
- Взаимодействие с модулями клиентов, автомобилей и поставщиков

## Архитектура

Модуль следует принципам чистой архитектуры и состоит из следующих уровней:

| Уровень | Назначение | Компоненты |
|---------|------------|------------|
| Presentation | Пользовательский интерфейс | `OrdersScreen`, `OrderDetailsScreen`,  `OrderFormScreen`|
| Domain | Бизнес-логика | `OrderService`, `OrderStatusManager` |
| Data | Доступ к данным | `OrdersDao`, `OrderPartsDao`, `OrderServicesDao` |

## Основные компоненты

### OrderService

Сервисный класс, обеспечивающий бизнес-логику работы с заказ-нарядами:

Функциональность: Управление жизненным циклом заказ-нарядов, обработка данных
Ключевые методы:
getOrders(): Получение всех активных заказ-нарядов
watchOrders(): Реактивное наблюдение за списком заказ-нарядов
createOrder(): Создание нового заказ-наряда
updateOrder(): Обновление существующего заказ-наряда
addPartToOrder(): Добавление запчасти в заказ-наряд
addServiceToOrder(): Добавление работы в заказ-наряд
calculateOrderTotal(): Расчет общей стоимости заказ-наряда
changeOrderStatus(): Изменение статуса заказ-наряда

### OrderStatusManager

Класс для управления статусами заказ-нарядов:

Функциональность: Контроль переходов между статусами, валидация возможных действий
Ключевые методы:
canTransitionTo(OrderStatus from, OrderStatus to): Проверка возможности перехода
transitionTo(Order order, OrderStatus newStatus): Выполнение перехода
getAvailableTransitions(Order order): Получение доступных переходов

### OrdersDao

Data Access Object для прямой работы с таблицей заказ-нарядов:

Функциональность: Предоставляет низкоуровневый доступ к данным таблицы
Ключевые методы:
getActiveOrders(): Получение всех активных заказ-нарядов
watchActiveOrders(): Реактивное наблюдение за заказ-нарядами
getOrdersByClientId(): Получение заказ-нарядов клиента
getOrdersByCarId(): Получение заказ-нарядов для автомобиля
insertOrder(): Добавление нового заказ-наряда
updateOrder(): Обновление данных заказ-наряда
updateOrderStatus(): Обновление статуса заказ-наряда
getFullOrderDetails(): Получение полных данных заказ-наряда с работами и запчастями

## Модели данных

### OrdersItem (модель таблицы)

```dart
class OrdersItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(ClientsItems, #id)();
  IntColumn get carId => integer().references(CarsItems, #id)();
  TextColumn get orderNumber => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get status => text()(); // "new", "in_progress", "completed", "cancelled"
  TextColumn get description => text().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
```

### OrderPartsItem (модель таблицы)

```dart
class OrderPartsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OrdersItems, #id)();
  TextColumn get partNumber => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  TextColumn get supplierName => text().nullable()();
  IntColumn get deliveryDays => integer().nullable()();
  BoolColumn get isOrdered => boolean().withDefault(const Constant(false))();
  BoolColumn get isReceived => boolean().withDefault(const Constant(false))();
}
```

### OrderServicesItem (модель таблицы)

```dart
class OrderServicesItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OrdersItems, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
  RealColumn get duration => real().nullable()(); // в часах
  TextColumn get performedBy => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
```

### OrderModel (бизнес-модель)

Представляет заказ-наряд в бизнес-логике приложения:

id: Уникальный идентификатор
clientId: ID клиента
carId: ID автомобиля
orderNumber: Номер заказ-наряда
createdAt: Дата создания
scheduledDate: Запланированная дата выполнения
completedAt: Дата завершения
status: Статус заказ-наряда (OrderStatus)
description: Описание проблемы/работ
totalAmount: Общая стоимость
parts: Список запчастей (OrderPartModel)
services: Список работ (OrderServiceModel)
clientName: Имя клиента (опционально, для отображения)
carInfo: Информация об автомобиле (опционально, для отображения)

### OrderStatus (перечисление)

```dart
enum OrderStatus {
  new,
  inProgress,
  waitingForParts,
  readyForPickup,
  completed,
  cancelled;
  
  String get displayName {
    switch (this) {
      case OrderStatus.new: return 'Новый';
      case OrderStatus.inProgress: return 'В работе';
      case OrderStatus.waitingForParts: return 'Ожидание запчастей';
      case OrderStatus.readyForPickup: return 'Готов к выдаче';
      case OrderStatus.completed: return 'Завершен';
      case OrderStatus.cancelled: return 'Отменен';
    }
  }
  
  Color get color {
    switch (this) {
      case OrderStatus.new: return Colors.blue;
      case OrderStatus.inProgress: return Colors.orange;
      case OrderStatus.waitingForParts: return Colors.amber;
      case OrderStatus.readyForPickup: return Colors.green;
      case OrderStatus.completed: return Colors.teal;
      case OrderStatus.cancelled: return Colors.red;
    }
  }
}
```

## Основные операции

### Создание заказ-наряда

Процесс создания заказ-наряда включает:

Выбор клиента
Выбор автомобиля клиента
Указание описания проблемы
Планирование даты выполнения
Добавление работ
Добавление запчастей
Расчет общей стоимости
Сохранение заказ-наряда

### Управление запчастями заказ-наряда

Операции с запчастями включают:

Добавление запчасти вручную
Подбор запчасти через каталог
Получение цен от поставщиков
Отметка о заказе запчасти
Отметка о получении запчасти

### Управление статусом заказ-наряда

Жизненный цикл заказ-наряда включает различные статусы:

Новый → В работе → Завершен
Новый → Ожидание запчастей → В работе → Завершен
Новый → Отменен
Смена статуса сопровождается валидацией и может инициировать дополнительные действия.

## UI компоненты

### OrdersScreen

Основной экран управления заказ-нарядами:

Список активных заказ-нарядов с группировкой по статусам
Фильтрация по клиенту, автомобилю, дате, статусу
Поиск по номеру заказ-наряда или описанию
Возможность создания нового заказ-наряда
Отображение статуса и основной информации

### OrderFormScreen

Форма для создания/редактирования заказ-наряда:

Выбор клиента из списка с возможностью создания нового
Выбор автомобиля из списка автомобилей клиента
Поля для ввода описания и планирования даты
Добавление работ со стоимостью и описанием
Добавление запчастей с интеграцией каталога и поставщиков
Расчет итоговой стоимости

### OrderDetailsScreen

Экран детальной информации о заказ-наряде:

Полная информация о клиенте и автомобиле
Список работ с возможностью отметки выполнения
Список запчастей с информацией о наличии/заказе
Изменение статуса заказ-наряда
Печать/экспорт заказ-наряда

## Жизненный цикл заказ-наряда

Жизненный цикл заказ-наряда включает следующие этапы:
1. Создание заказ-наряда
2. Добавление работ и запчастей
3. Изменение статуса (в работе, ожидание запчастей, завершен)
4. Завершение заказ-наряда
5. Архивирование или удаление (мягкое удаление)
6. Отчетность и аналитика по завершенным заказ-нарядам
7. Интеграция с бухгалтерией (при необходимости)

## Интеграция с другими модулями

### Взаимодействие с модулем клиентов

Получение информации о клиенте
Отображение истории заказ-нарядов клиента
Создание нового клиента непосредственно из формы заказ-наряда

## Взаимодействие с модулем автомобилей

Выбор автомобиля клиента для заказ-наряда
Отображение истории заказ-нарядов автомобиля
Создание нового автомобиля непосредственно из формы заказ-наряда

### Взаимодействие с модулем поставщиков

Подбор запчастей по артикулу с использованием ApiClientPartsCatalogs
Получение цен и сроков поставки от поставщиков
Отображение информации о наличии и стоимости запчастей
Оформление заказа на запчасти у поставщика