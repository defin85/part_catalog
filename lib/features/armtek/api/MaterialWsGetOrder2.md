# ...existing code...
components:
  # ... existing securitySchemes ...
  schemas:
    # ... existing BaseResponse, ResponseMessage ...
    GenericErrorResponse:
      # ... existing GenericErrorResponse schema ...
    RateLimitErrorResponse:
      # ... existing RateLimitErrorResponse schema ...

    # --- Схемы для Заказов (Обновления) ---
    OrderStatusDetail: # Новая схема для элемента массива STATUSES
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

    OrderItemDetail: # Схема для элемента массива ITEMS (возможно, используется и в getOrder)
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
        ORDERED: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Изначально заказанное количество (не меняется, хранится в родительской позиции при перезаказе)
        REJECTED: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Общее отклоненное количество (не может быть поставлено)
        PROCESSING: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество в процессе обработки (на складах партнера или АРМТЕК)
        Ready: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к отгрузке на складе отгрузки
        Delivered: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, отгруженное клиенту
        InvoiceNum: # Добавлено поле
          type: string
          # maxLength: Не указан
          description: Номер накладной (если отгружено)
        InvoiceDate: # Добавлено поле
          type: string
          format: date # YYYYMMDD ?
          description: Дата накладной (если отгружено)
        ClientRefusal: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, от которого клиент отказался при доставке
        ReadyToIssue: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к выдаче (при самовывозе)
        Issued: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, выданное клиенту (при самовывозе)
        # ... другие существующие поля позиции заказа ...

    OrderDetailsResponse: # Обновляем схему ответа для getOrder/getOrder2
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  type: object
                  properties:
                    ORDER: # Добавлено поле из описания
                      type: string
                      maxLength: 10
                      description: Номер заказа
                    # ... другие поля заголовка заказа
                ITEMS:
                  type: array
                  items:
                    $ref: '#/components/schemas/OrderItemDetail' # Используем детализированную схему
                ABGRU_ITEMS: # Таблица для editOrder
                   type: array
                   items:
                     type: object
                     properties:
                       ABGRU:
                         type: string
                         description: Код причины отклонения
                       # ... другие поля
                STATUSES: # Новая структура, добавляемая при STATUS=1
                  type: array
                  description: Расшифровка статусов позиций (доступно при STATUS=1)
                  items:
                    type: array # Вложенный массив? Или объект? Документация неясна ("новая сложная структура (вложенные массивы): STATUSES"). Предполагаем массив объектов.
                    items:
                      $ref: '#/components/schemas/OrderStatusDetail'
                # ... другие таблицы и поля в ответе getOrder

    # ... остальные схемы ...

