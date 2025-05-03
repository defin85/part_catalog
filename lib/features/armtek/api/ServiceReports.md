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
    UserSetting:
      # ... existing UserSetting schema ...
    PingResponse:
      # ... existing PingResponse schema ...

    # --- Схемы для Отчетов ---
    ReportRequestBase: # Базовая схема для запросов отчетов
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        SCRDATE:
          type: string
          format: date # YYYYMMDD
          description: Дата создания С (по умолчанию текущая)
          example: '20170105'
        ECRDATE:
          type: string
          format: date # YYYYMMDD
          description: Дата создания ПО (по умолчанию текущая)
          example: '20170105'
        SDLDATE:
          type: string
          format: date # YYYYMMDD
          description: Поставка товара С (Формат YYYYMMDD)
          example: '20170105'
        EDLDATE:
          type: string
          format: date # YYYYMMDD
          description: Поставка товара ПО (Формат YYYYMMDD)
          example: '20170105'
        TYPEZK_SALE:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Включить заказы продаж (1 - да)
        TYPEZK_RETN:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Включить возвраты и количественные разницы (1 - да)
        KURR_LOGIN:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Фильтровать заказы по текущему логину (1 - да)
      required: # Обязательные поля не указаны явно, предполагаем основные
        - VKORG
        - KUNNR_RG

    ReportResponseBase: # Базовая схема для ответов отчетов (структура DATA неизвестна)
      type: object
      properties:
        DATA:
          type: array
          description: Таблица результатов отчета
          items:
            type: object # Конкретные поля неизвестны
            properties:
              # Примерные поля на основе getOrderPositionsReportByDate
              PIN: { type: string }
              BRAND: { type: string }
              NAME: { type: string }
              KWMENG: { type: number }
              PRICE: { type: number }
              # ... другие поля из таблицы DATA
      # required: # Неизвестно

    # Схемы для конкретных отчетов (если нужны специфичные поля)
    OrderReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля, если есть

    OrderPositionsReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderPositionsReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля, если есть

    OrderPositionsReportRequestV2:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля для V2, если есть

    OrderPositionsReportResponseV2:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля для V2, если есть

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
  /ws_ping/index:
    # ... existing ping path ...

  # --- Пути для Отчетов ---
  /ws_reports/getOrderReportByDate:
    post:
      summary: Отчет по заказам за интервал времени
      description: Получает отчет по заказам за указанный интервал времени и с учетом других фильтров.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderReportRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/OrderReportRequest'
      responses:
        '200':
          description: Данные отчета по заказам
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderReportResponse' # Структура DATA неизвестна
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

  /ws_reports/getOrderPositionsReportByDate:
    post:
      summary: Отчет по заказам в разрезе позиций за интервал времени
      description: Получает отчет по позициям заказов за указанный интервал времени и с учетом других фильтров.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderPositionsReportRequest'
      responses:
        '200':
          description: Данные отчета по позициям заказов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponse' # Структура DATA неизвестна
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

  /ws_reports/getOrderPositionsReportByDate2:
    post:
      summary: Отчет по заказам в разрезе позиций за интервал времени (ver. 2)
      description: Получает отчет по позициям заказов за указанный интервал времени (версия 2). Параметры запроса аналогичны первой версии.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderPositionsReportRequestV2' # Используем V2 схему запроса
      responses:
        '200':
          description: Данные отчета по позициям заказов (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponseV2' # Используем V2 схему ответа
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

  # --- Остальные пути (Search, User) остаются как были ---
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
  - name: Reporting
    description: Сервисы, связанные с отчетностью
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_reports/getOrderReportByDate`, `/ws_reports/getOrderPositionsReportByDate`, `/ws_reports/getOrderPositionsReportByDate2`. Все используют метод POST.
2.  **Добавлены схемы запросов:** Создана базовая схема `ReportRequestBase` с общими параметрами (VKORG, KUNNR_RG, даты, фильтры). На ее основе созданы схемы для конкретных отчетов (`OrderReportRequest`, `OrderPositionsReportRequest`, `OrderPositionsReportRequestV2`), хотя в данном случае они не добавляют специфичных полей.
3.  **Добавлены схемы ответов:** Создана базовая схема `ReportResponseBase`, которая включает массив `DATA`. Конкретная структура объектов внутри `DATA` неизвестна, поэтому она оставлена как `type: object`. На ее основе созданы схемы для конкретных ответов (`OrderReportResponse`, `OrderPositionsReportResponse`, `OrderPositionsReportResponseV2`).
4.  **Описаны параметры запроса:** Для каждого пути указан `requestBody` со ссылкой на соответствующую схему запроса. Добавлен опциональный query-параметр `format`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `Reporting`.# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
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
    UserSetting:
      # ... existing UserSetting schema ...
    PingResponse:
      # ... existing PingResponse schema ...

    # --- Схемы для Отчетов ---
    ReportRequestBase: # Базовая схема для запросов отчетов
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента)
        SCRDATE:
          type: string
          format: date # YYYYMMDD
          description: Дата создания С (по умолчанию текущая)
          example: '20170105'
        ECRDATE:
          type: string
          format: date # YYYYMMDD
          description: Дата создания ПО (по умолчанию текущая)
          example: '20170105'
        SDLDATE:
          type: string
          format: date # YYYYMMDD
          description: Поставка товара С (Формат YYYYMMDD)
          example: '20170105'
        EDLDATE:
          type: string
          format: date # YYYYMMDD
          description: Поставка товара ПО (Формат YYYYMMDD)
          example: '20170105'
        TYPEZK_SALE:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Включить заказы продаж (1 - да)
        TYPEZK_RETN:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Включить возвраты и количественные разницы (1 - да)
        KURR_LOGIN:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Фильтровать заказы по текущему логину (1 - да)
      required: # Обязательные поля не указаны явно, предполагаем основные
        - VKORG
        - KUNNR_RG

    ReportResponseBase: # Базовая схема для ответов отчетов (структура DATA неизвестна)
      type: object
      properties:
        DATA:
          type: array
          description: Таблица результатов отчета
          items:
            type: object # Конкретные поля неизвестны
            properties:
              # Примерные поля на основе getOrderPositionsReportByDate
              PIN: { type: string }
              BRAND: { type: string }
              NAME: { type: string }
              KWMENG: { type: number }
              PRICE: { type: number }
              # ... другие поля из таблицы DATA
      # required: # Неизвестно

    # Схемы для конкретных отчетов (если нужны специфичные поля)
    OrderReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля, если есть

    OrderPositionsReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderPositionsReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля, если есть

    OrderPositionsReportRequestV2:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля для V2, если есть

    OrderPositionsReportResponseV2:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля для V2, если есть

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
  /ws_ping/index:
    # ... existing ping path ...

  # --- Пути для Отчетов ---
  /ws_reports/getOrderReportByDate:
    post:
      summary: Отчет по заказам за интервал времени
      description: Получает отчет по заказам за указанный интервал времени и с учетом других фильтров.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderReportRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/OrderReportRequest'
      responses:
        '200':
          description: Данные отчета по заказам
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderReportResponse' # Структура DATA неизвестна
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

  /ws_reports/getOrderPositionsReportByDate:
    post:
      summary: Отчет по заказам в разрезе позиций за интервал времени
      description: Получает отчет по позициям заказов за указанный интервал времени и с учетом других фильтров.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderPositionsReportRequest'
      responses:
        '200':
          description: Данные отчета по позициям заказов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponse' # Структура DATA неизвестна
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

  /ws_reports/getOrderPositionsReportByDate2:
    post:
      summary: Отчет по заказам в разрезе позиций за интервал времени (ver. 2)
      description: Получает отчет по позициям заказов за указанный интервал времени (версия 2). Параметры запроса аналогичны первой версии.
      tags: [Reporting, Orders]
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
              $ref: '#/components/schemas/OrderPositionsReportRequestV2' # Используем V2 схему запроса
      responses:
        '200':
          description: Данные отчета по позициям заказов (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponseV2' # Используем V2 схему ответа
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

  # --- Остальные пути (Search, User) остаются как были ---
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
  - name: Reporting
    description: Сервисы, связанные с отчетностью
  - name: Testing
    description: Сервисы для тестирования
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_reports/getOrderReportByDate`, `/ws_reports/getOrderPositionsReportByDate`, `/ws_reports/getOrderPositionsReportByDate2`. Все используют метод POST.
2.  **Добавлены схемы запросов:** Создана базовая схема `ReportRequestBase` с общими параметрами (VKORG, KUNNR_RG, даты, фильтры). На ее основе созданы схемы для конкретных отчетов (`OrderReportRequest`, `OrderPositionsReportRequest`, `OrderPositionsReportRequestV2`), хотя в данном случае они не добавляют специфичных полей.
3.  **Добавлены схемы ответов:** Создана базовая схема `ReportResponseBase`, которая включает массив `DATA`. Конкретная структура объектов внутри `DATA` неизвестна, поэтому она оставлена как `type: object`. На ее основе созданы схемы для конкретных ответов (`OrderReportResponse`, `OrderPositionsReportResponse`, `OrderPositionsReportResponseV2`).
4.  **Описаны параметры запроса:** Для каждого пути указан `requestBody` со ссылкой на соответствующую схему запроса. Добавлен опциональный query-параметр `format`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `Reporting`.