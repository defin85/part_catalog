openapi: 3.0.0
info:
  title: Armtek REST API (Unofficial Specification)
  version: '1.1.7' # Указанная версия на странице
  description: >
    Неофициальная спецификация OpenAPI для REST API Armtek, основанная на общедоступной информации с ws.armtek.ru.
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
    * **Аутентификация:** Требуется логин и пароль клиента Armtek, специально зарегистрированный для веб-сервисов. **Обязательно смените пароль** после регистрации логина через ЭТП, иначе API вернет ошибку авторизации.
    * **Базовые URL:** Используйте URL, соответствующий вашему региону.
    * **Ограничение запросов:** Существует суточное ограничение на количество поисковых запросов (по умолчанию 1000). Превышение лимита приведет к ошибке.
    * **IP Whitelisting:** Опционально можно ограничить доступ к API по IP-адресам для повышения безопасности (настраивается через менеджера).
    * **Эта спецификация неполная**, так как детальная структура многих запросов и ответов неизвестна.
servers:
  - url: http://ws.armtek.ru # Для России
    description: Production server (Russia)
  - url: http://ws.armtek.by # Для Беларуси
    description: Production server (Belarus)
security:
  - basicAuth: [] # Применяем Basic Auth глобально
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    RateLimitError:
      # ... existing RateLimitError schema ...
    # ... Invoice Schemas ...
    CreateReturnInvoiceRequest:
      # ... existing schema ...
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
        KUNWE: # Добавляем описание
          type: string
          maxLength: 10
          description: Грузополучатель (опционально, из структуры клиента KUNNR_WE)
        KUNNR_ZA: # Добавляем описание
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
          # ... existing items ...
    # ... Order Schemas ...
    OrderItemInput:
      # ... existing schema ...
      properties:
        PIN:
          type: string
          maxLength: 10 # Уточнено из описания PIN
          description: Артикул (номер детали)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд детали (принятое в Armtek наименование)
        # ... остальные поля ...
        KEYZAK: # Добавляем поле KEYZAK, т.к. оно обязательно при создании заказа из поиска
          type: string
          maxLength: 10
          description: Код склада, с которого заказывается позиция (из результатов поиска). Обязательно при создании заказа из поиска.
    CreateOrderRequest:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента, KUNNR_RG)
        KUNWE:
          type: string
          maxLength: 10
          description: Грузополучатель (опционально, KUNNR_WE)
        # ... остальные поля ...
        PIN:
          type: string
          maxLength: 10 # Уточнено из описания PIN
          description: Артикул (опционально, для быстрого заказа одной позиции?)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд (опционально, для быстрого заказа одной позиции?)
        # ... остальные поля ...
        INCOTERMS: # Добавляем поле INCOTERMS
          type: string
          maxLength: 1
          enum: ['1', '0', '']
          description: Признак самовывоза ('1' - самовывоз, '0'/пусто - доставка). При '1' KUNNR_ZA не требуется.
        ITEMS:
          type: array
          description: Таблица позиций заказа
          items:
            $ref: '#/components/schemas/OrderItemInput' # Убеждаемся, что здесь используется схема с KEYZAK
    # ... Ping Schema ...
    PingResponse:
      # ... existing PingResponse schema ...
    # ... Report Schemas ...
    ReportRequestBase:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента, KUNNR_RG)
        # ... остальные поля ...
    # ... Search Schemas ...
    SearchRequestBase:
      # ... existing schema ...
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
        # ... остальные поля ...
        KUNNR_ZA:
          type: string
          maxLength: 10
          description: >
            Адрес доставки или Пункт выдачи для самовывоза (KUNNR_ZA).
            Доступные значения из сервиса структуры клиента (RG_TAB->ZA_TAB-KUNNR или RG_TAB->EWX_TAB-ID).
            Пример: 00000000
        PARNR: # Уточняем описание для поиска
          type: string
          maxLength: 20
          description: Код склада партнера (не путать с контактным лицом).
        KEYZAK:
          type: string
          maxLength: 10
          description: >
            Код склада. Соответствует аналогичному параметру из ответа сервиса поиска.
            Рекомендуется заполнять, иначе поиск только по основному складу.
    SearchResponseItem:
      # ... existing schema ...
      properties:
        # ...
        KEYZAK: # Добавляем описание
          type: string
          description: Код склада, с которого доступна позиция.
        # ...
    # ... User Schemas ...
    VkorgItem:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        PROGRAM_NAME: # Добавляем поле PROGRAM_NAME
          type: string
          maxLength: 100
          description: Наименование сбытовой организации (программы)
    UserInfoRequest:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки). Пример: 4000
        # ... остальные поля ...
    ClientStructure:
      # ... existing schema ...
      properties:
        KUNAG: # Добавляем описание
          type: string
          maxLength: 10
          description: Головной Клиент (определяется по логину)
        VKORG: # Добавляем описание
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        SNAME: # Добавляем описание
          type: string
          maxLength: 100
          description: Краткое наименование Головного Клиента
        # ... другие поля структуры клиента ...
        RG_TAB: # Таблица плательщиков
          type: array
          items:
            type: object
            properties:
              KUNNR: { type: string, maxLength: 10, description: Идентификатор плательщика (KUNNR_RG) }
              SNAME: { type: string, maxLength: 100, description: Краткое наименование Покупателя }
              # ...
              ZA_TAB: # Таблица адресов доставки
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор адреса (KUNNR_ZA) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Адреса доставки }
                    # ...
              WE_TAB: # Добавляем таблицу грузополучателей (WE_TAB)
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор грузополучателя (KUNNR_WE) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Грузополучателя }
                    # ...
              EWX_TAB: # Таблица пунктов выдачи
                type: array
                items:
                  type: object
                  properties:
                    ID: { type: string, maxLength: 10, description: Идентификатор пункта выдачи (может использоваться как KUNNR_ZA) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Пункта выдачи }
                    # ...
              DOGOVOR_TAB: # Таблица договоров
                type: array
                items:
                  type: object
                  properties:
                    VBELN: { type: string, description: Идентификатор договора (VBELN) } # Размер не указан
                    # ... поля договора ...
              CONTACT_TAB: # Таблица контактных лиц
                type: array
                items:
                  type: object
                  properties:
                    PARNR: { type: string, maxLength: 10, description: Идентификатор контактного лица (PARNR) } # Уточнено из текста
                    # ...

