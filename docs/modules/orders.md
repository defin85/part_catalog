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

Модуль следует принципам чистой архитектуры и использует архитектуру "Композиция + Интерфейсы + `@freezed`". Он состоит из следующих уровней:

| Уровень | Назначение | Компоненты |
|---------|------------|------------|
| Presentation | Пользовательский интерфейс | `OrdersScreen`, `OrderDetailsScreen`, `OrderFormScreen` |
| Domain | Бизнес-логика | `OrderService`, `OrderStatusManager`, `OrderModelComposite`, `OrderPartModelComposite`, `OrderServiceModelComposite`, `IDocumentEntity`, `IDocumentItemEntity` |
| Data | Доступ к данным | `OrdersDao`, `OrderPartsDao`, `OrderServicesDao`, `EntityCoreData`, `DocumentSpecificData`, `OrderSpecificData`, `ItemCoreData`, `DocumentItemSpecificData`, `PartSpecificData`, `ServiceSpecificData` (`@freezed` модели) |

## Основные компоненты

### OrderService

Сервисный класс, обеспечивающий бизнес-логику работы с заказ-нарядами:

Функциональность: Управляет жизненным циклом заказ-нарядов, работает с бизнес-моделями (`OrderModelComposite`, `OrderPartModelComposite`, `OrderServiceModelComposite`) и интерфейсами (`IDocumentEntity`, `IDocumentItemEntity`). Координирует взаимодействие с DAO для получения/сохранения данных, преобразуя `@freezed` модели данных в бизнес-модели и обратно.
Ключевые методы:
`getOrders()`: Получение списка `OrderModelComposite`.
`watchOrders()`: Реактивное наблюдение за списком `OrderModelComposite`.
`createOrder()`: Создание нового `OrderModelComposite`.
`updateOrder()`: Обновление существующего `OrderModelComposite`.
`addPartToOrder()`: Добавление `OrderPartModelComposite` в `OrderModelComposite`.
`addServiceToOrder()`: Добавление `OrderServiceModelComposite` в `OrderModelComposite`.
`calculateOrderTotal()`: Расчет общей стоимости `OrderModelComposite`.
`changeOrderStatus()`: Изменение статуса `OrderModelComposite`.

### OrderStatusManager

Класс для управления статусами заказ-нарядов:

Функциональность: Контроль переходов между статусами (`OrderStatus`), валидация возможных действий на основе текущего статуса `OrderModelComposite`.
Ключевые методы:
`canTransitionTo(OrderStatus from, OrderStatus to)`: Проверка возможности перехода.
`transitionTo(OrderModelComposite order, OrderStatus newStatus)`: Выполнение перехода (возвращает новый экземпляр `OrderModelComposite`).
`getAvailableTransitions(OrderModelComposite order)`: Получение доступных переходов.

### OrdersDao, OrderPartsDao, OrderServicesDao

Data Access Objects для прямой работы с таблицами `OrdersItems`, `OrderPartsItems`, `OrderServicesItems` в БД:

Функциональность: Предоставляют низкоуровневый доступ к данным таблиц. Получают данные в виде моделей таблиц (`OrdersItem` и т.д.) и мапят их в соответствующие `@freezed` модели данных (`EntityCoreData`, `DocumentSpecificData`, `ItemCoreData` и т.д.) для передачи в сервисный слой. При сохранении принимают `Companion` объекты, созданные из `@freezed` моделей данных.
Ключевые методы:
`getActiveOrders()`: Получение данных для активных заказ-нарядов.
`watchActiveOrders()`: Реактивное наблюдение за данными заказ-нарядов.
`getOrdersByClientId()`: Получение данных заказ-нарядов клиента.
`getOrdersByCarId()`: Получение данных заказ-нарядов для автомобиля.
`insertOrder()`: Добавление нового заказ-наряда (принимает `Companion`).
`updateOrder()`: Обновление данных заказ-наряда (принимает `Companion`).
`updateOrderStatus()`: Обновление статуса заказ-наряда.
`getFullOrderDetails()`: Получение полных данных заказ-наряда с работами и запчастями (в виде `@freezed` моделей).

## Модели данных

### Модели таблиц (Drift)

- `OrdersItems`: Структура таблицы заказ-нарядов.
- `OrderPartsItems`: Структура таблицы запчастей заказ-наряда.
- `OrderServicesItems`: Структура таблицы услуг заказ-наряда.

### Модели данных (`@freezed`)

