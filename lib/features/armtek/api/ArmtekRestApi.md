openapi: 3.0.0
info:
  title: Armtek REST API (Unofficial Specification)
  version: '1.1.7' # Based on the mentioned version
  description: >
    Неофициальная спецификация OpenAPI, основанная на ограниченной информации с ws.armtek.ru.
    Описывает сервисы для работы с фактурами, заказами, поиском, отчетностью и т.д.
    **Примечание:** Эта спецификация неполная из-за отсутствия детальной документации по эндпоинтам.
servers:
  - url: https://ws.armtek.ru/api/ # Placeholder - Актуальный базовый URL неизвестен
    description: Production server (URL - предположение)
security:
  - basicAuth: [] # Применяем Basic Auth глобально
components:
  securitySchemes:
    basicAuth:
      type: http
      scheme: basic
      description: Basic Authentication с использованием логина и пароля.
  schemas:
    GenericError:
      type: object
      properties:
        errorCode:
          type: string
        message:
          type: string
    # Placeholder схемы для ответов - актуальная структура неизвестна
    Invoice:
      type: object
      properties:
        id:
          type: string
        # ... другие поля фактуры
    Order:
      type: object
      properties:
        id:
          type: string
        # ... другие поля заказа
    OrderPosition:
      type: object
      properties:
        id:
          type: string
        POSEX: # Добавлено в 1.1.7
          type: string
          description: Ссылка на "Родительскую позицию"
        POSROOT: # Добавлено в 1.1.7
          type: string
          description: Ссылка "На корневую позицию"
        CHARG: # Добавлено в 1.1.7
          type: string
          description: Признак некондиции
        CHARG_BLK: # Добавлено в 1.1.7
          type: string
          description: Признак блокировки некондиции к отгрузке
        # ... другие поля позиции заказа
    SearchResult:
      type: object
      properties:
        # ... поля результата поиска
    Report:
      type: object
      properties:
        # ... поля отчета
    UserSetting:
      type: object
      properties:
        # ... поля настроек пользователя
    PingResponse:
      type: object
      properties:
        status:
          type: string
          example: OK

