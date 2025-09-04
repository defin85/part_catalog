import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';

// Импортируем сгенерированный файл slang

// Провайдер для текущей локали
final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocale>((ref) {
  return LocaleNotifier();
});

// Нотификатор для управления локалью
class LocaleNotifier extends StateNotifier<AppLocale> {
  LocaleNotifier() : super(LocaleSettings.currentLocale);

  void setLocale(AppLocale locale) {
    state = locale;
    LocaleSettings.setLocale(locale);
    // Принудительно обновляем переводы
    LocaleSettings.setLocaleRaw(locale.languageCode);
  }
}

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем текущую локаль из провайдера
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<AppLocale>(
      tooltip: t.core.changeLanguageTooltip, // Используем ключ из Slang
      icon: const Icon(Icons.language),
      itemBuilder: (context) {
        // ----- Переписываем с использованием цикла for -----
        final List<PopupMenuEntry<AppLocale>> menuItems = [];
        // Используем AppLocale.values вместо AppLocaleUtils.supportedLocales
        for (final AppLocale locale in AppLocale.values) {
          final isSelected = locale == currentLocale;
          final localeName = _getLocaleName(locale);

          menuItems.add(
            PopupMenuItem<AppLocale>(
              value: locale,
              child: Row(
                children: [
                  if (isSelected)
                    const Icon(Icons.check, size: 18)
                  else
                    const SizedBox(width: 18), // Пустое место для выравнивания
                  const SizedBox(width: 8),
                  Text(localeName),
                ],
              ),
            ),
          );
        }
        return menuItems;
        // ----- Конец переписывания -----
      },
      onSelected: (AppLocale selectedLocale) {
        // Устанавливаем новую локаль через провайдер
        ref.read(localeProvider.notifier).setLocale(selectedLocale);
      },
    );
  }

  // Вспомогательный метод для получения имени локали
  String _getLocaleName(AppLocale locale) {
    // Используем switch expression для большей лаконичности
    return switch (locale) {
      AppLocale.ru => 'Русский', // Или t.core.languageNameRu
      AppLocale.en => 'English', // Или t.core.languageNameEn
      // default случай не нужен, так как все значения enum перечислены
    };
  }
}