paths:
  # ... existing paths ...
  # Обновляем описания параметров, где это необходимо, на основе уточнений
  /ws_user/getUserVkorgList:
    get:
      summary: Получение сбытовых организаций клиента
      description: Возвращает список доступных сбытовых организаций (мест отгрузки) для текущего пользователя.
      # ...
  /ws_user/getUserInfo:
    post:
      summary: Получение структуры клиента
      description: Возвращает информацию о структуре клиента (Покупатели, Грузополучатели, Адреса доставки, Пункты выдачи, Договоры, Контакты) для указанной Сбытовой организации.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserInfoRequest' # Убеждаемся, что VKORG описан как Сбытовая организация
  /ws_user/getBrandList:
    get:
      summary: Получение списка брендов
      description: Возвращает список брендов и их наименований, принятых в Armtek.
      # ...
  /ws_search/assortment_search:
    post:
      summary: Поиск по ассортименту
      description: Выполняет поиск запчастей по ассортименту Armtek с учетом Сбытовой организации, Покупателя и других параметров.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AssortmentSearchRequest' # Убеждаемся, что поля описаны корректно
  /ws_search/search:
    post:
      summary: Поиск (общий)
      description: Выполняет общий поиск запчастей, включая склады партнеров, с учетом Сбытовой организации, Покупателя и других параметров.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/GeneralSearchRequest' # Убеждаемся, что поля описаны корректно
  /ws_order/createOrder:
    post:
      summary: Создание заказа
      description: Создает новый заказ клиента с указанными позициями. Требует указания Сбытовой организации, Плательщика и кода склада (KEYZAK) для каждой позиции, если заказ создается из результатов поиска.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest' # Убеждаемся, что поля описаны корректно