Чистые, иммутабельные структуры для хранения данных, используемые для передачи между слоями Data и Domain:
- `EntityCoreData`: Базовые данные сущности (uuid, code, displayName...).
- `DocumentSpecificData`: Специфичные данные документа (status, documentDate...).
- `OrderSpecificData`: Специфичные данные заказ-наряда (clientId, carId...).
- `ItemCoreData`: Базовые данные элемента (uuid, name, itemType...).
- `DocumentItemSpecificData`: Специфичные данные элемента документа (price, quantity...).
- `PartSpecificData`: Специфичные данные запчасти (partNumber, brand...).
- `ServiceSpecificData`: Специфичные данные услуги (duration, performedBy...).

### Бизнес-модели (Композиторы)

Классы, реализующие интерфейсы (`IDocumentEntity`, `IDocumentItemEntity`) и инкапсулирующие `@freezed` модели данных. Представляют заказ-наряд и его элементы в бизнес-логике:
- `OrderModelComposite`: Представляет заказ-наряд. Содержит `EntityCoreData`, `DocumentSpecificData`, `OrderSpecificData` и карту `_itemsMap` с `IDocumentItemEntity`. Реализует `IDocumentEntity`.
- `OrderPartModelComposite`: Представляет запчасть в заказ-наряде. Содержит `ItemCoreData`, `DocumentItemSpecificData`, `PartSpecificData`. Реализует `IDocumentItemEntity`.
- `OrderServiceModelComposite`: Представляет услугу в заказ-наряде. Содержит `ItemCoreData`, `DocumentItemSpecificData`, `ServiceSpecificData`. Реализует `IDocumentItemEntity`.

### OrderStatus (перечисление)

Определяет возможные статусы заказ-наряда (`new`, `inProgress`, `waitingForParts`, `readyForPickup`, `completed`, `cancelled`) с методами для получения отображаемого имени и цвета.

## Основные операции

### Создание заказ-наряда

Процесс создания `OrderModelComposite` включает:
- Выбор клиента и автомобиля.
- Указание описания проблемы и планирование даты.
- Добавление работ (`OrderServiceModelComposite`) и запчастей (`OrderPartModelComposite`).
- Расчет общей стоимости.
- Сохранение через `OrderService`, который преобразует композитор в `@freezed` модели и передает их в DAO.

### Управление запчастями заказ-наряда

Операции с `OrderPartModelComposite` включают:
- Добавление вручную или через каталог.
- Получение цен от поставщиков (через `SuppliersService`).
- Обновление статусов заказа и получения (методы `withOrderStatus`, `withReceiveStatus` в композиторе).

### Управление статусом заказ-наряда

Изменение статуса `OrderModelComposite` через `OrderService` и `OrderStatusManager`. Смена статуса сопровождается валидацией и может инициировать дополнительные действия. Используется иммутабельный метод `withStatus` композитора.

## UI компоненты

### OrdersScreen

Основной экран управления заказ-нарядами:
- Отображает список `OrderModelComposite`.
- Использует `OrderService` для получения и фильтрации данных.
- Позволяет создавать новые заказ-наряды.

### OrderFormScreen

Форма для создания/редактирования `OrderModelComposite`:
- Взаимодействует с `OrderService` для сохранения данных.
- Позволяет добавлять/редактировать `OrderPartModelComposite` и `OrderServiceModelComposite`.

### OrderDetailsScreen

Экран детальной информации о `OrderModelComposite`:
- Отображает полную информацию, включая списки работ и запчастей.
- Позволяет изменять статус через `OrderService`.

## Жизненный цикл заказ-наряда

Жизненный цикл `OrderModelComposite` управляется через `OrderService` и `OrderStatusManager`, включая создание, изменение статусов, завершение и архивирование (мягкое удаление).

## Интеграция с другими модулями

### Взаимодействие с модулем клиентов

- Получение информации о клиенте (`ClientModelComposite`) для отображения в заказ-наряде.
- Отображение истории заказ-нарядов (`OrderModelComposite`) клиента.

### Взаимодействие с модулем автомобилей

- Выбор автомобиля (`CarModelComposite`) клиента для заказ-наряда.
- Отображение истории заказ-нарядов (`OrderModelComposite`) автомобиля.

### Взаимодействие с модулем поставщиков

- Подбор запчастей (`OrderPartModelComposite`) по артикулу.
- Получение цен и сроков поставки от поставщиков через `SuppliersService`.
- Отображение информации о наличии и стоимости запчастей.