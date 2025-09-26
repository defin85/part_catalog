import 'package:flutter/material.dart';

/// Фильтр для группы чипов
class ChipFilter {
  final String id;
  final String label;
  final IconData? icon;
  final Color? color;
  final String? tooltip;
  final bool isSelected;
  final VoidCallback? onTap;

  const ChipFilter({
    required this.id,
    required this.label,
    this.icon,
    this.color,
    this.tooltip,
    this.isSelected = false,
    this.onTap,
  });

  ChipFilter copyWith({
    String? id,
    String? label,
    IconData? icon,
    Color? color,
    String? tooltip,
    bool? isSelected,
    VoidCallback? onTap,
  }) {
    return ChipFilter(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      tooltip: tooltip ?? this.tooltip,
      isSelected: isSelected ?? this.isSelected,
      onTap: onTap ?? this.onTap,
    );
  }
}

/// Группа чипов для фильтрации
/// Используется для создания наборов фильтров в списках и формах поиска
class FilterChipGroup extends StatelessWidget {
  /// Список фильтров
  final List<ChipFilter> filters;

  /// Обработчик изменения выбранных фильтров
  final Function(List<String> selectedIds)? onFiltersChanged;

  /// Заголовок группы фильтров
  final String? title;

  /// Показывать ли кнопку "Очистить всё"
  final bool showClearAll;

  /// Показывать ли счетчик выбранных фильтров
  final bool showSelectedCount;

  /// Максимальное количество строк (прокручиваемая группа)
  final int? maxLines;

  /// Отступы между чипами
  final double spacing;
  final double runSpacing;

  /// Выравнивание чипов
  final WrapAlignment alignment;

  /// Компактный режим
  final bool compact;

  /// Разрешить множественный выбор
  final bool multiSelect;

  /// Анимировать изменения
  final bool animated;

  const FilterChipGroup({
    super.key,
    required this.filters,
    this.onFiltersChanged,
    this.title,
    this.showClearAll = true,
    this.showSelectedCount = false,
    this.maxLines,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.compact = false,
    this.multiSelect = true,
    this.animated = true,
  });

  /// Создает группу с единственным выбором (радио-кнопки)
  const FilterChipGroup.singleSelect({
    super.key,
    required this.filters,
    this.onFiltersChanged,
    this.title,
    this.showClearAll = false,
    this.showSelectedCount = false,
    this.maxLines,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.compact = false,
    this.animated = true,
  }) : multiSelect = false;

