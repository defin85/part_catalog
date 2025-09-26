import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_colors.dart';
import 'package:part_catalog/core/ui/molecules/status_indicator.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';

/// Элемент списка клиентов с поддержкой выделения и статусов
///
/// Отображает:
/// - Аватар с иконкой типа клиента
/// - Имя и контактную информацию
/// - Статусы и индикаторы
/// - Поддержку выделения и действий
class ClientListItem extends StatelessWidget {
  const ClientListItem({
    super.key,
    required this.client,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.showDetails = true,
  });

  final ClientModelComposite client;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: _buildAvatar(),
        title: _buildTitle(context),
        subtitle: showDetails ? _buildSubtitle(context) : null,
        trailing: _buildTrailing(context),
        isThreeLine: showDetails && _hasMultipleContacts(),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: client.clientData.isIndividual
          ? AppColors.client.withValues(alpha: 0.2)
          : AppColors.primary.withValues(alpha: 0.2),
      child: Icon(
        client.clientData.isIndividual
            ? Icons.person
            : Icons.business,
        color: client.clientData.isIndividual
            ? AppColors.client
            : AppColors.primary,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            client.clientData.displayName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
        if (client.coreData.isDeleted) ...[
          const SizedBox(width: 8),
          StatusIndicator.error(
            'Удален',
            size: StatusSize.small,
          ),
        ],
      ],
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final hasPhone = client.clientData.phone?.isNotEmpty == true;
    final hasEmail = client.clientData.email?.isNotEmpty == true;

    if (!hasPhone && !hasEmail) {
      return Text(
        'Контактная информация не указана',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhone)
          _ContactInfo(
            icon: Icons.phone,
            text: client.clientData.phone!,
          ),
        if (hasEmail)
          _ContactInfo(
            icon: Icons.email,
            text: client.clientData.email!,
          ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          client.clientData.isIndividual ? 'Физ. л.' : 'Юр. л.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: client.clientData.isIndividual
                ? AppColors.client
                : AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: 4),
          Icon(
            Icons.check_circle,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ],
    );
  }

  bool _hasMultipleContacts() {
    final hasPhone = client.clientData.phone?.isNotEmpty == true;
    final hasEmail = client.clientData.email?.isNotEmpty == true;
    return hasPhone && hasEmail;
  }
}

/// Компонент для отображения контактной информации
class _ContactInfo extends StatelessWidget {
  const _ContactInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Предустановленные варианты элементов списка клиентов
class ClientListItemPresets {

  /// Компактный элемент списка без деталей
  static ClientListItem compact({
    Key? key,
    required ClientModelComposite client,
    bool isSelected = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return ClientListItem(
      key: key,
      client: client,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      showDetails: false,
    );
  }

  /// Полный элемент списка с деталями
  static ClientListItem detailed({
    Key? key,
    required ClientModelComposite client,
    bool isSelected = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return ClientListItem(
      key: key,
      client: client,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      showDetails: true,
    );
  }
}