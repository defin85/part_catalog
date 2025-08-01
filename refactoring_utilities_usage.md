# Руководство по использованию утилит рефакторинга

## 📋 Обзор

Созданы две группы утилит для упрощения работы с композитными моделями:
1. **CompositeUtils** - статические методы для общей функциональности
2. **Extension методы** - расширения для интерфейсов IEntity, IDocumentEntity, IReferenceEntity

## 🔧 CompositeUtils

### Пример использования в композитной модели:

```dart
class ClientModelComposite implements IReferenceEntity {
  // ... существующий код ...

  /// Помечает клиента как удаленного
  ClientModelComposite markAsDeleted() {
    return CompositeUtils.markAsDeleted(
      coreData: coreData,
      rebuild: (newCore) => ClientModelComposite._(
        coreData: newCore,
        clientData: clientData,
        parentId: parentId,
        isFolder: isFolder,
        ancestorIds: ancestorIds,
        itemsMap: itemsMap,
      ),
    );
  }

  /// Восстанавливает удаленного клиента
  ClientModelComposite restore() {
    return CompositeUtils.restore(
      coreData: coreData,
      rebuild: (newCore) => ClientModelComposite._(
        coreData: newCore,
        clientData: clientData,
        // ... остальные поля ...
      ),
    );
  }

  /// Проверяет наличие текста в полях клиента
  @override
  bool containsSearchText(String searchText) {
    return CompositeUtils.containsSearchText(
      code: code,
      displayName: displayName,
      searchQuery: searchText,
      additionalFields: [
        clientData.phone,
        clientData.email,
        clientData.comment,
      ],
    );
  }
}
```

### DocumentCompositeUtils для документов:

```dart
class OrderModelComposite implements IDocumentEntity {
  // ... существующий код ...

  /// Проверяет, можно ли редактировать заказ
  bool get canEdit => DocumentCompositeUtils.canEdit(
    isPosted: isPosted,
    status: status,
  );

  /// Проверяет, просрочен ли заказ
  bool get isOverdue => DocumentCompositeUtils.isOverdue(
    scheduledDate: orderData.scheduledDate,
    status: status,
  );
}
```

## 🎯 Extension методы

### Для единичных сущностей:

```dart
// Базовые расширения для всех сущностей
final client = await clientService.getById(id);
if (client.wasModified) {
  print('Клиент был изменен ${client.ageInDays} дней назад');
}

// Специфичные для документов
final order = await orderService.getById(id);
if (order.canEdit) {
  // Разрешено редактирование
}
print('Всего позиций: ${order.totalItemsCount}');

// Специфичные для справочников
final category = await categoryService.getById(id);
if (category.isRoot) {
  print('Это корневая категория');
}
print('Уровень вложенности: ${category.nestingLevel}');
```

### Для коллекций:

```dart
// Фильтрация и сортировка клиентов
final clients = await clientService.getAll();
final activeClients = clients.activeOnly
    .search('ООО')
    .sortByModifiedDate();

// Группировка заказов по статусу
final orders = await orderService.getAll();
final ordersByStatus = orders.groupByStatus();
ordersByStatus.forEach((status, orderList) {
  print('$status: ${orderList.length} заказов');
});

// Построение дерева категорий
final categories = await categoryService.getAll();
final categoryTree = categories.buildTree();
final rootCategories = categories.rootsOnly;
```

## 💡 ErrorHandler

### Использование в сервисах:

```dart
class ClientService {
  final Logger _logger = Logger();

  Future<List<ClientModelComposite>> getAll() async {
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final entities = await _dao.getAllEntities();
        return _mapToComposites(entities);
      },
      logger: _logger,
      operationName: 'ClientService.getAll',
      defaultValue: [],
    );
  }

  Future<ClientModelComposite?> create(ClientModelComposite client) async {
    return ErrorHandler.executeWithRetry(
      operation: () async {
        final id = await _dao.insertEntity(client.coreData, client.clientData);
        return getById(id.toString());
      },
      logger: _logger,
      operationName: 'ClientService.create',
      maxAttempts: 3,
    );
  }

  Future<Map<String, dynamic>> batchOperation() async {
    return ErrorHandler.executeBatch(
      operations: {
        'updateClients': () => _updateAllClients(),
        'cleanupDeleted': () => _cleanupDeletedClients(),
        'recalculateStats': () => _recalculateStatistics(),
      },
      logger: _logger,
      stopOnError: false,
    );
  }
}
```

## 🚀 Миграция существующего кода

### До рефакторинга:
```dart
class ClientModelComposite {
  ClientModelComposite markAsDeleted() {
    if (isDeleted) return this;
    final now = DateTime.now();
    return ClientModelComposite._(
      coreData: coreData.copyWith(
        isDeleted: true,
        deletedAt: now,
        modifiedAt: now,
      ),
      clientData: clientData,
      // ... копирование всех полей ...
    );
  }
}
```

### После рефакторинга:
```dart
class ClientModelComposite {
  ClientModelComposite markAsDeleted() {
    return CompositeUtils.markAsDeleted(
      coreData: coreData,
      rebuild: (newCore) => ClientModelComposite._(
        coreData: newCore,
        clientData: clientData,
        parentId: parentId,
        isFolder: isFolder,
        ancestorIds: ancestorIds,
        itemsMap: itemsMap,
      ),
    );
  }
}
```

## ✅ Преимущества

1. **Уменьшение дублирования** - общая логика вынесена в утилиты
2. **Типобезопасность** - сохранена благодаря дженерикам
3. **Простота использования** - интуитивный API
4. **Отсутствие breaking changes** - существующий код продолжает работать
5. **Постепенная миграция** - можно мигрировать по частям

## ⚠️ Важные моменты

1. **Не изменяйте публичные API** существующих моделей
2. **Тестируйте после каждого изменения**
3. **Используйте утилиты только там, где это упрощает код**
4. **Документируйте изменения** в коде

## 📊 Метрики успеха

- Уменьшение дублирования кода на ~20-30%
- Упрощение добавления новых методов
- Улучшение читаемости кода
- Сохранение производительности