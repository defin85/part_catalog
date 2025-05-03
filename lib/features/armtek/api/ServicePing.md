# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    InvoiceDetailsResponse:
      # ... existing InvoiceDetailsResponse schema ...
    ReturnInvoicePositionInput:
      # ... existing ReturnInvoicePositionInput schema ...
    CreateReturnInvoiceRequest:
      # ... existing CreateReturnInvoiceRequest schema ...
    CreateReturnInvoiceResponse:
      # ... existing CreateReturnInvoiceResponse schema ...
    OrderItemInput:
      # ... existing OrderItemInput schema ...
    CreateOrderRequest:
      # ... existing CreateOrderRequest schema ...
    CreateOrderResponse:
      # ... existing CreateOrderResponse schema ...
    OrderDetailsResponse:
      # ... existing OrderDetailsResponse schema ...
    RefundDetailsResponse:
      # ... existing RefundDetailsResponse schema ...
    EditOrderItemInput:
      # ... existing EditOrderItemInput schema ...
    EditOrderRequest:
      # ... existing EditOrderRequest schema ...
    EditOrderResponse:
      # ... existing EditOrderResponse schema ...
    Order:
      # ... existing Order schema ...
    OrderPosition:
      # ... existing OrderPosition schema ...
    SearchResult:
      # ... existing SearchResult schema ...
    Report:
      # ... existing Report schema ...
    UserSetting:
      # ... existing UserSetting schema ...

    # --- Схема для Пинга ---
    PingResponse:
      type: object
      properties:
        IP:
          type: string
          maxLength: 16
          description: IP адрес вызвавшего скрипт
          nullable: true # "Нет" в обязательности может означать nullable
        TIME:
          type: string
          maxLength: 20
          description: Время выполнения скрипта
          nullable: true # "Нет" в обязательности может означать nullable
      example: # Примерный ответ
        IP: "192.168.1.100"
        TIME: "0.001234 sec"

paths:
  /ws_invoice/getInvoice:
    # ... existing getInvoice path ...
  /ws_invoice/createReturnInvoice:
    # ... existing createReturnInvoice path ...
  /ws_order/createOrder:
    # ... existing createOrder path ...
  /ws_order/createTestOrder:
    # ... existing createTestOrder path ...
  /ws_order/getOrder:
    # ... existing getOrder path ...
  /ws_order/getOrder2:
    # ... existing getOrder2 path ...
  /ws_order/getRefund:
    # ... existing getRefund path ...
  /ws_order/editOrder:
    # ... existing editOrder path ...

  # --- Путь для Пинга ---
  /ws_ping/index: # Конкретный путь из примера
    get:
      summary: Пинг Системы
      description: Проверяет доступность системы и возвращает IP адрес клиента и время выполнения.
      tags: [System]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      responses:
        '200':
          description: Система доступна
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PingResponse'
            application/xml: # Добавляем XML, если поддерживается
              schema:
                $ref: '#/components/schemas/PingResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericError'

  # --- Остальные пути (Reports, Search, User) остаются как были ---
  /reports:
    # ... existing reports path ...
  /reports/orders/positions:
    # ... existing report path ...
  /search:
    # ... existing search path ...
  /user/settings:
    # ... existing user settings paths ...

