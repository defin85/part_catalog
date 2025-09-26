import 'package:flutter/material.dart';

/// Карточка статуса с индикаторами
class StatusCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final StatusCardType status;
  final IconData? customIcon;
  final Color? customColor;
  final String? statusText;
  final List<StatusCardIndicator>? indicators;
  final Widget? action;
  final EdgeInsets? padding;
  final bool compact;

  const StatusCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.status,
    this.customIcon,
    this.customColor,
    this.statusText,
    this.indicators,
    this.action,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(context);

    return Card(
      color: statusInfo.backgroundColor,
      child: Padding(
        padding: padding ?? EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок со статусом
            Row(
              children: [
                Icon(
                  customIcon ?? statusInfo.icon,
                  size: compact ? 20 : 24,
                  color: customColor ?? statusInfo.color,
                ),
                SizedBox(width: compact ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: (compact
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleMedium)
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: compact ? 2 : 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Статус
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (customColor ?? statusInfo.color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: customColor ?? statusInfo.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusText ?? statusInfo.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: customColor ?? statusInfo.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Индикаторы
            if (indicators != null && indicators!.isNotEmpty) ...[
              SizedBox(height: compact ? 12 : 16),
              _buildIndicators(context),
            ],

            // Действие
            if (action != null) ...[
              SizedBox(height: compact ? 12 : 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(BuildContext context) {
    return Column(
      children: indicators!.map((indicator) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicator.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  indicator.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                indicator.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  StatusInfo _getStatusInfo(BuildContext context) {
    switch (status) {
      case StatusCardType.success:
        return StatusInfo(
          icon: Icons.check_circle,
          color: Colors.green,
          label: 'Успешно',
          backgroundColor: Colors.green.withValues(alpha: 0.05),
        );
      case StatusCardType.warning:
        return StatusInfo(
          icon: Icons.warning,
          color: Colors.orange,
          label: 'Внимание',
          backgroundColor: Colors.orange.withValues(alpha: 0.05),
        );
      case StatusCardType.error:
        return StatusInfo(
          icon: Icons.error,
          color: Colors.red,
          label: 'Ошибка',
          backgroundColor: Colors.red.withValues(alpha: 0.05),
        );
      case StatusCardType.info:
        return StatusInfo(
          icon: Icons.info,
          color: Colors.blue,
          label: 'Информация',
          backgroundColor: Colors.blue.withValues(alpha: 0.05),
        );
      case StatusCardType.pending:
        return StatusInfo(
          icon: Icons.schedule,
          color: Colors.grey,
          label: 'Ожидание',
          backgroundColor: Colors.grey.withValues(alpha: 0.05),
        );
    }
  }
}

/// Индикатор для карточки статуса
class StatusCardIndicator {
  final String label;
  final String value;
  final Color color;

  const StatusCardIndicator({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Типы статусных карточек
enum StatusCardType {
  success,
  warning,
  error,
  info,
  pending,
}

/// Информация о статусе
class StatusInfo {
  final IconData icon;
  final Color color;
  final String label;
  final Color backgroundColor;

  const StatusInfo({
    required this.icon,
    required this.color,
    required this.label,
    required this.backgroundColor,
  });
}