paths:
  # ... existing paths ...

  /ws_order/getOrder:
    get:
      summary: Подробная информация по номеру заказа
      description: Получает детальную информацию по указанному номеру заказа. Может включать расшифровку статусов при STATUS=1.
      tags: [Orders]
      parameters:
        - name: VKORG
          # ...
        - name: KUNRG
          # ...
        - name: ORDER
          # ...
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
          # ...
        - name: format
          # ...
      responses:
        '200':
          description: Детальная информация по заказу
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Используем обновленную схему
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/getOrder2:
    get:
      summary: Подробная информация по номеру заказа (ver. 2)
      description: >
        Получает детальную информацию по указанному номеру заказа (версия 2).
        Отличается от getOrder в основном структурой ответа при использовании параметра STATUS=1,
        который добавляет детализированную расшифровку статусов в структуру STATUSES.
      tags: [Orders]
      parameters:
        - name: VKORG
          # ...
        - name: KUNRG
          # ...
        - name: ORDER
          # ...
        - name: STATUS # Добавляем параметр STATUS, так как он ключевой для getOrder2
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
          # ...
      responses:
        '200':
          description: Детальная информация по заказу (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Используем ту же обновленную схему ответа
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # ... остальные пути ...
```

**Основные изменения:**

1.  **Добавлена схема `OrderStatusDetail`:** Описывает поля, входящие в расшифровку статуса (`POSROOT`, `SUPPLIER`, `DateDelNew`, `SubStatus`, `Werks`, `WerksName`, `LsegETP`).
2.  **Создана/Обновлена схема `OrderItemDetail`:** Включены новые поля, описывающие количество на разных стадиях (`ORDERED`, `REJECTED`, `PROCESSING`, `Ready`, `Delivered`, `ClientRefusal`, `ReadyToIssue`, `Issued`), а также поля накладной (`InvoiceNum`, `InvoiceDate`). Эта схема используется в `OrderDetailsResponse`.
3.  **Обновлена схема `OrderDetailsResponse`:**
    *   В `RESP.HEADER` добавлено поле `ORDER`.
    *   В `RESP.ITEMS` теперь используется ссылка на `OrderItemDetail`.
    *   Добавлено опциональное поле `RESP.STATUSES` (массив массивов или массив объектов `OrderStatusDetail` - выбрал массив объектов для большей структурированности), которое появляется при `STATUS=1`.
4.  **Обновлен путь `/ws_order/getOrder`:** Уточнено описание параметра `STATUS`. Ссылка на ответ теперь указывает на обновленную `OrderDetailsResponse`. Добавлены ответы 401/404 со ссылкой на `GenericErrorResponse`.
5.  **Обновлен путь `/ws_order/getOrder2`:**
    *   Добавлено более подробное описание, подчеркивающее роль `STATUS=1` и структуры `STATUSES`.
    *   Добавлен параметр `STATUS`, так как он является ключевым отличием/особенностью этого эндпоинта согласно документации.
    *   Ссылка на ответ указывает на ту же обновленную `OrderDetailsResponse`.
    *   Добавлены ответы 401/404 со ссылкой на `GenericErrorResponse`.

**Неясности:**

*   Точная структура `STATUSES` (массив объектов или массив массивов). Выбрана структура массива объектов.
*   Типы данных для полей количества (`ORDERED`, `REJECTED` и т.д.) - указаны как "строка (20)", но логичнее было бы число. Оставлены как `string` согласно документации, но это может потребовать уточнения.
*   Присутствуют ли новые поля (`ORDERED`, `REJECTED` и т.д.) в ответе `getOrder` или только в `getOrder2` (или только при `STATUS=1`). Пока добавлены в общую схему `OrderItemDetail`, используемую обеими версиями.# filepath: c:\FlutterProject\part_catalog\lib\features\armtek\api\ArmtekRestApi.md
# ...existing code...
components:
  # ... existing securitySchemes ...
  schemas:
    # ... existing BaseResponse, ResponseMessage ...
    GenericErrorResponse:
      # ... existing GenericErrorResponse schema ...
    RateLimitErrorResponse:
      # ... existing RateLimitErrorResponse schema ...

    # --- Схемы для Заказов (Обновления) ---
    OrderStatusDetail: # Новая схема для элемента массива STATUSES
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

    OrderItemDetail: # Схема для элемента массива ITEMS (возможно, используется и в getOrder)
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
        ORDERED: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Изначально заказанное количество (не меняется, хранится в родительской позиции при перезаказе)
        REJECTED: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Общее отклоненное количество (не может быть поставлено)
        PROCESSING: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество в процессе обработки (на складах партнера или АРМТЕК)
        Ready: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к отгрузке на складе отгрузки
        Delivered: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, отгруженное клиенту
        InvoiceNum: # Добавлено поле
          type: string
          # maxLength: Не указан
          description: Номер накладной (если отгружено)
        InvoiceDate: # Добавлено поле
          type: string
          format: date # YYYYMMDD ?
          description: Дата накладной (если отгружено)
        ClientRefusal: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, от которого клиент отказался при доставке
        ReadyToIssue: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, готовое к выдаче (при самовывозе)
        Issued: # Добавлено поле
          type: string # Или number? Указано "строка ( 20 )"
          description: Количество, выданное клиенту (при самовывозе)
        # ... другие существующие поля позиции заказа ...

    OrderDetailsResponse: # Обновляем схему ответа для getOrder/getOrder2
      allOf:
        - $ref: '#/components/schemas/BaseResponse'
        - type: object
          properties:
            RESP: # Переопределяем RESP
              type: object
              properties:
                HEADER:
                  type: object
                  properties:
                    ORDER: # Добавлено поле из описания
                      type: string
                      maxLength: 10
                      description: Номер заказа
                    # ... другие поля заголовка заказа
                ITEMS:
                  type: array
                  items:
                    $ref: '#/components/schemas/OrderItemDetail' # Используем детализированную схему
                ABGRU_ITEMS: # Таблица для editOrder
                   type: array
                   items:
                     type: object
                     properties:
                       ABGRU:
                         type: string
                         description: Код причины отклонения
                       # ... другие поля
                STATUSES: # Новая структура, добавляемая при STATUS=1
                  type: array
                  description: Расшифровка статусов позиций (доступно при STATUS=1)
                  items:
                    type: array # Вложенный массив? Или объект? Документация неясна ("новая сложная структура (вложенные массивы): STATUSES"). Предполагаем массив объектов.
                    items:
                      $ref: '#/components/schemas/OrderStatusDetail'
                # ... другие таблицы и поля в ответе getOrder

    # ... остальные схемы ...

paths:
  # ... existing paths ...

  /ws_order/getOrder:
    get:
      summary: Подробная информация по номеру заказа
      description: Получает детальную информацию по указанному номеру заказа. Может включать расшифровку статусов при STATUS=1.
      tags: [Orders]
      parameters:
        - name: VKORG
          # ...
        - name: KUNRG
          # ...
        - name: ORDER
          # ...
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
          # ...
        - name: format
          # ...
      responses:
        '200':
          description: Детальная информация по заказу
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Используем обновленную схему
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  /ws_order/getOrder2:
    get:
      summary: Подробная информация по номеру заказа (ver. 2)
      description: >
        Получает детальную информацию по указанному номеру заказа (версия 2).
        Отличается от getOrder в основном структурой ответа при использовании параметра STATUS=1,
        который добавляет детализированную расшифровку статусов в структуру STATUSES.
      tags: [Orders]
      parameters:
        - name: VKORG
          # ...
        - name: KUNRG
          # ...
        - name: ORDER
          # ...
        - name: STATUS # Добавляем параметр STATUS, так как он ключевой для getOrder2
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
          # ...
      responses:
        '200':
          description: Детальная информация по заказу (версия 2)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderDetailsResponse' # Используем ту же обновленную схему ответа
        '401':
          description: Ошибка авторизации
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        '404':
          description: Заказ не найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'
        default:
          description: Ошибка
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GenericErrorResponse'

  # ... остальные пути ...
```

**Основные изменения:**

1.  **Добавлена схема `OrderStatusDetail`:** Описывает поля, входящие в расшифровку статуса (`POSROOT`, `SUPPLIER`, `DateDelNew`, `SubStatus`, `Werks`, `WerksName`, `LsegETP`).
2.  **Создана/Обновлена схема `OrderItemDetail`:** Включены новые поля, описывающие количество на разных стадиях (`ORDERED`, `REJECTED`, `PROCESSING`, `Ready`, `Delivered`, `ClientRefusal`, `ReadyToIssue`, `Issued`), а также поля накладной (`InvoiceNum`, `InvoiceDate`). Эта схема используется в `OrderDetailsResponse`.
3.  **Обновлена схема `OrderDetailsResponse`:**
    *   В `RESP.HEADER` добавлено поле `ORDER`.
    *   В `RESP.ITEMS` теперь используется ссылка на `OrderItemDetail`.
    *   Добавлено опциональное поле `RESP.STATUSES` (массив массивов или массив объектов `OrderStatusDetail` - выбрал массив объектов для большей структурированности), которое появляется при `STATUS=1`.
4.  **Обновлен путь `/ws_order/getOrder`:** Уточнено описание параметра `STATUS`. Ссылка на ответ теперь указывает на обновленную `OrderDetailsResponse`. Добавлены ответы 401/404 со ссылкой на `GenericErrorResponse`.
5.  **Обновлен путь `/ws_order/getOrder2`:**
    *   Добавлено более подробное описание, подчеркивающее роль `STATUS=1` и структуры `STATUSES`.
    *   Добавлен параметр `STATUS`, так как он является ключевым отличием/особенностью этого эндпоинта согласно документации.
    *   Ссылка на ответ указывает на ту же обновленную `OrderDetailsResponse`.
    *   Добавлены ответы 401/404 со ссылкой на `GenericErrorResponse`.

**Неясности:**

*   Точная структура `STATUSES` (массив объектов или массив массивов). Выбрана структура массива объектов.
*   Типы данных для полей количества (`ORDERED`, `REJECTED` и т.д.) - указаны как "строка (20)", но логичнее было бы число. Оставлены как `string` согласно документации, но это может потребовать уточнения.
*   Присутствуют ли новые поля (`ORDERED`, `REJECTED` и т.д.) в ответе `getOrder` или только в `getOrder2` (или только при `STATUS=1`). Пока добавлены в общую схему `OrderItemDetail`, используемую обеими версиями.