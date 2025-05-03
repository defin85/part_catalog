/// Константы для сообщений логирования.
/// Централизованное хранение всех сообщений логов позволяет обеспечить их консистентность
/// и упрощает поддержку и обновление.
class LogMessages {
  // Общие сообщения
  static const String error = 'Ошибка: ';

  // Сообщения связанные с базой данных
  static const String databaseResetError = 'Ошибка при сбросе базы данных';
  static const String dataLoadingError = 'Ошибка загрузки данных';
  static const String dbTableMissingError =
      'Ошибка отсутствия таблицы в базе данных';

  // Сообщения для модуля клиентов
  static const String clientAddError = 'Ошибка при добавлении клиента';
  static const String clientUpdateError = 'Ошибка при обновлении клиента';
  static const String clientDeleteError = 'Ошибка при удалении клиента';
  static const String clientRestoreError = 'Ошибка при восстановлении клиента';
  static const String clientValidationError = 'Ошибка валидации данных клиента';
  static const String clientSearchError = 'Ошибка при поиске клиентов';
  static const String clientCodeValidationError =
      'Ошибка проверки уникальности кода клиента';
  static const String clientNotFoundByUuid =
      'Клиент с UUID {uuid} не найден в базе данных';
  static const String clientInserting =
      'Добавление клиента с UUID {uuid} и кодом {code}'; // Обновлено для ясности
  static const String clientUpdating = 'Обновление клиента с UUID {uuid}';
  static const String clientSoftDeleting =
      'Мягкое удаление клиента с UUID {uuid}';
  static const String clientRestoring = 'Восстановление клиента с UUID {uuid}';
  static const String clientGeneratedCode =
      'Сгенерирован новый код клиента: {code}'; // <-- Новая константа

  // --- Новые константы для ClientService ---
  static const String clientWatchActive = 'Наблюдение за активными клиентами';
  static const String clientGetByUuid = 'Получение клиента по UUID {uuid}';
  static const String clientGetByCode = 'Получение клиента по коду {code}';
  static const String clientNotFoundByCode = 'Клиент с кодом {code} не найден';
  static const String clientAddErrorMissingUuid =
      'Ошибка добавления клиента: отсутствует UUID';
  static const String clientCreated = 'Клиент {uuid} успешно создан';
  static const String clientNotFoundForUpdate =
      'Клиент {uuid} не найден для обновления';
  static const String clientUpdated = 'Клиент {uuid} успешно обновлен';
  static const String clientDeleting = 'Удаление клиента {uuid}';
  static const String clientNotFoundForDelete =
      'Клиент {uuid} не найден для удаления';
  static const String clientAlreadyDeleted =
      'Клиент {uuid} уже помечен как удаленный';
  static const String clientDeleted = 'Клиент {uuid} помечен как удаленный';
  static String clientGetAll(bool includeDeleted) =>
      'Получение всех клиентов ${includeDeleted ? " (включая удаленных)" : ""}'; // Метод для динамического сообщения
  static const String clientGetByType = 'Получение клиентов по типу {type}';
  static const String clientNotFoundForRestore =
      'Клиент {uuid} не найден для восстановления';
  static const String clientRestoreAttemptOnNonDeleted =
      'Попытка восстановить не удаленного клиента {uuid}';
  static const String clientRestored = 'Клиент {uuid} успешно восстановлен';
  static const String clientCreatingWithCars =
      'Создание клиента {uuid} с {carCount} автомобилями';
  static const String clientCreatedWithCarsSuccess =
      'Клиент {uuid} и его автомобили успешно созданы';
  static const String clientCreateWithCarsError =
      'Ошибка создания клиента {uuid} с автомобилями';
  static const String clientSearching = 'Поиск клиентов по запросу "{query}"';
  static const String clientCheckingCodeUniqueness =
      'Проверка уникальности кода клиента {code}';
  static const String clientInsertedInTransaction =
      'Клиент {uuid} вставлен в транзакции';
  static const String clientCarAddedInTransaction =
      'Машина {carUuid} добавлена для клиента {clientUuid} в транзакции';

  // Сообщения для модуля автомобилей
  static const String carAddError = 'Ошибка при добавлении автомобиля';
  static const String carUpdateError = 'Ошибка при обновлении автомобиля';
  static const String carDeleteError = 'Ошибка при удалении автомобиля';
  static const String carRestoreError = 'Ошибка при восстановлении автомобиля';
  static const String carNotFoundByUuid = 'Автомобиль с UUID {uuid} не найден';
  static const String carInserting =
      'Добавление автомобиля с UUID {uuid} для клиента ID {clientId}';
  static const String carUpdating = 'Обновление автомобиля с UUID {uuid}';
  static const String carSoftDeleting =
      'Мягкое удаление автомобиля с UUID {uuid}';
  static const String carRestoring = 'Восстановление автомобиля с UUID {uuid}';

