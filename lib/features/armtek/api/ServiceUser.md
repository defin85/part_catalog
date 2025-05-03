# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    # ... other existing schemas ...
    PingResponse:
      # ... existing PingResponse schema ...
    # ... report schemas ...
    # ... search schemas ...

    # --- Схемы для Настроек Пользователя ---
    VkorgItem: # Элемент ответа getUserVkorgList
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        PROGRAM_NAME:
          type: string
          maxLength: 100
          description: Наименование программы
      required:
        - VKORG
        - PROGRAM_NAME
    GetUserVkorgListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/VkorgItem'
      # required: # Неизвестно

    UserInfoRequest: # Запрос для getUserInfo
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация. Пример: 4000
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

    ClientStructure: # Часть ответа getUserInfo
      type: object
      properties:
        KUNAG:
          type: string
          maxLength: 10
          description: Клиент
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        SNAME:
          type: string
          maxLength: 100
          description: Краткое наименование
        # ... другие поля структуры клиента ...
        RG_TAB: # Таблица плательщиков
          type: array
          items:
            type: object
            properties:
              KUNNR: { type: string, maxLength: 10, description: Идентификатор плательщика }
              DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
              SNAME: { type: string, maxLength: 100, description: Краткое наименование }
              # ... другие поля плательщика ...
              ZA_TAB: # Таблица адресов доставки
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор адреса }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование }
                    # ... другие поля адреса ...
              EWX_TAB: # Таблица пунктов выдачи
                type: array
                items:
                  type: object
                  properties:
                    ID: { type: string, maxLength: 10, description: Идентификатор пункта выдачи }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование }
                    # ... другие поля пункта выдачи ...
              DOGOVOR_TAB: # Таблица договоров
                type: array
                items:
                  type: object
                  properties:
                    # ... поля договора ...
              CONTACT_TAB: # Таблица контактных лиц
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор контактного лица }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    FNAME: { type: string, maxLength: 100, description: Полное наименование }
                    LNAME: { type: string, maxLength: 100, description: Фамилия }
                    MNAME: { type: string, maxLength: 100, description: Отчество }
                    PHONE: { type: string, description: Телефон } # Размер не указан
                    # ... другие поля контактного лица ...
    FtpData: # Часть ответа getUserInfo
      type: object
      properties:
        # ... поля данных FTP ...
    GetUserInfoResponse:
      type: object
      properties:
        STRUCTURE:
          $ref: '#/components/schemas/ClientStructure'
        FTPDATA:
          $ref: '#/components/schemas/FtpData'
      # required: # Неизвестно

    BrandItem: # Элемент ответа getBrandList
      type: object
      properties:
        # ... поля бренда (не описаны) ...
    GetBrandListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/BrandItem'
      # required: # Неизвестно

    StoreItem: # Элемент ответа getStoreList
      type: object
      properties:
        # ... поля склада (не описаны) ...
    GetStoreListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/StoreItem'
      # required: # Неизвестно

paths:
  # ... existing invoice paths ...
  # ... existing order paths ...
  /ws_ping/index:
    # ... existing ping path ...
  # ... existing report paths ...
  # ... existing search paths ...

  # --- Пути для Настроек Пользователя ---
  /ws_user/getUserVkorgList:
    get:
      summary: Получение сбытовых организаций клиента
      description: Возвращает список доступных сбытовых организаций для текущего пользователя.
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
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_user/getUserInfo:
    post:
      summary: Получение структуры клиента
      description: Возвращает информацию о структуре клиента, включая адреса, контакты, договоры и данные FTP.
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
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/UserInfoRequest'
      responses:
        '200':
          description: Структура клиента
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse'
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

  /ws_user/getBrandList:
    get:
      summary: Получение списка брендов
      description: Возвращает список брендов (структура ответа не описана).
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
          description: Список брендов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetBrandListResponse' # Структура DATA неизвестна
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_user/getStoreList:
    get:
      summary: Получение списка складов
      description: Возвращает список складов (структура ответа не описана).
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
          description: Список складов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetStoreListResponse' # Структура DATA неизвестна
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

