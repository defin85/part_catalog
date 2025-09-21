import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/settings/api_control_center/notifiers/api_control_center_notifier.dart';
import 'package:part_catalog/features/settings/api_control_center/state/api_control_center_state.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart'; // Для тестовой кнопки

// import 'package:part_catalog/core/config/global_api_settings_service.dart'; // Больше не нужен напрямую

class ApiControlCenterScreen extends ConsumerWidget {
  const ApiControlCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final state = ref.watch(apiControlCenterNotifierProvider);
    final notifier = ref.read(apiControlCenterNotifierProvider.notifier);

    // Слушатель для обновления snackbar при ошибках
    ref.listen<ApiControlCenterState>(
      apiControlCenterNotifierProvider,
      (previous, next) {
        if (next.error != null && previous?.error != next.error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: ${next.error}')),
              );
            }
          });
        }
      },
    );

    if (state.isLoading && state.suppliers.isEmpty) {
      // Показываем загрузку только при первой загрузке
      return Scaffold(
        appBar: AppBar(
          title: Text(t.settings.apiControlCenter.screenTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.apiControlCenter.screenTitle),
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
      body: ResponsiveLayoutBuilder(
        small: (context, constraints) => _buildContent(context, ref, state, notifier, t, isTablet: false),
        medium: (context, constraints) => _buildContent(context, ref, state, notifier, t, isTablet: true),
        large: (context, constraints) => _buildContent(context, ref, state, notifier, t, isTablet: true),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ApiControlCenterState state, dynamic notifier, dynamic t, {required bool isTablet}) {
    final logger = appLogger('ApiControlCenterScreen');
    final TextEditingController proxyUrlController = TextEditingController(text: state.proxyUrl);

    // Слушатель для обновления текста в контроллере
    ref.listen<ApiControlCenterState>(apiControlCenterNotifierProvider,
        (previous, next) {
      if (previous?.proxyUrl != next.proxyUrl) {
        proxyUrlController.text = next.proxyUrl;
        proxyUrlController.selection = TextSelection.fromPosition(
            TextPosition(offset: proxyUrlController.text.length));
      }
    });

    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 800 : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.apiControlCenter.apiConnectionMode,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioGroup<ApiConnectionMode>(
              groupValue: state.apiMode,
              onChanged: (ApiConnectionMode? value) {
                if (value != null) {
                  notifier.setApiConnectionMode(value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<ApiConnectionMode>(
                    title: Text(t.settings.apiControlCenter.directMode),
                    value: ApiConnectionMode.direct,
                  ),
                  RadioListTile<ApiConnectionMode>(
                    title: Text(t.settings.apiControlCenter.proxyMode),
                    value: ApiConnectionMode.proxy,
                  ),
                ],
              ),
            ),
            if (state.apiMode == ApiConnectionMode.proxy)
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TextFormField(
                  controller: proxyUrlController,
                  decoration: InputDecoration(
                    labelText: t.settings.apiControlCenter.proxyUrlLabel,
                    hintText: t.settings.apiControlCenter.proxyUrlHint,
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
              t.settings.apiControlCenter.suppliersListTitle,
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
                return _buildSupplierTile(
                  context,
                  icon: Icons.business_center,
                  name: supplierInfo.displayName,
                  status: supplierInfo.status,
                  isConfigured: supplierInfo.isConfigured,
                  onConfigure: () {
                    logger.i(
                        'Configure button pressed for ${supplierInfo.displayName}');
                    context
                        .go('${AppRoutes.supplierConfig}/${supplierInfo.code}');
                  },
                  onConfigureWithWizard: () {
                    logger.i(
                        'Wizard configure pressed for ${supplierInfo.displayName}');
                    final encoded =
                        Uri.encodeComponent(supplierInfo.code);
                    context.push('${AppRoutes.supplierWizard}?code=$encoded');
                  },
                  onTestToggleConfigured: () {
                    final sc = SupplierCode.values
                        .firstWhere((e) => e.code == supplierInfo.code);
                    notifier.addOrUpdateTestSupplierSetting(
                        sc, !supplierInfo.isConfigured);
                  },
                );
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
    required VoidCallback onConfigureWithWizard,
    required VoidCallback onTestToggleConfigured,
  }) {
    final t = Translations.of(context);
    final statusColor = isConfigured ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: statusColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isConfigured ? Icons.toggle_on : Icons.toggle_off,
                    color: statusColor,
                    size: 30,
                  ),
                  tooltip:
                      'Тест: ${isConfigured ? "Сделать не настроенным" : "Сделать настроенным"}',
                  onPressed: onTestToggleConfigured,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onConfigure,
                  icon: const Icon(Icons.settings),
                  label: Text(t.settings.apiControlCenter.configureButton),
                ),
                OutlinedButton.icon(
                  onPressed: onConfigureWithWizard,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Через мастер'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
