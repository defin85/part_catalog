# Armtek API: Сервис Заказов (`/ws_order`) - Метод `getOrder2` (ver. 1.1.7)

**Общие параметры:**

*   **Базовый URL:** `http://ws.armtek.ru` (или другой региональный)
*   **Аутентификация:** Basic Authentication (логин/пароль)
*   **Формат ответа:** Управляется query-параметром `format` (`json` или `xml`, по умолчанию `json`).
*   **Базовая структура ответа:**
    *   `STATUS` (integer): HTTP статус код.
    *   `MESSAGES` (array): Массив сообщений (`TYPE`, `TEXT`, `DATE`).
    *   `RESP` (object/array/null): Тело ответа, специфичное для метода.

---

## Метод `getOrder2`

*   **Назначение:** Получение подробной информации по номеру заказа с возможностью получения расшифровки статусов позиций.
*   **HTTP Метод:** `GET`
*   **Путь:** `/ws_order/getOrder2`
*   **Параметры запроса (Query):**
    *   `VKORG` (string, **обязательный**): Сбытовая организация.
    *   `KUNRG` (string, **обязательный**): Номер покупателя (KUNNR\_RG).
    *   `ORDER` (string, **обязательный**): Номер заказа Armtek.
    *   `STATUS` (integer, *необязательный*): Флаг получения расшифровки статусов (`1` - получать, по умолчанию не передается).
    *   `format` (string, *необязательный*): `json` или `xml`.
*   **Структура успешного ответа (`RESP`, object):**
    *   `HEADER` (object): Заголовок заказа. Поля аналогичны методу `getOrder`.
        *   *... (ORDER, ORDER_DATE, ORDER_TIME, ORDER_TYPE, ORDER_STATUS, KUNRG, KUNRG_TXT, KUNWE, KUNWE_TXT, KUNNR_ZA, ADDRZA, PARNRAP, NAMEAP, BSTKD, KETDT, INCOTERMS, DELIVERY_ADDRESS, DELIVERY_INTERVAL, DELIVERY_METHOD, CONTACT_PERSON, CONTACT_PHONE, BACKORDER, SUBSTITUTION, SUMMA, CURRENCY, ...) ...*
    *   `ITEMS` (array): Массив позиций заказа. Поля аналогичны методу `getOrder`.
        *   *... (POSNR, PIN, BRAND, NAME, KWMENG, KWMENG_CONF, PRICE, SUMMA, NOTE, STATUS, STATUS_DATE, STATUS_TIME, DELIVERY_DATE, DELIVERY_TIME, KEYZAK, ARTSKU, PRICEMAX, DATEMAX, VBELN, POSNR_VL, VBELN_VF, POSNR_VF, ABGRU, ABGRU_TXT, ...) ...*
        *   `KWMENG_ORIG` (number/string): Исходное заказанное количество (может отличаться от `KWMENG` при частичной поставке со складов партнеров).
        *   `REJECTED` (number/string): Общее отклоненное количество, которое не будет поставлено.
        *   `PROCESSING` (number/string): Количество в процессе обработки (на складах партнера и/или Armtek).
        *   `READY` (number/string): Количество, готовое к отгрузке клиенту на складе отгрузки.
        *   `DELIVERED` (number/string): Количество, уже отгруженное клиенту.
        *   `InvoiceNum` (string): Номер фактуры (если отгружено).
        *   `InvoiceDate` (string): Дата фактуры (YYYYMMDD).
        *   `InvoicePos` (string): Номер позиции в фактуре.
        *   `REFUSED` (number/string): Количество, от которого клиент отказался при доставке.
        *   `ReadyToIssue` (number/string): Количество, готовое к выдаче (при самовывозе).
        *   `Issued` (number/string): Количество, выданное клиенту (при самовывозе).
    *   `STATUSES` (array, *только если `STATUS=1`*): Массив объектов с расшифровкой статусов позиций.
        *   `ORDER` (string, max 10): Номер заказа.
        *   `POSNR` (string, max 10): Номер позиции в заказе.
        *   `POSROOT` (string, max 10): Номер корневой позиции (для перезаказанных позиций).
        *   `SUPPLIER` (string, max 10): Код партнера (если позиция со склада партнера).
        *   `SUPPLIER_NAME` (string, max 100): Наименование партнера.
        *   `WERKS` (string, max 4): Код склада Armtek (если статус относится к складу Armtek).
        *   `WERKS_NAME` (string, max 100): Наименование склада Armtek.
        *   `LSEG` (string, max 10): Код сегмента логистики.
        *   `LSEG_ETP` (string, max 100): Описание сегмента логистики (например, "На приемке", "В пути на склад отгрузки", "Ожидаем прибытия от поставщика").
        *   `DATECR` (string, max 14): Дата/время создания записи статуса (ГГГГММДДЧЧММСС).
        *   `DATECH` (string, max 14): Дата/время изменения записи статуса (ГГГГММДДЧЧММСС).
        *   `DATEDEL` (string, max 14): Дата/время ожидаемой поставки (ГГГГММДДЧЧММСС).
        *   `DATEDELNEW` (string, max 14): Дата/время последнего события по товару (ГГГГММДДЧЧММСС).
        *   `SUBSTATUS` (string, max 10): Субстатус позиции:
            *   `WayQuan`: Товар в пути между пунктами логистической цепочки Armtek.
            *   `Planned`: Запланировано к закупке у партнера.
            *   `Waiting`: Ожидание подтверждения от партнера.
            *   `Confirmed`: Партнер подтвердил готовность отгрузить.
            *   `Shipped`: Партнер отгрузил товар в адрес Armtek.
        *   `KWMENG` (number/string): Количество в данном субстатусе.
    *   `ABGRU_ITEMS` (array): Массив объектов с расшифровкой причин отказа (поля `ABGRU`, `TEXT`). Поля аналогичны методу `getOrder`.

---