tags:
  # ... existing tags ...
  - name: User
    description: Сервисы, связанные с настройками и информацией пользователя
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_user/getUserVkorgList` (GET), `/ws_user/getUserInfo` (POST), `/ws_user/getBrandList` (GET), `/ws_user/getStoreList` (GET).
2.  **Добавлены схемы запросов:** `UserInfoRequest`.
3.  **Добавлены схемы ответов:** `GetUserVkorgListResponse`, `GetUserInfoResponse` (с вложенными `ClientStructure`, `FtpData` и другими), `GetBrandListResponse`, `GetStoreListResponse`. **Структуры ответов для `getBrandList` и `getStoreList`, а также детальная структура `ClientStructure` и `FtpData` не описаны в документации и являются предположениями.**
4.  **Описаны параметры запроса:** Для каждого пути указаны query-параметры или `requestBody`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` (для POST) и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `User`. Добавлен тег `Search` для `getBrandList` и `getStoreList`, так как они могут быть релевантны для поиска.

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   **Структура ответа** для `getBrandList` и `getStoreList`.
*   **Полная структура** ответа `getUserInfo` (поля в `ClientStructure`, `FtpData` и вложенных таблицах).
*   Формат передачи данных для POST-запросов (JSON или form-urlencoded).# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
# ...existing code...
components:
  securitySchemes:
    basicAuth:
      # ... existing basicAuth schema ...
  schemas:
    GenericError:
      # ... existing GenericError schema ...
    # ... other existing schemas ...
    PingResponse:
      # ... existing PingResponse schema ...
    # ... report schemas ...
    # ... search schemas ...

    # --- Схемы для Настроек Пользователя ---
    VkorgItem: # Элемент ответа getUserVkorgList
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        PROGRAM_NAME:
          type: string
          maxLength: 100
          description: Наименование программы
      required:
        - VKORG
        - PROGRAM_NAME
    GetUserVkorgListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/VkorgItem'
      # required: # Неизвестно

    UserInfoRequest: # Запрос для getUserInfo
      type: object
      properties:
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация. Пример: 4000
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

    ClientStructure: # Часть ответа getUserInfo
      type: object
      properties:
        KUNAG:
          type: string
          maxLength: 10
          description: Клиент
        VKORG:
          type: string
          maxLength: 4
          description: Сбытовая организация
        SNAME:
          type: string
          maxLength: 100
          description: Краткое наименование
        # ... другие поля структуры клиента ...
        RG_TAB: # Таблица плательщиков
          type: array
          items:
            type: object
            properties:
              KUNNR: { type: string, maxLength: 10, description: Идентификатор плательщика }
              DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
              SNAME: { type: string, maxLength: 100, description: Краткое наименование }
              # ... другие поля плательщика ...
              ZA_TAB: # Таблица адресов доставки
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор адреса }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование }
                    # ... другие поля адреса ...
              EWX_TAB: # Таблица пунктов выдачи
                type: array
                items:
                  type: object
                  properties:
                    ID: { type: string, maxLength: 10, description: Идентификатор пункта выдачи }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    SNAME: { type: string, maxLength: 100, description: Краткое наименование }
                    # ... другие поля пункта выдачи ...
              DOGOVOR_TAB: # Таблица договоров
                type: array
                items:
                  type: object
                  properties:
                    # ... поля договора ...
              CONTACT_TAB: # Таблица контактных лиц
                type: array
                items:
                  type: object
                  properties:
                    KUNNR: { type: string, maxLength: 10, description: Идентификатор контактного лица }
                    DEFAULT: { type: string, maxLength: 1, description: Признак установки по умолчанию }
                    FNAME: { type: string, maxLength: 100, description: Полное наименование }
                    LNAME: { type: string, maxLength: 100, description: Фамилия }
                    MNAME: { type: string, maxLength: 100, description: Отчество }
                    PHONE: { type: string, description: Телефон } # Размер не указан
                    # ... другие поля контактного лица ...
    FtpData: # Часть ответа getUserInfo
      type: object
      properties:
        # ... поля данных FTP ...
    GetUserInfoResponse:
      type: object
      properties:
        STRUCTURE:
          $ref: '#/components/schemas/ClientStructure'
        FTPDATA:
          $ref: '#/components/schemas/FtpData'
      # required: # Неизвестно

    BrandItem: # Элемент ответа getBrandList
      type: object
      properties:
        # ... поля бренда (не описаны) ...
    GetBrandListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/BrandItem'
      # required: # Неизвестно

    StoreItem: # Элемент ответа getStoreList
      type: object
      properties:
        # ... поля склада (не описаны) ...
    GetStoreListResponse:
      type: object
      properties:
        DATA:
          type: array
          items:
            $ref: '#/components/schemas/StoreItem'
      # required: # Неизвестно

