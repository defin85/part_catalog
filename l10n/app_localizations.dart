import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Part Catalog'**
  String get appTitle;

  /// Title for the clients screen
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsScreenTitle;

  /// Title for the cars screen
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get carsScreenTitle;

  /// Title for the orders screen
  ///
  /// In en, this message translates to:
  /// **'Work Orders'**
  String get ordersScreenTitle;

  /// Button text to add a new client
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// Button text to add a new car
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addCar;

  /// Button text to add a new order
  ///
  /// In en, this message translates to:
  /// **'Add Work Order'**
  String get addOrder;

  /// Dialog title for editing client info
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// Dialog title for editing car info
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editCar;

  /// Confirmation message for deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// Button text for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button text for cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text for save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Client name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get clientName;

  /// Client type field label
  ///
  /// In en, this message translates to:
  /// **'Client Type'**
  String get clientType;

  /// Contact information field label
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// Additional information field label
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// Car make field label
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// Car model field label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Car year field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Vehicle identification number field label
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vin;

  /// License plate field label
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// Car owner field label
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// Physical person client type
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get clientTypePhysical;

  /// Legal entity client type
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get clientTypeLegal;

  /// Individual entrepreneur client type
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur'**
  String get clientTypeEntrepreneur;

  /// Other client type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get clientTypeOther;

  /// Filter vehicles by client
  ///
  /// In en, this message translates to:
  /// **'Filter by Client'**
  String get filterByClient;

  /// Option to show all clients in filter
  ///
  /// In en, this message translates to:
  /// **'All Clients'**
  String get allClients;

  /// Message when no clients are available
  ///
  /// In en, this message translates to:
  /// **'No clients available'**
  String get noClientsAvailable;

  /// Message when no cars are available
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get noCarsAvailable;

  /// Message after successful database reset
  ///
  /// In en, this message translates to:
  /// **'Database reset successfully'**
  String get resetDatabaseSuccess;

  /// Error message after database reset failed
  ///
  /// In en, this message translates to:
  /// **'Error resetting database: {error}'**
  String resetDatabaseError(String error);

  /// Message after vehicle deletion
  ///
  /// In en, this message translates to:
  /// **'Vehicle {make} {model} deleted'**
  String vehicleDeleted(String make, String model);

  /// General error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error message when loading data fails
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(String error);

  /// Button to reset database
  ///
  /// In en, this message translates to:
  /// **'Reset Database'**
  String get resetDatabase;

  /// Title for car history section
  ///
  /// In en, this message translates to:
  /// **'Vehicle History'**
  String get carHistory;

  /// Prompt to select vehicle in desktop mode
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle from the list'**
  String get selectVehiclePrompt;

  /// Message when cars list is empty
  ///
  /// In en, this message translates to:
  /// **'The vehicles list is empty. Add a vehicle by clicking the \'+\' button'**
  String get emptyCarsList;

  /// Message when clients list is empty
  ///
  /// In en, this message translates to:
  /// **'The clients list is empty. Add a client by clicking the \'+\' button'**
  String get emptyClientsList;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