tags:
  - name: Invoices
    description: Сервисы, связанные с фактурами и возвратами
  - name: Orders
    description: Сервисы, связанные с заказами
  - name: System
    description: Сервисы состояния и статуса системы
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Обновлен путь:** Заменен плейсхолдер `/ping` на конкретный путь `/ws_ping/index`.
2.  **Обновлено описание:** Добавлено более точное описание эндпоинта.
3.  **Добавлен параметр `format`:** В `parameters` добавлен опциональный параметр `format`.
4.  **Добавлена схема `PingResponse`:** В `components/schemas` добавлена схема `PingResponse` с полями `IP` и `TIME`. Поля помечены как `nullable: true`, так как в документации указано "Нет" в графе "Обязательный".
5.  **Обновлен ответ `200`:** Ссылка в ответе `200` теперь указывает на `#/components/schemas/PingResponse`. Добавлен также ответ для `application/xml`.
6.  **Обновлен тег:** Убедились, что используется тег `System`.# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    InvoiceDetailsResponse:
      # ... existing InvoiceDetailsResponse schema ...
    ReturnInvoicePositionInput:
      # ... existing ReturnInvoicePositionInput schema ...
    CreateReturnInvoiceRequest:
      # ... existing CreateReturnInvoiceRequest schema ...
    CreateReturnInvoiceResponse:
      # ... existing CreateReturnInvoiceResponse schema ...
    OrderItemInput:
      # ... existing OrderItemInput schema ...
    CreateOrderRequest:
      # ... existing CreateOrderRequest schema ...
    CreateOrderResponse:
      # ... existing CreateOrderResponse schema ...
    OrderDetailsResponse:
      # ... existing OrderDetailsResponse schema ...
    RefundDetailsResponse:
      # ... existing RefundDetailsResponse schema ...
    EditOrderItemInput:
      # ... existing EditOrderItemInput schema ...
    EditOrderRequest:
      # ... existing EditOrderRequest schema ...
    EditOrderResponse:
      # ... existing EditOrderResponse schema ...
    Order:
      # ... existing Order schema ...
    OrderPosition:
      # ... existing OrderPosition schema ...
    SearchResult:
      # ... existing SearchResult schema ...
    Report:
      # ... existing Report schema ...
    UserSetting:
      # ... existing UserSetting schema ...

    # --- Схема для Пинга ---
    PingResponse:
      type: object
      properties:
        IP:
          type: string
          maxLength: 16
          description: IP адрес вызвавшего скрипт
          nullable: true # "Нет" в обязательности может означать nullable
        TIME:
          type: string
          maxLength: 20
          description: Время выполнения скрипта
          nullable: true # "Нет" в обязательности может означать nullable
      example: # Примерный ответ
        IP: "192.168.1.100"
        TIME: "0.001234 sec"

paths:
  /ws_invoice/getInvoice:
    # ... existing getInvoice path ...
  /ws_invoice/createReturnInvoice:
    # ... existing createReturnInvoice path ...
  /ws_order/createOrder:
    # ... existing createOrder path ...
  /ws_order/createTestOrder:
    # ... existing createTestOrder path ...
  /ws_order/getOrder:
    # ... existing getOrder path ...
  /ws_order/getOrder2:
    # ... existing getOrder2 path ...
  /ws_order/getRefund:
    # ... existing getRefund path ...
  /ws_order/editOrder:
    # ... existing editOrder path ...

  # --- Путь для Пинга ---
  /ws_ping/index: # Конкретный путь из примера
    get:
      summary: Пинг Системы
      description: Проверяет доступность системы и возвращает IP адрес клиента и время выполнения.
      tags: [System]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      responses:
        '200':
          description: Система доступна
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PingResponse'
            application/xml: # Добавляем XML, если поддерживается
              schema:
                $ref: '#/components/schemas/PingResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericError'

  # --- Остальные пути (Reports, Search, User) остаются как были ---
  /reports:
    # ... existing reports path ...
  /reports/orders/positions:
    # ... existing report path ...
  /search:
    # ... existing search path ...
  /user/settings:
    # ... existing user settings paths ...

tags:
  - name: Invoices
    description: Сервисы, связанные с фактурами и возвратами
  - name: Orders
    description: Сервисы, связанные с заказами
  - name: System
    description: Сервисы состояния и статуса системы
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Обновлен путь:** Заменен плейсхолдер `/ping` на конкретный путь `/ws_ping/index`.
2.  **Обновлено описание:** Добавлено более точное описание эндпоинта.
3.  **Добавлен параметр `format`:** В `parameters` добавлен опциональный параметр `format`.
4.  **Добавлена схема `PingResponse`:** В `components/schemas` добавлена схема `PingResponse` с полями `IP` и `TIME`. Поля помечены как `nullable: true`, так как в документации указано "Нет" в графе "Обязательный".
5.  **Обновлен ответ `200`:** Ссылка в ответе `200` теперь указывает на `#/components/schemas/PingResponse`. Добавлен также ответ для `application/xml`.
6.  **Обновлен тег:** Убедились, что используется тег `System`.