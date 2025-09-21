import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Шаг 4: Дополнительные параметры
class AdditionalParametersStep extends ConsumerStatefulWidget {
  final SupplierConfig? config;
  final Function(SupplierConfig) onConfigChanged;

  const AdditionalParametersStep({
    super.key,
    this.config,
    required this.onConfigChanged,
  });

  @override
  ConsumerState<AdditionalParametersStep> createState() =>
      _AdditionalParametersStepState();
}

class _AdditionalParametersStepState
    extends ConsumerState<AdditionalParametersStep> {
  final TextEditingController _customerCodeController = TextEditingController();
  String? _selectedVkorg;
  List<String> _availableVkorgList = [];
  bool _isLoadingVkorg = false;

  @override
  void initState() {
    super.initState();
    _customerCodeController.text =
        widget.config?.businessConfig?.customerCode ?? '';
    _selectedVkorg =
        widget.config?.apiConfig.credentials?.additionalParams?['VKORG'];
  }

  @override
  void dispose() {
    _customerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Дополнительные параметры',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Настройте специфичные для поставщика параметры',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          if (widget.config?.supplierCode == 'armtek') ...[
            _buildArmtekSpecificSettings(),
            SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),
          ],

          _buildGeneralSettings(),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          _buildOptionalSettings(),
        ],
      ),
    );
  }

  Widget _buildArmtekSpecificSettings() {
    return FormSection(
      title: 'Настройки Армтек',
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // VKORG Selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Организация продаж (VKORG)',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          if (_availableVkorgList.isEmpty)
                            TextButton.icon(
                              onPressed: _isLoadingVkorg ? null : _loadVkorgList,
                              icon: _isLoadingVkorg
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.download),
                              label: Text(_isLoadingVkorg
                                  ? 'Загрузка...'
                                  : 'Загрузить список VKORG'),
                            )
                          else
                            DropdownButtonFormField<String>(
                              initialValue: _selectedVkorg,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              hint: const Text('Выберите VKORG'),
                              items: _availableVkorgList.map((vkorg) {
                                return DropdownMenuItem(
                                  value: vkorg,
                                  child: Text(vkorg),
                                );
                              }).toList(),
                              onChanged: _updateVkorg,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Customer Code
                TextFormField(
                  controller: _customerCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Код клиента',
                    helperText: 'Ваш код клиента в системе Армтек',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _updateCustomerCode,
                ),

                const SizedBox(height: 16),

                // Load Additional Data Buttons
                AdaptiveFormLayout(
                  fields: [
                    ElevatedButton.icon(
                      onPressed: _loadBrandList,
                      icon: const Icon(Icons.branding_watermark),
                      label: const Text('Загрузить бренды'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _loadStoreList,
                      icon: const Icon(Icons.store),
                      label: const Text('Загрузить склады'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _loadUserInfo,
                      icon: const Icon(Icons.person),
                      label: const Text('Загрузить профиль'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings() {
    return FormSection(
      title: 'Общие настройки',
      children: [
        AdaptiveFormLayout(
          fields: [
            SwitchListTile(
              title: const Text('Включить поставщика'),
              subtitle: const Text('Поставщик будет активен для поиска запчастей'),
              value: widget.config?.isEnabled ?? true,
              onChanged: _updateEnabled,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionalSettings() {
    return FormSection(
      title: 'Дополнительные возможности',
      children: [
        Card(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Автоматическая настройка',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'После завершения мастера будет выполнена автоматическая '
                  'загрузка справочников и настройка оптимальных параметров.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ...([
                  'Проверка подключения к API',
                  'Загрузка списка доступных брендов',
                  'Получение информации о складах',
                  'Настройка кэширования',
                ].map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadVkorgList() async {
    if (widget.config == null) return;

    setState(() {
      _isLoadingVkorg = true;
    });

    try {
      final formProvider = ref.read(supplierConfigFormProvider(widget.config!.supplierCode).notifier);
      await formProvider.loadVkorgList();

      final formState = ref.read(supplierConfigFormProvider(widget.config!.supplierCode));
      setState(() {
        _availableVkorgList = formState.availableVkorgList
            .map((vkorg) => vkorg.vkorg)
            .toList();
        _isLoadingVkorg = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVkorg = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки VKORG: $e')),
        );
      }
    }
  }

  Future<void> _loadBrandList() async {
    if (widget.config == null) return;

    try {
      final formProvider = ref.read(supplierConfigFormProvider(widget.config!.supplierCode).notifier);
      await formProvider.loadBrandList();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Список брендов загружен')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки брендов: $e')),
        );
      }
    }
  }

  Future<void> _loadStoreList() async {
    if (widget.config == null) return;

    try {
      final formProvider = ref.read(supplierConfigFormProvider(widget.config!.supplierCode).notifier);
      await formProvider.loadStoreList();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Список складов загружен')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки складов: $e')),
        );
      }
    }
  }

  Future<void> _loadUserInfo() async {
    if (widget.config == null) return;

    try {
      final formProvider = ref.read(supplierConfigFormProvider(widget.config!.supplierCode).notifier);
      await formProvider.loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Информация о пользователе загружена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки профиля: $e')),
        );
      }
    }
  }

  void _updateVkorg(String? vkorg) {
    setState(() {
      _selectedVkorg = vkorg;
    });

    if (widget.config != null && vkorg != null) {
      final updatedCredentials = widget.config!.apiConfig.credentials?.copyWith(
        additionalParams: {
          ...?widget.config!.apiConfig.credentials?.additionalParams,
          'VKORG': vkorg,
        },
      );

      final updatedConfig = widget.config!.copyWith(
        apiConfig: widget.config!.apiConfig.copyWith(
          credentials: updatedCredentials,
        ),
      );
      widget.onConfigChanged(updatedConfig);
    }
  }

  void _updateCustomerCode(String value) {
    if (widget.config != null) {
      final updatedConfig = widget.config!.copyWith(
        businessConfig: (widget.config!.businessConfig ?? const SupplierBusinessConfig())
            .copyWith(customerCode: value),
      );
      widget.onConfigChanged(updatedConfig);
    }
  }

  void _updateEnabled(bool value) {
    if (widget.config != null) {
      final updatedConfig = widget.config!.copyWith(isEnabled: value);
      widget.onConfigChanged(updatedConfig);
    }
  }
}
