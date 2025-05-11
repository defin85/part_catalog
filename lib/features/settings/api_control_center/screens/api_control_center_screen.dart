import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
// import 'package:part_catalog/core/config/global_api_settings_service.dart'; // Больше не нужен напрямую
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/settings/api_control_center/notifiers/api_control_center_notifier.dart';
import 'package:part_catalog/features/settings/api_control_center/state/api_control_center_state.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart'; // Для тестовой кнопки

class ApiControlCenterScreen extends ConsumerWidget {
  const ApiControlCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final state = ref.watch(apiControlCenterNotifierProvider);
    final notifier = ref.read(apiControlCenterNotifierProvider.notifier);
    final logger = appLogger(
        'ApiControlCenterScreen'); // Логгер можно инициализировать здесь

    final TextEditingController proxyUrlController =
        TextEditingController(text: state.proxyUrl);
    // Слушатель для обновления текста в контроллере, если он изменится извне
    ref.listen<ApiControlCenterState>(apiControlCenterNotifierProvider,
        (previous, next) {
      if (previous?.proxyUrl != next.proxyUrl) {
        proxyUrlController.text = next.proxyUrl;
        proxyUrlController.selection = TextSelection.fromPosition(
            TextPosition(offset: proxyUrlController.text.length));
      }
    });

    if (state.isLoading && state.suppliers.isEmpty) {
      // Показываем загрузку только при первой загрузке
      return Scaffold(
        appBar: AppBar(
          title: Text(t.apiControlCenter.screenTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${state.error}')),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.apiControlCenter.screenTitle),
        actions: [
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.apiControlCenter.apiConnectionMode,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile<ApiConnectionMode>(
              title: Text(t.apiControlCenter.directMode),
              value: ApiConnectionMode.direct,
              groupValue: state.apiMode,
              onChanged: (ApiConnectionMode? value) {
                if (value != null) {
                  notifier.setApiConnectionMode(value);
                }
              },
            ),
            RadioListTile<ApiConnectionMode>(
              title: Text(t.apiControlCenter.proxyMode),
              value: ApiConnectionMode.proxy,
              groupValue: state.apiMode,
              onChanged: (ApiConnectionMode? value) {
                if (value != null) {
                  notifier.setApiConnectionMode(value);
                }
              },
            ),
            if (state.apiMode == ApiConnectionMode.proxy)
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TextFormField(
                  controller: proxyUrlController,
                  decoration: InputDecoration(
                    labelText: t.apiControlCenter.proxyUrlLabel,
                    hintText: t.apiControlCenter.proxyUrlHint,
                    border: const OutlineInputBorder(),
                  ),
                  onEditingComplete: () {
                    notifier.setProxyUrl(proxyUrlController.text);
                    FocusScope.of(context).unfocus(); // Скрыть клавиатуру
                  },
                ),
              ),
            const SizedBox(height: 24),
            Text(
              t.apiControlCenter.suppliersListTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (state.suppliers.isEmpty && !state.isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(t.core.noDataAvailable)),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.suppliers.length,
              itemBuilder: (context, index) {
                final supplierInfo = state.suppliers[index];
                return _buildSupplierTile(context,
                    // icon: supplierInfo.icon ?? Icons.business_center, // Используем иконку или дефолтную
                    icon: Icons.business_center, // Заглушка иконки
                    name: supplierInfo.displayName,
                    status: supplierInfo.status,
                    isConfigured: supplierInfo.isConfigured, onConfigure: () {
                  logger.i(
                      'Configure button pressed for ${supplierInfo.displayName}');
                  // TODO: Навигация на экран настроек supplierInfo.code
                  // Например, context.go('/settings/suppliers/${supplierInfo.code}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Переход к настройкам ${supplierInfo.displayName} (TODO)')),
                  );
                },
                    // Тестовая кнопка для имитации сохранения настроек
                    onTestToggleConfigured: () {
                  final sc = SupplierCode.values
                      .firstWhere((e) => e.code == supplierInfo.code);
                  notifier.addOrUpdateTestSupplierSetting(
                      sc, !supplierInfo.isConfigured);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierTile(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String status,
    required bool isConfigured,
    required VoidCallback onConfigure,
    required VoidCallback onTestToggleConfigured, // Тестовый коллбэк
  }) {
    final t = Translations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon,
            size: 40, color: isConfigured ? Colors.green : Colors.grey),
        title: Text(name),
        subtitle: Text(status),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Тестовая кнопка для переключения статуса isConfigured
            IconButton(
              icon: Icon(
                isConfigured ? Icons.toggle_on : Icons.toggle_off,
                color: isConfigured ? Colors.green : Colors.grey,
                size: 30,
              ),
              tooltip:
                  'Тест: ${isConfigured ? "Сделать не настроенным" : "Сделать настроенным"}',
              onPressed: onTestToggleConfigured,
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onConfigure,
              child: Text(t.apiControlCenter.configureButton),
            ),
          ],
        ),
      ),
    );
  }
}
