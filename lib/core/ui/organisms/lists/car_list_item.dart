import 'package:flutter/material.dart';

import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/core/ui/atoms/typography/index.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';

/// Компонент для отображения автомобиля в списке
class CarListItem extends StatelessWidget {
  final CarModelComposite car;
  final String? ownerName;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? trailing;

  const CarListItem({
    super.key,
    required this.car,
    this.ownerName,
    this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected ? colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.directions_car,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      '${car.make} ${car.model} (${car.year})',
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (ownerName != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Caption(
                            ownerName!,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Caption(
                          car.displayLicensePlate,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const Spacer(),
                        Caption(
                          'VIN: ${car.vin.substring(0, 8)}...',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ] else ...[
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}