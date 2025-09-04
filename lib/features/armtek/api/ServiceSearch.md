# Armtek API: Сервис Поиска (`/ws_search`) - Формализованная информация

**Общие параметры:**

*   **Базовый URL:** `http://ws.armtek.ru` (или другой региональный)
*   **Аутентификация:** Basic Authentication (логин/пароль)
*   **Формат ответа:** Управляется query-параметром `format` (`json` или `xml`, по умолчанию `json`).
*   **Базовая структура ответа:**
    *   `STATUS` (integer): HTTP статус код.
    *   `MESSAGES` (array): Массив сообщений (`TYPE`, `TEXT`, `DATE`).
    *   `RESP` (object/array/null): Тело ответа, специфичное для метода.

---

## 1. Метод `assortment_search`

*   **Назначение:** Поиск по ассортименту (вероятно, для проверки наличия в каталоге без цен и остатков).
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_search/assortment_search`
*   **Параметры запроса (Body - JSON или form-urlencoded):**
    *   `VKORG` (string, max 4, **обязательный**): Сбытовая организация. (Настройка в "Сервис получения сбытовых организаций клиента").
    *   `KUNNR_RG` (string, max 10, **обязательный**): Номер покупателя (KUNNR\_RG).
    *   `KUNNR_ZA` (string, max 10, *необязательный*): Адрес доставки или Пункт выдачи для самовывоза. (Значения из "Сервис получения структуры клиента").
    *   `PIN` (string, max <40, **обязательный**): Номер артикула (строка поиска).
    *   `BRAND` (string, max 40, *необязательный*): Наименование бренда. (Рекомендуется заполнять).
    *   `NAME` (string, max 100, *необязательный*): Наименование.
    *   `PROGRAM` (string, max 2, *необязательный*): Легковая (`LP`), Грузовая (`GP`) программа или пусто.
    *   `QUERY_TYPE` (string, max 1, *необязательный*): Тип поиска (`1`, `2` или пусто). (Если `BRAND` пуст, рекомендуется `1`).
*   **Структура успешного ответа (`RESP`, array - предположительно):**
    *   Массив объектов, представляющих найденные в ассортименте позиции. Точная структура полей не указана в предоставленном контексте, но вероятно включает `PIN`, `BRAND`, `NAME`.

curl --location 'http://ws.armtek.ru/api/ws_search/assortment_search' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic MUVHT1JfTUFaQUxPVkBNQUlMLlJVOkNuOEpqR0BTV3hpMlRQbQ==' \
--data '{
    "VKORG": 4000,
    "PIN": "1192095F0A"
}'

{
    "STATUS": 200,
    "MESSAGES": [],
    "RESP": [
        {
            "PIN": "1192095F0A",
            "BRAND": "NISSAN",
            "NAME": "ремень поликлин.!\\ Nissan Almera/Primera 1.5-1.8 99>"
        },
        {
            "PIN": "1192095F0A",
            "BRAND": "DONGIL",
            "NAME": "Ремень приводной (6pk1113)"
        },
        {
            "PIN": "1192095F0A",
            "BRAND": "AMD",
            "NAME": "Ремень 6PK1110 поликлиновой, генератора 11920-95F0A/AMD.BL168 AMD"
        },
        {
            "PIN": "1192095F0A",
            "BRAND": "INFINITI",
            "NAME": "РЕМЕНЬ ПРИВОДНОЙ КОМПРЕССОРА КОНД (B10RS)"
        },
        {
            "PIN": "11920-95F0A",
            "BRAND": "DATSUN",
            "NAME": "Ремень поликлиновый AVANTECH"
        },
        {
            "PIN": "1192095F0A",
            "BRAND": "LADA",
            "NAME": "РЕМЕНЬ ПРИВОДНОЙ, С ДЛИННОЙ НАРУЖНОЙ ОКР"
        }
    ]
}

---

## 2. Метод `search`

*   **Назначение:** Поиск предложений (цены, остатки, сроки) по артикулу.
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_search/search`
*   **Параметры запроса (Body - JSON или form-urlencoded):**
    *   `VKORG` (string, max 4, **обязательный**): Сбытовая организация.
    *   `KUNNR_RG` (string, max 10, **обязательный**): Номер покупателя (KUNNR\_RG).
    *   `PIN` (string, max <40, **обязательный**): Номер артикула (строка поиска).
    *   `BRAND` (string, max 40, *необязательный*): Наименование бренда. (Рекомендуется заполнять. Влияет на поиск аналогов при `QUERY_TYPE=2`).
    *   `QUERY_TYPE` (string, max 1, *необязательный*): Тип поиска (`1`, `2` или пусто). (Вероятно, `1` - только запрошенный артикул, `2` - артикул и аналоги).
    *   *Примечание: Могут существовать другие параметры, не указанные в предоставленном контексте.*
