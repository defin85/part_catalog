import 'package:flutter/material.dart';
import 'package:part_catalog/core/utils/s.dart';
import 'package:part_catalog/core/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale =
        localeProvider.locale ?? Localizations.localeOf(context);

    return PopupMenuButton<Locale>(
      tooltip: 'Сменить язык / Change language',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language),
            const SizedBox(width: 4),
            Text(currentLocale.languageCode.toUpperCase()),
          ],
        ),
      ),
      itemBuilder: (context) {
        return S.supportedLocales.map((locale) {
          final isSelected = locale.languageCode == currentLocale.languageCode;

          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                if (isSelected)
                  const Icon(Icons.check, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(S.getLocaleName(locale)),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (Locale selectedLocale) {
        localeProvider.setLocale(selectedLocale);
      },
    );
  }
}
