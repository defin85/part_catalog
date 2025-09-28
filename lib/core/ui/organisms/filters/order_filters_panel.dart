import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/molecules/filter_chip_group.dart';
import 'package:part_catalog/features/core/document_status.dart';

/// Панель поиска и фильтров для заказов
class OrderFiltersPanel extends StatelessWidget {
  final String searchQuery;
  final String statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusFilterChanged;

  const OrderFiltersPanel({
    super.key,
    required this.searchQuery,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Поиск
          TextField(
            decoration: const InputDecoration(
              hintText: 'Поиск заказов по номеру',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          // Фильтры статуса
          FilterChipGroup(
            filters: [
              ChipFilter(
                id: '',
                label: 'Все',
                isSelected: statusFilter.isEmpty,
              ),
              ChipFilter(
                id: DocumentStatus.inProgress.name,
                label: DocumentStatus.inProgress.displayName,
                isSelected: statusFilter == DocumentStatus.inProgress.name,
              ),
              ChipFilter(
                id: DocumentStatus.completed.name,
                label: DocumentStatus.completed.displayName,
                isSelected: statusFilter == DocumentStatus.completed.name,
              ),
              ChipFilter(
                id: DocumentStatus.cancelled.name,
                label: DocumentStatus.cancelled.displayName,
                isSelected: statusFilter == DocumentStatus.cancelled.name,
              ),
              ChipFilter(
                id: DocumentStatus.posted.name,
                label: DocumentStatus.posted.displayName,
                isSelected: statusFilter == DocumentStatus.posted.name,
              ),
            ],
            onFiltersChanged: (selectedIds) {
              final newFilter = selectedIds.isNotEmpty ? selectedIds.first : '';
              onStatusFilterChanged(newFilter);
            },
            multiSelect: false,
          ),
        ],
      ),
    );
  }
}