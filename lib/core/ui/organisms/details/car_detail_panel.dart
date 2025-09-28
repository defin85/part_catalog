import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';

import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/core/ui/atoms/typography/index.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';
import 'package:part_catalog/core/ui/organisms/cards/info_card.dart';
import 'package:part_catalog/core/ui/organisms/forms/form_actions_bar.dart';

/// Панель деталей автомобиля для MasterDetail интерфейса
class CarDetailPanel extends StatelessWidget {
  final CarModelComposite? car;
  final ClientModelComposite? owner;
  final bool isLoading;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CarDetailPanel({
    super.key,
    this.car,
    this.owner,
    this.isLoading = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (car == null) {
      return const EmptyStateMessage(
        icon: Icon(Icons.directions_car_outlined),
        title: 'Выберите автомобиль',
        subtitle: 'Выберите автомобиль из списка для просмотра деталей',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: _buildContent(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(
                car!.displayName,
                level: HeadingLevel.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Caption(
                'VIN: ${car!.vin}',
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          tooltip: 'Редактировать',
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          tooltip: 'Удалить',
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InfoCard(
            title: 'Основная информация',
            items: [
              InfoCardItem(
                label: 'Марка',
                value: car!.make,
              ),
              InfoCardItem(
                label: 'Модель',
                value: car!.model,
              ),
              InfoCardItem(
                label: 'Год',
                value: car!.year.toString(),
              ),
              InfoCardItem(
                label: 'VIN',
                value: car!.vin,
              ),
              InfoCardItem(
                label: 'Гос. номер',
                value: car!.displayLicensePlate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          InfoCard(
            title: 'Владелец',
            items: [
              InfoCardItem(
                label: 'Имя',
                value: isLoading ? 'Загрузка...' : (owner?.displayName ?? 'Не найден'),
              ),
            ],
          ),
          if (car!.additionalInfo?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            InfoCard(
              title: 'Дополнительная информация',
              items: [
                InfoCardItem(
                  label: 'Заметки',
                  value: car!.additionalInfo!,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          InfoCard(
            title: 'История заказов',
            items: [
              InfoCardItem(
                label: 'Статус',
                value: 'История заказов появится здесь',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return FormActionsBar(
      actions: [
        FormAction.primary(
          label: 'Редактировать',
          onPressed: onEdit,
          icon: Icons.edit,
        ),
        FormAction.destructive(
          label: 'Удалить',
          onPressed: onDelete,
          icon: Icons.delete,
        ),
      ],
    );
  }
}