*   **Структура успешного ответа (`RESP`, array - предположительно):**
    *   Массив объектов, представляющих найденные предложения по запчастям. Каждый объект может содержать поля (на основе контекста):
        *   `PIN` (string): Артикул.
        *   `BRAND` (string): Бренд.
        *   `NAME` (string): Наименование.
        *   `PRICE` (number/string): Цена.
        *   `RVALUE` (string, max 20): Доступное количество.
        *   `DELIVERY_DAY` (number/string): Срок поставки в днях.
        *   `KEYZAK` (string, max 10): Код склада Armtek (используется для заказа).
        *   `PARNR` (string, max 20): Код склада партнера.
        *   `RETDAYS` (number, max 4): Количество дней на возврат.
        *   `RDPRF` (string, max 10): Кратность (минимальное количество для заказа).
        *   *...и другие поля, такие как вес, объем, страна происхождения, информация о производителе и т.д.*

curl --location 'http://ws.armtek.ru/api/ws_search/search' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic MUVHT1JfTUFaQUxPVkBNQUlMLlJVOkNuOEpqR0BTV3hpMlRQbQ==' \
--data '{
    "VKORG": 4000,
    "KUNNR_RG": 43247459,
    "PIN": "1987948437"
}'

{
    "STATUS": 200,
    "MESSAGES": [],
    "RESP": [
        {
            "ARTID": "17218",
            "PARNR": "0",
            "KEYZAK": "MOV0007276",
            "RVALUE": "2",
            "RDPRF": "1",
            "MINBM": "1.000",
            "RETDAYS": "30",
            "VENSL": "100.0",
            "PRICE": "394.00",
            "WAERS": "RUB",
            "DLVDT": "20250819190000",
            "WRNTDT": "",
            "ANALOG": "X",
            "PIN": "06-01100-SX",
            "BRAND": "STELLOX",
            "NAME": "ремень поликлиновой! 6PK1100\\ Peugeot 306/405, Citroen ZX 1.6-2.0 91>"
        },
        {
            "ARTID": "644345",
            "PARNR": "0",
            "KEYZAK": "MOV0007276",
            "RVALUE": "2",
            "RDPRF": "1",
            "MINBM": "1.000",
            "RETDAYS": "30",
            "VENSL": "100.0",
            "PRICE": "1033.00",
            "WAERS": "RUB",
            "DLVDT": "20250819190000",
            "WRNTDT": "",
            "ANALOG": "",
            "PIN": "1 987 948 437",
            "BRAND": "BOSCH",
            "NAME": "ремень поликлиновой! 6PK1100\\ Peugeot 405, Citroen ZX 1.6-2.0 91>"
        },
        {
            "ARTID": "51542105",
            "PARNR": "0",
            "KEYZAK": "MOV0007276",
            "RVALUE": "1",
            "RDPRF": "1",
            "MINBM": "1.000",
            "RETDAYS": "30",
            "VENSL": "100.0",
            "PRICE": "524.00",
            "WAERS": "RUB",
            "DLVDT": "20250819190000",
            "WRNTDT": "",
            "ANALOG": "X",
            "PIN": "Z22598",
            "BRAND": "ZENTPARTS",
            "NAME": "ремень поликлиновой! 6PK1100\\ Peugeot 306/405, Citroen ZX 1.6-2.0 91>"
        }
    ]
}    
---