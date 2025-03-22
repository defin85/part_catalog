// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Каталог запчастей';

  @override
  String get clientsScreenTitle => 'Клиенты';

  @override
  String get carsScreenTitle => 'Автомобили';

  @override
  String get ordersScreenTitle => 'Заказ-наряды';

  @override
  String get addClient => 'Добавить клиента';

  @override
  String get addCar => 'Добавить автомобиль';

  @override
  String get addOrder => 'Добавить заказ-наряд';

  @override
  String get editClient => 'Редактировать клиента';

  @override
  String get editCar => 'Редактировать автомобиль';

  @override
  String get deleteConfirmation => 'Вы уверены, что хотите удалить этот элемент?';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get clientName => 'Имя/Название';

  @override
  String get clientType => 'Тип клиента';

  @override
  String get contactInfo => 'Контактная информация';

  @override
  String get additionalInfo => 'Дополнительная информация';

  @override
  String get make => 'Марка';

  @override
  String get model => 'Модель';

  @override
  String get year => 'Год';

  @override
  String get vin => 'VIN';

  @override
  String get licensePlate => 'Гос. номер';

  @override
  String get owner => 'Владелец';

  @override
  String get clientTypePhysical => 'Физическое лицо';

  @override
  String get clientTypeLegal => 'Юридическое лицо';

  @override
  String get clientTypeEntrepreneur => 'ИП';

  @override
  String get clientTypeOther => 'Другое';

  @override
  String get filterByClient => 'Фильтр по клиенту';

  @override
  String get allClients => 'Все клиенты';

  @override
  String get noClientsAvailable => 'Нет доступных клиентов';

  @override
  String get noCarsAvailable => 'Нет доступных автомобилей';

  @override
  String get resetDatabaseSuccess => 'База данных успешно сброшена';

  @override
  String resetDatabaseError(String error) {
    return 'Ошибка сброса базы данных: $error';
  }

  @override
  String vehicleDeleted(String make, String model) {
    return 'Автомобиль $make $model удален';
  }

  @override
  String get error => 'Ошибка';

  @override
  String errorLoadingData(String error) {
    return 'Ошибка загрузки данных: $error';
  }

  @override
  String get resetDatabase => 'Сбросить базу данных';

  @override
  String get carHistory => 'История автомобиля';

  @override
  String get selectVehiclePrompt => 'Выберите автомобиль из списка слева';

  @override
  String get emptyCarsList => 'Список автомобилей пуст. Добавьте автомобиль, нажав на кнопку \'+\'';

  @override
  String get emptyClientsList => 'Список клиентов пуст. Добавьте клиента, нажав на кнопку \'+\'';
}
