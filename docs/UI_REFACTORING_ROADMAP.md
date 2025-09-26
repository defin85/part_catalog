# UI Refactoring Roadmap - Flutter Best Practices

## 🎯 Цель
Устранение "портянок" кода в экранах через внедрение системы переиспользуемых компонентов на основе композиции и Flutter best practices.

## 🏗️ Архитектурные принципы

### 1. Композиция вместо наследования
- ❌ Не используем базовые классы экранов
- ✅ Используем виджеты-обёртки и композицию слотов

### 2. Atomic Design Pattern
```
atoms/       → Базовые элементы (кнопки, иконки)
molecules/   → Простые компоненты (поля с валидацией)
organisms/   → Сложные компоненты (формы, списки)
templates/   → Шаблоны экранов (scaffolds)
pages/       → Конкретные экраны
```

### 3. Material Design 3 Guidelines
- Canonical Layouts (list-detail, supporting pane)
- Adaptive components
- Navigation patterns (rail, drawer, bottom nav)

## 📦 Новая структура компонентов

```
lib/core/ui/
├── atoms/
│   ├── buttons/
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   └── icon_button_extended.dart
│   ├── inputs/
│   │   ├── text_input.dart
│   │   ├── dropdown_input.dart
│   │   └── date_picker_input.dart
│   └── typography/
│       ├── heading.dart
│       ├── body_text.dart
│       └── caption.dart
│
├── molecules/
│   ├── search_bar.dart           # Поиск с debounce
│   ├── filter_chip_group.dart    # Группа фильтров
│   ├── validation_field.dart     # Поле с валидацией
│   ├── status_indicator.dart     # Индикатор статуса
│   ├── empty_state_message.dart  # Заглушка для пустых списков
│   └── loading_overlay.dart      # Оверлей загрузки
│
├── organisms/
│   ├── forms/
│   │   ├── form_section.dart     # Секция формы с заголовком
│   │   ├── form_card.dart        # Карточка с полями
│   │   ├── validation_summary.dart # Сводка ошибок валидации
│   │   └── form_actions_bar.dart # Панель действий формы
│   ├── lists/
│   │   ├── paginated_list.dart   # Список с пагинацией
│   │   ├── searchable_list.dart  # Список с поиском
│   │   ├── filterable_list.dart  # Список с фильтрами
│   │   └── swipeable_list_item.dart # Свайпы для действий
│   ├── cards/
│   │   ├── info_card.dart        # Информационная карточка
│   │   ├── status_card.dart      # Карточка статуса
│   │   ├── action_card.dart      # Карточка с действиями
│   │   └── metric_card.dart      # Карточка с метриками
│   └── navigation/
│       ├── tab_section.dart      # Секция с табами
│       ├── stepper_section.dart  # Многошаговая форма
│       └── breadcrumbs.dart      # Хлебные крошки
│
├── templates/
│   ├── scaffolds/
│   │   ├── list_screen_scaffold.dart    # Шаблон экрана списка
│   │   ├── form_screen_scaffold.dart    # Шаблон экрана формы
│   │   ├── wizard_screen_scaffold.dart  # Шаблон мастера
│   │   ├── tabbed_screen_scaffold.dart  # Шаблон с табами
│   │   └── master_detail_scaffold.dart  # Шаблон список-детали
│   └── layouts/
│       ├── adaptive_layout.dart         # Адаптивный layout
│       ├── list_detail_layout.dart      # MD3 list-detail
│       ├── supporting_pane_layout.dart  # MD3 supporting pane
│       └── feed_layout.dart             # MD3 feed
│
└── themes/
    ├── app_colors.dart
    ├── app_typography.dart
    ├── app_spacing.dart
    └── app_breakpoints.dart
```

## 🔄 Паттерны использования

### Композиция экрана списка
```dart
class ClientsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListScreenScaffold(
      title: 'Клиенты',
      // Композиция через слоты
      searchBar: SearchBar(
        onSearch: (query) => ref.read(clientsProvider.notifier).search(query),
        hint: 'Поиск по имени, телефону, email',
      ),
      filterPanel: FilterChipGroup(
        filters: ClientFilters.all,
        onFilterChanged: (filter) => ref.read(clientsProvider.notifier).setFilter(filter),
      ),
      body: SearchableList<ClientModelComposite>(
        items: ref.watch(filteredClientsProvider),
        itemBuilder: (client) => ClientCard(client: client),
        emptyStateBuilder: () => EmptyStateMessage(
          icon: Icons.people_outline,
          title: 'Клиенты не найдены',
          subtitle: 'Попробуйте изменить параметры поиска',
          action: ElevatedButton(
            onPressed: () => _showAddClientDialog(),
            child: Text('Добавить клиента'),
          ),
        ),
      ),
      floatingActionButton: ExtendedFloatingActionButton.icon(
        onPressed: () => _showAddClientDialog(),
        icon: Icon(Icons.add),
        label: Text('Добавить'),
      ),
    );
  }
}
```

