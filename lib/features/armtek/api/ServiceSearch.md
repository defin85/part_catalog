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
    # ... other existing schemas ...
    PingResponse:
      # ... existing PingResponse schema ...
    ReportRequestBase:
      # ... existing ReportRequestBase schema ...
    ReportResponseBase:
      # ... existing ReportResponseBase schema ...
    # ... other report schemas ...

    # --- Схемы для Поиска ---
    SearchRequestBase: # Базовая схема для запросов поиска
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация. Пример: 4000
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Покупатель (номер клиента)
        PIN:
          type: string
          maxLength: 40 # Указано <40
          description: Номер артикула (строка поиска)
        BRAND:
          type: string
          maxLength: 50
          description: Наименование бренда. Рекомендуется заполнять.
        QUERY_TYPE:
          type: string
          maxLength: 1
          enum: ['1', '2', '']
          description: >
            Тип поиска.
            1 - поиск по артикулу и его аналогам.
            2 - поиск только по указанному артикулу.
            Пусто - как 1.
            Рекомендуется 1, если BRAND не указан.
        PROGRAM:
          type: string
          maxLength: 2
          enum: ['LP', 'GP', '']
          description: Легковая (LP) или Грузовая (GP) программа.
        KUNNR_ZA:
          type: string
          maxLength: 10
          description: >
            Адрес доставки или Пункт выдачи для самовывоза.
            Доступные значения из сервиса структуры клиента (RG_TAB->ZA_TAB-KUNNR или RG_TAB->EWX_TAB-ID).
            Пример: 00000000
        PARNR:
          type: string
          maxLength: 20
          description: Код склада партнера.
        KEYZAK:
          type: string
          maxLength: 10
          description: >
            Код склада. Соответствует аналогичному параметру из ответа сервиса поиска.
            Рекомендуется заполнять, иначе поиск только по основному складу.
      required: # Обязательные поля для поиска
        - VKORG
        - KUNNR_RG
        - PIN

    SearchResponseItem: # Примерная структура элемента ответа поиска (основано на полях, упомянутых в других сервисах)
      type: object
      properties:
        PIN:
          type: string
        BRAND:
          type: string
        NAME:
          type: string
        PRICE:
          type: number
        RVALUE: # Доступное количество
          type: string # Или number? Указано "строка ( 20 )"
        RETDAYS: # Дней на возврат
          type: integer # Или string? Указано "число ( 4 )"
        RDPRF: # Кратность
          type: string # Или number? Указано "строка ( 10 )"
        KEYZAK: # Код склада
          type: string
        # ... другие поля из ответа сервиса поиска ...

    SearchResponse: # Базовая схема ответа поиска
      type: object
      properties:
        DATA: # Предполагаем, что ответ содержит массив DATA
          type: array
          items:
            $ref: '#/components/schemas/SearchResponseItem'
      # required: # Неизвестно

    AssortmentSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    AssortmentSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse'
        # Дополнительные поля, если есть

    GeneralSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    GeneralSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse'
        # Дополнительные поля, если есть

paths:
  # ... existing invoice paths ...
  # ... existing order paths ...
  /ws_ping/index:
    # ... existing ping path ...
  # ... existing report paths ...

  # --- Пути для Поиска ---
  /ws_search/assortment_search:
    post:
      summary: Поиск по ассортименту
      description: Выполняет поиск запчастей по ассортименту Armtek.
      tags: [Search]
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
              $ref: '#/components/schemas/AssortmentSearchRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/AssortmentSearchRequest'
      responses:
        '200':
          description: Результаты поиска по ассортименту
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse' # Структура DATA неизвестна
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

  /ws_search/search:
    post:
      summary: Поиск (общий)
      description: Выполняет общий поиск запчастей.
      tags: [Search]
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
              $ref: '#/components/schemas/GeneralSearchRequest'
      responses:
        '200':
          description: Результаты поиска
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GeneralSearchResponse' # Структура DATA неизвестна
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

  # --- Остальные пути (User) остаются как были ---
  /user/settings:
    # ... existing user settings paths ...

