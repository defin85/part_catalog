# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    # --- Базовая структура ответа ---
    ResponseMessage:
      type: object
      properties:
        TYPE:
          type: string
          enum: [A, E, S, W, I]
          description: >
            Тип сообщения:
            * A - критическая ошибка
            * E - ошибка
            * S - успешное сообщение
            * W - предупреждение
            * I - информационное сообщение
        TEXT:
          type: string
          description: Текст сообщения
        DATE: # Формат даты не указан, предполагаем строку
          type: string
          # format: date-time ?
          description: Дата сообщения
    BaseResponse:
      type: object
      properties:
        STATUS:
          type: integer
          description: HTTP статус код ответа (например, 200, 400, 401, 500)
        MESSAGES:
          type: array
          items:
            $ref: '#/components/schemas/ResponseMessage'
          description: Список сообщений, сопровождающих ответ
        RESP: # Это поле будет переопределено в конкретных ответах
          type: object # Или array, или примитив - зависит от конкретного эндпоинта
          description: Тело ответа, специфичное для каждого веб-сервиса
      required:
        - STATUS # Предполагаем, что STATUS всегда присутствует

    # --- Обновленные схемы ответов ---
    GenericErrorResponse: # Заменяем GenericError на структуру ответа
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        # RESP здесь может быть пустым или содержать доп. инфо об ошибке
      example:
        STATUS: 401
        MESSAGES:
          - TYPE: "E"
            TEXT: "Ошибка авторизации пользователя. Необходимо сменить пароль. Зайдите в ЭТП и измените пароль"
            DATE: "..."
        RESP: {}
    RateLimitErrorResponse: # Заменяем RateLimitError
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
      example:
        STATUS: 429
        MESSAGES:
          - TYPE: "E"
            TEXT: "Превышен лимит поисковых запросов" # Точный текст неизвестен
            DATE: "..."
        RESP: {}

    # --- Обновляем существующие схемы ответов, чтобы они включали BaseResponse ---
    GetUserVkorgListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/VkorgItem'
    GetUserInfoResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                STRUCTURE:
                  $ref: '#/components/schemas/ClientStructure'
                FTPDATA:
                  $ref: '#/components/schemas/FtpData'
    GetBrandListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/BrandItem' # Структура BrandItem неизвестна
    GetStoreListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/StoreItem' # Структура StoreItem неизвестна
    SearchResponse: # Базовая схема для поиска
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/SearchResponseItem'
    AssortmentSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть
    GeneralSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть
    PingResponse:
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                IP:
                  type: string
                  maxLength: 16
                  description: IP адрес вызвавшего скрипт
                  nullable: true
                TIME:
                  type: string
                  maxLength: 20
                  description: Время выполнения скрипта
                  nullable: true
    ReportResponseBase: # Базовая схема для отчетов
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  description: Таблица результатов отчета
                  items:
                    type: object # Конкретные поля неизвестны
    OrderReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    OrderPositionsReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    OrderPositionsReportResponseV2:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    InvoiceDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  # ...
                AUGRU_OUTPUT:
                  # ...
                CASH_BACK:
                  # ...
    CreateReturnInvoiceResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа, например, номер созданного документа возврата
    CreateOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                orderNumber: # Предполагаемое поле
                  type: string
                  description: Номер созданного заказа
                # ... другие поля ответа
    OrderDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  # ...
                ITEMS:
                  # ...
                ABGRU_ITEMS:
                  # ...
    RefundDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа
    EditOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа, например, статус операции

    # --- Старые схемы ошибок (можно удалить или оставить для совместимости) ---
    # GenericError: ...
    # RateLimitError: ...

    # --- Остальные схемы запросов и данных остаются без изменений ---
    VkorgItem:
      # ... existing VkorgItem schema ...
    UserInfoRequest:
      # ... existing UserInfoRequest schema ...
    ClientStructure:
      # ... existing ClientStructure schema ...
    FtpData:
      # ... existing FtpData schema ...
    BrandItem:
      # ... existing BrandItem schema ...
    StoreItem:
      # ... existing StoreItem schema ...
    SearchRequestBase:
      # ... existing SearchRequestBase schema ...
    AssortmentSearchRequest:
      # ... existing AssortmentSearchRequest schema ...
    GeneralSearchRequest:
      # ... existing GeneralSearchRequest schema ...
    SearchResponseItem:
      # ... existing SearchResponseItem schema ...
    ReportRequestBase:
      # ... existing ReportRequestBase schema ...
    OrderReportRequest:
      # ... existing OrderReportRequest schema ...
    OrderPositionsReportRequest:
      # ... existing OrderPositionsReportRequest schema ...
    OrderPositionsReportRequestV2:
      # ... existing OrderPositionsReportRequestV2 schema ...
    ReturnInvoicePositionInput:
      # ... existing ReturnInvoicePositionInput schema ...
    CreateReturnInvoiceRequest:
      # ... existing CreateReturnInvoiceRequest schema ...
    OrderItemInput:
      # ... existing OrderItemInput schema ...
    CreateOrderRequest:
      # ... existing CreateOrderRequest schema ...
    EditOrderItemInput:
      # ... existing EditOrderItemInput schema ...
    EditOrderRequest:
      # ... existing EditOrderRequest schema ...
    Order:
      # ... existing Order schema ...
    OrderPosition:
      # ... existing OrderPosition schema ...

