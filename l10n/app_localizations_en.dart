// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Part Catalog';

  @override
  String get clientsScreenTitle => 'Clients';

  @override
  String get carsScreenTitle => 'Vehicles';

  @override
  String get ordersScreenTitle => 'Work Orders';

  @override
  String get addClient => 'Add Client';

  @override
  String get addCar => 'Add Vehicle';

  @override
  String get addOrder => 'Add Work Order';

  @override
  String get editClient => 'Edit Client';

  @override
  String get editCar => 'Edit Vehicle';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get clientName => 'Name';

  @override
  String get clientType => 'Client Type';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get make => 'Make';

  @override
  String get model => 'Model';

  @override
  String get year => 'Year';

  @override
  String get vin => 'VIN';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get owner => 'Owner';

  @override
  String get clientTypePhysical => 'Person';

  @override
  String get clientTypeLegal => 'Company';

  @override
  String get clientTypeEntrepreneur => 'Entrepreneur';

  @override
  String get clientTypeOther => 'Other';

  @override
  String get filterByClient => 'Filter by Client';

  @override
  String get allClients => 'All Clients';

  @override
  String get noClientsAvailable => 'No clients available';

  @override
  String get noCarsAvailable => 'No vehicles available';

  @override
  String get resetDatabaseSuccess => 'Database reset successfully';

  @override
  String resetDatabaseError(String error) {
    return 'Error resetting database: $error';
  }

  @override
  String vehicleDeleted(String make, String model) {
    return 'Vehicle $make $model deleted';
  }

  @override
  String get error => 'Error';

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get resetDatabase => 'Reset Database';

  @override
  String get carHistory => 'Vehicle History';

  @override
  String get selectVehiclePrompt => 'Please select a vehicle from the list';

  @override
  String get emptyCarsList => 'The vehicles list is empty. Add a vehicle by clicking the \'+\' button';

  @override
  String get emptyClientsList => 'The clients list is empty. Add a client by clicking the \'+\' button';
}
