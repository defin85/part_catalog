# Armtek API: Сервис Настроек Пользователя (`/ws_user`) - Формализованная информация

**Общие параметры:**

*   **Базовый URL:** `http://ws.armtek.ru` (или другой региональный)
*   **Аутентификация:** Basic Authentication (логин/пароль)
*   **Формат ответа:** Управляется query-параметром `format` (`json` или `xml`, по умолчанию `json`).
*   **Базовая структура ответа:**
    *   `STATUS` (integer): HTTP статус код.
    *   `MESSAGES` (array): Массив сообщений (`TYPE`, `TEXT`, `DATE`).
    *   `RESP` (object/array/null): Тело ответа, специфичное для метода.

---

## 1. Метод `getUserVkorgList`

*   **Назначение:** Получение списка доступных сбытовых организаций для текущего пользователя.
*   **HTTP Метод:** `GET`
*   **Путь:** `/ws_user/getUserVkorgList`
*   **Параметры запроса (Query):**
    *   `format` (string, *необязательный*): `json` или `xml`.
*   **Структура успешного ответа (`RESP`, array):**
    *   Массив объектов, каждый из которых представляет сбытовую организацию:
        *   `VKORG` (string, max 4): Код сбытовой организации.
        *   `PROGRAM_NAME` (string, max 100): Наименование программы (например, "Легковая", "Грузовая").

---

## 2. Метод `getUserInfo`

*   **Назначение:** Получение подробной информации о структуре клиента (покупатели, адреса, контакты) и данных FTP.
*   **HTTP Метод:** `POST`
*   **Путь:** `/ws_user/getUserInfo`
*   **Параметры запроса (Body - JSON или form-urlencoded):**
    *   `VKORG` (string, max 4, **обязательный**): Сбытовая организация (код из `getUserVkorgList`).
    *   `STRUCTURE` (string, '0' или '1', *необязательный*, по умолчанию '1'): Флаг получения структуры клиента (`1` - получить, `0` - не получать).
    *   `FTPDATA` (string, '0' или '1', *необязательный*, по умолчанию '1'): Флаг получения данных FTP (`1` - получить, `0` - не получать).
*   **Структура успешного ответа (`RESP`, object):**
    *   `STRUCTURE` (array, *если `STRUCTURE=1`*): Массив объектов, представляющих структуру клиента (покупатели/грузополучатели).
        *   `KUNNR` (string, max 10): Номер клиента (покупателя KUNNR_RG или грузополучателя KUNNR_WE).
        *   `NAME1` (string, max 35): Наименование 1.
        *   `NAME2` (string, max 35): Наименование 2.
        *   `ORT01` (string, max 35): Город.
        *   `ORT02` (string, max 35): Район.
        *   `PSTLZ` (string, max 10): Почтовый индекс.
        *   `REGIO` (string, max 3): Регион (код).
        *   `SORTL` (string, max 20): Понятие поиска.
        *   `STRAS` (string, max 60): Улица и номер дома.
        *   `TELF1` (string, max 30): Номер телефона 1.
        *   `TELF2` (string, max 30): Номер телефона 2.
        *   `TELFX` (string, max 30): Номер факса.
        *   `ADDRESS` (string, max 255): Полный адрес.
        *   `INN` (string, max 20): ИНН.
        *   `KPP` (string, max 9): КПП.
        *   `OKPO` (string, max 10): ОКПО.
        *   `OKVED` (string, max 100): ОКВЭД.
        *   `EMAIL` (string, max 241): Адрес электронной почты.
        *   `WWW` (string, max 100): Адрес сайта.
        *   `TYPE` (string, max 1): Тип клиента (`1` - ЮЛ, `2` - ФЛ, `3` - ИП).
        *   `CONTACTS` (array): Массив контактных лиц.
            *   `PARNR` (string, max 10): Код контактного лица.
            *   `DEFAULT` (string, max 1): Признак установки по умолчанию (`X` - да).
            *   `FNAME` (string, max 100): Полное наименование (Имя).
            *   `LNAME` (string, max 100): Фамилия.
            *   `MNAME` (string, max 100): Отчество.
            *   `PHONE` (string, max 30): Телефон.
            *   `EMAIL` (string, max 241): Email.
            *   `POSITION` (string, max 100): Должность.
        *   `DELIVERY_ADDRESSES` (array): Массив адресов доставки (KUNNR_ZA).
            *   `KUNNR` (string, max 10): Код адреса доставки.
            *   `DEFAULT` (string, max 1): Признак установки по умолчанию (`X` - да).
            *   `NAME1` (string, max 35): Наименование 1.
            *   `ORT01` (string, max 35): Город.
            *   `STRAS` (string, max 60): Улица и номер дома.
            *   `ADDRESS` (string, max 255): Полный адрес.
    *   `FTPDATA` (object, *если `FTPDATA=1`*): Объект с данными FTP.
        *   `FTP_HOST` (string, max 100): Хост FTP.
        *   `FTP_USER` (string, max 100): Пользователь FTP.
        *   `FTP_PASS` (string, max 100): Пароль FTP.
        *   `FTP_DIR` (string, max 100): Директория FTP.

---

## 3. Метод `getBrandList`

*   **Назначение:** Получение полного списка брендов, доступных в системе.
*   **HTTP Метод:** `GET`
*   **Путь:** `/ws_user/getBrandList`
*   **Параметры запроса (Query):**
    *   `format` (string, *необязательный*): `json` или `xml`.
*   **Структура успешного ответа (`RESP`, array):**
    *   Массив объектов, каждый из которых представляет бренд:
        *   `BRAND` (string, max 40): Наименование бренда.

---

## 4. Метод `getStoreList`

*   **Назначение:** Получение списка складов, доступных для указанной сбытовой организации.
*   **HTTP Метод:** `GET`
*   **Путь:** `/ws_user/getStoreList`
*   **Параметры запроса (Query):**
    *   `VKORG` (string, max 4, **обязательный**): Сбытовая организация (код из `getUserVkorgList`).
    *   `format` (string, *необязательный*): `json` или `xml`.
*   **Структура успешного ответа (`RESP`, array):**
    *   Массив объектов, каждый из которых представляет склад:
        *   `KEYZAK` (string, max 10): Код склада (используется при поиске и заказе).
        *   `SKLCODE` (string, max 10): Технический идентификатор склада.
        *   `NAME` (string, max 100): Наименование склада.
        *   `ADDRESS` (string, max 255): Адрес склада.
        *   `PHONE` (string, max 30): Телефон склада.
        *   `WORKTIME` (string, max 100): Время работы склада.
        *   `GPS` (string, max 100): Координаты GPS.

---