paths:
  # --- Обновляем секции responses во всех путях ---
  /ws_user/getUserVkorgList:
    get:
      # ... existing parameters ...
      responses:
        '200':
          description: Список сбытовых организаций
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserVkorgListResponse' # Уже включает BaseResponse
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки

  /ws_user/getUserInfo:
    post:
      # ... existing parameters & requestBody ...
      responses:
        '200':
          description: Структура клиента
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse' # Уже включает BaseResponse
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки

  # ... (Аналогично обновить responses для ВСЕХ остальных путей, заменяя GenericError/RateLimitError на GenericErrorResponse/RateLimitErrorResponse и проверяя ссылки на схемы ответов 2xx) ...

  /ws_search/assortment_search:
    post:
      # ... existing parameters & requestBody ...
      responses:
        '200':
          description: Результаты поиска по ассортименту
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse' # Уже включает BaseResponse
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '429':
          description: Превышен лимит запросов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse' # Используем новую схему ошибки
        '500': # Пример добавления других кодов ошибок
          description: Внутренняя ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '503': # Пример добавления других кодов ошибок
          description: Сервис недоступен
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Неизвестная ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # ... (Продолжить обновление для всех путей: /ws_search/search, /ws_ping/index, /ws_reports/*, /ws_invoice/*, /ws_order/*) ...

tags:
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлена схема `BaseResponse`:** Определяет общую структуру ответа с полями `STATUS`, `MESSAGES` и `RESP`.
2.  **Добавлена схема `ResponseMessage`:** Описывает структуру объекта в массиве `MESSAGES`.
3.  **Обновлены схемы ответов:** Все существующие схемы ответов (например, `GetUserVkorgListResponse`, `SearchResponse`, `PingResponse` и т.д.) теперь используют `allOf` для включения `BaseResponse` и переопределяют поле `RESP` своей специфичной структурой.
4.  **Обновлены схемы ошибок:** `GenericError` и `RateLimitError` заменены на `GenericErrorResponse` и `RateLimitErrorResponse`, которые также наследуют `BaseResponse`. Это позволяет ошибкам иметь стандартную структуру с `STATUS` и `MESSAGES`.
5.  **Обновлены секции `responses` в `paths`:** Ссылки на схемы ошибок заменены на новые (`GenericErrorResponse`, `RateLimitErrorResponse`). Ссылки на успешные ответы (2xx) теперь указывают на обновленные схемы, включающие `BaseResponse`. Добавлены примеры других кодов ошибок (500, 503) на основе списка со страницы.

