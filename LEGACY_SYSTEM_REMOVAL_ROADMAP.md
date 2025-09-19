# 🚀 ROADMAP: Завершение удаления классической системы API

## 📋 Текущее состояние после анализа (18.09.2025)

### ✅ **Уже выполнено (~30%):**
- **ApiClientManager** - рефакторингован для оптимизированных клиентов
- **enhanced_parts_search_screen.dart** - очищен от legacy переключателей
- **Оптимизированная система** полностью функциональна

### ❌ **Остается сделать (~70%):**

#### **UI компоненты:**
- `enhanced_supplier_config_screen.dart:43,237,239` - переключатель `_useOptimizedSystem`

#### **Модели и конфигурация:**
- `SupplierBusinessConfig:130` - поле `useOptimizedSystem`
- `GlobalApiSettingsService:19,77,89,210` - методы работы с legacy флагами

#### **Провайдеры:**
- `parts_search_providers.dart` - классический `partsSearchProvider`
- Переименование оптимизированных провайдеров

#### **Сервисы и API клиенты:**
- `parts_price_service.dart` - использует устаревший ApiClientManager
- `armtek_api_client.dart` - базовый клиент без оптимизаций

---

## 🎯 Обновленный план действий

### **Этап 1: Очистка UI (15 мин)**
#### 1.1 Удалить переключатель из настроек поставщика
- [ ] **Файл:** `enhanced_supplier_config_screen.dart`
- [ ] Удалить `bool _useOptimizedSystem = true;` (строка 43)
- [ ] Удалить Switch с `_useOptimizedSystem` (строки 237-239)
- [ ] Удалить условную логику с `_useOptimizedSystem` (строки 158, 445, 561, 687, 1002, 1015, 1064)
- [ ] Всегда использовать оптимизированную систему

### **Этап 2: Очистка моделей (10 мин)**
#### 2.1 Удалить устаревшие поля
- [ ] **Файл:** `lib/features/suppliers/models/supplier_config.dart`
- [ ] Удалить поле `useOptimizedSystem` из `SupplierBusinessConfig` (строка 130)
- [ ] Регенерировать код: `dart run build_runner build --delete-conflicting-outputs`

#### 2.2 Очистить глобальные настройки
- [ ] **Файл:** `lib/core/config/global_api_settings_service.dart`
- [ ] Удалить `_useOptimizedSystemKey` (строка 19)
- [ ] Удалить методы `getUseOptimizedSystem()` и `setUseOptimizedSystem()` (строки 77-89)
- [ ] Удалить из `getAllSettings()` (строка 210)

### **Этап 3: Унификация провайдеров (20 мин)**
#### 3.1 Удалить legacy провайдеры
- [ ] **Файл:** `lib/features/suppliers/providers/parts_search_providers.dart`
- [ ] Удалить `partsSearchProvider` (строки 19-44)
- [ ] Удалить `PartsSearchParams` класс (строки 47-68)
- [ ] Оставить только служебные провайдеры для ApiClientManager и PartsPriceService

#### 3.2 Переименовать оптимизированные провайдеры
- [ ] **Файл:** `lib/features/suppliers/providers/optimized_api_providers.dart`
- [ ] `OptimizedPartsSearchParams` → `PartsSearchParams`
- [ ] `optimizedPartsSearchProvider` → `partsSearchProvider`
- [ ] Обновить все импорты в использующих файлах

### **Этап 4: Обновление сервисов (25 мин)**
#### 4.1 Рефакторинг PartsPriceService
- [ ] **Файл:** `lib/features/suppliers/services/parts_price_service.dart`
- [ ] Заменить `ApiClientManager` на использование оптимизированных клиентов
- [ ] Использовать провайдеры из `optimized_api_providers.dart`
- [ ] Обновить логику получения клиентов

#### 4.2 Удаление базового Armtek клиента
- [ ] **Файлы на удаление:**
  - `lib/features/suppliers/api/implementations/armtek_api_client.dart`
  - `lib/features/suppliers/api/implementations/armtek_api_client.g.dart`
- [ ] Обновить импорты во всех файлах
- [ ] Переименовать `OptimizedArmtekApiClient` → `ArmtekApiClient`

### **Этап 5: Финальная очистка (15 мин)**
#### 5.1 Удаление неиспользуемых файлов
- [ ] **Проверить и удалить при необходимости:**
  - `lib/features/suppliers/screens/parts_search_screen.dart` (старый экран)
  - Неиспользуемые утилиты и конфигурации

#### 5.2 Переименования для ясности
- [ ] `enhanced_supplier_config_screen.dart` → `supplier_config_screen.dart`
- [ ] `enhanced_parts_search_screen.dart` → `parts_search_screen.dart`
- [ ] Обновить маршруты и импорты

#### 5.3 Обновление документации
- [ ] Обновить `CLAUDE.md` - убрать упоминания о двух системах
- [ ] Добавить информацию о единой оптимизированной архитектуре

---

## ⚠️ Критические моменты

### **Порядок выполнения ОБЯЗАТЕЛЕН:**
1. **Этап 1** (UI) → **Этап 2** (модели) → **Этап 3** (провайдеры) → **Этап 4** (сервисы) → **Этап 5** (очистка)
2. **После каждого этапа:** запускать `flutter analyze` и исправлять ошибки
3. **После Этапа 2:** обязательно регенерировать код

### **Точки риска:**
- **Этап 4:** Может потребовать изменение логики в зависимых файлах
- **Переименования:** Могут сломать существующие импорты

### **Тестирование:**
После каждого этапа проверять:
- [ ] `flutter analyze` - без ошибок
- [ ] Основные сценарии: поиск запчастей, настройка поставщиков
- [ ] Health check оптимизированных клиентов

---

## 📊 Ожидаемые результаты

### **Будет удалено:**
- ~300 строк legacy кода
- 1 устаревший API клиент
- 2 набора провайдеров
- Условная логика в 8+ местах
- 3 устаревших поля модели

### **Останется:**
- **Единая оптимизированная архитектура**
- Полная совместимость функций
- Улучшенная производительность
- Упрощенная поддержка кода

---

## ✅ Критерии завершения

- [ ] `flutter analyze` - 0 ошибок
- [ ] `flutter build apk` - успешная сборка
- [ ] Поиск запчастей работает через оптимизированную систему
- [ ] Настройки поставщиков сохраняются корректно
- [ ] Health check и мониторинг функционируют
- [ ] Нет упоминаний legacy системы в коде
- [ ] Обновлена документация

---

**Estimated time**: 1.5 часа
**Complexity**: Medium
**Risk**: Low (при соблюдении порядка выполнения)

**Created**: 18.09.2025
**Status**: Ready to start