  // --- Новые константы для CarService ---
  static const String carWatchActive = 'Наблюдение за активными автомобилями';
  static const String carWatchActiveByClient =
      'Наблюдение за активными автомобилями клиента {uuid}';
  static const String carGetByUuid = 'Получение автомобиля по UUID {uuid}';
  static const String carAddErrorMissingUuid =
      'Ошибка добавления автомобиля: отсутствует UUID';
  static const String carCreated = 'Автомобиль {uuid} успешно создан';
  static const String carNotFoundForUpdate =
      'Автомобиль {uuid} не найден для обновления';
  static const String carUpdated = 'Автомобиль {uuid} успешно обновлен';
  static const String carDeleting = 'Удаление автомобиля {uuid}';
  static const String carNotFoundForDelete =
      'Автомобиль {uuid} не найден для удаления';
  static const String carAlreadyDeleted =
      'Автомобиль {uuid} уже помечен как удаленный';
  static const String carDeleted =
      'Автомобиль {uuid} помечен как удаленный'; // Добавлено
  static const String carNotFoundForRestore =
      'Автомобиль {uuid} не найден для восстановления';
  static const String carRestoreAttemptOnNonDeleted =
      'Попытка восстановить не удаленный автомобиль {uuid}';
  static const String carRestored = 'Автомобиль {uuid} успешно восстановлен';
  static const String carGetWithOwners =
      'Получение списка автомобилей с владельцами';
  static const String carGetWithOwnersError =
      'Ошибка при получении списка автомобилей с владельцами';
  static const String carWatchWithOwners =
      'Наблюдение за списком автомобилей с владельцами';
  static const String carWatchWithOwnersError =
      'Ошибка при наблюдении за списком автомобилей с владельцами';

  // Сообщения для API
  static const String apiRequestError = 'Ошибка запроса к API';
  static const String apiResponseError = 'Ошибка в ответе API';