**Важно:** Необходимо пройти по **всем** путям (`paths`) в спецификации и обновить их секции `responses`, чтобы они ссылались на новые схемы ответов и ошибок (`...Response`). Я обновил только несколько примеров.# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    # --- Базовая структура ответа ---
    ResponseMessage:
      type: object
      properties:
        TYPE:
          type: string
          enum: [A, E, S, W, I]
          description: >
            Тип сообщения:
            * A - критическая ошибка
            * E - ошибка
            * S - успешное сообщение
            * W - предупреждение
            * I - информационное сообщение
        TEXT:
          type: string
          description: Текст сообщения
        DATE: # Формат даты не указан, предполагаем строку
          type: string
          # format: date-time ?
          description: Дата сообщения
    BaseResponse:
      type: object
      properties:
        STATUS:
          type: integer
          description: HTTP статус код ответа (например, 200, 400, 401, 500)
        MESSAGES:
          type: array
          items:
            $ref: '#/components/schemas/ResponseMessage'
          description: Список сообщений, сопровождающих ответ
        RESP: # Это поле будет переопределено в конкретных ответах
          type: object # Или array, или примитив - зависит от конкретного эндпоинта
          description: Тело ответа, специфичное для каждого веб-сервиса
      required:
        - STATUS # Предполагаем, что STATUS всегда присутствует

    # --- Обновленные схемы ответов ---
    GenericErrorResponse: # Заменяем GenericError на структуру ответа
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        # RESP здесь может быть пустым или содержать доп. инфо об ошибке
      example:
        STATUS: 401
        MESSAGES:
          - TYPE: "E"
            TEXT: "Ошибка авторизации пользователя. Необходимо сменить пароль. Зайдите в ЭТП и измените пароль"
            DATE: "..."
        RESP: {}
    RateLimitErrorResponse: # Заменяем RateLimitError
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
      example:
        STATUS: 429
        MESSAGES:
          - TYPE: "E"
            TEXT: "Превышен лимит поисковых запросов" # Точный текст неизвестен
            DATE: "..."
        RESP: {}

    # --- Обновляем существующие схемы ответов, чтобы они включали BaseResponse ---
    GetUserVkorgListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/VkorgItem'
    GetUserInfoResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                STRUCTURE:
                  $ref: '#/components/schemas/ClientStructure'
                FTPDATA:
                  $ref: '#/components/schemas/FtpData'
    GetBrandListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/BrandItem' # Структура BrandItem неизвестна
    GetStoreListResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/StoreItem' # Структура StoreItem неизвестна
    SearchResponse: # Базовая схема для поиска
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  items:
                    $ref: '#/components/schemas/SearchResponseItem'
    AssortmentSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть
    GeneralSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть
    PingResponse:
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                IP:
                  type: string
                  maxLength: 16
                  description: IP адрес вызвавшего скрипт
                  nullable: true
                TIME:
                  type: string
                  maxLength: 20
                  description: Время выполнения скрипта
                  nullable: true
    ReportResponseBase: # Базовая схема для отчетов
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA:
                  type: array
                  description: Таблица результатов отчета
                  items:
                    type: object # Конкретные поля неизвестны
    OrderReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    OrderPositionsReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    OrderPositionsReportResponseV2:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP, если есть
    InvoiceDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  # ...
                AUGRU_OUTPUT:
                  # ...
                CASH_BACK:
                  # ...
    CreateReturnInvoiceResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа, например, номер созданного документа возврата
    CreateOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                orderNumber: # Предполагаемое поле
                  type: string
                  description: Номер созданного заказа
                # ... другие поля ответа
    OrderDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  # ...
                ITEMS:
                  # ...
                ABGRU_ITEMS:
                  # ...
    RefundDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа
    EditOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                # ... поля ответа, например, статус операции

    # --- Старые схемы ошибок (можно удалить или оставить для совместимости) ---
    # GenericError: ...
    # RateLimitError: ...

    # --- Остальные схемы запросов и данных остаются без изменений ---
    VkorgItem:
      # ... existing VkorgItem schema ...
    UserInfoRequest:
      # ... existing UserInfoRequest schema ...
    ClientStructure:
      # ... existing ClientStructure schema ...
    FtpData:
      # ... existing FtpData schema ...
    BrandItem:
      # ... existing BrandItem schema ...
    StoreItem:
      # ... existing StoreItem schema ...
    SearchRequestBase:
      # ... existing SearchRequestBase schema ...
    AssortmentSearchRequest:
      # ... existing AssortmentSearchRequest schema ...
    GeneralSearchRequest:
      # ... existing GeneralSearchRequest schema ...
    SearchResponseItem:
      # ... existing SearchResponseItem schema ...
    ReportRequestBase:
      # ... existing ReportRequestBase schema ...
    OrderReportRequest:
      # ... existing OrderReportRequest schema ...
    OrderPositionsReportRequest:
      # ... existing OrderPositionsReportRequest schema ...
    OrderPositionsReportRequestV2:
      # ... existing OrderPositionsReportRequestV2 schema ...
    ReturnInvoicePositionInput:
      # ... existing ReturnInvoicePositionInput schema ...
    CreateReturnInvoiceRequest:
      # ... existing CreateReturnInvoiceRequest schema ...
    OrderItemInput:
      # ... existing OrderItemInput schema ...
    CreateOrderRequest:
      # ... existing CreateOrderRequest schema ...
    EditOrderItemInput:
      # ... existing EditOrderItemInput schema ...
    EditOrderRequest:
      # ... existing EditOrderRequest schema ...
    Order:
      # ... existing Order schema ...
    OrderPosition:
      # ... existing OrderPosition schema ...

