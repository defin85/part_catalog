import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_colors.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';

/// Панель деталей клиента для использования в MasterDetailScaffold
///
/// Отображает:
/// - Основную информацию о клиенте
/// - Контактные данные
/// - Системную информацию
/// - Кнопки действий
class ClientDetailPanel extends StatelessWidget {
  const ClientDetailPanel({
    super.key,
    required this.client,
    this.onEdit,
    this.onDelete,
    this.onCall,
    this.onEmail,
  });

  final ClientModelComposite client;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCall;
  final VoidCallback? onEmail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainInfoCard(context),
          const SizedBox(height: 16),
          _buildContactCard(context),
          const SizedBox(height: 16),
          _buildSystemInfoCard(context),
          const SizedBox(height: 16),
          _buildActionsCard(context),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Основная информация',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: client.clientData.isIndividual
                      ? AppColors.client.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
                  child: Icon(
                    client.clientData.isIndividual
                        ? Icons.person
                        : Icons.business,
                    size: 30,
                    color: client.clientData.isIndividual
                        ? AppColors.client
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.clientData.displayName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client.clientData.isIndividual
                            ? 'Физическое лицо'
                            : 'Юридическое лицо',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (client.coreData.isDeleted) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 16,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Удален',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final hasPhone = client.clientData.phone?.isNotEmpty == true;
    final hasEmail = client.clientData.email?.isNotEmpty == true;

    if (!hasPhone && !hasEmail) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Контактная информация',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Контактная информация не указана',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Контактная информация',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            if (hasPhone)
              _ContactInfoRow(
                icon: Icons.phone,
                label: 'Телефон',
                value: client.clientData.phone!,
                onTap: onCall,
                actionIcon: Icons.call,
              ),

            if (hasPhone && hasEmail)
              const SizedBox(height: 12),

            if (hasEmail)
              _ContactInfoRow(
                icon: Icons.email,
                label: 'Email',
                value: client.clientData.email!,
                onTap: onEmail,
                actionIcon: Icons.mail,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Системная информация',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            _SystemInfoRow(
              icon: Icons.key,
              label: 'UUID',
              value: client.uuid,
            ),
            const SizedBox(height: 8),
            _SystemInfoRow(
              icon: Icons.access_time,
              label: 'Создан',
              value: _formatDateTime(client.coreData.createdAt),
            ),
            const SizedBox(height: 8),
            _SystemInfoRow(
              icon: Icons.update,
              label: 'Изменен',
              value: _formatDateTime(client.coreData.modifiedAt),
            ),
            if (client.coreData.deletedAt != null) ...[
              const SizedBox(height: 8),
              _SystemInfoRow(
                icon: Icons.delete,
                label: 'Удален',
                value: _formatDateTime(client.coreData.deletedAt!),
                valueColor: AppColors.error,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Действия',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onEdit != null)
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Редактировать'),
                    ),

                  if (!client.coreData.isDeleted && onDelete != null)
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text('Удалить'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                      ),
                    ),

                  if (client.clientData.phone?.isNotEmpty == true && onCall != null)
                    OutlinedButton.icon(
                      onPressed: onCall,
                      icon: const Icon(Icons.call),
                      label: const Text('Позвонить'),
                    ),

                  if (client.clientData.email?.isNotEmpty == true && onEmail != null)
                    OutlinedButton.icon(
                      onPressed: onEmail,
                      icon: const Icon(Icons.mail),
                      label: const Text('Написать'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Не указано';
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Строка контактной информации с возможностью действия
class _ContactInfoRow extends StatelessWidget {
  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.actionIcon,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(label),
        subtitle: SelectableText(value),
        trailing: onTap != null && actionIcon != null
            ? IconButton(
                icon: Icon(actionIcon),
                onPressed: onTap,
                tooltip: 'Действие с $label',
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

/// Строка системной информации
class _SystemInfoRow extends StatelessWidget {
  const _SystemInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}