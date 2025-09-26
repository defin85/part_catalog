import 'package:flutter/material.dart';

/// Секция с вкладками для разделения контента
/// Более гибкая альтернатива стандартному TabBar
class TabSection extends StatefulWidget {
  final List<TabSectionItem> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final TabController? controller;
  final bool isScrollable;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Duration animationDuration;

  const TabSection({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> with TickerProviderStateMixin {
  late TabController _tabController;
  late final bool _shouldDisposeController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _tabController = widget.controller!;
      _shouldDisposeController = false;
    } else {
      _tabController = TabController(
        length: widget.tabs.length,
        initialIndex: widget.initialIndex,
        vsync: this,
        animationDuration: widget.animationDuration,
      );
      _shouldDisposeController = true;
    }

    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    if (_shouldDisposeController) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha:0.3),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            indicatorColor: widget.selectedColor ?? colorScheme.primary,
            labelColor: widget.selectedColor ?? colorScheme.primary,
            unselectedLabelColor: widget.unselectedColor ?? colorScheme.onSurfaceVariant,
            labelStyle: widget.selectedTextStyle ?? theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: widget.unselectedTextStyle ?? theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            padding: widget.padding,
            tabs: widget.tabs.map((tab) {
              return Tab(
                icon: tab.icon,
                text: tab.label,
                iconMargin: tab.icon != null ? const EdgeInsets.only(bottom: 4) : EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }
}

/// Элемент секции с вкладками
class TabSectionItem {
  final String label;
  final Widget content;
  final Widget? icon;
  final String? tooltip;
  final bool enabled;

  const TabSectionItem({
    required this.label,
    required this.content,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });
}

/// Простая реализация секции с вкладками без TabController
class SimpleTabSection extends StatefulWidget {
  final List<TabSectionItem> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const SimpleTabSection({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<SimpleTabSection> createState() => _SimpleTabSectionState();
}

class _SimpleTabSectionState extends State<SimpleTabSection> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, widget.tabs.length - 1);
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex || !widget.tabs[index].enabled) return;

    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha:0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: widget.tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == _selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _onTabTapped(index),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tab.icon != null) ...[
                          Icon(
                            tab.icon is Icon ? (tab.icon as Icon).icon : null,
                            size: 18,
                            color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            tab.label,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Flexible(
          child: widget.tabs.isNotEmpty
            ? widget.tabs[_selectedIndex].content
            : const SizedBox.shrink(),
        ),
      ],
    );
  }
}