paths:
  # --- Обновляем секции responses во всех путях ---
  /ws_user/getUserVkorgList:
    get:
      # ... existing parameters ...
      responses:
        '200':
          description: Список сбытовых организаций
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserVkorgListResponse' # Уже включает BaseResponse
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки

  /ws_user/getUserInfo:
    post:
      # ... existing parameters & requestBody ...
      responses:
        '200':
          description: Структура клиента
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse' # Уже включает BaseResponse
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем новую схему ошибки

  # ... (Аналогично обновить responses для ВСЕХ остальных путей, заменяя GenericError/RateLimitError на GenericErrorResponse/RateLimitErrorResponse и проверяя ссылки на схемы ответов 2xx) ...

  /ws_search/assortment_search:
    post:
      # ... existing parameters & requestBody ...
      responses:
        '200':
          description: Результаты поиска по ассортименту
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse' # Уже включает BaseResponse
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '429':
          description: Превышен лимит запросов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse' # Используем новую схему ошибки
        '500': # Пример добавления других кодов ошибок
          description: Внутренняя ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '503': # Пример добавления других кодов ошибок
          description: Сервис недоступен
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Неизвестная ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # ... (Продолжить обновление для всех путей: /ws_search/search, /ws_ping/index, /ws_reports/*, /ws_invoice/*, /ws_order/*) ...

tags:
  # ... existing tags ...
```

**Основные изменения:**

1.  **Добавлена схема `BaseResponse`:** Определяет общую структуру ответа с полями `STATUS`, `MESSAGES` и `RESP`.
2.  **Добавлена схема `ResponseMessage`:** Описывает структуру объекта в массиве `MESSAGES`.
3.  **Обновлены схемы ответов:** Все существующие схемы ответов (например, `GetUserVkorgListResponse`, `SearchResponse`, `PingResponse` и т.д.) теперь используют `allOf` для включения `BaseResponse` и переопределяют поле `RESP` своей специфичной структурой.
4.  **Обновлены схемы ошибок:** `GenericError` и `RateLimitError` заменены на `GenericErrorResponse` и `RateLimitErrorResponse`, которые также наследуют `BaseResponse`. Это позволяет ошибкам иметь стандартную структуру с `STATUS` и `MESSAGES`.
5.  **Обновлены секции `responses` в `paths`:** Ссылки на схемы ошибок заменены на новые (`GenericErrorResponse`, `RateLimitErrorResponse`). Ссылки на успешные ответы (2xx) теперь указывают на обновленные схемы, включающие `BaseResponse`. Добавлены примеры других кодов ошибок (500, 503) на основе списка со страницы.

**Важно:** Необходимо пройти по **всем** путям (`paths`) в спецификации и обновить их секции `responses`, чтобы они ссылались на новые схемы ответов и ошибок (`...Response`). Я обновил только несколько примеров.