tags:
  # ... existing tags ...
```

**Основные изменения:**

1.  **`info.description`:** Добавлены разделы "Ключевые понятия структуры клиента" и "Ключевые понятия поиска и заказа" с описанием полей `VKORG`, `KUNAG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`, `PARNR`, `VBELN`, `PIN`, `BRAND`, `KEYZAK`, `INCOTERMS`.
2.  **`components.schemas`:**
    *   Добавлены или уточнены описания для полей `VKORG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`, `PARNR`, `VBELN`, `PIN`, `BRAND`, `KEYZAK` в соответствующих схемах запросов и ответов (`CreateReturnInvoiceRequest`, `OrderItemInput`, `CreateOrderRequest`, `ReportRequestBase`, `SearchRequestBase`, `VkorgItem`, `ClientStructure`).
    *   Добавлено поле `INCOTERMS` в `CreateOrderRequest`.
    *   Добавлено поле `KEYZAK` в `OrderItemInput` и уточнено его использование.
    *   Добавлено поле `PROGRAM_NAME` в `VkorgItem`.
    *   Добавлены поля `SNAME` в элементы структуры клиента (`KUNAG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`).
    *   Добавлена таблица `WE_TAB` (Грузополучатели) в `ClientStructure`.
    *   Уточнены идентификаторы в таблицах `DOGOVOR_TAB` (`VBELN`) и `CONTACT_TAB` (`PARNR`) в `ClientStructure`.
3.  **`paths`:** Обновлены описания некоторых эндпоинтов (`getUserVkorgList`, `getUserInfo`, `getBrandList`, `assortment_search`, `search`, `createOrder`) для отражения уточнений в полях и концепциях.# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
openapi: 3.0.0
info:
  title: Armtek REST API (Unofficial Specification)
  version: '1.1.7' # Указанная версия на странице
  description: >
    Неофициальная спецификация OpenAPI для REST API Armtek, основанная на общедоступной информации с ws.armtek.ru.
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
    * **Аутентификация:** Требуется логин и пароль клиента Armtek, специально зарегистрированный для веб-сервисов. **Обязательно смените пароль** после регистрации логина через ЭТП, иначе API вернет ошибку авторизации.
    * **Базовые URL:** Используйте URL, соответствующий вашему региону.
    * **Ограничение запросов:** Существует суточное ограничение на количество поисковых запросов (по умолчанию 1000). Превышение лимита приведет к ошибке.
    * **IP Whitelisting:** Опционально можно ограничить доступ к API по IP-адресам для повышения безопасности (настраивается через менеджера).
    * **Эта спецификация неполная**, так как детальная структура многих запросов и ответов неизвестна.
servers:
  - url: http://ws.armtek.ru # Для России
    description: Production server (Russia)
  - url: http://ws.armtek.by # Для Беларуси
    description: Production server (Belarus)
security:
  - basicAuth: [] # Применяем Basic Auth глобально
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    RateLimitError:
      # ... existing RateLimitError schema ...
    # ... Invoice Schemas ...
    CreateReturnInvoiceRequest:
      # ... existing schema ...
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
        KUNWE: # Добавляем описание
          type: string
          maxLength: 10
          description: Грузополучатель (опционально, из структуры клиента KUNNR_WE)
        KUNNR_ZA: # Добавляем описание
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
          # ... existing items ...
    # ... Order Schemas ...
    OrderItemInput:
      # ... existing schema ...
      properties:
        PIN:
          type: string
          maxLength: 10 # Уточнено из описания PIN
          description: Артикул (номер детали)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд детали (принятое в Armtek наименование)
        # ... остальные поля ...
        KEYZAK: # Добавляем поле KEYZAK, т.к. оно обязательно при создании заказа из поиска
          type: string
          maxLength: 10
          description: Код склада, с которого заказывается позиция (из результатов поиска). Обязательно при создании заказа из поиска.
    CreateOrderRequest:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        KUNRG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента, KUNNR_RG)
        KUNWE:
          type: string
          maxLength: 10
          description: Грузополучатель (опционально, KUNNR_WE)
        # ... остальные поля ...
        PIN:
          type: string
          maxLength: 10 # Уточнено из описания PIN
          description: Артикул (опционально, для быстрого заказа одной позиции?)
        BRAND:
          type: string
          maxLength: 50
          description: Бренд (опционально, для быстрого заказа одной позиции?)
        # ... остальные поля ...
        INCOTERMS: # Добавляем поле INCOTERMS
          type: string
          maxLength: 1
          enum: ['1', '0', '']
          description: Признак самовывоза ('1' - самовывоз, '0'/пусто - доставка). При '1' KUNNR_ZA не требуется.
        ITEMS:
          type: array
          description: Таблица позиций заказа
          items:
            $ref: '#/components/schemas/OrderItemInput' # Убеждаемся, что здесь используется схема с KEYZAK
    # ... Ping Schema ...
    PingResponse:
      # ... existing PingResponse schema ...
    # ... Report Schemas ...
    ReportRequestBase:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        KUNNR_RG:
          type: string
          maxLength: 10
          description: Плательщик (номер клиента, KUNNR_RG)
        # ... остальные поля ...
    # ... Search Schemas ...
    SearchRequestBase:
      # ... existing schema ...
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
        # ... остальные поля ...
        KUNNR_ZA:
          type: string
          maxLength: 10
          description: >
            Адрес доставки или Пункт выдачи для самовывоза (KUNNR_ZA).
            Доступные значения из сервиса структуры клиента (RG_TAB->ZA_TAB-KUNNR или RG_TAB->EWX_TAB-ID).
            Пример: 00000000
        PARNR: # Уточняем описание для поиска
          type: string
          maxLength: 20
          description: Код склада партнера (не путать с контактным лицом).
        KEYZAK:
          type: string
          maxLength: 10
          description: >
            Код склада. Соответствует аналогичному параметру из ответа сервиса поиска.
            Рекомендуется заполнять, иначе поиск только по основному складу.
    SearchResponseItem:
      # ... existing schema ...
      properties:
        # ...
        KEYZAK: # Добавляем описание
          type: string
          description: Код склада, с которого доступна позиция.
        # ...
    # ... User Schemas ...
    VkorgItem:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        PROGRAM_NAME: # Добавляем поле PROGRAM_NAME
          type: string
          maxLength: 100
          description: Наименование сбытовой организации (программы)
    UserInfoRequest:
      # ... existing schema ...
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки). Пример: 4000
        # ... остальные поля ...
    ClientStructure:
      # ... existing schema ...
      properties:
        KUNAG: # Добавляем описание
          type: string
          maxLength: 10
          description: Головной Клиент (определяется по логину)
        VKORG: # Добавляем описание
          type: string
          maxLength: 4
          description: Сбытовая организация (Место отгрузки)
        SNAME: # Добавляем описание
          type: string
          maxLength: 100
          description: Краткое наименование Головного Клиента
        # ... другие поля структуры клиента ...
        RG_TAB: # Таблица плательщиков
          type: array
          items:
            type: object
            properties:
              KUNNR: { type: string, maxLength: 10, description: Идентификатор плательщика (KUNNR_RG) }
              SNAME: { type: string, maxLength: 100, description: Краткое наименование Покупателя }
              # ...
              ZA_TAB: # Таблица адресов доставки
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор адреса (KUNNR_ZA) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Адреса доставки }
                    # ...
              WE_TAB: # Добавляем таблицу грузополучателей (WE_TAB)
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор грузополучателя (KUNNR_WE) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Грузополучателя }
                    # ...
              EWX_TAB: # Таблица пунктов выдачи
                type: array
                items:
                  type: object
                  properties:
                    ID: { type: string, maxLength: 10, description: Идентификатор пункта выдачи (может использоваться как KUNNR_ZA) }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование Пункта выдачи }
                    # ...
              DOGOVOR_TAB: # Таблица договоров
                type: array
                items:
                  type: object
                  properties:
                    VBELN: { type: string, description: Идентификатор договора (VBELN) } # Размер не указан
                    # ... поля договора ...
              CONTACT_TAB: # Таблица контактных лиц
                type: array
                items:
                  type: object
                  properties:
                    PARNR: { type: string, maxLength: 10, description: Идентификатор контактного лица (PARNR) } # Уточнено из текста
                    # ...

paths:
  # ... existing paths ...
  # Обновляем описания параметров, где это необходимо, на основе уточнений
  /ws_user/getUserVkorgList:
    get:
      summary: Получение сбытовых организаций клиента
      description: Возвращает список доступных сбытовых организаций (мест отгрузки) для текущего пользователя.
      # ...
  /ws_user/getUserInfo:
    post:
      summary: Получение структуры клиента
      description: Возвращает информацию о структуре клиента (Покупатели, Грузополучатели, Адреса доставки, Пункты выдачи, Договоры, Контакты) для указанной Сбытовой организации.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserInfoRequest' # Убеждаемся, что VKORG описан как Сбытовая организация
  /ws_user/getBrandList:
    get:
      summary: Получение списка брендов
      description: Возвращает список брендов и их наименований, принятых в Armtek.
      # ...
  /ws_search/assortment_search:
    post:
      summary: Поиск по ассортименту
      description: Выполняет поиск запчастей по ассортименту Armtek с учетом Сбытовой организации, Покупателя и других параметров.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AssortmentSearchRequest' # Убеждаемся, что поля описаны корректно
  /ws_search/search:
    post:
      summary: Поиск (общий)
      description: Выполняет общий поиск запчастей, включая склады партнеров, с учетом Сбытовой организации, Покупателя и других параметров.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/GeneralSearchRequest' # Убеждаемся, что поля описаны корректно
  /ws_order/createOrder:
    post:
      summary: Создание заказа
      description: Создает новый заказ клиента с указанными позициями. Требует указания Сбытовой организации, Плательщика и кода склада (KEYZAK) для каждой позиции, если заказ создается из результатов поиска.
      # ...
      requestBody:
        # ...
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest' # Убеждаемся, что поля описаны корректно

tags:
  # ... existing tags ...
```