tags:
  # ... existing tags ...
  - name: Search
    description: Сервисы поиска
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_search/assortment_search` и `/ws_search/search`. Оба используют метод POST.
2.  **Добавлены схемы запросов:** Создана базовая схема `SearchRequestBase` с общими параметрами (VKORG, KUNNR_RG, PIN, BRAND, QUERY_TYPE и т.д.). На ее основе созданы схемы для конкретных поисков (`AssortmentSearchRequest`, `GeneralSearchRequest`).
3.  **Добавлены схемы ответов:** Создана базовая схема ответа `SearchResponse`, предполагающая наличие массива `DATA`. Создана примерная схема элемента ответа `SearchResponseItem` на основе полей, упомянутых в других сервисах. На их основе созданы схемы для конкретных ответов (`AssortmentSearchResponse`, `GeneralSearchResponse`). **Структура ответа не детализирована в документации.**
4.  **Описаны параметры запроса:** Для каждого пути указан `requestBody` со ссылкой на соответствующую схему запроса. Добавлен опциональный query-параметр `format`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `Search`.

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   **Структура ответа** для обоих сервисов поиска (поля в массиве `DATA`).
*   Тип данных для полей `RVALUE`, `RETDAYS`, `RDPRF` в ответе (число или строка).
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
    # ... other existing schemas ...
    PingResponse:
      # ... existing PingResponse schema ...
    ReportRequestBase:
      # ... existing ReportRequestBase schema ...
    ReportResponseBase:
      # ... existing ReportResponseBase schema ...
    # ... other report schemas ...

    # --- Схемы для Поиска ---
    SearchRequestBase: # Базовая схема для запросов поиска
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация. Пример: 4000
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Покупатель (номер клиента)
        PIN:
          type: string
          maxLength: 40 # Указано <40
          description: Номер артикула (строка поиска)
        BRAND:
          type: string
          maxLength: 50
          description: Наименование бренда. Рекомендуется заполнять.
        QUERY_TYPE:
          type: string
          maxLength: 1
          enum: ['1', '2', '']
          description: >
            Тип поиска.
            1 - поиск по артикулу и его аналогам.
            2 - поиск только по указанному артикулу.
            Пусто - как 1.
            Рекомендуется 1, если BRAND не указан.
        PROGRAM:
          type: string
          maxLength: 2
          enum: ['LP', 'GP', '']
          description: Легковая (LP) или Грузовая (GP) программа.
        KUNNR_ZA:
          type: string
          maxLength: 10
          description: >
            Адрес доставки или Пункт выдачи для самовывоза.
            Доступные значения из сервиса структуры клиента (RG_TAB->ZA_TAB-KUNNR или RG_TAB->EWX_TAB-ID).
            Пример: 00000000
        PARNR:
          type: string
          maxLength: 20
          description: Код склада партнера.
        KEYZAK:
          type: string
          maxLength: 10
          description: >
            Код склада. Соответствует аналогичному параметру из ответа сервиса поиска.
            Рекомендуется заполнять, иначе поиск только по основному складу.
      required: # Обязательные поля для поиска
        - VKORG
        - KUNNR_RG
        - PIN

    SearchResponseItem: # Примерная структура элемента ответа поиска (основано на полях, упомянутых в других сервисах)
      type: object
      properties:
        PIN:
          type: string
        BRAND:
          type: string
        NAME:
          type: string
        PRICE:
          type: number
        RVALUE: # Доступное количество
          type: string # Или number? Указано "строка ( 20 )"
        RETDAYS: # Дней на возврат
          type: integer # Или string? Указано "число ( 4 )"
        RDPRF: # Кратность
          type: string # Или number? Указано "строка ( 10 )"
        KEYZAK: # Код склада
          type: string
        # ... другие поля из ответа сервиса поиска ...

    SearchResponse: # Базовая схема ответа поиска
      type: object
      properties:
        DATA: # Предполагаем, что ответ содержит массив DATA
          type: array
          items:
            $ref: '#/components/schemas/SearchResponseItem'
      # required: # Неизвестно

    AssortmentSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    AssortmentSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse'
        # Дополнительные поля, если есть

    GeneralSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    GeneralSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse'
        # Дополнительные поля, если есть

paths:
  # ... existing invoice paths ...
  # ... existing order paths ...
  /ws_ping/index:
    # ... existing ping path ...
  # ... existing report paths ...

  # --- Пути для Поиска ---
  /ws_search/assortment_search:
    post:
      summary: Поиск по ассортименту
      description: Выполняет поиск запчастей по ассортименту Armtek.
      tags: [Search]
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
              $ref: '#/components/schemas/AssortmentSearchRequest'
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/AssortmentSearchRequest'
      responses:
        '200':
          description: Результаты поиска по ассортименту
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse' # Структура DATA неизвестна
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

  /ws_search/search:
    post:
      summary: Поиск (общий)
      description: Выполняет общий поиск запчастей.
      tags: [Search]
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
              $ref: '#/components/schemas/GeneralSearchRequest'
      responses:
        '200':
          description: Результаты поиска
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GeneralSearchResponse' # Структура DATA неизвестна
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

  # --- Остальные пути (User) остаются как были ---
  /user/settings:
    # ... existing user settings paths ...

tags:
  # ... existing tags ...
  - name: Search
    description: Сервисы поиска
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_search/assortment_search` и `/ws_search/search`. Оба используют метод POST.
2.  **Добавлены схемы запросов:** Создана базовая схема `SearchRequestBase` с общими параметрами (VKORG, KUNNR_RG, PIN, BRAND, QUERY_TYPE и т.д.). На ее основе созданы схемы для конкретных поисков (`AssortmentSearchRequest`, `GeneralSearchRequest`).
3.  **Добавлены схемы ответов:** Создана базовая схема ответа `SearchResponse`, предполагающая наличие массива `DATA`. Создана примерная схема элемента ответа `SearchResponseItem` на основе полей, упомянутых в других сервисах. На их основе созданы схемы для конкретных ответов (`AssortmentSearchResponse`, `GeneralSearchResponse`). **Структура ответа не детализирована в документации.**
4.  **Описаны параметры запроса:** Для каждого пути указан `requestBody` со ссылкой на соответствующую схему запроса. Добавлен опциональный query-параметр `format`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `Search`.

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   **Структура ответа** для обоих сервисов поиска (поля в массиве `DATA`).
*   Тип данных для полей `RVALUE`, `RETDAYS`, `RDPRF` в ответе (число или строка).
*   Формат передачи данных для POST-запросов (JSON или form-urlencoded).