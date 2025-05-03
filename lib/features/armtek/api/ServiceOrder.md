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

    # --- Схемы для Заказов ---
    OrderItemInput: # Для createOrder
      type: object
      required:
        - PIN
        - BRAND
        - KWMENG
      properties:
        PIN:
          type: string
          maxLength: 10
          description: Артикул (номер детали)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд детали
        ARTSKU:
          type: string
          maxLength: 50
          description: Артикул поставщика (опционально)
        NAME:
          type: string
          maxLength: 100
          description: Наименование детали (опционально)
        KWMENG:
          type: number # Или string? Указано "число ( 10 )"
          format: float # Или double
          description: Количество
        PRICE:
          type: number # Или string?
          format: float # Или double
          description: Цена (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD
          description: Желаемая дата поставки для позиции (опционально)
        NOTE:
          type: string
          maxLength: 512
          description: Примечание к позиции (опционально)
    CreateOrderRequest:
      type: object
      required:
        - VKORG
        - KUNRG
        - ITEMS
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        KUNWE:
          type: string
          maxLength: 10
          description: Грузополучатель (опционально)
        KONDA:
          type: string
          maxLength: 2
          description: Ценовая группа клиента (опционально)
        BSTKD:
          type: string
          maxLength: 35
          description: Номер заказа клиента (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD
          description: Желаемая дата поставки всего заказа (опционально)
        PIN: # Выглядит странно на уровне заголовка, возможно для быстрого заказа одной позиции?
          type: string
          maxLength: 10
          description: Артикул (опционально, для быстрого заказа?)
        BRAND: # Выглядит странно на уровне заголовка
          type: string
          maxLength: 50
          description: Бренд (опционально, для быстрого заказа?)
        KWMENG: # Выглядит странно на уровне заголовка
          type: number
          format: float
          description: Количество (опционально, для быстрого заказа?)
        NOTE:
          type: string
          maxLength: 512
          description: Примечание к заказу (опционально)
        DELIVERY_ADDRESS:
          type: string
          maxLength: 255
          description: Адрес доставки текстом (опционально)
        DELIVERY_INTERVAL:
          type: string
          maxLength: 50
          description: Интервал доставки текстом (опционально)
        DELIVERY_METHOD:
          type: string
          maxLength: 50
          description: Способ доставки текстом (опционально)
        CONTACT_PERSON:
          type: string
          maxLength: 50
          description: Контактное лицо текстом (опционально)
        CONTACT_PHONE:
          type: string
          maxLength: 50
          description: Контактный телефон текстом (опционально)
        BACKORDER:
          type: string
          maxLength: 1
          enum: ['X', '']
          description: Разрешить дозаказ ('X' - да, пусто - нет) (опционально)
        SUBSTITUTION:
          type: string
          maxLength: 1
          enum: ['X', '']
          description: Разрешить замену ('X' - да, пусто - нет) (опционально)
        ITEMS:
          type: array
          description: Таблица позиций заказа
          items:
            $ref: '#/components/schemas/OrderItemInput'
    CreateOrderResponse: # Структура ответа неизвестна
      type: object
      properties:
        orderNumber: # Предполагаемое поле
          type: string
          description: Номер созданного заказа
        # ... другие поля ответа
    OrderDetailsResponse: # Структура ответа для getOrder/getOrder2 (неизвестна, placeholder)
      type: object
      properties:
        HEADER:
          type: object
          properties:
            ORDER:
              type: string
              description: Номер заказа
            # ... другие поля заголовка заказа
        ITEMS:
          type: array
          items:
            type: object
            properties:
              POSNR:
                type: string
                description: Номер позиции
              PIN:
                type: string
                description: Артикул
              BRAND:
                type: string
                description: Бренд
              KWMENG:
                type: number
                description: Количество
              # ... другие поля позиции заказа
        ABGRU_ITEMS: # Таблица для editOrder
           type: array
           items:
             type: object
             properties:
               ABGRU:
                 type: string
                 description: Код причины отклонения
               # ... другие поля
        # ... другие таблицы и поля в ответе getOrder
    RefundDetailsResponse: # Структура ответа для getRefund (неизвестна, placeholder)
      type: object
      properties:
        # ... поля ответа
    EditOrderItemInput: # Для editOrder
      type: object
      required:
        - POSNR
        - KWMENG
        - ABGRU
      properties:
        POSNR:
          type: string
          maxLength: 10
          description: Номер позиции в заказе для редактирования
        KWMENG:
          type: number # Или string?
          format: float
          description: Новое количество
        ABGRU:
          type: string
          maxLength: 3
          description: Код причины отклонения (из getOrder ABGRU_ITEMS)
        NOTE:
          type: string
          maxLength: 512
          description: Комментарий к изменению (опционально)
    EditOrderRequest:
      type: object
      required:
        - VKORG
        - KUNRG
        - ORDER
        - POSITION_INPUT
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        ORDER:
          type: string
          maxLength: 10
          description: Номер заказа для редактирования
        POSITION_INPUT:
          type: array
          description: Таблица изменяемых позиций
          items:
            $ref: '#/components/schemas/EditOrderItemInput'
    EditOrderResponse: # Структура ответа неизвестна
      type: object
      properties:
        # ... поля ответа, например, статус операции
    # ... другие схемы ...
    Order: # Placeholder, если используется в других местах
      type: object
      properties:
        id:
          type: string
        # ... другие поля заказа
    OrderPosition: # Placeholder, если используется в других местах
      type: object
      properties:
        id:
          type: string
        # ... другие поля позиции заказа
    SearchResult:
      # ... existing SearchResult schema ...
    Report:
      # ... existing Report schema ...
    UserSetting:
      # ... existing UserSetting schema ...
    PingResponse:
      # ... existing PingResponse schema ...

paths:
  /ws_invoice/getInvoice:
    # ... existing getInvoice path ...
  /ws_invoice/createReturnInvoice:
    # ... existing createReturnInvoice path ...

  # --- Пути для Заказов ---
  /ws_order/createOrder:
    post:
      summary: Создание заказа
      description: Создает новый заказ клиента с указанными позициями.
      tags: [Orders]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json: # Предполагаем JSON
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Заказ успешно создан
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/createTestOrder:
    post:
      summary: Создание тестового заказа
      description: Создает тестовый заказ клиента. Параметры и структура идентичны createOrder.
      tags: [Orders, Testing]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest' # Используем ту же схему
      responses:
        '201':
          description: Тестовый заказ успешно создан
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse' # Используем ту же схему
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getOrder:
    get:
      summary: Подробная информация по номеру заказа
      description: Получает детальную информацию по указанному номеру заказа.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: ORDER
          in: query
          required: true
          schema:
            type: string
            maxLength: 10
          description: Номер заказа
        - name: STATUS
          in: query
          required: false
          schema:
            type: string # '0', '1' или пустая строка
            enum: ['0', '1', '']
            # default: '1' # Не указано явно
          description: Флаг для добавления полного описания статусов позиций (1 - да)
        - name: EDIT
          in: query
          required: false
          schema:
            type: string # '0', '1' или пустая строка
            enum: ['0', '1', '']
            # default: '1' # Не указано явно
          description: Флаг "Для изменения" (влияние на ответ неясно)
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
          description: Детальная информация по заказу
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse'
        '404':
          description: Заказ не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getOrder2:
    get:
      summary: Подробная информация по номеру заказа (ver. 2)
      description: Получает детальную информацию по указанному номеру заказа (версия 2). Параметры идентичны getOrder.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: ORDER
          in: query
          required: true
          schema:
            type: string
            maxLength: 10
          description: Номер заказа
        # STATUS и EDIT не упомянуты для getOrder2, но могут подразумеваться
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
          description: Детальная информация по заказу (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Предполагаем ту же структуру ответа
        '404':
          description: Заказ не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getRefund:
    get:
      summary: Подробная информация по номеру возврата
      description: Получает детальную информацию по указанному номеру возврата.
      tags: [Orders, Invoices] # Возвраты связаны и с заказами, и с фактурами
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: RETURN # Уточнено из URL примера
          in: query
          required: true
          schema:
            type: string
            # maxLength: Не указан
          description: Номер возврата
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
          description: Детальная информация по возврату
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RefundDetailsResponse' # Структура неизвестна
        '404':
          description: Возврат не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/editOrder:
    post:
      summary: Редактирование заказа
      description: Позволяет редактировать количество и причину отклонения для позиций существующего заказа.
      tags: [Orders]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json: # Предполагаем JSON
            schema:
              $ref: '#/components/schemas/EditOrderRequest'
      responses:
        '200': # Или 204 No Content, если ответ пустой
          description: Заказ успешно отредактирован
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EditOrderResponse' # Структура неизвестна
        '400':
          description: Ошибка валидации входных данных или невозможность редактирования
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        '404':
          description: Заказ не найден
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  # --- Остальные пути (Ping, Reports, Search, User) остаются как были ---
  /ping:
    # ... existing ping path ...
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
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_order/createOrder`, `/ws_order/createTestOrder`, `/ws_order/getOrder`, `/ws_order/getOrder2`, `/ws_order/getRefund`, `/ws_order/editOrder`.
2.  **Описаны параметры запроса** (query и body) для каждого нового эндпоинта на основе документации.
3.  **Добавлены/обновлены схемы** в `components/schemas` для тел запросов (`CreateOrderRequest`, `EditOrderRequest` с вложенными `OrderItemInput`, `EditOrderItemInput`) и ответов (`CreateOrderResponse`, `OrderDetailsResponse`, `RefundDetailsResponse`, `EditOrderResponse`). Структуры ответов в основном являются предположениями.
4.  **Уточнены типы данных и ограничения** (maxLength), где это было возможно.
5.  **Добавлены коды ответов** (200, 201, 400, 404, default) с описаниями.
6.  **Добавлен тег** `Testing` для `createTestOrder`. Тег `Invoices` теперь включает и возвраты (`getRefund`).

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   Структура ответов для всех новых эндпоинтов.
*   Тип данных для числовых полей (number или string).
*   Назначение и влияние параметра `EDIT` в `getOrder`.
*   Назначение полей `PIN`, `BRAND`, `KWMENG` на уровне заголовка в `createOrder`.
*   Формат передачи данных для POST-запросов (JSON или form-urlencoded).# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
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

    # --- Схемы для Заказов ---
    OrderItemInput: # Для createOrder
      type: object
      required:
        - PIN
        - BRAND
        - KWMENG
      properties:
        PIN:
          type: string
          maxLength: 10
          description: Артикул (номер детали)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд детали
        ARTSKU:
          type: string
          maxLength: 50
          description: Артикул поставщика (опционально)
        NAME:
          type: string
          maxLength: 100
          description: Наименование детали (опционально)
        KWMENG:
          type: number # Или string? Указано "число ( 10 )"
          format: float # Или double
          description: Количество
        PRICE:
          type: number # Или string?
          format: float # Или double
          description: Цена (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD
          description: Желаемая дата поставки для позиции (опционально)
        NOTE:
          type: string
          maxLength: 512
          description: Примечание к позиции (опционально)
    CreateOrderRequest:
      type: object
      required:
        - VKORG
        - KUNRG
        - ITEMS
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        KUNWE:
          type: string
          maxLength: 10
          description: Грузополучатель (опционально)
        KONDA:
          type: string
          maxLength: 2
          description: Ценовая группа клиента (опционально)
        BSTKD:
          type: string
          maxLength: 35
          description: Номер заказа клиента (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD
          description: Желаемая дата поставки всего заказа (опционально)
        PIN: # Выглядит странно на уровне заголовка, возможно для быстрого заказа одной позиции?
          type: string
          maxLength: 10
          description: Артикул (опционально, для быстрого заказа?)
        BRAND: # Выглядит странно на уровне заголовка
          type: string
          maxLength: 50
          description: Бренд (опционально, для быстрого заказа?)
        KWMENG: # Выглядит странно на уровне заголовка
          type: number
          format: float
          description: Количество (опционально, для быстрого заказа?)
        NOTE:
          type: string
          maxLength: 512
          description: Примечание к заказу (опционально)
        DELIVERY_ADDRESS:
          type: string
          maxLength: 255
          description: Адрес доставки текстом (опционально)
        DELIVERY_INTERVAL:
          type: string
          maxLength: 50
          description: Интервал доставки текстом (опционально)
        DELIVERY_METHOD:
          type: string
          maxLength: 50
          description: Способ доставки текстом (опционально)
        CONTACT_PERSON:
          type: string
          maxLength: 50
          description: Контактное лицо текстом (опционально)
        CONTACT_PHONE:
          type: string
          maxLength: 50
          description: Контактный телефон текстом (опционально)
        BACKORDER:
          type: string
          maxLength: 1
          enum: ['X', '']
          description: Разрешить дозаказ ('X' - да, пусто - нет) (опционально)
        SUBSTITUTION:
          type: string
          maxLength: 1
          enum: ['X', '']
          description: Разрешить замену ('X' - да, пусто - нет) (опционально)
        ITEMS:
          type: array
          description: Таблица позиций заказа
          items:
            $ref: '#/components/schemas/OrderItemInput'
    CreateOrderResponse: # Структура ответа неизвестна
      type: object
      properties:
        orderNumber: # Предполагаемое поле
          type: string
          description: Номер созданного заказа
        # ... другие поля ответа
    OrderDetailsResponse: # Структура ответа для getOrder/getOrder2 (неизвестна, placeholder)
      type: object
      properties:
        HEADER:
          type: object
          properties:
            ORDER:
              type: string
              description: Номер заказа
            # ... другие поля заголовка заказа
        ITEMS:
          type: array
          items:
            type: object
            properties:
              POSNR:
                type: string
                description: Номер позиции
              PIN:
                type: string
                description: Артикул
              BRAND:
                type: string
                description: Бренд
              KWMENG:
                type: number
                description: Количество
              # ... другие поля позиции заказа
        ABGRU_ITEMS: # Таблица для editOrder
           type: array
           items:
             type: object
             properties:
               ABGRU:
                 type: string
                 description: Код причины отклонения
               # ... другие поля
        # ... другие таблицы и поля в ответе getOrder
    RefundDetailsResponse: # Структура ответа для getRefund (неизвестна, placeholder)
      type: object
      properties:
        # ... поля ответа
    EditOrderItemInput: # Для editOrder
      type: object
      required:
        - POSNR
        - KWMENG
        - ABGRU
      properties:
        POSNR:
          type: string
          maxLength: 10
          description: Номер позиции в заказе для редактирования
        KWMENG:
          type: number # Или string?
          format: float
          description: Новое количество
        ABGRU:
          type: string
          maxLength: 3
          description: Код причины отклонения (из getOrder ABGRU_ITEMS)
        NOTE:
          type: string
          maxLength: 512
          description: Комментарий к изменению (опционально)
    EditOrderRequest:
      type: object
      required:
        - VKORG
        - KUNRG
        - ORDER
        - POSITION_INPUT
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        ORDER:
          type: string
          maxLength: 10
          description: Номер заказа для редактирования
        POSITION_INPUT:
          type: array
          description: Таблица изменяемых позиций
          items:
            $ref: '#/components/schemas/EditOrderItemInput'
    EditOrderResponse: # Структура ответа неизвестна
      type: object
      properties:
        # ... поля ответа, например, статус операции
    # ... другие схемы ...
    Order: # Placeholder, если используется в других местах
      type: object
      properties:
        id:
          type: string
        # ... другие поля заказа
    OrderPosition: # Placeholder, если используется в других местах
      type: object
      properties:
        id:
          type: string
        # ... другие поля позиции заказа
    SearchResult:
      # ... existing SearchResult schema ...
    Report:
      # ... existing Report schema ...
    UserSetting:
      # ... existing UserSetting schema ...
    PingResponse:
      # ... existing PingResponse schema ...

paths:
  /ws_invoice/getInvoice:
    # ... existing getInvoice path ...
  /ws_invoice/createReturnInvoice:
    # ... existing createReturnInvoice path ...

  # --- Пути для Заказов ---
  /ws_order/createOrder:
    post:
      summary: Создание заказа
      description: Создает новый заказ клиента с указанными позициями.
      tags: [Orders]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json: # Предполагаем JSON
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Заказ успешно создан
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/createTestOrder:
    post:
      summary: Создание тестового заказа
      description: Создает тестовый заказ клиента. Параметры и структура идентичны createOrder.
      tags: [Orders, Testing]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest' # Используем ту же схему
      responses:
        '201':
          description: Тестовый заказ успешно создан
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse' # Используем ту же схему
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getOrder:
    get:
      summary: Подробная информация по номеру заказа
      description: Получает детальную информацию по указанному номеру заказа.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: ORDER
          in: query
          required: true
          schema:
            type: string
            maxLength: 10
          description: Номер заказа
        - name: STATUS
          in: query
          required: false
          schema:
            type: string # '0', '1' или пустая строка
            enum: ['0', '1', '']
            # default: '1' # Не указано явно
          description: Флаг для добавления полного описания статусов позиций (1 - да)
        - name: EDIT
          in: query
          required: false
          schema:
            type: string # '0', '1' или пустая строка
            enum: ['0', '1', '']
            # default: '1' # Не указано явно
          description: Флаг "Для изменения" (влияние на ответ неясно)
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
          description: Детальная информация по заказу
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse'
        '404':
          description: Заказ не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getOrder2:
    get:
      summary: Подробная информация по номеру заказа (ver. 2)
      description: Получает детальную информацию по указанному номеру заказа (версия 2). Параметры идентичны getOrder.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: ORDER
          in: query
          required: true
          schema:
            type: string
            maxLength: 10
          description: Номер заказа
        # STATUS и EDIT не упомянуты для getOrder2, но могут подразумеваться
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
          description: Детальная информация по заказу (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Предполагаем ту же структуру ответа
        '404':
          description: Заказ не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/getRefund:
    get:
      summary: Подробная информация по номеру возврата
      description: Получает детальную информацию по указанному номеру возврата.
      tags: [Orders, Invoices] # Возвраты связаны и с заказами, и с фактурами
      parameters:
        - name: VKORG
          in: query
          required: true
          schema:
            type: string
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema:
            type: string
          description: Номер покупателя (плательщик)
        - name: RETURN # Уточнено из URL примера
          in: query
          required: true
          schema:
            type: string
            # maxLength: Не указан
          description: Номер возврата
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
          description: Детальная информация по возврату
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RefundDetailsResponse' # Структура неизвестна
        '404':
          description: Возврат не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_order/editOrder:
    post:
      summary: Редактирование заказа
      description: Позволяет редактировать количество и причину отклонения для позиций существующего заказа.
      tags: [Orders]
      parameters:
        - name: format
          in: query
          required: false
          schema:
            type: string
            enum: [json, xml]
            default: json
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json: # Предполагаем JSON
            schema:
              $ref: '#/components/schemas/EditOrderRequest'
      responses:
        '200': # Или 204 No Content, если ответ пустой
          description: Заказ успешно отредактирован
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EditOrderResponse' # Структура неизвестна
        '400':
          description: Ошибка валидации входных данных или невозможность редактирования
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
        '404':
          description: Заказ не найден
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  # --- Остальные пути (Ping, Reports, Search, User) остаются как были ---
  /ping:
    # ... existing ping path ...
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
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_order/createOrder`, `/ws_order/createTestOrder`, `/ws_order/getOrder`, `/ws_order/getOrder2`, `/ws_order/getRefund`, `/ws_order/editOrder`.
2.  **Описаны параметры запроса** (query и body) для каждого нового эндпоинта на основе документации.
3.  **Добавлены/обновлены схемы** в `components/schemas` для тел запросов (`CreateOrderRequest`, `EditOrderRequest` с вложенными `OrderItemInput`, `EditOrderItemInput`) и ответов (`CreateOrderResponse`, `OrderDetailsResponse`, `RefundDetailsResponse`, `EditOrderResponse`). Структуры ответов в основном являются предположениями.
4.  **Уточнены типы данных и ограничения** (maxLength), где это было возможно.
5.  **Добавлены коды ответов** (200, 201, 400, 404, default) с описаниями.
6.  **Добавлен тег** `Testing` для `createTestOrder`. Тег `Invoices` теперь включает и возвраты (`getRefund`).

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   Структура ответов для всех новых эндпоинтов.
*   Тип данных для числовых полей (number или string).
*   Назначение и влияние параметра `EDIT` в `getOrder`.
*   Назначение полей `PIN`, `BRAND`, `KWMENG` на уровне заголовка в `createOrder`.
*   Формат передачи данных для POST-запросов (JSON или form-urlencoded).