  // Сообщения для модуля заказ-нарядов
  static const String orderGetError = 'Ошибка при получении заказ-нарядов';
  static const String orderWatchError =
      'Ошибка при наблюдении за заказ-нарядами';
  static const String orderByUuidGetError =
      'Ошибка при получении заказ-наряда по UUID';
  static const String orderByUuidWatchError =
      'Ошибка при наблюдении за заказ-нарядом';
  static const String orderCreateError = 'Ошибка при создании заказ-наряда';
  static const String orderNewCreateError =
      'Ошибка при создании нового заказ-наряда';
  static const String orderUpdateError = 'Ошибка при обновлении заказ-наряда';
  static const String orderStatusChangeError =
      'Ошибка при изменении статуса заказ-наряда';
  static const String orderServiceAddError =
      'Ошибка при добавлении услуги к заказ-наряду';
  static const String orderPartAddError =
      'Ошибка при добавлении запчасти к заказ-наряду';
  static const String orderServiceUpdateError = 'Ошибка при обновлении услуги';
  static const String orderPartUpdateError = 'Ошибка при обновлении запчасти';
  static const String orderServiceRemoveError = 'Ошибка при удалении услуги';
  static const String orderPartRemoveError = 'Ошибка при удалении запчасти';
  static const String orderDeleteError = 'Ошибка при удалении заказ-наряда';
  static const String orderRestoreError =
      'Ошибка при восстановлении заказ-наряда';
  static const String orderServiceCreateAddError =
      'Ошибка при создании и добавлении услуги';
  static const String orderPartCreateAddError =
      'Ошибка при создании и добавлении запчасти';
  static const String orderGetByClientError =
      'Ошибка при получении заказ-нарядов клиента';
  static const String orderGetByCarError =
      'Ошибка при получении заказ-нарядов автомобиля';
  static const String orderGetByStatusError =
      'Ошибка при получении заказ-нарядов по статусу';
  static const String orderSearchError = 'Ошибка при поиске заказ-нарядов';
  static const String orderProvestiError = 'Ошибка при проведении заказ-наряда';
  static const String orderOtmenitError =
      'Ошибка при отмене проведения заказ-наряда';
  static const String orderAddError = 'Ошибка при добавлении заказ-наряда';
  static const String orderStatusUpdateError =
      'Ошибка при обновлении статуса заказ-наряда';
  static const String orderItemAddError =
      'Ошибка при добавлении элемента в заказ-наряд';
  static const String orderItemUpdateError =
      'Ошибка при обновлении элемента заказ-наряда';
  static const String orderItemDeleteError =
      'Ошибка при удалении элемента из заказ-наряда';
  static const String orderNotFoundByUuid =
      'Заказ-наряд с UUID {uuid} не найден';
  static const String orderInserting = 'Добавление заказ-наряда с UUID {uuid}';
  static const String orderUpdating = 'Обновление заказ-наряда с UUID {uuid}';
  static const String orderSoftDeleting =
      'Мягкое удаление заказ-наряда с UUID {uuid}';
  static const String orderRestoring =
      'Восстановление заказ-наряда с UUID {uuid}';
  static const String orderStatusUpdating =
      'Обновление статуса заказ-наряда {uuid} на {status}';
  static const String orderItemInserting =
      'Добавление элемента {itemUuid} в заказ-наряд {orderUuid}';
  static const String orderItemUpdating =
      'Обновление элемента {itemUuid} в заказ-наряде {orderUuid}';
  static const String orderItemDeleting =
      'Удаление элемента {itemUuid} из заказ-наряда {orderUuid}';
  static const String orderCreated = 'Заказ-наряд {uuid} успешно создан';
  static const String orderUpdated = 'Заказ-наряд {uuid} успешно обновлен';
  static const String orderStatusUpdated =
      'Статус заказ-наряда {uuid} обновлен на {status}';
  static const String orderItemAdded =
      'Элемент {itemUuid} добавлен в заказ-наряд {orderUuid}';
  static const String orderItemUpdated =
      'Элемент {itemUuid} обновлен в заказ-наряде {orderUuid}';
  static const String orderItemRemoved =
      'Элемент {itemUuid} удален из заказ-наряда {orderUuid}';
  static const String orderDeleted = 'Заказ-наряд {uuid} помечен как удаленный';
  static const String orderRestored = 'Заказ-наряд {uuid} восстановлен';
  static const String orderServiceCreatedAdd =
      'Услуга {itemUuid} создана и добавлена в заказ-наряд {orderUuid}';
  static const String orderPartCreatedAdd =
      'Запчасть {itemUuid} создана и добавлена в заказ-наряд {orderUuid}';
  static const String orderPosted = 'Заказ-наряд {uuid} проведен';
  static const String orderUnposted = 'Проведение заказ-наряда {uuid} отменено';
  static const String orderItemInvalidData =
      'Некорректные или неполные данные элемента заказа: {itemUuid}'; // Добавлено для _mapDataToComposite
  static const String orderStreamError =
      'Ошибка в потоке данных для заказа {uuid}: {error}'; // Добавлено для _mapStreamDataToComposite
  static const String orderListStreamItemError =
      'Ошибка в потоке заказа {uuid} при просмотре списка'; // Добавлено для watchOrders
  static const String orderSaveError =
      'Ошибка сохранения заказа {uuid}'; // Добавлено для _saveOrder
  static const String orderAddItemError =
      'Ошибка добавления элемента {itemUuid} к заказу {orderUuid}'; // Добавлено для addItemToOrder
  static const String orderUpdateItemError =
      'Ошибка обновления элемента {itemUuid} в заказе {orderUuid}'; // Добавлено для updateOrderItem
  static const String orderRemoveItemError =
      'Ошибка удаления элемента {itemUuid} из заказа {orderUuid}'; // Добавлено для removeItemFromOrder
  static const String orderRestoreAttemptOnNonDeleted =
      'Попытка восстановить не удаленный заказ-наряд {uuid}'; // Добавлено для restoreOrder
  static const String orderPostAttemptOnPosted =
      'Попытка повторно провести заказ-наряд {uuid}'; // Добавлено для provesti
  static const String orderUnpostAttemptOnUnposted =
      'Попытка отменить непроведенный заказ-наряд {uuid}'; // Добавлено для otmenit
  static const String orderDetailsStreamBuilderError =
      'Ошибка в StreamBuilder OrderDetailsScreen'; // <-- Новая константа
  static const String orderDeleteErrorDetails =
      'Ошибка удаления заказ-наряда {uuid}'; // <-- Новая константа
  static const String orderStatusChangeErrorDetails =
      'Ошибка смены статуса заказа {uuid} на {status}'; // <-- Новая константа
  static const String orderAddPartNotImplemented =
      '_addPart не реализован'; // <-- Новая константа
  static const String orderAddServiceNotImplemented =
      '_addService не реализован'; // <-- Новая константа
  static const String orderEditItemNotImplemented =
      '_editItem не реализован для {runtimeType}'; // <-- Новая константа
  static const String orderRemoveItemErrorDetails =
      'Ошибка удаления элемента {itemUuid} из заказа {orderUuid}'; // <-- Новая константа

  // Другие категории сообщений можно добавить по мере необходимости
}
