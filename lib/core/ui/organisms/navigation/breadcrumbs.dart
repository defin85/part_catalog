import 'package:flutter/material.dart';

/// Компонент хлебных крошек для навигации
/// Показывает путь к текущей странице и позволяет быстро переходить
class Breadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final String separator;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final Color? separatorColor;
  final EdgeInsets? padding;
  final MainAxisAlignment alignment;
  final bool showHomeIcon;
  final Widget? homeIcon;
  final VoidCallback? onHomePressed;
  final int? maxItems;

  const Breadcrumbs({
    super.key,
    required this.items,
    this.separator = '›',
    this.textStyle,
    this.activeTextStyle,
    this.separatorColor,
    this.padding,
    this.alignment = MainAxisAlignment.start,
    this.showHomeIcon = false,
    this.homeIcon,
    this.onHomePressed,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (items.isEmpty) return const SizedBox.shrink();

    List<BreadcrumbItem> displayItems = items;

    // Ограничиваем количество элементов если указано
    if (maxItems != null && items.length > maxItems!) {
      final skipCount = items.length - maxItems! + 1; // +1 для многоточия
      displayItems = [
        items.first,
        BreadcrumbItem(title: '...', onTap: null),
        ...items.skip(skipCount),
      ];
    }

    final defaultTextStyle = textStyle ?? theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    final defaultActiveTextStyle = activeTextStyle ?? theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    );

    final separatorStyle = TextStyle(
      color: separatorColor ?? colorScheme.onSurfaceVariant.withValues(alpha:0.6),
    );

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          // Home icon
          if (showHomeIcon) ...[
            InkWell(
              onTap: onHomePressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: homeIcon ?? Icon(
                  Icons.home,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (displayItems.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(separator, style: separatorStyle),
              const SizedBox(width: 8),
            ],
          ],
          // Breadcrumb items
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildBreadcrumbWidgets(
                  displayItems,
                  defaultTextStyle,
                  defaultActiveTextStyle,
                  separatorStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBreadcrumbWidgets(
    List<BreadcrumbItem> items,
    TextStyle? defaultStyle,
    TextStyle? activeStyle,
    TextStyle separatorStyle,
  ) {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;
      final style = isLast ? activeStyle : defaultStyle;

      // Breadcrumb item
      if (item.onTap != null && !isLast) {
        widgets.add(
          InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 14,
                      color: style?.color,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    item.title,
                    style: style?.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: style.color?.withValues(alpha:0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 14,
                  color: style?.color,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                item.title,
                style: style,
              ),
            ],
          ),
        );
      }

      // Separator
      if (!isLast) {
        widgets.add(const SizedBox(width: 8));
        widgets.add(Text(separator, style: separatorStyle));
        widgets.add(const SizedBox(width: 8));
      }
    }

    return widgets;
  }
}

/// Элемент хлебных крошек
class BreadcrumbItem {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? tooltip;

  const BreadcrumbItem({
    required this.title,
    this.onTap,
    this.icon,
    this.tooltip,
  });
}

/// Адаптивные хлебные крошки, которые сворачиваются на мобильных
class AdaptiveBreadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final double mobileBreakpoint;

  const AdaptiveBreadcrumbs({
    super.key,
    required this.items,
    this.mobileBreakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;

        if (isMobile && items.length > 2) {
          // На мобильных показываем только последние 2 элемента
          return Breadcrumbs(
            items: items.length > 2 ? items.sublist(items.length - 2) : items,
            showHomeIcon: true,
            onHomePressed: items.isNotEmpty ? items.first.onTap : null,
            maxItems: 2,
          );
        }

        return Breadcrumbs(
          items: items,
          showHomeIcon: true,
          onHomePressed: items.isNotEmpty ? items.first.onTap : null,
        );
      },
    );
  }
}

/// Готовые breadcrumbs для типичных случаев использования
class AppBreadcrumbs {
  /// Создает breadcrumbs для экрана списка
  static List<BreadcrumbItem> forList({
    required String sectionName,
    VoidCallback? onHomePressed,
    VoidCallback? onSectionPressed,
  }) {
    return [
      BreadcrumbItem(
        title: 'Главная',
        icon: Icons.home,
        onTap: onHomePressed,
      ),
      BreadcrumbItem(
        title: sectionName,
        onTap: onSectionPressed,
      ),
    ];
  }

  /// Создает breadcrumbs для экрана детализации
  static List<BreadcrumbItem> forDetail({
    required String sectionName,
    required String itemName,
    VoidCallback? onHomePressed,
    VoidCallback? onSectionPressed,
  }) {
    return [
      BreadcrumbItem(
        title: 'Главная',
        icon: Icons.home,
        onTap: onHomePressed,
      ),
      BreadcrumbItem(
        title: sectionName,
        onTap: onSectionPressed,
      ),
      BreadcrumbItem(
        title: itemName,
        onTap: null, // Текущая страница, не кликабельна
      ),
    ];
  }

  /// Создает breadcrumbs для настроек
  static List<BreadcrumbItem> forSettings({
    required String settingsSection,
    String? subSection,
    VoidCallback? onHomePressed,
    VoidCallback? onSettingsPressed,
    VoidCallback? onSectionPressed,
  }) {
    final items = [
      BreadcrumbItem(
        title: 'Главная',
        icon: Icons.home,
        onTap: onHomePressed,
      ),
      BreadcrumbItem(
        title: 'Настройки',
        icon: Icons.settings,
        onTap: onSettingsPressed,
      ),
      BreadcrumbItem(
        title: settingsSection,
        onTap: subSection != null ? onSectionPressed : null,
      ),
    ];

    if (subSection != null) {
      items.add(BreadcrumbItem(
        title: subSection,
        onTap: null,
      ));
    }

    return items;
  }
}