  /// Создает компактную группу фильтров
  const FilterChipGroup.compact({
    super.key,
    required this.filters,
    this.onFiltersChanged,
    this.title,
    this.showClearAll = true,
    this.showSelectedCount = false,
    this.maxLines,
    this.spacing = 6,
    this.runSpacing = 6,
    this.alignment = WrapAlignment.start,
    this.animated = true,
    this.multiSelect = true,
  }) : compact = true;

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) _buildHeader(context),
        _buildChips(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final selectedCount = filters.where((f) => f.isSelected).length;

    return Padding(
      padding: EdgeInsets.only(
        bottom: compact ? 8 : 12,
        left: compact ? 4 : 8,
        right: compact ? 4 : 8,
      ),
      child: Row(
        children: [
          Text(
            title!,
            style: (compact
                    ? Theme.of(context).textTheme.titleSmall
                    : Theme.of(context).textTheme.titleMedium)
                ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showSelectedCount && selectedCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$selectedCount',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (showClearAll && selectedCount > 0)
            TextButton(
              onPressed: _clearAll,
              style: TextButton.styleFrom(
                padding: compact
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                    : null,
                minimumSize: compact ? const Size(0, 32) : null,
              ),
              child: Text(
                'Очистить',
                style: compact
                    ? Theme.of(context).textTheme.bodySmall
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    Widget chipsWidget = Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: filters.map((filter) => _buildChip(context, filter)).toList(),
    );

    if (maxLines != null) {
      chipsWidget = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: (compact ? 32 : 40) * maxLines! + runSpacing * (maxLines! - 1),
        ),
        child: SingleChildScrollView(
          child: chipsWidget,
        ),
      );
    }

    if (animated) {
      chipsWidget = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: chipsWidget,
      );
    }

    return chipsWidget;
  }

  Widget _buildChip(BuildContext context, ChipFilter filter) {
    Widget chip;

    if (multiSelect) {
      chip = FilterChip(
        label: Text(
          filter.label,
          style: compact ? Theme.of(context).textTheme.bodySmall : null,
        ),
        avatar: filter.icon != null
            ? Icon(
                filter.icon,
                size: compact ? 16 : 18,
              )
            : null,
        selected: filter.isSelected,
        onSelected: (selected) => _toggleFilter(filter.id, selected),
        backgroundColor: filter.color?.withValues(alpha: 0.1),
        selectedColor: filter.color?.withValues(alpha: 0.2) ??
            Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: filter.color ?? Theme.of(context).colorScheme.primary,
        side: filter.isSelected && filter.color != null
            ? BorderSide(color: filter.color!)
            : null,
        materialTapTargetSize: compact
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
        visualDensity: compact
            ? VisualDensity.compact
            : VisualDensity.standard,
      );
    } else {
      // Для одиночного выбора используем ChoiceChip
      chip = ChoiceChip(
        label: Text(
          filter.label,
          style: compact ? Theme.of(context).textTheme.bodySmall : null,
        ),
        avatar: filter.icon != null
            ? Icon(
                filter.icon,
                size: compact ? 16 : 18,
              )
            : null,
        selected: filter.isSelected,
        onSelected: (selected) {
          if (selected) {
            _selectSingle(filter.id);
          }
        },
        selectedColor: filter.color?.withValues(alpha: 0.2) ??
            Theme.of(context).colorScheme.primaryContainer,
        backgroundColor: filter.color?.withValues(alpha: 0.1),
        side: filter.isSelected && filter.color != null
            ? BorderSide(color: filter.color!)
            : null,
        materialTapTargetSize: compact
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
        visualDensity: compact
            ? VisualDensity.compact
            : VisualDensity.standard,
      );
    }

    // Добавляем анимацию если включена
    if (animated) {
      chip = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: chip,
      );
    }

    // Добавляем tooltip если есть
    if (filter.tooltip != null) {
      chip = Tooltip(
        message: filter.tooltip!,
        child: chip,
      );
    }

    return chip;
  }

  void _toggleFilter(String filterId, bool isSelected) {
    final currentSelected = filters
        .where((f) => f.isSelected)
        .map((f) => f.id)
        .toList();

    List<String> newSelected;

    if (isSelected) {
      newSelected = [...currentSelected, filterId];
    } else {
      newSelected = currentSelected.where((id) => id != filterId).toList();
    }

    onFiltersChanged?.call(newSelected);
  }

  void _selectSingle(String filterId) {
    onFiltersChanged?.call([filterId]);
  }

  void _clearAll() {
    onFiltersChanged?.call([]);
  }
}

/// Утилитарный класс для создания популярных наборов фильтров
class CommonFilters {
  /// Фильтры статусов
  static List<ChipFilter> status({
    required List<String> selectedIds,
  }) {
    return [
      ChipFilter(
        id: 'active',
        label: 'Активные',
        icon: Icons.check_circle_outline,
        color: Colors.green,
        isSelected: selectedIds.contains('active'),
      ),
      ChipFilter(
        id: 'inactive',
        label: 'Неактивные',
        icon: Icons.pause_circle_outline,
        color: Colors.orange,
        isSelected: selectedIds.contains('inactive'),
      ),
      ChipFilter(
        id: 'deleted',
        label: 'Удаленные',
        icon: Icons.delete_outline,
        color: Colors.red,
        isSelected: selectedIds.contains('deleted'),
      ),
    ];
  }

  /// Фильтры по времени
  static List<ChipFilter> timeRange({
    required List<String> selectedIds,
  }) {
    return [
      ChipFilter(
        id: 'today',
        label: 'Сегодня',
        icon: Icons.today,
        isSelected: selectedIds.contains('today'),
      ),
      ChipFilter(
        id: 'week',
        label: 'Неделя',
        icon: Icons.date_range,
        isSelected: selectedIds.contains('week'),
      ),
      ChipFilter(
        id: 'month',
        label: 'Месяц',
        icon: Icons.calendar_month,
        isSelected: selectedIds.contains('month'),
      ),
      ChipFilter(
        id: 'year',
        label: 'Год',
        icon: Icons.calendar_today,
        isSelected: selectedIds.contains('year'),
      ),
    ];
  }

  /// Фильтры приоритета
  static List<ChipFilter> priority({
    required List<String> selectedIds,
  }) {
    return [
      ChipFilter(
        id: 'high',
        label: 'Высокий',
        icon: Icons.priority_high,
        color: Colors.red,
        isSelected: selectedIds.contains('high'),
      ),
      ChipFilter(
        id: 'medium',
        label: 'Средний',
        icon: Icons.remove,
        color: Colors.orange,
        isSelected: selectedIds.contains('medium'),
      ),
      ChipFilter(
        id: 'low',
        label: 'Низкий',
        icon: Icons.keyboard_arrow_down,
        color: Colors.green,
        isSelected: selectedIds.contains('low'),
      ),
    ];
  }
}