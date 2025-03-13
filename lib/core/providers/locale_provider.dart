import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер для управления текущей локалью приложения
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';

  // Текущая локаль, по умолчанию null (будет использована системная)
  Locale? _locale;

  // Геттер для доступа к текущей локали
  Locale? get locale => _locale;

  // Конструктор, загружающий сохраненную локаль
  LocaleProvider() {
    _loadSavedLocale();
  }

  // Метод для установки локали
  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale(locale);
    notifyListeners();
  }

  // Метод для сброса локали на системную
  void resetLocale() {
    _locale = null;
    _removeLocale();
    notifyListeners();
  }

  // Метод для загрузки сохраненной локали
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);

    if (localeString != null) {
      final parts = localeString.split('_');
      _locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
      notifyListeners();
    }
  }

  // Метод для сохранения локали
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await prefs.setString(_localeKey, localeString);
  }

  // Метод для удаления сохраненной локали
  Future<void> _removeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}
