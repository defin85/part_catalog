# Работа с асинхронным кодом

> В этом руководстве описаны подходы и рекомендации по работе с асинхронным кодом в проекте Part Catalog.

## Содержание
- [Основные принципы](#основные-принципы)
- [Структурирование асинхронного кода](#структурирование-асинхронного-кода)
- [Безопасная работа с BuildContext](#безопасная-работа-с-buildcontext)
- [Обработка ошибок](#обработка-ошибок)
- [Кэширование и оптимизация](#кэширование-и-оптимизация)
- [Тестирование асинхронного кода](#тестирование-асинхронного-кода)
- [Часто встречающиеся проблемы](#часто-встречающиеся-проблемы)

## Основные принципы

## Future и Stream

В проекте используются два основных подхода к работе с асинхронными операциями:

Future - для одиночных асинхронных операций (получение данных от API, запись в БД)
Stream - для потоков данных (реактивное обновление UI при изменении данных в БД)

## Маркировка асинхронных методов

* Всегда используйте ключевое слово async для методов, возвращающих Future
* Выполняйте await для всех асинхронных операций, за исключением случаев, когда вы намеренно запускаете операции параллельно
* Явно указывайте возвращаемые типы (Future<T>, Stream<T>)

## Структурирование асинхронного кода

### Использование паттерна Репозиторий

Разделяйте код на слои, чтобы минимизировать асинхронную сложность

### Параллельное выполнение асинхронных операций

Для оптимизации производительности используйте Future.wait для параллельного выполнения нескольких асинхронных операций

## Безопасная работа с BuildContext

### Проверка mounted перед setState

Всегда проверяйте, что виджет всё ещё находится в дереве (mounted), перед вызовом setState() после асинхронных операций

### Сохранение ссылок на зависимые от контекста объекты

Сохраняйте ссылки на объекты, зависящие от контекста, перед асинхронными операциями

### Использование addPostFrameCallback

Для запуска асинхронных операций после отрисовки фрейма используйте WidgetsBinding.instance.addPostFrameCallback

## Обработка ошибок

### Паттерн try-catch-finally

Используйте блоки try-catch-finally для обработки асинхронных ошибок

### Обработка ошибок в Stream

При работе с потоками данных обрабатывайте ошибки в Stream с помощью catchError или внутри StreamBuilder

### Пробрасывание ошибок

При необходимости проброса ошибок на верхние уровни используйте собственные типы исключений

## Кэширование и оптимизация

### Кэширование результатов асинхронных операций

Для часто используемых асинхронных операций применяйте кэширование

### Дебаунсинг и троттлинг

Для предотвращения лишних запросов при быстром вводе пользователя или прокрутке

## Тестирование асинхронного кода

### Unit-тестирование асинхронного кода

Для unit-тестов асинхронного кода используйте async/await и методы для ожидания завершения асинхронных операций

### Тестирование с fake_async

Для тестирования кода с таймерами используйте fake_async

## Часто встречающиеся проблемы

### "Uncaught exception" в асинхронном коде

Если в асинхронном коде возникают необработанные исключения:

```dart
// ❌ Неправильно: исключение не обрабатывается
void initState() {
  super.initState();
  loadData(); // Асинхронный метод без обработки ошибок
}

// ✅ Правильно: добавляем обработку ошибок
void initState() {
  super.initState();
  loadData().catchError((error) {
    if (mounted) {
      setState(() => _error = error.toString());
    }
  });
}
```

### Проблема "setState() or markNeedsBuild() called during build"

Если вы получаете эту ошибку при асинхронных операциях:

```dart
// ❌ Неправильно: setState вызывается синхронно в build
Widget build(BuildContext context) {
  _service.getData().then((data) {
    setState(() => _data = data); // Вызывает ошибку!
  });
  return Container();
}

// ✅ Правильно: используем FutureBuilder или StreamBuilder
Widget build(BuildContext context) {
  return FutureBuilder<Data>(
    future: _service.getData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return DataWidget(data: snapshot.data!);
      } else if (snapshot.hasError) {
        return ErrorWidget(error: snapshot.error!);
      }
      return LoadingWidget();
    },
  );
}
```

### Утечки памяти в асинхронном коде

Если происходят утечки памяти из-за асинхронных операций:

```dart
// ❌ Неправильно: подписка на Stream без отписки
StreamSubscription _subscription;

@override
void initState() {
  super.initState();
  _subscription = _service.dataStream.listen((data) {
    setState(() => _data = data);
  });
}

// ✅ Правильно: отписываемся при dispose
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}

// ✅ Еще лучше: используем StreamBuilder вместо ручной подписки
Widget build(BuildContext context) {
  return StreamBuilder<Data>(
    stream: _service.dataStream,
    builder: (context, snapshot) {
      // Логика отображения
    },
  );
}
```

### Зацикленные асинхронные вызовы

Избегайте создания бесконечных циклов асинхронных вызовов:

```dart
// ❌ Неправильно: метод вызывает сам себя без условия остановки
Future<void> refreshData() async {
  final newData = await _repository.fetchData();
  setState(() => _data = newData);
  refreshData(); // Будет вызываться бесконечно!
}

// ✅ Правильно: используем таймер или условие остановки
Future<void> startPeriodicRefresh() async {
  while (_isActive) {
    final newData = await _repository.fetchData();
    if (mounted) {
      setState(() => _data = newData);
    }
    await Future.delayed(Duration(minutes: 1));
  }
}

@override
void initState() {
  super.initState();
  _isActive = true;
  startPeriodicRefresh();
}

@override
void dispose() {
  _isActive = false;
  super.dispose();
}
```