<pre>
openapi: 3.0.0
info:
  title: Armtek REST API (Unofficial Consolidated Specification)
  version: '1.1.7' # Based on the mentioned version across documents
  description: >
    Неофициальная сводная спецификация OpenAPI для REST API Armtek v1.1.7, основанная на общедоступной информации с ws.armtek.ru.
    Предоставляет доступ к сервисам фактур, заказов, поиска, отчетности, пинга и настроек пользователя.

    **Ключевые понятия структуры клиента:**
    * **VKORG (Сбытовая организация):** Место отгрузки товара. Получается через `getUserVkorgList`.
    * **KUNAG (Головной Клиент):** Общий идентификатор всей структуры клиента. Определяется по логину, не передается в запросах.
    * **KUNNR_RG (Покупатель):** Организация/лицо, осуществляющее покупку и расчеты. Получается из `getUserInfo` (RG_TAB).
    * **KUNNR_WE (Грузополучатель):** Получатель товара. Подчинен Покупателю. Получается из `getUserInfo` (WE_TAB).
    * **KUNNR_ZA (Адрес доставки / Место получения):** Место доставки или пункт выдачи. Подчинен Покупателю. Получается из `getUserInfo` (ZA_TAB или EWX_TAB).
    * **PARNR (Контактное лицо):** Ответственное лицо со стороны Покупателя. Получается из `getUserInfo` (CONTACT_TAB).
    * **VBELN (Договор):** Документ, регулирующий взаимодействие. Подчинен Покупателю. Получается из `getUserInfo` (DOGOVOR_TAB).

    **Ключевые понятия поиска и заказа:**
    * **PIN:** Искомый номер детали (артикул).
    * **BRAND:** Наименование бренда (используется принятое в Armtek). Получается через `getBrandList`.
    * **KEYZAK:** Код склада. Обязательно передается при создании заказа из результатов поиска.
    * **INCOTERMS:** Признак самовывоза ('1' - самовывоз, '0'/пусто - доставка).

    **Важные замечания:**
    * **Аутентификация:** Требуется логин и пароль клиента Armtek, специально зарегистрированный для веб-сервисов. **Обязательно смените пароль** после регистрации логина через ЭТП, иначе API вернет ошибку авторизации (STATUS 401).
    * **Базовые URL:** Используйте URL, соответствующий вашему региону.
    * **Ограничение запросов:** Существует суточное ограничение на количество поисковых запросов (по умолчанию 1000). Превышение лимита приведет к ошибке (STATUS 429).
    * **IP Whitelisting:** Опционально можно ограничить доступ к API по IP-адресам для повышения безопасности (настраивается через менеджера).
    * **Эта спецификация неполная**, так как детальная структура многих ответов (особенно в поле RESP) неизвестна или основана на предположениях.
    * **Типы данных:** Некоторые числовые поля (например, количество) в документации описаны как строки ("строка ( 20 )"). В спецификации они оставлены как строки с комментарием, но могут требовать преобразования на клиенте.
servers:
  - url: http://ws.armtek.ru # Для России
    description: Production server (Russia)
  - url: http://ws.armtek.by # Для Беларуси
    description: Production server (Belarus)
security:
  - basicAuth: [] # Применяем Basic Auth глобально
tags:
  - name: Invoices
    description: Сервисы, связанные с фактурами и возвратами
  - name: Orders
    description: Сервисы, связанные с заказами
  - name: System
    description: Сервисы состояния и статуса системы
  - name: Reporting
    description: Сервисы, связанные с отчетностью
  - name: Search
    description: Сервисы поиска
  - name: User
    description: Сервисы, связанные с настройками и информацией пользователя
  - name: Testing
    description: Сервисы для тестирования (например, createTestOrder)
