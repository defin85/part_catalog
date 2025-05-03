import 'package:flutter/material.dart';
import 'strings.g.dart';

/// Класс для управления локализацией в приложении
class CustomAppLocale {
  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  /// Текущая активная локаль
  static Locale _currentLocale = const Locale('ru');

  /// Глобальный объект для доступа к переводам
  static late Translations translations;

  /// Инициализация переводов
  static Future<void> load([Locale? locale]) async {
    final localeToUse = locale ?? _currentLocale;
    _currentLocale = localeToUse;

    // Получаем соответствующий AppLocale
    final appLocale = AppLocaleUtils.instance.parse(localeToUse.toString());

    // Создаем экземпляр переводов для указанной локали
    translations = await appLocale.build();

    // Устанавливаем локаль в LocaleSettings
    await LocaleSettings.setLocale(appLocale);
  }

  /// Изменение локали в рантайме
  static Future<void> setLocale(Locale locale) async {
    if (!isLocaleSupported(locale)) {
      throw Exception('Locale $locale is not supported');
    }

    await load(locale);
  }

  /// Проверка, поддерживается ли указанная локаль
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  /// Метод для получения делегата локализации Flutter
  static LocalizationsDelegate<Translations> get delegate =>
      _LocalizationsDelegate(supportedLocales: supportedLocales);
}

/// Делегат локализации для работы с slang
class _LocalizationsDelegate extends LocalizationsDelegate<Translations> {
  final List<Locale> supportedLocales;

  const _LocalizationsDelegate({
    required this.supportedLocales,
  });

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    // Используем AppLocale для установки текущей локали
    await CustomAppLocale.load(locale);
    return CustomAppLocale.translations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Translations> old) => false;
}