### Композиция экрана формы
```dart
class SupplierConfigScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabbedScreenScaffold(
      title: 'Настройка поставщика',
      tabs: [
        TabConfig(
          icon: Icons.info,
          label: 'Основные',
          builder: () => BasicSettingsTab(),
        ),
        TabConfig(
          icon: Icons.api,
          label: 'Подключение',
          builder: () => ConnectionSettingsTab(),
        ),
        // ... другие табы
      ],
      persistentFooterButtons: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: ref.watch(hasChangesProvider)
            ? () => ref.read(supplierConfigProvider.notifier).save()
            : null,
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}
```

## 📚 Примеры использования новых компонентов (Фаза 3 - Завершена)

### 🧭 Навигационные компоненты

#### TabSection - Секция с табами
```dart
// Простое переключение между разделами
SimpleTabSection(
  tabs: [
    TabSectionItem(
      label: 'Активные',
      icon: Icon(Icons.check_circle),
      content: ActiveOrdersList(),
    ),
    TabSectionItem(
      label: 'Архив',
      icon: Icon(Icons.archive),
      content: ArchivedOrdersList(),
    ),
  ],
)
```

#### StepperSection - Многошаговые формы
```dart
// Мастер настройки
StepperSection(
  steps: [
    StepperItem(
      title: 'Основные данные',
      content: BasicSettingsForm(),
    ),
    StepperItem(
      title: 'Подключение',
      content: ConnectionForm(),
    ),
    StepperItem(
      title: 'Тестирование',
      content: TestingForm(),
    ),
  ],
  onFinish: () => _saveConfiguration(),
)
```

#### Breadcrumbs - Хлебные крошки
```dart
// Навигация по разделам
AdaptiveBreadcrumbs(
  items: AppBreadcrumbs.forDetail(
    sectionName: 'Клиенты',
    itemName: client.name,
    onHomePressed: () => context.go(AppRoutes.home),
    onSectionPressed: () => context.go(AppRoutes.clients),
  ),
)
```

### 📋 Компоненты форм

#### ValidationSummary - Сводка ошибок
```dart
// Отображение всех ошибок валидации
ValidationSummary(
  errors: [
    ValidationError.field(
      fieldName: 'Email',
      message: 'Некорректный формат email',
      onTap: () => _focusEmailField(),
    ),
    ValidationError.field(
      fieldName: 'Телефон',
      message: 'Поле обязательно для заполнения',
      onTap: () => _focusPhoneField(),
    ),
  ],
  title: 'Исправьте ошибки для продолжения',
  collapsible: true,
)
```

### 📝 Компоненты списков

#### SwipeableListItem - Свайпы для действий
```dart
// Список с возможностью свайпа
SwipeableList<Client>(
  items: clients,
  itemBuilder: (context, client, index) => ClientCard(client),
  rightActionsBuilder: (client, index) => [
    SwipeAction.edit(
      onTap: () => _editClient(client),
    ),
    SwipeAction.delete(
      onTap: () => _deleteClient(client),
    ),
  ],
  leftActionsBuilder: (client, index) => [
    SwipeAction.favorite(
      isFavorite: client.isFavorite,
      onTap: () => _toggleFavorite(client),
    ),
    SwipeAction.archive(
      onTap: () => _archiveClient(client),
    ),
  ],
)
```

### 🎴 Карточки

#### ConnectionTestCard - Тестирование соединений
```dart
// Карточка для тестирования API
ConnectionTestPresets.httpApi(
  title: 'Armtek API',
  url: 'https://ws.armtek.ru/search',
  status: ConnectionTestStatus.success,
  lastTestTime: 'Сегодня в 14:30',
  steps: [
    ConnectionTestStep(
      name: 'Подключение к серверу',
      isSuccess: true,
      duration: Duration(milliseconds: 120),
    ),
    ConnectionTestStep(
      name: 'Аутентификация',
      isSuccess: true,
      duration: Duration(milliseconds: 45),
    ),
    ConnectionTestStep(
      name: 'Тестовый запрос',
      isSuccess: true,
      duration: Duration(milliseconds: 300),
    ),
  ],
  onTest: () => _testConnection(),
  onConfigure: () => _openSettings(),
)
```

