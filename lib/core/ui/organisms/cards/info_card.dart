import 'package:flutter/material.dart';

/// Информационная карточка для отображения данных
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final List<InfoCardItem>? items;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool showDividers;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.items,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.showDividers = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
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
                  if (trailing != null) trailing!,
                ],
              ),

              // Элементы данных
              if (items != null && items!.isNotEmpty) ...[
                const SizedBox(height: 16),
                if (showDividers) const Divider(),
                ...items!.map((item) => _buildInfoItem(context, item)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, InfoCardItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 80,
            child: Text(
              '${item.label}:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (item.trailing != null) item.trailing!,
        ],
      ),
    );
  }
}

/// Элемент данных для информационной карточки
class InfoCardItem {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;

  const InfoCardItem({
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
  });
}