paths:
  # ... existing invoice paths ...
  # ... existing order paths ...
  /ws_ping/index:
    # ... existing ping path ...
  # ... existing report paths ...
  # ... existing search paths ...

  # --- Пути для Настроек Пользователя ---
  /ws_user/getUserVkorgList:
    get:
      summary: Получение сбытовых организаций клиента
      description: Возвращает список доступных сбытовых организаций для текущего пользователя.
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
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_user/getUserInfo:
    post:
      summary: Получение структуры клиента
      description: Возвращает информацию о структуре клиента, включая адреса, контакты, договоры и данные FTP.
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
          # application/x-www-form-urlencoded: # Возможен и такой вариант
          #   schema:
          #     $ref: '#/components/schemas/UserInfoRequest'
      responses:
        '200':
          description: Структура клиента
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetUserInfoResponse'
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

  /ws_user/getBrandList:
    get:
      summary: Получение списка брендов
      description: Возвращает список брендов (структура ответа не описана).
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
          description: Список брендов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetBrandListResponse' # Структура DATA неизвестна
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

  /ws_user/getStoreList:
    get:
      summary: Получение списка складов
      description: Возвращает список складов (структура ответа не описана).
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
          description: Список складов
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetStoreListResponse' # Структура DATA неизвестна
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericError'

tags:
  # ... existing tags ...
  - name: User
    description: Сервисы, связанные с настройками и информацией пользователя
```

**Основные изменения:**

1.  **Добавлены пути:** `/ws_user/getUserVkorgList` (GET), `/ws_user/getUserInfo` (POST), `/ws_user/getBrandList` (GET), `/ws_user/getStoreList` (GET).
2.  **Добавлены схемы запросов:** `UserInfoRequest`.
3.  **Добавлены схемы ответов:** `GetUserVkorgListResponse`, `GetUserInfoResponse` (с вложенными `ClientStructure`, `FtpData` и другими), `GetBrandListResponse`, `GetStoreListResponse`. **Структуры ответов для `getBrandList` и `getStoreList`, а также детальная структура `ClientStructure` и `FtpData` не описаны в документации и являются предположениями.**
4.  **Описаны параметры запроса:** Для каждого пути указаны query-параметры или `requestBody`.
5.  **Описаны ответы:** Добавлены ответы `200`, `400` (для POST) и `default` со ссылками на соответствующие схемы.
6.  **Обновлены теги:** Убедились, что используется тег `User`. Добавлен тег `Search` для `getBrandList` и `getStoreList`, так как они могут быть релевантны для поиска.

**Необходимые уточнения (если возможно):**

*   Точный базовый URL API.
*   **Структура ответа** для `getBrandList` и `getStoreList`.
*   **Полная структура** ответа `getUserInfo` (поля в `ClientStructure`, `FtpData` и вложенных таблицах).
*   Формат передачи данных для POST-запросов (JSON или form-urlencoded).