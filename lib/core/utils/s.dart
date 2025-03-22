import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

/// Вспомогательный класс для работы с локализацией приложения
class S {
  // Константы локалей
  static const en = Locale('en');
  static const ru = Locale('ru');

  // Системная локаль (используем по умолчанию)
  static const Locale? useSystemLocale = null;

  // Поддерживаемые локали
  static const List<Locale> supportedLocales = [en, ru];

  // Делегаты локализации
  static const localizationDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // Метод быстрого доступа к строкам
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);

  // Проверка текущей локали
  static bool isRu(Locale locale) => locale.languageCode == ru.languageCode;
  static bool isEn(Locale locale) => locale.languageCode == en.languageCode;

  // Получение текущей локали
  static Locale getCurrentLocale(BuildContext context) =>
      Localizations.localeOf(context);

  // Получение названия текущей локали для отображения
  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }
}