components:
  securitySchemes:
    basicAuth:
      type: http
      scheme: basic
      description: Basic Authentication с использованием логина и пароля пользователя Armtek, зарегистрированного для веб-сервисов.
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
            * A - Прерывание (Abend)
            * E - Ошибка (Error)
            * S - Успешное выполнение (Success)
            * W - Предупреждение (Warning)
            * I - Информационное сообщение (Information)
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
          description: HTTP статус код ответа (например, 200, 400, 401, 429, 500)
        MESSAGES:
          type: array
          items:
            $ref: '#/components/schemas/ResponseMessage'
          description: Список сообщений, сопровождающих ответ
        RESP: # Это поле будет переопределено в конкретных ответах
          type: object # Или array, или примитив - зависит от конкретного эндпоинта
          description: Тело ответа, специфичное для каждого веб-сервиса
          nullable: true
      required:
        - STATUS # Предполагаем, что STATUS всегда присутствует

    # --- Общие схемы ошибок ---
    GenericErrorResponse: # Ошибка валидации, авторизации, не найдено и т.д.
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        # RESP здесь обычно пустой или содержит доп. инфо об ошибке
      example:
        STATUS: 401
        MESSAGES:
          - TYPE: "E"
            TEXT: "Ошибка авторизации пользователя. Необходимо сменить пароль. Зайдите в ЭТП и измените пароль"
            DATE: "..."
        RESP: {}
    RateLimitErrorResponse: # Ошибка превышения лимита запросов
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
      example:
        STATUS: 429
        MESSAGES:
          - TYPE: "E"
            TEXT: "Превышен лимит поисковых запросов" # Точный текст неизвестен
            DATE: "..."
        RESP: {}

    # --- Схемы для Сервисов Пользователя (User) ---
    VkorgItem: # Элемент ответа getUserVkorgList
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        PROGRAM_NAME:
          type: string
          maxLength: 100
          description: Наименование сбытовой организации (программы)
      required:
        - VKORG
        - PROGRAM_NAME
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

    UserInfoRequest: # Запрос для getUserInfo
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки). Пример: 4000
        STRUCTURE:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Получить структуру клиента (1 - да, 0/пусто - нет)
        FTPDATA:
          type: string
          maxLength: 1
          enum: ['0', '1', '']
          description: Получить данные FTP клиента (1 - да, 0/пусто - нет)
      required:
        - VKORG

    ClientStructure: # Часть ответа getUserInfo (структура детализирована частично)
      type: object
      properties:
        KUNAG:
          type: string
          maxLength: 10
          description: Головной Клиент (определяется по логину)
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        SNAME:
          type: string
          maxLength: 100
          description: Краткое наименование Головного Клиента
        # ... другие поля структуры клиента ...
        RG_TAB: # Таблица плательщиков (Покупатели)
          type: array
          items:
            type: object
            properties:
              KUNNR: { type: string, maxLength: 10, description: Идентификатор плательщика (KUNNR_RG) }
              DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
              SNAME: { type: string, maxLength: 100, description: Краткое наименование плательщика }
              # ... другие поля плательщика ...
              WE_TAB: # Таблица грузополучателей (подчинена KUNNR_RG)
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор грузополучателя (KUNNR_WE) }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование грузополучателя }
                    # ... другие поля грузополучателя ...
              ZA_TAB: # Таблица адресов доставки (подчинена KUNNR_RG)
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор адреса доставки (KUNNR_ZA) }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование адреса }
                    # ... другие поля адреса ...
              EWX_TAB: # Таблица пунктов выдачи (подчинена KUNNR_RG)
                type: array
                items:
                  type: object
                  properties:
                    ID: { type: string, maxLength: 10, description: Идентификатор пункта выдачи (также используется как KUNNR_ZA) }
                    SNAME: { type: string, maxLength: 100, description: Наименование пункта выдачи }
                    # ... другие поля пункта выдачи ...
              DOGOVOR_TAB: # Таблица договоров (подчинена KUNNR_RG)
                type: array
                items:
                  type: object
                  properties:
                    VBELN: { type: string, description: Номер договора }
                    # ... поля договора ...
              CONTACT_TAB: # Таблица контактных лиц (подчинена KUNNR_RG)
                type: array
                items:
                  type: object
                  properties:
                    PARNR: { type: string, maxLength: 10, description: Идентификатор контактного лица (PARNR) }
                    SNAME: { type: string, description: Имя контактного лица }
                    # ... другие поля контактного лица ...
    FtpData: # Часть ответа getUserInfo (структура неизвестна)
      type: object
      properties:
        # ... поля данных FTP ...
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
                  nullable: true
                FTPDATA:
                  $ref: '#/components/schemas/FtpData'
                  nullable: true

    BrandItem: # Элемент ответа getBrandList (структура неизвестна)
      type: object
      properties:
        # ... поля бренда (например, ID, NAME) ...
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
                    $ref: '#/components/schemas/BrandItem'

    StoreItem: # Элемент ответа getStoreList (структура неизвестна)
      type: object
      properties:
        # ... поля склада (например, ID, NAME, KEYZAK?) ...
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
                    $ref: '#/components/schemas/StoreItem'

    # --- Схемы для Сервисов Поиска (Search) ---
    SearchRequestBase: # Базовая схема для запросов поиска
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки). Пример: 4000
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Покупатель (номер клиента, KUNNR_RG)
        PIN:
          type: string
          maxLength: 40 # Указано <40
          description: Номер артикула (строка поиска)
        BRAND:
          type: string
          maxLength: 50
          description: Наименование бренда (принятое в Armtek). Рекомендуется заполнять.
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
            Адрес доставки или Пункт выдачи для самовывоза (KUNNR_ZA).
            Доступные значения из `getUserInfo` (RG_TAB->ZA_TAB-KUNNR или RG_TAB->EWX_TAB-ID).
            Пример: 00000000
        PARNR: # В поиске это код склада партнера!
          type: string
          maxLength: 20
          description: Код склада партнера (не путать с контактным лицом).
        KEYZAK:
          type: string
          maxLength: 10
          description: >
            Код склада Armtek. Соответствует аналогичному параметру из ответа сервиса поиска.
            Рекомендуется заполнять, иначе поиск только по основному складу.
      required: # Обязательные поля для поиска
        - VKORG
        - KUNNR_RG
        - PIN

    SearchResponseItem: # Примерная структура элемента ответа поиска
      type: object
      properties:
        PIN:
          type: string
        BRAND:
          type: string
        NAME:
          type: string
        PRICE:
          type: number # Или string?
        RVALUE: # Доступное количество
          type: string # Или number? Указано "строка ( 20 )"
        RETDAYS: # Дней на возврат
          type: integer # Или string? Указано "число ( 4 )"
        RDPRF: # Кратность
          type: string # Или number? Указано "строка ( 10 )"
        KEYZAK: # Код склада Armtek
          type: string
          description: Код склада Armtek, с которого доступна позиция. Обязателен для заказа.
        # ... другие поля из ответа сервиса поиска ...

    SearchResponse: # Базовая схема ответа поиска
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                DATA: # Предполагаем, что ответ содержит массив DATA
                  type: array
                  items:
                    $ref: '#/components/schemas/SearchResponseItem'

    AssortmentSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    AssortmentSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть

    GeneralSearchRequest:
      allOf:
        - $ref: '#/components/schemas/SearchRequestBase'
        # Дополнительные поля, если есть

    GeneralSearchResponse:
      allOf:
        - $ref: '#/components/schemas/SearchResponse' # Наследует BaseResponse через SearchResponse
        # Дополнительные поля в RESP, если есть

    # --- Схемы для Сервисов Пинга (System) ---
    PingResponseData: # Специфичные данные для Ping
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
      example:
        IP: "192.168.1.100"
        TIME: "0.001234 sec"
    PingResponse: # Полный ответ для Ping
       allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/PingResponseData'

    # --- Схемы для Сервисов Отчетности (Reporting) ---
    ReportRequestBase: # Базовая схема для запросов отчетов
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента, KUNNR_RG)
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

    ReportResponseDataBase: # Базовая структура данных отчета (массив объектов)
      type: object
      properties:
        DATA:
          type: array
          description: Таблица результатов отчета
          items:
            type: object # Конкретные поля зависят от отчета
            properties:
              # Примерные поля на основе getOrderPositionsReportByDate
              # ... другие поля из таблицы DATA
    ReportResponseBase: # Базовая схема для ответов отчетов
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/ReportResponseDataBase'

    OrderReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP.DATA, если есть

    OrderPositionsReportRequest:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля, если есть

    OrderPositionsReportResponse:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP.DATA, если есть

    OrderPositionsReportRequestV2:
      allOf:
        - $ref: '#/components/schemas/ReportRequestBase'
        # Дополнительные поля для V2, если есть

    OrderPositionsReportResponseV2:
      allOf:
        - $ref: '#/components/schemas/ReportResponseBase'
        # Дополнительные поля в RESP.DATA для V2, если есть

    # --- Схемы для Сервисов Фактур и Возвратов (Invoices) ---
    InvoiceDetailsData: # Структура данных для getInvoice (неизвестна, placeholder)
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
    InvoiceDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/InvoiceDetailsData'

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
          type: number # Или string?
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
          description: Покупатель (из getInvoice, KUNNR_RG)
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
        KUNWE:
          type: string
          maxLength: 10
          description: Грузополучатель (опционально, из структуры клиента KUNNR_WE)
        KUNNR_ZA:
          type: string
          maxLength: 10
          description: Адрес доставки или Пункт выдачи для самовывоза (опционально, из структуры клиента KUNNR_ZA)
        INVDATE:
          type: string
          format: date # YYYYMMDD
          description: Дата возврата (опционально)
          example: '20171005'
        PARNRZP: # Уточняем описание
          type: string
          maxLength: 10
          description: Контактное лицо (опционально, если есть KUNNR_ZA, из структуры клиента PARNR)
        POSITION_INPUT:
          type: array
          description: Таблица позиций для возврата
          items:
            $ref: '#/components/schemas/ReturnInvoicePositionInput'
    CreateReturnInvoiceResponseData: # Структура данных ответа для createReturnInvoice (неизвестна)
      type: object
      properties:
        # ... поля ответа, например, номер созданного документа возврата
    CreateReturnInvoiceResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/CreateReturnInvoiceResponseData'

    # --- Схемы для Сервисов Заказов (Orders) ---
    OrderItemInput: # Для createOrder
      type: object
      required:
        - PIN
        - BRAND
        - KWMENG
        - KEYZAK # Обязателен при создании из поиска
      properties:
        PIN:
          type: string
          description: Артикул (номер детали)
        BRAND:
          type: string
          description: Бренд детали (принятое в Armtek наименование)
        ARTSKU:
          type: string
          description: Артикул поставщика (опционально)
        NAME:
          type: string
          description: Наименование детали (опционально)
        KWMENG:
          type: number # Или string? Указано "число ( 10 )"
          description: Количество
        PRICE:
          type: number # Или string?
          description: Цена (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD ?
          description: Желаемая дата поставки для позиции (опционально)
        NOTE:
          type: string
          description: Примечание к позиции (опционально)
        KEYZAK: # Добавлено поле KEYZAK
          type: string
          description: Код склада Armtek, с которого заказывается позиция (из результатов поиска). Обязательно при создании заказа из поиска.
    CreateOrderRequest:
      type: object
      required:
        - VKORG
        - KUNRG
        - ITEMS
      properties:
        VKORG:
          type: string
          description: Сбытовая организация (Место отгрузки)
        KUNRG:
          type: string
          description: Плательщик (номер клиента, KUNNR_RG)
        KUNWE:
          type: string
          description: Грузополучатель (опционально, KUNNR_WE)
        KONDA:
          type: string
          description: Ценовая группа клиента (опционально)
        BSTKD:
          type: string
          description: Номер заказа клиента (опционально)
        KETDT:
          type: string
          format: date # YYYYMMDD ?
          description: Желаемая дата поставки всего заказа (опционально)
        PIN: # Выглядит странно на уровне заголовка, возможно для быстрого заказа одной позиции?
          type: string
          description: Артикул (опционально, для быстрого заказа одной позиции?)
        BRAND: # Выглядит странно на уровне заголовка
          type: string
          description: Бренд (опционально, для быстрого заказа одной позиции?)
        KWMENG: # Выглядит странно на уровне заголовка
          type: number
          description: Количество (опционально, для быстрого заказа одной позиции?)
        NOTE:
          type: string
          description: Примечание к заказу (опционально)
        DELIVERY_ADDRESS:
          type: string
          description: Адрес доставки текстом (опционально)
        DELIVERY_INTERVAL:
          type: string
          description: Интервал доставки текстом (опционально)
        DELIVERY_METHOD:
          type: string
          description: Способ доставки текстом (опционально)
        CONTACT_PERSON:
          type: string
          description: Контактное лицо текстом (опционально)
        CONTACT_PHONE:
          type: string
          description: Контактный телефон текстом (опционально)
        BACKORDER:
          type: string
          enum: ['X', '']
          description: Разрешить дозаказ ('X' - да, пусто - нет) (опционально)
        SUBSTITUTION:
          type: string
          enum: ['X', '']
          description: Разрешить замену ('X' - да, пусто - нет) (опционально)
        INCOTERMS: # Добавляем поле INCOTERMS
          type: string
          enum: ['1', '0', '']
          description: Признак самовывоза ('1' - самовывоз, '0'/пусто - доставка). При '1' KUNNR_ZA не требуется.
        ITEMS:
          type: array
          items:
            $ref: '#/components/schemas/OrderItemInput'
    CreateOrderResponseData: # Структура данных ответа для createOrder (неизвестна)
      type: object
      properties:
        orderNumber: # Предполагаемое поле
          type: string
          description: Номер созданного заказа
        # ... другие поля ответа
    CreateOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/CreateOrderResponseData'

    OrderStatusDetail: # Новая схема для элемента массива STATUSES (из getOrder2)
      type: object
      properties:
        POSROOT:
          type: string
          maxLength: 10
          description: Номер корневой позиции (для связанных позиций при перезаказе)
        SUPPLIER:
          type: string
          # maxLength: Не указан
          description: Код склада партнера (если статус относится к партнеру)
        DateDelNew:
          type: string
          # format: date-time ? (YYYYMMDDHHMMSS)
          description: Дата/время последнего события по товару в формате ГГГГММДДЧЧММСС
        SubStatus:
          type: string
          maxLength: 10
          enum: [WayQuan, Planned, Waiting, Confirmed, Shipped]
          description: >
            Субстатус:
            * WayQuan - товар в пути между пунктами логистической цепочки
            * Planned - запланировано к закупке у партнера
            * Waiting - ожидание подтверждения от партнера
            * Confirmed - партнер подтвердил отгрузку
            * Shipped - партнер отгрузил товар в адрес АРМТЕК
        Werks:
          type: string
          maxLength: 4
          description: Код склада АРМТЕК (если статус относится к складу АРМТЕК)
        WerksName:
          type: string
          # maxLength: Не указан
          description: Наименование склада АРМТЕК
        LsegETP:
          type: string
          # maxLength: Не указан
          description: Текстовое пояснение состояния товара (например, "На приемке", "Ожидаем прибытия от поставщика")

    OrderItemDetail: # Схема для элемента массива ITEMS в getOrder/getOrder2
      type: object
      properties:
        POSNR:
          type: string
          maxLength: 10
          description: Номер позиции в заказе
        PIN:
          type: string
          description: Артикул
        BRAND:
          type: string
          description: Бренд
        KWMENG: # Текущее количество к поставке
          type: number # Или string?
          description: Количество к поставке (может быть уменьшено при невозможности полной поставки)
        ORDERED: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Изначально заказанное количество (не меняется, хранится в родительской позиции при перезаказе)
        REJECTED: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Общее отклоненное количество (не может быть поставлено)
        PROCESSING: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество в процессе обработки (на складах партнера или АРМТЕК)
        Ready: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к отгрузке на складе отгрузки
        Delivered: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, отгруженное клиенту
        InvoiceNum: # Добавлено поле (из getOrder2)
          type: string
          # maxLength: Не указан
          description: Номер накладной (если отгружено)
        InvoiceDate: # Добавлено поле (из getOrder2)
          type: string
          format: date # YYYYMMDD ?
          description: Дата накладной (если отгружено)
        ClientRefusal: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, от которого клиент отказался при доставке
        ReadyToIssue: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к выдаче (при самовывозе)
        Issued: # Добавлено поле (из getOrder2)
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, выданное клиенту (при самовывозе)
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
        # ... другие существующие поля позиции заказа (NAME, PRICE, etc.) ...

    OrderDetailsData: # Структура данных ответа для getOrder/getOrder2
      type: object
      properties:
        HEADER:
          type: object
          properties:
            ORDER: # Добавлено поле (из getOrder2)
              type: string
              description: Номер заказа
            # ... другие поля заголовка заказа ...
        ITEMS:
          type: array
          items:
            $ref: '#/components/schemas/OrderItemDetail'
        ABGRU_ITEMS: # Таблица для editOrder (структура элементов неизвестна)
           type: array
           items:
             type: object
             properties:
               ABGRU:
                 type: string
                 description: Код причины отклонения
               TEXT:
                 type: string
                 description: Описание причины отклонения
        STATUSES: # Добавляется при STATUS=1 (из getOrder2)
          type: array
          description: Детализированная расшифровка статусов позиций (появляется при STATUS=1)
          items:
            $ref: '#/components/schemas/OrderStatusDetail'
        # ... другие таблицы и поля в ответе getOrder ...
    OrderDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/OrderDetailsData'

    RefundDetailsData: # Структура данных ответа для getRefund (неизвестна, placeholder)
      type: object
      properties:
        # ... поля ответа ...
    RefundDetailsResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/RefundDetailsData'

    EditOrderItemInput: # Для editOrder
      type: object
      required:
        - POSNR
        - KWMENG
        - ABGRU
      properties:
        POSNR:
          type: string
          description: Номер позиции в заказе для редактирования
        KWMENG:
          type: number # Или string?
          description: Новое количество
        ABGRU:
          type: string
          description: Код причины отклонения (из getOrder ABGRU_ITEMS)
        NOTE:
          type: string
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
          description: Сбытовая организация
        KUNRG:
          type: string
          description: Плательщик (номер клиента, KUNNR_RG)
        ORDER:
          type: string
          description: Номер заказа для редактирования
        POSITION_INPUT:
          type: array
          items:
            $ref: '#/components/schemas/EditOrderItemInput'
    EditOrderResponseData: # Структура данных ответа для editOrder (неизвестна)
      type: object
      properties:
        # ... поля ответа, например, статус операции
    EditOrderResponse:
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              $ref: '#/components/schemas/EditOrderResponseData'

paths:
  # --- Пути для Сервисов Пользователя (User) ---
  /ws_user/getUserVkorgList:
    get:
      summary: Получение сбытовых организаций клиента
      description: Возвращает список доступных сбытовых организаций (мест отгрузки, VKORG) для текущего пользователя.
      tags: [User]
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
          description: Список сбытовых организаций
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserVkorgListResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GetUserVkorgListResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_user/getUserInfo:
    post:
      summary: Получение структуры клиента
      description: Возвращает информацию о структуре клиента (Покупатели KUNNR_RG, Грузополучатели KUNNR_WE, Адреса доставки KUNNR_ZA, Пункты выдачи, Договоры VBELN, Контакты PARNR) для указанной Сбытовой организации (VKORG). Также может вернуть данные FTP.
      tags: [User]
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
              $ref: '#/components/schemas/UserInfoRequest'
          application/x-www-form-urlencoded: # Возможен и такой вариант
            schema:
              $ref: '#/components/schemas/UserInfoRequest'
      responses:
        '200':
          description: Структура клиента
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_user/getBrandList:
    get:
      summary: Получение списка брендов
      description: Возвращает список брендов и их наименований, принятых в Armtek. Используется для корректного указания бренда при поиске и заказе.
      tags: [User, Search] # Бренды могут использоваться и при поиске
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
          description: Список брендов (Структура RESP.DATA неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetBrandListResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GetBrandListResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_user/getStoreList:
    get:
      summary: Получение списка складов
      description: Возвращает список складов Armtek (структура ответа RESP.DATA не описана). Может использоваться для фильтрации поиска по коду склада (KEYZAK).
      tags: [User, Search] # Склады могут использоваться при поиске
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
          description: Список складов (Структура RESP.DATA неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetStoreListResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GetStoreListResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # --- Пути для Сервисов Поиска (Search) ---
  /ws_search/assortment_search:
    post:
      summary: Поиск по ассортименту
      description: Выполняет поиск запчастей по ассортименту Armtek с учетом Сбытовой организации (VKORG), Покупателя (KUNNR_RG) и других параметров.
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
          application/x-www-form-urlencoded: # Возможен и такой вариант
            schema:
              $ref: '#/components/schemas/AssortmentSearchRequest'
      responses:
        '200':
          description: Результаты поиска по ассортименту (Структура RESP.DATA описана в SearchResponseItem)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/AssortmentSearchResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '429':
          description: Превышен лимит запросов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse'
        '500': # Пример добавления других кодов ошибок
          description: Внутренняя ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '503': # Пример добавления других кодов ошибок
          description: Сервис недоступен
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Неизвестная ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_search/search:
    post:
      summary: Поиск (общий)
      description: Выполняет общий поиск запчастей, включая склады партнеров, с учетом Сбытовой организации (VKORG), Покупателя (KUNNR_RG) и других параметров.
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
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/GeneralSearchRequest'
      responses:
        '200':
          description: Результаты поиска (Структура RESP.DATA описана в SearchResponseItem)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GeneralSearchResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GeneralSearchResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '429':
          description: Превышен лимит запросов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/RateLimitErrorResponse'
        '500':
          description: Внутренняя ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '503':
          description: Сервис недоступен
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Неизвестная ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # --- Пути для Сервисов Пинга (System) ---
  /ws_ping/index:
    get:
      summary: Пинг Системы
      description: Проверяет доступность системы и возвращает IP адрес клиента и время выполнения. Не требует авторизации.
      tags: [System]
      security: [] # Отключаем Basic Auth для этого эндпоинта
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
          description: Ошибка сервера (маловероятно для пинга, но возможно)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse' # Используем общую схему ошибки
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # --- Пути для Сервисов Отчетности (Reporting) ---
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
          application/x-www-form-urlencoded: # Возможен и такой вариант
            schema:
              $ref: '#/components/schemas/OrderReportRequest'
      responses:
        '200':
          description: Данные отчета по заказам (Структура RESP.DATA неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderReportResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/OrderReportResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

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
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/OrderPositionsReportRequest'
      responses:
        '200':
          description: Данные отчета по позициям заказов (Структура RESP.DATA неизвестна, но включает поля из OrderItemDetail)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_reports/getOrderPositionsReportByDate2:
    post:
      summary: Отчет по заказам в разрезе позиций за интервал времени (ver. 2)
      description: Получает отчет по позициям заказов за указанный интервал времени (версия 2). Параметры запроса аналогичны первой версии. Структура ответа может отличаться.
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
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/OrderPositionsReportRequestV2'
      responses:
        '200':
          description: Данные отчета по позициям заказов (версия 2) (Структура RESP.DATA неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponseV2'
            application/xml:
              schema:
                $ref: '#/components/schemas/OrderPositionsReportResponseV2'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # --- Пути для Сервисов Фактур и Возвратов (Invoices) ---
  /ws_invoice/getInvoice:
    get:
      summary: Подробная информация по номеру фактуры
      description: Получает детальную информацию по фактуре (HEADER, AUGRU_OUTPUT, CASH_BACK и др.), необходимую в том числе для создания возврата.
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
          description: Номер покупателя (KUNNR_RG)
        - name: INVOICE # Используем INVOICE как в примере URL
          in: query
          required: true
          schema:
            type: string
          description: Номер Фактуры (VBELNF)
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
          description: Детальная информация по фактуре (Структура RESP описана в InvoiceDetailsData)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InvoiceDetailsResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/InvoiceDetailsResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Фактура не найдена
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_invoice/createReturnInvoice:
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
          application/x-www-form-urlencoded: # Возможен и такой вариант, если API принимает данные формы
            schema:
              $ref: '#/components/schemas/CreateReturnInvoiceRequest'
      responses:
        '201': # Обычно 201 Created для POST
          description: Возврат успешно создан (Структура RESP неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateReturnInvoiceResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/CreateReturnInvoiceResponse'
        '400':
          description: Ошибка валидации входных данных (например, неверные параметры, невозможность возврата)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # --- Пути для Сервисов Заказов (Orders) ---
  /ws_order/createOrder:
    post:
      summary: Создание заказа
      description: Создает новый заказ клиента с указанными позициями. Требует указания Сбытовой организации (VKORG), Плательщика (KUNNR_RG) и кода склада (KEYZAK) для каждой позиции, если заказ создается из результатов поиска.
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
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Заказ успешно создан (Структура RESP неизвестна, предположительно содержит номер заказа)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/createTestOrder:
    post:
      summary: Создание тестового заказа
      description: Создает тестовый заказ клиента. Параметры и структура идентичны createOrder, но заказ не будет обработан как реальный.
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
              $ref: '#/components/schemas/CreateOrderRequest' # Используем ту же схему запроса
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Тестовый заказ успешно создан (Структура RESP неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse' # Используем ту же схему ответа
            application/xml:
              schema:
                $ref: '#/components/schemas/CreateOrderResponse'
        '400':
          description: Ошибка валидации входных данных
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/getOrder:
    get:
      summary: Подробная информация по номеру заказа
      description: Получает детальную информацию по указанному номеру заказа (HEADER, ITEMS, ABGRU_ITEMS). Может включать расшифровку статусов (STATUSES) при STATUS=1.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema: { type: string }
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema: { type: string }
          description: Номер покупателя (плательщик, KUNNR_RG)
        - name: ORDER
          in: query
          required: true
          schema: { type: string }
          description: Номер заказа
        - name: STATUS # Уточняем описание
          in: query
          required: false
          schema:
            type: string
            enum: ['0', '1', '']
          description: >
            Флаг для добавления расшифровки статусов позиций.
            1 - добавить структуру STATUSES с детальной расшифровкой.
            0 или пусто - без расшифровки.
        - name: EDIT
          in: query
          required: false
          schema: { type: string, enum: ['1', ''] }
          description: Флаг "Для изменения" (1 - да, влияние на ответ неясно, возможно добавляет ABGRU_ITEMS).
        - name: format
          in: query
          required: false
          schema: { type: string, enum: [json, xml], default: json }
          description: Формат ответа
      responses:
        '200':
          description: Детальная информация по заказу (Структура RESP описана в OrderDetailsData)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/getOrder2:
    get:
      summary: Подробная информация по номеру заказа (ver. 2)
      description: >
        Получает детальную информацию по указанному номеру заказа (версия 2).
        Отличается от getOrder в основном структурой ответа при использовании параметра STATUS=1,
        который добавляет детализированную расшифровку статусов в структуру STATUSES и доп. поля в ITEMS.
      tags: [Orders]
      parameters:
        - name: VKORG
          in: query
          required: true
          schema: { type: string }
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema: { type: string }
          description: Номер покупателя (плательщик, KUNNR_RG)
        - name: ORDER
          in: query
          required: true
          schema: { type: string }
          description: Номер заказа
        - name: STATUS # Добавляем параметр STATUS
          in: query
          required: false
          schema:
            type: string
            enum: ['0', '1', '']
          description: >
            Флаг для добавления расшифровки статусов позиций.
            1 - добавить структуру STATUSES с детальной расшифровкой.
            0 или пусто - без расшифровки.
        # EDIT не упомянут для getOrder2
        - name: format
          in: query
          required: false
          schema: { type: string, enum: [json, xml], default: json }
          description: Формат ответа
      responses:
        '200':
          description: Детальная информация по заказу (версия 2) (Структура RESP описана в OrderDetailsData)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Используем ту же обновленную схему ответа
            application/xml:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/getRefund:
    get:
      summary: Подробная информация по номеру возврата
      description: Получает детальную информацию по указанному номеру возврата.
      tags: [Orders, Invoices] # Возвраты связаны и с заказами, и с фактурами
      parameters:
        - name: VKORG
          in: query
          required: true
          schema: { type: string }
          description: Сбытовая организация
        - name: KUNRG
          in: query
          required: true
          schema: { type: string }
          description: Номер покупателя (плательщик, KUNNR_RG)
        - name: RETURN # Уточнено из URL примера
          in: query
          required: true
          schema: { type: string }
          description: Номер возврата
        - name: format
          in: query
          required: false
          schema: { type: string, enum: [json, xml], default: json }
          description: Формат ответа
      responses:
        '200':
          description: Детальная информация по возврату (Структура RESP неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RefundDetailsResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/RefundDetailsResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Возврат не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/editOrder:
    post:
      summary: Редактирование заказа
      description: Позволяет редактировать количество (KWMENG) и причину отклонения (ABGRU) для позиций существующего заказа. Требует получения кодов причин отклонения через getOrder (ABGRU_ITEMS).
      tags: [Orders]
      parameters:
        - name: format
          in: query
          required: false
          schema: { type: string, enum: [json, xml], default: json }
          description: Формат ответа
      requestBody:
        required: true
        content:
          application/json: # Предполагаем JSON
            schema:
              $ref: '#/components/schemas/EditOrderRequest'
          application/x-www-form-urlencoded:
            schema:
              $ref: '#/components/schemas/EditOrderRequest'
      responses:
        '200': # Или 204 No Content, если ответ пустой? Документация не уточняет.
          description: Заказ успешно отредактирован (Структура RESP неизвестна)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EditOrderResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/EditOrderResponse'
        '400':
          description: Ошибка валидации входных данных или невозможность редактирования
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка сервера
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
            application/xml:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

</pre>