### 🔄 Комплексный пример: RefactoredClientsScreen

```dart
class RefactoredClientsScreen extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MasterDetailScaffold(
      title: 'Клиенты',
      // Хлебные крошки
      breadcrumbs: AdaptiveBreadcrumbs(
        items: AppBreadcrumbs.forList(
          sectionName: 'Клиенты',
          onHomePressed: () => context.go(AppRoutes.home),
        ),
      ),
      // Основной список с фильтрацией
      master: FilterableList<ClientModelComposite>(
        items: ref.watch(clientsProvider),
        searchBuilder: (clients, query) =>
          clients.where((c) => c.containsSearchText(query)).toList(),
        filters: [
          ListFilter(
            id: 'active',
            label: 'Активные',
            predicate: (client) => !client.coreData.isDeleted,
          ),
          ListFilter(
            id: 'individual',
            label: 'Физ. лица',
            predicate: (client) => client.specificData.isIndividual,
          ),
        ],
        itemBuilder: (client) => SwipeableListItem(
          rightActions: [
            SwipeAction.edit(onTap: () => _editClient(client)),
            SwipeAction.delete(onTap: () => _deleteClient(client)),
          ],
          child: ClientCard(
            client: client,
            onTap: () => _selectClient(client),
          ),
        ),
        emptyStateBuilder: () => EmptyStateMessage(
          icon: Icons.people_outline,
          title: 'Клиенты не найдены',
          subtitle: 'Попробуйте изменить параметры поиска',
          action: FloatingActionButton.extended(
            onPressed: _addClient,
            icon: Icon(Icons.add),
            label: Text('Добавить клиента'),
          ),
        ),
      ),
      // Панель деталей
      detail: _selectedClient != null
        ? ClientDetailsPanel(client: _selectedClient!)
        : EmptyStateMessage(
            icon: Icons.person_outline,
            title: 'Выберите клиента',
            subtitle: 'Выберите клиента из списка для просмотра деталей',
          ),
    );
  }
}
```

### 📈 Достигнутые результаты Фазы 3

- ✅ **ImprovedSupplierConfigScreen**: 1138 → 162 строки (-85%)
- ✅ **RefactoredClientsScreen**: 742 → 420 строк (-43%)
- ✅ **Новые компоненты**: 7 компонентов (navigation: 3, forms: 1, lists: 1, cards: 1)
- ✅ **Использование в продакшене**: 2/15 экранов используют новую архитектуру

### 🚀 Результаты Фазы 4 ✅ **ЗАВЕРШЕНА**

- ✅ **RefactoredOrdersScreen**: 859 → 295 строк (-66%)
- ✅ **RefactoredCarsScreen**: 1137 → 249 строк (-78%)
- ✅ **RefactoredPartsSearchScreen**: 603 → 355 строк (-41%)
- ✅ **Новые компоненты**: 6 компонентов (OrderListItem, OrderDetailPanel, CarListItem, CarDetailPanel)
- ✅ **Использование в продакшене**: 6/15 экранов (40%) используют новую архитектуру
- ✅ **Ошибки анализатора**: 132 → 81 (-39%)

## 📊 Метрики успеха

### Текущее состояние (После Фазы 4)
- **RefactoredOrdersScreen**: **295 строк** (было 859) ✅ **-66%**
- **RefactoredCarsScreen**: **249 строк** (было 1137) ✅ **-78%**
- **RefactoredPartsSearchScreen**: **355 строк** (было 603) ✅ **-41%**
- **ImprovedSupplierConfigScreen**: **162 строки** (было 1138) ✅ **-85%**
- **RefactoredClientsScreen**: **261 строка** (было 742) ✅ **-65%**
- **RefactoredApiControlCenterScreen**: **167 строк** (новый) ✅
- Создано новых компонентов: **65+ компонентов** (atoms + molecules + organisms + templates)
- Использование новой архитектуры: **6/15 экранов** (40%)

### Целевые метрики
- Средний размер экрана: **150-250 строк** (-75%)
- Дублирование кода: **< 10%** (-30%)
- Время создания нового экрана: **3-5 часов** (-85%)
- Покрытие тестами: **> 80%**

## 🚀 План внедрения

### Фаза 1: Базовая инфраструктура (Неделя 1)
- [ ] Создать структуру папок atoms/molecules/organisms/templates
- [ ] Реализовать базовые atoms:
  - [ ] Buttons (primary, secondary, text, icon)
  - [ ] Inputs (text, dropdown, date)
  - [ ] Typography (heading, body, caption)
