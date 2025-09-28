import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/logging/app_log_store.dart';
import 'package:part_catalog/core/ui/index.dart';

final appLogStoreProvider = ChangeNotifierProvider<AppLogStore>((ref) {
  return appLogStore;
});

/// Экран журналов с использованием новых UI компонентов
class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen>
    with SearchableListMixin {
  Level? _levelFilter;

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(appLogStoreProvider);
    final filtered = _filterLogs(store.records);

    return ListScreenScaffold<LogRecord>.withSearch(
      title: 'Журнал',
      items: filtered,
      searchHint: 'Поиск в журнале...',
      onSearch: updateSearchQuery,
      filterPanel: FilterChipGroup(
        filters: _getLogLevelFilters(),
        onFiltersChanged: (selectedIds) => setState(() {
          final selectedId = selectedIds.isNotEmpty ? selectedIds.first : 'all';
          _levelFilter = selectedId == 'all' ? null : _getLevelFromId(selectedId);
        }),
      ),
      itemBuilder: (context, record, index) => LogRecordCard(record: record),
      emptyState: EmptyStateMessage(
        icon: const Icon(Icons.event_note_outlined),
        title: 'Журнал пуст',
        subtitle: 'Логи будут появляться здесь по мере работы приложения',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () => _clearLogs(store),
          tooltip: 'Очистить',
        ),
      ],
    );
  }

  List<LogRecord> _filterLogs(List<LogRecord> records) {
    return records.where((record) {
      final levelOk = _levelFilter == null || record.level == _levelFilter;
      final queryOk = searchQuery.isEmpty ||
          record.message.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (record.error?.toString().toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      return levelOk && queryOk;
    }).toList();
  }

  List<ChipFilter> _getLogLevelFilters() => [
        ChipFilter(
          id: 'all',
          label: 'Все',
          isSelected: _levelFilter == null,
        ),
        ChipFilter(
          id: 'error',
          label: 'Ошибки',
          isSelected: _levelFilter == Level.error,
        ),
        ChipFilter(
          id: 'warning',
          label: 'Предупреждения',
          isSelected: _levelFilter == Level.warning,
        ),
        ChipFilter(
          id: 'info',
          label: 'Информация',
          isSelected: _levelFilter == Level.info,
        ),
        ChipFilter(
          id: 'debug',
          label: 'Отладка',
          isSelected: _levelFilter == Level.debug,
        ),
      ];

  Level? _getLevelFromId(String id) {
    switch (id) {
      case 'error':
        return Level.error;
      case 'warning':
        return Level.warning;
      case 'info':
        return Level.info;
      case 'debug':
        return Level.debug;
      default:
        return null;
    }
  }

  void _clearLogs(AppLogStore store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить журнал'),
        content: const Text('Вы уверены, что хотите очистить журнал?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              store.clear();
              Navigator.pop(context);
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}

/// Карточка записи лога
class LogRecordCard extends StatelessWidget {
  final LogRecord record;

  const LogRecordCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          _getIconForLevel(record.level),
          color: _getColorForLevel(record.level),
        ),
        title: Text(record.message),
        subtitle: Text(_formatTime(record.time)),
        trailing: record.error != null
            ? IconButton(
                icon: const Icon(Icons.error_outline),
                onPressed: () => _showErrorDetails(context),
              )
            : null,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  IconData _getIconForLevel(Level level) {
    switch (level) {
      case Level.error:
        return Icons.error;
      case Level.warning:
        return Icons.warning;
      case Level.info:
        return Icons.info;
      case Level.debug:
        return Icons.bug_report;
      default:
        return Icons.message;
    }
  }

  Color _getColorForLevel(Level level) {
    switch (level) {
      case Level.error:
        return Colors.red;
      case Level.warning:
        return Colors.orange;
      case Level.info:
        return Colors.blue;
      case Level.debug:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showErrorDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Детали ошибки'),
        content: SingleChildScrollView(
          child: Text(record.error.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}