**Основные изменения:**

1.  **`info.description`:** Добавлены разделы "Ключевые понятия структуры клиента" и "Ключевые понятия поиска и заказа" с описанием полей `VKORG`, `KUNAG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`, `PARNR`, `VBELN`, `PIN`, `BRAND`, `KEYZAK`, `INCOTERMS`.
2.  **`components.schemas`:**
    *   Добавлены или уточнены описания для полей `VKORG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`, `PARNR`, `VBELN`, `PIN`, `BRAND`, `KEYZAK` в соответствующих схемах запросов и ответов (`CreateReturnInvoiceRequest`, `OrderItemInput`, `CreateOrderRequest`, `ReportRequestBase`, `SearchRequestBase`, `VkorgItem`, `ClientStructure`).
    *   Добавлено поле `INCOTERMS` в `CreateOrderRequest`.
    *   Добавлено поле `KEYZAK` в `OrderItemInput` и уточнено его использование.
    *   Добавлено поле `PROGRAM_NAME` в `VkorgItem`.
    *   Добавлены поля `SNAME` в элементы структуры клиента (`KUNAG`, `KUNNR_RG`, `KUNNR_WE`, `KUNNR_ZA`).
    *   Добавлена таблица `WE_TAB` (Грузополучатели) в `ClientStructure`.
    *   Уточнены идентификаторы в таблицах `DOGOVOR_TAB` (`VBELN`) и `CONTACT_TAB` (`PARNR`) в `ClientStructure`.
3.  **`paths`:** Обновлены описания некоторых эндпоинтов (`getUserVkorgList`, `getUserInfo`, `getBrandList`, `assortment_search`, `search`, `createOrder`) для отражения уточнений в полях и концепциях.