paths:
  /invoices: # Placeholder для "Cервисы по работе с фактурами"
    get:
      summary: Получить Фактуры (Placeholder)
      description: Placeholder эндпоинт для сервисов, связанных с фактурами. Актуальный путь и параметры неизвестны.
      tags: [Invoices]
      responses:
        '200':
          description: Список фактур (Структура неизвестна)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Invoice'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /orders: # Placeholder для "Cервисы по работе с заказами"
    get:
      summary: Получить Заказы (Placeholder)
      description: Placeholder эндпоинт для сервисов, связанных с заказами. Актуальный путь и параметры неизвестны.
      tags: [Orders]
      responses:
        '200':
          description: Список заказов (Структура неизвестна)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Order'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
    post:
      summary: Создать Заказ (Placeholder)
      description: Placeholder эндпоинт для создания заказов. Актуальный путь и тело запроса неизвестны.
      tags: [Orders]
      responses:
        '201':
          description: Заказ создан (Структура неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /orders/{orderNumber}: # Упомянутый сервис: "Информация по номеру заказа"
    get:
      summary: Получить Заказ по Номеру
      description: Получает детальную информацию по конкретному номеру заказа. Основано на упомянутом сервисе "Информация по номеру заказа". Актуальная структура пути - предположение.
      tags: [Orders]
      parameters:
        - name: orderNumber
          in: path
          required: true
          schema:
            type: string
          description: Номер заказа для получения информации.
      responses:
        '200':
          description: Детали заказа (Структура включает поля, добавленные в v1.1.7)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order' # Предполагается, что схема Order включает позиции
        '404':
          description: Заказ не найден
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ping: # Placeholder для "Сервисы по пингу системы"
    get:
      summary: Пинг Системы
      description: Placeholder эндпоинт для проверки статуса системы. Актуальный путь неизвестен.
      tags: [System]
      responses:
        '200':
          description: Система доступна
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PingResponse'
        default:
          description: Ошибка

  /reports: # Placeholder для "Cервисы по работе с отчетностью"
    get:
      summary: Получить Отчеты (Placeholder)
      description: Placeholder эндпоинт для сервисов отчетности. Актуальный путь и параметры неизвестны.
      tags: [Reporting]
      responses:
        '200':
          description: Список отчетов или данные отчета (Структура неизвестна)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Report'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /reports/orders/positions: # Упомянутый сервис: "Отчет по заказам в разрезе позиций за интервал времени"
    get:
      summary: Получить Отчет по Позициям Заказов за Интервал
      description: Получает отчет по позициям заказов за указанный интервал времени. Основано на упомянутом сервисе "Отчет по заказам в разрезе позиций за интервал времени". Актуальный путь и параметры запроса (например, start/end date) неизвестны.
      tags: [Reporting, Orders]
      # parameters:
      #   - name: startDate
      #     in: query
      #     schema: { type: string, format: date }
      #   - name: endDate
      #     in: query
      #     schema: { type: string, format: date }
      responses:
        '200':
          description: Данные отчета, включая позиции заказов (Структура включает поля, добавленные в v1.1.7)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/OrderPosition'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /search: # Placeholder для "Cервисы поиска"
    get:
      summary: Поиск (Placeholder)
      description: Placeholder эндпоинт для сервисов поиска. Актуальный путь и параметры запроса неизвестны.
      tags: [Search]
      # parameters:
      #   - name: query
      #     in: query
      #     schema: { type: string }
      responses:
        '200':
          description: Результаты поиска (Структура неизвестна)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/SearchResult'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /user/settings: # Placeholder для "Сервисы по настройкам пользователя"
    get:
      summary: Получить Настройки Пользователя (Placeholder)
      description: Placeholder эндпоинт для сервисов настроек пользователя. Актуальный путь неизвестен.
      tags: [User]
      responses:
        '200':
          description: Настройки пользователя (Структура неизвестна)
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/UserSetting'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'
    put:
      summary: Обновить Настройки Пользователя (Placeholder)
      description: Placeholder эндпоинт для обновления настроек пользователя. Актуальный путь и тело запроса неизвестны.
      tags: [User]
      responses:
        '200':
          description: Настройки обновлены (Структура неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserSetting'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

tags: # Определение тегов для группировки
  - name: Invoices
    description: Сервисы, связанные с фактурами
  - name: Orders
    description: Сервисы, связанные с заказами
  - name: System
    description: Сервисы состояния и статуса системы
  - name: Reporting
    description: Сервисы, связанные с отчетностью
  - name: Search
    description: Сервисы поиска
  - name: User
    description: Сервисы, связанные с настройками пользователя

        # ...existing code...
    components:
      securitySchemes:
        basicAuth:
          type: http
          scheme: basic
          description: Basic Authentication с использованием логина и пароля.
      schemas:
        GenericError:
          type: object
          properties:
            errorCode:
              type: string
            message:
              type: string
        # --- Схемы для Фактур ---
        InvoiceDetailsResponse: # Схема ответа для getInvoice (структура неизвестна, placeholder)
          type: object
          properties:
            HEADER:
              type: object # Предполагаем объект, т.к. на него ссылаются
              properties:
                VBELNF:
                  type: string
                  description: Номер Фактуры
                # ... другие поля из таблицы HEADER
            AUGRU_OUTPUT:
              type: array # Предполагаем массив, т.к. это таблица
              items:
                type: object
                properties:
                  AUGRU:
                    type: string
                    description: Код Причины возврата
                  TEXT:
                    type: string
                    description: Описание причины возврата
                  # ... другие поля таблицы AUGRU_OUTPUT
            CASH_BACK:
              type: array # Предполагаем массив, т.к. это таблица
              items:
                type: object
                properties:
                  KEY:
                    type: string
                    description: Код способа возврата денег
                  # ... другие поля таблицы CASH_BACK
            # ... другие возможные таблицы и поля в ответе getInvoice
        ReturnInvoicePositionInput:
          type: object
          required:
            - POSNR
            - MATNR
            - VRKME
            - KWMENG
          properties:
            POSNR:
              type: string
              maxLength: 6
              description: Номер позиции из фактуры, которая возвращается
            MATNR:
              type: string
              # maxLength: Не указан, но обычно стандартный для SAP
              description: Код материала из фактуры
            VRKME:
              type: string
              # maxLength: Не указан (единица измерения)
              description: Единица измерения из фактуры
            KWMENG:
              type: number # Или string, если может быть не числом
              format: float # Или double, зависит от точности
              description: Количество возвращаемого материала
        CreateReturnInvoiceRequest:
          type: object
          required:
            - VKORG
            - KUNRG
            - VBELNF
            - AUGRU
            - POSITION_INPUT
          properties:
            VKORG:
              type: string
              maxLength: 4
              description: Сбытовая организация (из getInvoice)
            KUNRG:
              type: string
              maxLength: 10
              description: Покупатель (из getInvoice)
            VBELNF:
              type: string
              maxLength: 10
              description: Номер Фактуры (из getInvoice HEADER)
            AUGRU:
              type: string
              maxLength: 3
              description: Код Причины возврата (из getInvoice AUGRU_OUTPUT)
            RESOLUTION:
              type: string
              maxLength: 512
              description: Описание причины возврата (опционально, иначе из getInvoice AUGRU_OUTPUT.TEXT)
            CASH_BACK:
              type: string
              description: Код способа возврата денег (из getInvoice CASH_BACK.KEY, опционально, для физлиц)
            KUNZA:
              type: string
              maxLength: 10
              description: Адрес доставки клиента (опционально, из структуры клиента)
            INVDATE:
              type: string
              format: date # YYYYMMDD
              description: Дата возврата (опционально)
              example: '20171005'
            KUNWE:
              type: string
              maxLength: 10
              description: Грузополучатель (опционально, из структуры клиента)
            KUNNR_ZA: # Переименовано из KUNZA в описании параметров POST? Уточнить. Используем KUNNR_ZA как в описании POST.
              type: string
              maxLength: 10
              description: Адрес доставки или Пункт выдачи для самовывоза (опционально, из структуры клиента)
            PARNRZP:
              type: string
              maxLength: 10
              description: Контактное лицо (опционально, если есть KUNNR_ZA, из структуры клиента)
            POSITION_INPUT:
              type: array
              description: Таблица позиций для возврата
              items:
                $ref: '#/components/schemas/ReturnInvoicePositionInput'
        CreateReturnInvoiceResponse: # Схема ответа для createReturnInvoice (структура неизвестна)
          type: object
          properties:
            # ... поля ответа, например, номер созданного документа возврата
        # ... другие схемы ...
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
        PingResponse:
          # ... existing PingResponse schema ...
    
    paths:
      /ws_invoice/getInvoice: # Конкретный путь из примера
        get:
          summary: Подробная информация по номеру фактуры
          description: Получает детальную информацию по фактуре, необходимую в том числе для создания возврата.
          tags: [Invoices]
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
              description: Номер покупателя
            - name: INVOICE # Или VBELNF? В примере INVOICE, в описании параметров createReturnInvoice - VBELNF. Уточнить. Используем INVOICE как в примере URL.
              in: query
              required: true
              schema:
                type: string
              description: Номер Фактуры
            - name: ZZSF # Не описан, но есть в примере URL
              in: query
              required: false # Предположительно
              schema:
                type: string
              description: Неизвестный параметр (ZZSF)
            - name: REFLAG # Упомянут в тексте как обязательный для возврата
              in: query
              required: false # Формально не указан как обязательный для самого GET, но нужен для возврата
              schema:
                type: integer
                enum: [1] # Значение 1 для получения данных для возврата
              description: Флаг для получения данных, необходимых для возврата (установить в 1).
            - name: format
              in: query
              required: false
              schema:
                type: string
                enum: [json, xml] # Предполагаемые форматы
                default: json
              description: Формат ответа
          responses:
            '200':
              description: Детальная информация по фактуре
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/InvoiceDetailsResponse'
                  example: # Пример структуры ответа (гипотетический)
                    HEADER: { VBELNF: "1234567890", ... }
                    AUGRU_OUTPUT: [ { AUGRU: "001", TEXT: "Брак" }, ... ]
                    CASH_BACK: [ { KEY: "CASH", ... }, ... ]
                    # ...
            default:
              description: Ошибка
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/GenericError'
    
      /ws_invoice/createReturnInvoice: # Конкретный путь из примера
        post:
          summary: Создание возврата по фактуре
          description: Создает документ возврата на основе данных существующей фактуры. Перед вызовом необходимо получить данные через getInvoice с REFLAG=1.
          tags: [Invoices]
          parameters:
            - name: format
              in: query
              required: false
              schema:
                type: string
                enum: [json, xml] # Предполагаемые форматы
                default: json
              description: Формат ответа (если применимо к POST)
          requestBody:
            required: true
            content:
              application/json: # Предполагаем JSON
                schema:
                  $ref: '#/components/schemas/CreateReturnInvoiceRequest'
              # application/x-www-form-urlencoded: # Возможен и такой вариант, если API принимает данные формы
              #   schema:
              #     $ref: '#/components/schemas/CreateReturnInvoiceRequest'
          responses:
            '201': # Обычно 201 Created для POST
              description: Возврат успешно создан
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/CreateReturnInvoiceResponse' # Структура ответа неизвестна
            '400':
              description: Ошибка валидации входных данных (например, неверные параметры, невозможность возврата)
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
    
      # --- Остальные пути (Orders, Ping, Reports, Search, User) остаются как были ---
      /orders:
        # ... existing orders paths ...
      /orders/{orderNumber}:
        # ... existing order by number path ...
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
        description: Сервисы, связанные с фактурами
      # ... existing tags ...
    ```
    
    **Основные изменения:**
    
    1.  **Добавлены пути:** `/ws_invoice/getInvoice` (GET) и `/ws_invoice/createReturnInvoice` (POST) на основе примеров URL.
    2.  **Описаны параметры запроса** для `getInvoice` (в query) на основе документации и примера URL. Добавлен параметр `REFLAG`, упомянутый в тексте.
    3.  **Описано тело запроса** для `createReturnInvoice` (в requestBody) на основе таблицы входных параметров. Создана вспомогательная схема `ReturnInvoicePositionInput` для позиций.
    4.  **Добавлены схемы** `InvoiceDetailsResponse`, `CreateReturnInvoiceRequest`, `ReturnInvoicePositionInput`, `CreateReturnInvoiceResponse` в `components/schemas`. Структуры ответов (`InvoiceDetailsResponse`, `CreateReturnInvoiceResponse`) являются предположениями, так как они не описаны детально.
    5.  **Уточнены типы данных и ограничения** (maxLength) для параметров, где это было возможно.
    6.  **Добавлены коды ответов** (200, 201, 400, default) с описаниями.
    
    **Необходимые уточнения (если возможно):**
    
    *   Точный базовый URL API (вместо `/api/`).
    *   Структура ответов для `getInvoice` и `createReturnInvoice`.
    *   Различие между параметрами `INVOICE` (в URL `getInvoice`) и `VBELNF` (в параметрах `createReturnInvoice`). Предполагается, что это одно и то же поле.
    *   Наличие и обязательность параметра `ZZSF` в `getInvoice`.
    *   Различие между `KUNZA` (в описании `getInvoice`) и `KUNNR_ZA` (в описании `createReturnInvoice`).
    *   Формат передачи данных для `createReturnInvoice` (JSON или form-urlencoded).# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
    # ...existing code...
    components:
      securitySchemes:
        basicAuth:
          type: http
          scheme: basic
          description: Basic Authentication с использованием логина и пароля.
      schemas:
        GenericError:
          type: object
          properties:
            errorCode:
              type: string
            message:
              type: string
        # --- Схемы для Фактур ---
        InvoiceDetailsResponse: # Схема ответа для getInvoice (структура неизвестна, placeholder)
          type: object
          properties:
            HEADER:
              type: object # Предполагаем объект, т.к. на него ссылаются
              properties:
                VBELNF:
                  type: string
                  description: Номер Фактуры
                # ... другие поля из таблицы HEADER
            AUGRU_OUTPUT:
              type: array # Предполагаем массив, т.к. это таблица
              items:
                type: object
                properties:
                  AUGRU:
                    type: string
                    description: Код Причины возврата
                  TEXT:
                    type: string
                    description: Описание причины возврата
                  # ... другие поля таблицы AUGRU_OUTPUT
            CASH_BACK:
              type: array # Предполагаем массив, т.к. это таблица
              items:
                type: object
                properties:
                  KEY:
                    type: string
                    description: Код способа возврата денег
                  # ... другие поля таблицы CASH_BACK
            # ... другие возможные таблицы и поля в ответе getInvoice
        ReturnInvoicePositionInput:
          type: object
          required:
            - POSNR
            - MATNR
            - VRKME
            - KWMENG
          properties:
            POSNR:
              type: string
              maxLength: 6
              description: Номер позиции из фактуры, которая возвращается
            MATNR:
              type: string
              # maxLength: Не указан, но обычно стандартный для SAP
              description: Код материала из фактуры
            VRKME:
              type: string
              # maxLength: Не указан (единица измерения)
              description: Единица измерения из фактуры
            KWMENG:
              type: number # Или string, если может быть не числом
              format: float # Или double, зависит от точности
              description: Количество возвращаемого материала
        CreateReturnInvoiceRequest:
          type: object
          required:
            - VKORG
            - KUNRG
            - VBELNF
            - AUGRU
            - POSITION_INPUT
          properties:
            VKORG:
              type: string
              maxLength: 4
              description: Сбытовая организация (из getInvoice)
            KUNRG:
              type: string
              maxLength: 10
              description: Покупатель (из getInvoice)
            VBELNF:
              type: string
              maxLength: 10
              description: Номер Фактуры (из getInvoice HEADER)
            AUGRU:
              type: string
              maxLength: 3
              description: Код Причины возврата (из getInvoice AUGRU_OUTPUT)
            RESOLUTION:
              type: string
              maxLength: 512
              description: Описание причины возврата (опционально, иначе из getInvoice AUGRU_OUTPUT.TEXT)
            CASH_BACK:
              type: string
              description: Код способа возврата денег (из getInvoice CASH_BACK.KEY, опционально, для физлиц)
            KUNZA:
              type: string
              maxLength: 10
              description: Адрес доставки клиента (опционально, из структуры клиента)
            INVDATE:
              type: string
              format: date # YYYYMMDD
              description: Дата возврата (опционально)
              example: '20171005'
            KUNWE:
              type: string
              maxLength: 10
              description: Грузополучатель (опционально, из структуры клиента)
            KUNNR_ZA: # Переименовано из KUNZA в описании параметров POST? Уточнить. Используем KUNNR_ZA как в описании POST.
              type: string
              maxLength: 10
              description: Адрес доставки или Пункт выдачи для самовывоза (опционально, из структуры клиента)
            PARNRZP:
              type: string
              maxLength: 10
              description: Контактное лицо (опционально, если есть KUNNR_ZA, из структуры клиента)
            POSITION_INPUT:
              type: array
              description: Таблица позиций для возврата
              items:
                $ref: '#/components/schemas/ReturnInvoicePositionInput'
        CreateReturnInvoiceResponse: # Схема ответа для createReturnInvoice (структура неизвестна)
          type: object
          properties:
            # ... поля ответа, например, номер созданного документа возврата
        # ... другие схемы ...
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
        PingResponse:
          # ... existing PingResponse schema ...
    
    paths:
      /ws_invoice/getInvoice: # Конкретный путь из примера
        get:
          summary: Подробная информация по номеру фактуры
          description: Получает детальную информацию по фактуре, необходимую в том числе для создания возврата.
          tags: [Invoices]
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
              description: Номер покупателя
            - name: INVOICE # Или VBELNF? В примере INVOICE, в описании параметров createReturnInvoice - VBELNF. Уточнить. Используем INVOICE как в примере URL.
              in: query
              required: true
              schema:
                type: string
              description: Номер Фактуры
            - name: ZZSF # Не описан, но есть в примере URL
              in: query
              required: false # Предположительно
              schema:
                type: string
              description: Неизвестный параметр (ZZSF)
            - name: REFLAG # Упомянут в тексте как обязательный для возврата
              in: query
              required: false # Формально не указан как обязательный для самого GET, но нужен для возврата
              schema:
                type: integer
                enum: [1] # Значение 1 для получения данных для возврата
              description: Флаг для получения данных, необходимых для возврата (установить в 1).
            - name: format
              in: query
              required: false
              schema:
                type: string
                enum: [json, xml] # Предполагаемые форматы
                default: json
              description: Формат ответа
          responses:
            '200':
              description: Детальная информация по фактуре
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/InvoiceDetailsResponse'
                  example: # Пример структуры ответа (гипотетический)
                    HEADER: { VBELNF: "1234567890", ... }
                    AUGRU_OUTPUT: [ { AUGRU: "001", TEXT: "Брак" }, ... ]
                    CASH_BACK: [ { KEY: "CASH", ... }, ... ]
                    # ...
            default:
              description: Ошибка
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/GenericError'
    
      /ws_invoice/createReturnInvoice: # Конкретный путь из примера
        post:
          summary: Создание возврата по фактуре
          description: Создает документ возврата на основе данных существующей фактуры. Перед вызовом необходимо получить данные через getInvoice с REFLAG=1.
          tags: [Invoices]
          parameters:
            - name: format
              in: query
              required: false
              schema:
                type: string
                enum: [json, xml] # Предполагаемые форматы
                default: json
              description: Формат ответа (если применимо к POST)
          requestBody:
            required: true
            content:
              application/json: # Предполагаем JSON
                schema:
                  $ref: '#/components/schemas/CreateReturnInvoiceRequest'
              # application/x-www-form-urlencoded: # Возможен и такой вариант, если API принимает данные формы
              #   schema:
              #     $ref: '#/components/schemas/CreateReturnInvoiceRequest'
          responses:
            '201': # Обычно 201 Created для POST
              description: Возврат успешно создан
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/CreateReturnInvoiceResponse' # Структура ответа неизвестна
            '400':
              description: Ошибка валидации входных данных (например, неверные параметры, невозможность возврата)
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
    
      # --- Остальные пути (Orders, Ping, Reports, Search, User) остаются как были ---
      /orders:
        # ... existing orders paths ...
      /orders/{orderNumber}:
        # ... existing order by number path ...
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
        description: Сервисы, связанные с фактурами
      # ... existing tags ...
    ```