- [ ] Реализовать ключевые molecules:
  - [ ] SearchBar с debounce
  - [ ] ValidationField
  - [ ] StatusIndicator
  - [ ] EmptyStateMessage

### Фаза 2: Шаблоны экранов (Неделя 2)
- [ ] ListScreenScaffold
  - [ ] Поддержка поиска
  - [ ] Поддержка фильтров
  - [ ] Пагинация
  - [ ] Empty state
- [ ] FormScreenScaffold
  - [ ] Валидация
  - [ ] Сохранение состояния
  - [ ] Unsaved changes warning
- [ ] TabbedScreenScaffold
  - [ ] Lazy loading табов
  - [ ] Сохранение состояния табов
- [ ] MasterDetailScaffold
  - [ ] Адаптивность (stack на мобильных, split на планшетах)
  - [ ] Синхронизация выбора

### Фаза 3: Пилотный рефакторинг (Неделя 3) ✅ **ЗАВЕРШЕНА**
- [x] Рефакторинг ImprovedSupplierConfigScreen:
  - [x] Разделить на 4 таба-компонента
  - [x] Выделить StatusCard, ConnectionTestCard
  - [x] Использовать TabbedScreenScaffold
  - [x] Сократить с 1138 до 162 строки (-85%!)
- [x] Создать необходимые organisms:
  - [x] FormSection
  - [x] FormCard
  - [x] ValidationSummary ✨ **НОВОЕ**
  - [x] ConnectionTestCard ✨ **НОВОЕ**
  - [x] SwipeableListItem ✨ **НОВОЕ**
  - [x] Navigation компоненты ✨ **НОВОЕ** (TabSection, StepperSection, Breadcrumbs)
- [x] Написать документацию с примерами
- [x] Заменить AdaptiveClientsScreen на RefactoredClientsScreen

### Фаза 4: Миграция критических экранов (Недели 4-5) ✅ **ЗАВЕРШЕНА**
- [x] ClientsScreen → RefactoredClientsScreen (ListScreenScaffold)
- [x] OrdersScreen → RefactoredOrdersScreen (MasterDetailScaffold)
- [x] ApiControlCenterScreen → RefactoredApiControlCenterScreen (FormScreenScaffold)
- [x] AdaptivePartsSearchScreen → RefactoredPartsSearchScreen (композиция)
- [x] Создать недостающие компоненты: OrderListItem, OrderDetailPanel, CarListItem, CarDetailPanel

### Фаза 5: Полная миграция (Недели 6-7)
- [ ] Мигрировать оставшиеся экраны
- [ ] Удалить устаревшие компоненты
- [ ] Оптимизировать импорты
- [ ] Провести рефакторинг дублирующегося кода

### Фаза 6: Оптимизация и документация (Неделя 8)
- [ ] Performance profiling
- [ ] Оптимизация ререндеров
- [ ] Написать storybook/catalog компонентов
- [ ] Создать guidelines для команды
- [ ] Настроить linting rules

## 📈 Ожидаемые результаты

### Для разработки
- **-75%** объёма кода в экранах
- **-85%** времени на создание новых экранов
- **Унификация** UI/UX во всем приложении
- **Упрощение** поддержки и отладки

### Для пользователей
- **Консистентный** интерфейс
- **Улучшенная** производительность
- **Адаптивность** под все размеры экранов
- **Предсказуемое** поведение

## 🔍 Риски и митигация

### Риск 1: Сложность миграции
**Митигация:** Постепенная миграция, начиная с новых экранов

### Риск 2: Производительность композиции
**Митигация:** Использование const конструкторов, мемоизация

### Риск 3: Обучение команды
**Митигация:** Документация, примеры, code review

## 📚 Ресурсы и референсы

- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Material Design 3](https://m3.material.io/)
- [Flutter Gallery Source](https://github.com/flutter/gallery)
- [Atomic Design Methodology](https://bradfrost.com/blog/post/atomic-web-design/)
- [Flutter Best Practices](https://docs.flutter.dev/development/ui/widgets-intro#basic-widgets)

## ✅ Критерии завершения

- [ ] Все экраны используют новую архитектуру
- [ ] Нет экранов больше 300 строк
- [ ] Создан каталог компонентов
- [ ] Написана документация
- [ ] Проведено обучение команды
- [ ] Метрики производительности не ухудшились

---

*Документ будет обновляться по мере прогресса рефакторинга*