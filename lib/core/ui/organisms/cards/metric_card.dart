import 'package:flutter/material.dart';

/// Карточка с метрикой и показателями
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final MetricTrend? trend;
  final String? trendValue;
  final List<MetricItem>? additionalMetrics;
  final Widget? chart;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool compact;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    this.icon,
    this.color,
    this.trend,
    this.trendValue,
    this.additionalMetrics,
    this.chart,
    this.onTap,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с иконкой
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: compact ? 16 : 20,
                        color: effectiveColor,
                      ),
                    ),
                    SizedBox(width: compact ? 8 : 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: (compact
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(context).textTheme.titleSmall)
                          ?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: compact ? 8 : 12),

              // Основное значение метрики
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: (compact
                            ? Theme.of(context).textTheme.headlineSmall
                            : Theme.of(context).textTheme.headlineMedium)
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: effectiveColor,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      unit!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),

              // Подзаголовок и тренд
              if (subtitle != null || trend != null) ...[
                SizedBox(height: compact ? 4 : 8),
                Row(
                  children: [
                    if (subtitle != null)
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    if (trend != null) _buildTrend(context),
                  ],
                ),
              ],

              // График
              if (chart != null) ...[
                SizedBox(height: compact ? 8 : 12),
                SizedBox(
                  height: compact ? 40 : 60,
                  child: chart!,
                ),
              ],

              // Дополнительные метрики
              if (additionalMetrics != null && additionalMetrics!.isNotEmpty) ...[
                SizedBox(height: compact ? 8 : 12),
                const Divider(),
                SizedBox(height: compact ? 4 : 8),
                _buildAdditionalMetrics(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrend(BuildContext context) {
    final trendColor = _getTrendColor(context);
    final trendIcon = _getTrendIcon();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trendIcon, size: 12, color: trendColor),
          if (trendValue != null) ...[
            const SizedBox(width: 2),
            Text(
              trendValue!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalMetrics(BuildContext context) {
    return Column(
      children: additionalMetrics!.map((metric) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                metric.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getTrendColor(BuildContext context) {
    switch (trend!) {
      case MetricTrend.up:
        return Colors.green;
      case MetricTrend.down:
        return Colors.red;
      case MetricTrend.stable:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  IconData _getTrendIcon() {
    switch (trend!) {
      case MetricTrend.up:
        return Icons.trending_up;
      case MetricTrend.down:
        return Icons.trending_down;
      case MetricTrend.stable:
        return Icons.trending_flat;
    }
  }
}

/// Дополнительная метрика
class MetricItem {
  final String label;
  final String value;

  const MetricItem({
    required this.label,
    required this.value,
  });
}

/// Тренд метрики
enum MetricTrend {
  up,
  down,
  stable,
}