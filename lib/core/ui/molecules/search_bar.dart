import 'dart:async';
import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/atoms/inputs/text_input.dart';

/// Поисковая строка с поддержкой debounce и дополнительных функций
class SearchBarMolecule extends StatefulWidget {
  final String? hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final Duration debounceDuration;
  final bool enabled;
  final InputSize size;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showClearButton;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const SearchBarMolecule({
    super.key,
    this.hint,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
    this.size = InputSize.medium,
    this.leading,
    this.actions,
    this.showClearButton = true,
    this.autofocus = false,
    this.focusNode,
    this.controller,
  });

  @override
  State<SearchBarMolecule> createState() => _SearchBarMoleculeState();
}

class _SearchBarMoleculeState extends State<SearchBarMolecule> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounceTimer;
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.value != null) {
      _controller.text = widget.value!;
      _lastValue = widget.value!;
    }

    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SearchBarMolecule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
      _lastValue = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final currentValue = _controller.text;
    if (currentValue == _lastValue) return;

    _lastValue = currentValue;

    // Отменяем предыдущий таймер
    _debounceTimer?.cancel();

    // Если поле пустое, вызываем onChange сразу
    if (currentValue.isEmpty) {
      widget.onChanged?.call(currentValue);
      return;
    }

    // Устанавливаем новый таймер для debounce
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted) {
        widget.onChanged?.call(currentValue);
      }
    });
  }

  void _onClear() {
    _controller.clear();
    _lastValue = '';
    _debounceTimer?.cancel();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: TextInput.search(
            controller: _controller,
            focusNode: _focusNode,
            hint: widget.hint ?? 'Поиск...',
            enabled: widget.enabled,
            size: widget.size,
            autofocus: widget.autofocus,
            onTap: widget.enabled ? null : () {},
            suffixIcon: _buildSuffixIcon(),
            textInputAction: TextInputAction.search,
            onChanged: null, // Мы обрабатываем изменения через controller
          ),
        ),
        if (widget.actions != null) ...[
          const SizedBox(width: AppSpacing.sm),
          ...widget.actions!,
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    final hasText = _controller.text.isNotEmpty;

    if (widget.showClearButton && hasText && widget.enabled) {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: _onClear,
        tooltip: 'Очистить поиск',
        iconSize: _getIconSize(),
      );
    }

    return null;
  }

  double _getIconSize() {
    switch (widget.size) {
      case InputSize.small:
        return AppSizes.iconSm;
      case InputSize.medium:
        return AppSizes.iconMd;
      case InputSize.large:
        return AppSizes.iconLg;
    }
  }
}

/// Простая поисковая строка для быстрого использования
class QuickSearchBar extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const QuickSearchBar({
    super.key,
    this.hint,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBarMolecule(
      hint: hint,
      onChanged: onChanged,
      enabled: enabled,
      showClearButton: true,
      debounceDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Поисковая строка с предустановленными фильтрами
class SearchBarWithFilters extends StatefulWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final List<SearchFilter> filters;
  final ValueChanged<List<SearchFilter>>? onFiltersChanged;
  final bool enabled;

  const SearchBarWithFilters({
    super.key,
    this.hint,
    this.onChanged,
    required this.filters,
    this.onFiltersChanged,
    this.enabled = true,
  });

  @override
  State<SearchBarWithFilters> createState() => _SearchBarWithFiltersState();
}

class _SearchBarWithFiltersState extends State<SearchBarWithFilters> {
  late List<SearchFilter> _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = List.from(widget.filters);
  }

  void _toggleFilter(SearchFilter filter) {
    setState(() {
      final index = _currentFilters.indexWhere((f) => f.id == filter.id);
      if (index >= 0) {
        _currentFilters[index] = filter.copyWith(isActive: !filter.isActive);
      }
    });
    widget.onFiltersChanged?.call(_currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarMolecule(
          hint: widget.hint,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          actions: [
            if (_currentFilters.any((f) => f.isActive))
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () => _showFiltersMenu(context),
                tooltip: 'Фильтры',
              ),
          ],
        ),
        if (_currentFilters.any((f) => f.isActive)) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _currentFilters
                .where((f) => f.isActive)
                .map((filter) => _buildFilterChip(filter))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterChip(SearchFilter filter) {
    return FilterChip(
      label: Text(filter.label),
      selected: filter.isActive,
      onSelected: (_) => _toggleFilter(filter),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () => _toggleFilter(filter),
    );
  }

  void _showFiltersMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 0, 0, 0),
      items: _currentFilters.map((filter) {
        return PopupMenuItem<SearchFilter>(
          value: filter,
          child: Row(
            children: [
              Icon(
                filter.isActive ? Icons.check_box : Icons.check_box_outline_blank,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(filter.label)),
            ],
          ),
        );
      }).toList(),
    ).then((selectedFilter) {
      if (selectedFilter != null) {
        _toggleFilter(selectedFilter);
      }
    });
  }
}

/// Модель фильтра для поиска
class SearchFilter {
  final String id;
  final String label;
  final bool isActive;
  final dynamic value;

  const SearchFilter({
    required this.id,
    required this.label,
    this.isActive = false,
    this.value,
  });

  SearchFilter copyWith({
    String? id,
    String? label,
    bool? isActive,
    dynamic value,
  }) {
    return SearchFilter(
      id: id ?? this.id,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilter && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}