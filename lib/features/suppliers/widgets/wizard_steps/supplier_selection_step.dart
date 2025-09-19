import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/services/supplier_service.dart';
import 'package:part_catalog/features/suppliers/services/supplier_profile_service.dart';

/// Шаг 1: Выбор типа поставщика
class SupplierSelectionStep extends StatefulWidget {
  final SupplierConfig? config;
  final Function(SupplierConfig) onConfigChanged;

  const SupplierSelectionStep({
    super.key,
    this.config,
    required this.onConfigChanged,
  });

  @override
  State<SupplierSelectionStep> createState() => _SupplierSelectionStepState();
}

class _SupplierSelectionStepState extends State<SupplierSelectionStep> {
  String? _selectedSupplierCode;
  String? _selectedProfileCode;
  final TextEditingController _displayNameController = TextEditingController();
  List<SupplierProfile> _availableProfiles = [];

  final List<SupplierTemplate> _templates = [
    SupplierTemplate(
      code: 'armtek',
      name: 'Армтек',
      description: 'Российский поставщик автозапчастей',
      icon: Icons.local_shipping,
      features: ['API каталог', 'Остатки', 'Прайс-листы', 'VKORG'],
    ),
    SupplierTemplate(
      code: 'custom',
      name: 'Пользовательский',
      description: 'Настройка собственного API',
      icon: Icons.settings,
      features: ['Гибкая настройка', 'Любой протокол', 'Кастомные поля'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSupplierCode = widget.config?.supplierCode;
    _displayNameController.text = widget.config?.displayName ?? '';
    _loadAvailableProfiles();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите тип поставщика',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите шаблон для быстрой настройки или создайте пользовательскую конфигурацию',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Карточки шаблонов
          AdaptiveFormLayout(
            fields: _templates.map((template) =>
              _buildTemplateCard(template)
            ).toList(),
            spacing: 16,
            runSpacing: 16,
          ),

          if (_availableProfiles.isNotEmpty) ...[
            SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),
            FormSection(
              title: 'Быстрые профили',
              children: [
                Text(
                  'Выберите предустановленный профиль для быстрой настройки',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ..._availableProfiles.map((profile) => _buildProfileCard(profile)),
              ],
            ),
          ],

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Поле названия конфигурации
          FormSection(
            title: 'Настройки',
            children: [
              AdaptiveFormLayout(
                fields: [
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Название конфигурации',
                      helperText: 'Отображаемое имя для этого поставщика',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _updateDisplayName,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(SupplierTemplate template) {
    final isSelected = _selectedSupplierCode == template.code;

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: () => _selectTemplate(template),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    template.icon,
                    size: 32,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          template.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: template.features.map((feature) => Chip(
                  label: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTemplate(SupplierTemplate template) {
    setState(() {
      _selectedSupplierCode = template.code;
    });

    // Создаем базовую конфигурацию из шаблона
    final service = locator<SupplierService>();
    final config = service.createFromTemplate(template.code);

    if (config != null) {
      final updatedConfig = config.copyWith(
        displayName: _displayNameController.text.isNotEmpty
            ? _displayNameController.text
            : template.name,
      );
      widget.onConfigChanged(updatedConfig);
    }
  }

  void _updateDisplayName(String value) {
    if (widget.config != null) {
      final updatedConfig = widget.config!.copyWith(displayName: value);
      widget.onConfigChanged(updatedConfig);
    }
  }

  void _loadAvailableProfiles() {
    if (_selectedSupplierCode != null) {
      setState(() {
        _availableProfiles = SupplierProfileService.getProfilesForSupplier(_selectedSupplierCode!);
      });
    }
  }

  Widget _buildProfileCard(SupplierProfile profile) {
    final isSelected = _selectedProfileCode == profile.code;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            _getProfileIcon(profile),
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          profile.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : null,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile.description),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: [
                Chip(
                  label: Text(
                    profile.authType.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                Chip(
                  label: Text(
                    profile.connectionMode.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ],
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () => _selectProfile(profile),
      ),
    );
  }

  IconData _getProfileIcon(SupplierProfile profile) {
    if (profile.tags.contains('прокси')) {
      return Icons.security;
    }
    if (profile.tags.contains('альтернатива')) {
      return Icons.alt_route;
    }
    if (profile.tags.contains('пользовательский')) {
      return Icons.tune;
    }
    return Icons.api;
  }

  void _selectProfile(SupplierProfile profile) {
    setState(() {
      _selectedProfileCode = profile.code;
      _displayNameController.text = profile.name;
    });

    // Создаем конфигурацию из профиля
    final config = profile.toConfig(customDisplayName: profile.name);
    widget.onConfigChanged(config);

    // Автоматически выбираем тип поставщика
    setState(() {
      _selectedSupplierCode = profile.code.startsWith('armtek') ? 'armtek' : 'custom';
    });
  }
}

/// Шаблон поставщика
class SupplierTemplate {
  final String code;
  final String name;
  final String description;
  final IconData icon;
  final List<String> features;

  const SupplierTemplate({
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.features,
  });
}