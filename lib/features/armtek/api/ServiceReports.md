# Armtek API: Сервис Отчетов (`/ws_reports`) - Формализованная информация

**Общие параметры:**

*   **Базовый URL:** `http://ws.armtek.ru` (или другой региональный)
*   **Аутентификация:** Basic Authentication (логин/пароль)
*   **Формат ответа:** Управляется query-параметром `format` (`json` или `xml`, по умолчанию `json`).
*   **Базовая структура ответа:**
    *   `STATUS` (integer): HTTP статус код.
    *   `MESSAGES` (array): Массив сообщений (`TYPE`, `TEXT`, `DATE`).
    *   `RESP` (object/array/null): Тело ответа, специфичное для метода.

---

## 1. Метод `getOrderReportByDate`

*   **Назначение:** Получение отчета по заказам (заголовкам) за интервал времени.
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_reports/getOrderReportByDate`
*   **Параметры запроса (Body - JSON или form-urlencoded):**
    *   `VKORG` (string, **обязательный**): Сбытовая организация.
    *   `KUNRG` (string, **обязательный**): Номер покупателя (KUNNR\_RG).
    *   `SDLDATE` (string, **обязательный**): Дата начала периода (формат `YYYYMMDD`).
    *   `EDLDATE` (string, **обязательный**): Дата окончания периода (формат `YYYYMMDD`).
    *   `TYPEZK_SALE` (string, *необязательный*, '0' или '1'): Включить заказы продаж (по умолчанию `1` - да).
    *   `TYPEZK_RETN` (string, *необязательный*, '0' или '1'): Включить возвраты и количественные разницы (по умолчанию `1` - да).
    *   `KURR_LOGIN` (string, *необязательный*, '0' или '1'): Фильтровать заказы по текущему логину (по умолчанию `0` - нет).
*   **Структура успешного ответа (`RESP`, object):**
    *   `DATA` (array): Массив объектов с данными по заголовкам заказов. Поля аналогичны `HEADER` из ответа `getOrder` сервиса `/ws_order`:
        *   `ORDER` (string): Номер заказа Armtek.
        *   `ORDER_TYPE` (string): Тип заказа.
        *   `ORDER_DATE` (string): Дата создания заказа (YYYYMMDD).
        *   `ORDER_TIME` (string): Время создания заказа (HHMMSS).
        *   `ORDER_STATUS` (string): Статус заказа.
        *   `KUNRG` (string): Номер покупателя.
        *   `KUNRG_TXT` (string): Наименование покупателя.
        *   `KUNWE` (string): Номер грузополучателя.
        *   `KUNWE_TXT` (string): Наименование грузополучателя.
        *   `KUNNR_ZA` (string): Номер адреса доставки/пункта выдачи.
        *   `ADDRZA` (string): Адрес доставки (текст).
        *   `PARNRAP` (string): Код создателя заказа.
        *   `NAMEAP` (string): Наименование создателя заказа.
        *   `BSTKD` (string): Номер заказа клиента.
        *   `KETDT` (string): Желаемая дата поставки (YYYYMMDD).
        *   `INCOTERMS` (string): Признак самовывоза (`1` или `0`).
        *   `DELIVERY_ADDRESS` (string): Адрес доставки (текст).
        *   `DELIVERY_INTERVAL` (string): Интервал доставки (текст).
        *   `DELIVERY_METHOD` (string): Способ доставки (текст).
        *   `CONTACT_PERSON` (string): Контактное лицо (текст).
        *   `CONTACT_PHONE` (string): Телефон контактного лица (текст).
        *   `BACKORDER` (string): Признак разрешения довоза (`1` или `0`).
        *   `SUBSTITUTION` (string): Признак разрешения замен (`1` или `0`).
        *   `SUMMA` (number/string): Общая сумма заказа.
        *   `CURRENCY` (string): Валюта заказа.
        *   *...и другие поля заголовка заказа.*
    *   `INF` (array): Массив с суммарной информацией по выборке.
        *   `SUM` (string/number): Общая сумма по заказам в выборке.
        *   `CURRENCY` (string): Валюта.
        *   `NUM` (string/integer): Количество уникальных номеров заказов в выборке.

---

## 2. Метод `getOrderPositionsReportByDate`

*   **Назначение:** Получение отчета по позициям заказов за интервал времени.
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_reports/getOrderPositionsReportByDate`
*   **Параметры запроса (Body - JSON или form-urlencoded):** Аналогичны `getOrderReportByDate`.
*   **Структура успешного ответа (`RESP`, object):**
    *   `DATA` (array): Массив объектов с данными по позициям заказов. Поля аналогичны `ITEMS` из ответа `getOrder` сервиса `/ws_order`:
        *   `ORDER` (string): Номер заказа Armtek.
        *   `POSNR` (string): Номер позиции.
        *   `PIN` (string): Артикул.
        *   `BRAND` (string): Бренд.
        *   `NAME` (string): Наименование.
        *   `KWMENG` (number/string): Количество заказанное.
        *   `KWMENG_CONF` (number/string): Количество подтвержденное.
        *   `PRICE` (number/string): Цена за единицу.
        *   `SUMMA` (number/string): Сумма по позиции.
        *   `NOTE` (string): Комментарий к позиции.
        *   `STATUS` (string): Статус позиции.
        *   `STATUS_DATE` (string): Дата статуса позиции (YYYYMMDD).
        *   `STATUS_TIME` (string): Время статуса позиции (HHMMSS).
        *   `DELIVERY_DATE` (string): Ожидаемая дата поставки (YYYYMMDD).
        *   `DELIVERY_TIME` (string): Ожидаемое время поставки (HHMMSS).
        *   `KEYZAK` (string): Код склада Armtek.
        *   `ARTSKU` (string): Код материала Armtek (MATNR).
        *   `PRICEMAX` (string): Максимальная цена.
        *   `DATEMAX` (string): Максимальная дата поставки (YYYYMMDD).
        *   `VBELN` (string): Номер документа отгрузки (если есть).
        *   `POSNR_VL` (string): Номер позиции в документе отгрузки.
        *   `VBELN_VF` (string): Номер документа фактуры (если есть).
        *   `POSNR_VF` (string): Номер позиции в документе фактуры.
        *   `ABGRU` (string): Причина отказа.
        *   `ABGRU_TXT` (string): Описание причины отказа.
        *   *...и другие поля позиции заказа.*
    *   `INF` (array): Массив с суммарной информацией по выборке (аналогично `getOrderReportByDate`).

---

## 3. Метод `getOrderPositionsReportByDate2`

*   **Назначение:** Получение отчета по позициям заказов за интервал времени (версия 2).
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_reports/getOrderPositionsReportByDate2`
*   **Параметры запроса (Body - JSON или form-urlencoded):** Аналогичны `getOrderReportByDate`.
*   **Структура успешного ответа (`RESP`, object):**
    *   `DATA` (array): Массив объектов с данными по позициям заказов. Поля аналогичны `getOrderPositionsReportByDate`, возможно, с добавлением поля `STATCRED` (Блокировано по кредиту).
        *   *...все поля из `getOrderPositionsReportByDate`...*
        *   `STATCRED` (string): Статус блокировки по кредиту.
    *   `INF` (array): Массив с суммарной информацией по выборке (аналогично `getOrderReportByDate`).

---