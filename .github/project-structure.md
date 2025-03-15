# Tree View:
```
.\lib
├─core
│ ├─database
│ │ ├─daos
│ │ │ ├─cars_dao.dart
│ │ │ ├─cars_dao.g.dart
│ │ │ ├─clients_dao.dart
│ │ │ └─clients_dao.g.dart
│ │ ├─database.dart
│ │ ├─database.g.dart
│ │ ├─database_logger.dart
│ │ ├─items
│ │ │ ├─app_info_items.dart
│ │ │ ├─cars_items.dart
│ │ │ └─clients_items.dart
│ │ └─schema_synchronizer.dart
│ ├─schemas
│ │ └─app_schema.json
│ ├─service_locator.dart
│ └─utils
│   ├─json_converter.dart
│   └─logger_config.dart
├─features
│ ├─clients
│ │ ├─models
│ │ │ ├─client.dart
│ │ │ ├─client.g.dart
│ │ │ └─client_type.dart
│ │ ├─screens
│ │ │ └─clients_screen.dart
│ │ └─services
│ │   └─client_service.dart
│ ├─orders
│ │ ├─models
│ │ │ ├─order.dart
│ │ │ ├─order.g.dart
│ │ │ ├─order_item.dart
│ │ │ └─order_item.g.dart
│ │ ├─screens
│ │ └─services
│ ├─parts_catalog
│ │ ├─api
│ │ │ ├─PartsCatalogsRestAPI.md
│ │ │ ├─api_client_parts_catalogs.dart
│ │ │ └─api_client_parts_catalogs.g.dart
│ │ ├─models
│ │ │ ├─car2.dart
│ │ │ ├─car2.freezed.dart
│ │ │ ├─car2.g.dart
│ │ │ ├─car_info.dart
│ │ │ ├─car_info.freezed.dart
│ │ │ ├─car_info.g.dart
│ │ │ ├─car_parameter.dart
│ │ │ ├─car_parameter.freezed.dart
│ │ │ ├─car_parameter.g.dart
│ │ │ ├─car_parameter_idx.dart
│ │ │ ├─car_parameter_idx.freezed.dart
│ │ │ ├─car_parameter_idx.g.dart
│ │ │ ├─car_parameter_info.dart
│ │ │ ├─car_parameter_info.freezed.dart
│ │ │ ├─car_parameter_info.g.dart
│ │ │ ├─catalog.dart
│ │ │ ├─catalog.freezed.dart
│ │ │ ├─catalog.g.dart
│ │ │ ├─error.dart
│ │ │ ├─error.freezed.dart
│ │ │ ├─error.g.dart
│ │ │ ├─example_prices_response.dart
│ │ │ ├─example_prices_response.freezed.dart
│ │ │ ├─example_prices_response.g.dart
│ │ │ ├─group.dart
│ │ │ ├─group.freezed.dart
│ │ │ ├─group.g.dart
│ │ │ ├─groups_tree.dart
│ │ │ ├─groups_tree.freezed.dart
│ │ │ ├─groups_tree.g.dart
│ │ │ ├─groups_tree_response.dart
│ │ │ ├─groups_tree_response.freezed.dart
│ │ │ ├─groups_tree_response.g.dart
│ │ │ ├─ip.dart
│ │ │ ├─ip.freezed.dart
│ │ │ ├─ip.g.dart
│ │ │ ├─model.dart
│ │ │ ├─model.freezed.dart
│ │ │ ├─model.g.dart
│ │ │ ├─option_code.dart
│ │ │ ├─option_code.freezed.dart
│ │ │ ├─option_code.g.dart
│ │ │ ├─part.dart
│ │ │ ├─part.freezed.dart
│ │ │ ├─part.g.dart
│ │ │ ├─part_name.dart
│ │ │ ├─part_name.freezed.dart
│ │ │ ├─part_name.g.dart
│ │ │ ├─parts.dart
│ │ │ ├─parts.freezed.dart
│ │ │ ├─parts.g.dart
│ │ │ ├─parts_group.dart
│ │ │ ├─parts_group.freezed.dart
│ │ │ ├─parts_group.g.dart
│ │ │ ├─position.dart
│ │ │ ├─position.freezed.dart
│ │ │ ├─position.g.dart
│ │ │ ├─schema_model.dart
│ │ │ ├─schema_model.freezed.dart
│ │ │ ├─schema_model.g.dart
│ │ │ ├─schemas_response.dart
│ │ │ ├─schemas_response.freezed.dart
│ │ │ ├─schemas_response.g.dart
│ │ │ ├─suggest.dart
│ │ │ ├─suggest.freezed.dart
│ │ │ └─suggest.g.dart
│ │ ├─screens
│ │ └─widgets
│ │   ├─car_info_widget.dart
│ │   └─schema_list_widget.dart
│ ├─suppliers
│ │ ├─api
│ │ └─models
│ │   ├─price_offer.dart
│ │   ├─price_offer.g.dart
│ │   ├─supplier.dart
│ │   └─supplier.g.dart
│ └─vehicles
│   ├─models
│   │ ├─car.dart
│   │ └─car.g.dart
│   ├─screens
│   │ └─cars_screen.dart
│   └─services
│     └─car_service.dart
├─main.dart
└─models
```

```
scripts/
  ├─ full_ast/
  │   ├─ main.dart               # Точка входа в программу
  │   ├─ collectors/            # Сборщики информации о коде
  │   │   ├─ base_collector.dart # Базовый класс для всех коллекторов
  │   │   ├─ class_collector.dart # Сбор информации о классах
  │   │   ├─ function_collector.dart # Сбор информации о функциях
  │   │   ├─ type_collector.dart # Сбор информации о типах
  │   │   └─ ...
  │   ├─ models/                # Модели для структурирования AST
  │   │   ├─ ast_node.dart      # Базовая модель для узла AST
  │   │   ├─ class_info.dart    # Модель для информации о классе
  │   │   ├─ function_info.dart # Модель для информации о функции
  │   │   └─ ...
  │   ├─ utils/                 # Утилиты
  │   │   ├─ logger.dart        # Настройка логгирования
  │   │   ├─ file_utils.dart    # Утилиты для работы с файлами
  │   │   └─ ast_utils.dart     # Утилиты для работы с AST
  │   └─ analyzers/            # Анализаторы
  │       ├─ code_analyzer.dart # Основной анализатор кода
  │       ├─ metrics_analyzer.dart # Анализатор метрик кода
  │       └─ dependency_analyzer.dart # Анализатор зависимостей
```