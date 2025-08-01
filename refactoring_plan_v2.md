# План рефакторинга композитных моделей v2.0

## 🎯 Цель
Устранить дублирование кода в композитных моделях, сохранив типобезопасность и избегая проблем с системой типов Dart.

## 🔍 Анализ проблем первой попытки

### Проблемы с типами:
1. **Conflicting generic interfaces** - Dart не позволяет множественное наследование с разными типовыми параметрами
2. **Ковариантность** - проблемы с переопределением методов, возвращающих конкретные типы
3. **Миксины** - конфликты при использовании миксинов с дженериками

## 📐 Новая архитектура

### Вариант 1: Композиция вместо наследования
```dart
// Вместо наследования используем композицию
class CompositeHelper<T extends IEntity> {
  final EntityCoreData coreData;
  
  T markAsDeleted<T>(T Function(EntityCoreData) factory) {
    return factory(coreData.copyWith(
      isDeleted: true,
      deletedAt: DateTime.now(),
    ));
  }
}
```

### Вариант 2: Extension методы
```dart
// Общая функциональность через extension
extension CompositeExtensions on IEntity {
  bool containsSearchTextBase(String query, List<String> fields) {
    final lowerQuery = query.toLowerCase();
    return fields.any((field) => 
      field.toLowerCase().contains(lowerQuery)
    );
  }
}
```

### Вариант 3: Статические утилиты
```dart
// Статические методы для общей логики
class CompositeUtils {
  static T markAsDeleted<T extends IEntity>(
    T entity,
    T Function(EntityCoreData) rebuild,
  ) {
    // implementation
  }
}
```

## 🚀 Поэтапный план рефакторинга

### Этап 1: Создание утилит (низкий риск)
1. Создать `CompositeUtils` со статическими методами
2. Создать `ErrorHandler` для обработки ошибок
3. Не трогать существующие модели

### Этап 2: Extension методы (средний риск)
1. Создать extensions для `IEntity`, `IDocumentEntity`, `IReferenceEntity`
2. Вынести общую логику поиска и фильтрации
3. Протестировать на одной модели

### Этап 3: Рефакторинг моделей (высокий риск)
1. Начать с самой простой модели (например, CarModelComposite)
2. Использовать композицию для общей логики
3. Постепенно мигрировать остальные модели

## 🛡️ Стратегия минимизации рисков

1. **Не использовать сложное наследование** - избегать BaseCompositeModel с дженериками
2. **Предпочитать композицию** - использовать helper классы
3. **Тестировать каждый шаг** - запускать flutter analyze после каждого изменения
4. **Сохранять обратную совместимость** - не менять публичные API

## 📋 Чек-лист для каждого этапа

- [ ] Написать код
- [ ] Запустить `flutter analyze`
- [ ] Запустить тесты
- [ ] Проверить, что приложение компилируется
- [ ] Commit изменений

## 🎨 Примеры кода

### Пример утилиты:
```dart
class CompositeUtils {
  /// Помечает сущность как удаленную
  static T markAsDeleted<T>({
    required EntityCoreData coreData,
    required T Function(EntityCoreData) rebuild,
  }) {
    final now = DateTime.now();
    return rebuild(coreData.copyWith(
      isDeleted: true,
      deletedAt: now,
      modifiedAt: now,
    ));
  }
}
```

### Пример использования:
```dart
class ClientModelComposite implements IReferenceEntity {
  ClientModelComposite markAsDeleted() {
    return CompositeUtils.markAsDeleted(
      coreData: coreData,
      rebuild: (newCore) => ClientModelComposite._(
        coreData: newCore,
        clientData: clientData,
        // ...
      ),
    );
  }
}
```

## ⚠️ Важные моменты

1. **Не пытаться создать универсальный BaseCompositeModel** - это приводит к проблемам с типами
2. **Использовать конкретные типы в методах** - избегать dynamic
3. **Предпочитать простоту** - лучше немного дублирования, чем сложная иерархия
4. **Документировать изменения** - обновлять CLAUDE.md

## 🎯 Ожидаемые результаты

1. Уменьшение дублирования на 20-30%
2. Улучшение читаемости кода
3. Упрощение добавления новых композитных моделей
4. Сохранение типобезопасности
5. Отсутствие критических ошибок компиляции