import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/logging/app_log_store.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

final appLogStoreProvider = ChangeNotifierProvider<AppLogStore>((ref) {
  // Возвращаем глобальный инстанс, чтобы лог-аутпут писал в тот же стор
  return appLogStore;
});

class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen> {
  Level? _levelFilter; // null = все
  String _query = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(appLogStoreProvider);
    final filtered = store.records.where((r) {
      final levelOk = _levelFilter == null || r.level == _levelFilter;
      final queryOk = _query.isEmpty ||
          r.message.toLowerCase().contains(_query.toLowerCase()) ||
          (r.error?.toString().toLowerCase().contains(_query.toLowerCase()) ??
              false);
      return levelOk && queryOk;
    }).toList(growable: false);

    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildLogsContent(context, store, filtered, isTablet: false),
      medium: (context, constraints) => _buildLogsContent(context, store, filtered, isTablet: true),
      large: (context, constraints) => _buildLogsContent(context, store, filtered, isTablet: true),
    );
  }

  Widget _buildLogsContent(BuildContext context, AppLogStore store, List<dynamic> filtered, {required bool isTablet}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
          child: isTablet ? _buildTabletControls(store) : _buildMobileControls(store),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final r = filtered[filtered.length - 1 - index];
              return _buildLogTile(context, r, isTablet: isTablet);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileControls(AppLogStore store) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton<Level?>(
              value: _levelFilter,
              hint: const Text('Уровень: все'),
              items: <Level?>[null, Level.debug, Level.info, Level.warning, Level.error]
                  .map((lvl) => DropdownMenuItem<Level?>(
                        value: lvl,
                        child: Text(_titleForLevel(lvl)),
                      ))
                  .toList(),
              onChanged: (lvl) => setState(() => _levelFilter = lvl),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: store.paused ? 'Возобновить' : 'Пауза',
              onPressed: () => store.setPaused(!store.paused),
              icon: Icon(store.paused ? Icons.play_arrow : Icons.pause),
            ),
            IconButton(
              tooltip: 'Очистить',
              onPressed: store.clear,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Поиск по сообщению/ошибке',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ],
    );
  }

  Widget _buildTabletControls(AppLogStore store) {
    return Row(
      children: [
        DropdownButton<Level?>(
          value: _levelFilter,
          hint: const Text('Уровень: все'),
          items: <Level?>[null, Level.debug, Level.info, Level.warning, Level.error]
              .map((lvl) => DropdownMenuItem<Level?>(
                    value: lvl,
                    child: Text(_titleForLevel(lvl)),
                  ))
              .toList(),
          onChanged: (lvl) => setState(() => _levelFilter = lvl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Поиск по сообщению/ошибке',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: store.paused ? 'Возобновить' : 'Пауза',
          onPressed: () => store.setPaused(!store.paused),
          icon: Icon(store.paused ? Icons.play_arrow : Icons.pause),
        ),
        IconButton(
          tooltip: 'Очистить',
          onPressed: store.clear,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  Widget _buildLogTile(BuildContext context, dynamic r, {required bool isTablet}) {
    return ExpansionTile(
      leading: Icon(_iconFor(r.level), color: _colorFor(r.level)),
      title: Text(
        _summaryOf(r.message),
        maxLines: isTablet ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${_formatTime(r.time)} • ${r.level.name}'),
      childrenPadding: EdgeInsets.fromLTRB(isTablet ? 24 : 16, 0, isTablet ? 24 : 16, 12),
      children: [
        const Text('Сообщение:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        SelectableText(r.message),
        const SizedBox(height: 12),
        if (r.error != null) ...[
          const Text('Ошибка:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(r.error.toString()),
          const SizedBox(height: 12),
        ],
        if (r.stackTrace != null) ...[
          const Text('StackTrace:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(r.stackTrace.toString()),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () async {
                final text = _composeFullText(r);
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Скопировано')),
                  );
                }
              },
              icon: const Icon(Icons.copy_all_outlined),
              label: const Text('Копировать'),
            ),
          ],
        ),
      ],
    );
  }

  String _titleForLevel(Level? level) {
    switch (level) {
      case null:
        return 'Все';
      case Level.debug:
        return 'Debug';
      case Level.info:
        return 'Info';
      case Level.warning:
        return 'Warning';
      case Level.error:
        return 'Error';
      default:
        return level.name;
    }
  }
}

String _summaryOf(String message) {
  final firstLine = message.split('\n').first.trim();
  return firstLine.isEmpty ? '(пустое сообщение)' : firstLine;
}

String _formatTime(DateTime time) {
  final t = time.toLocal().toIso8601String();
  // Быстрое форматирование HH:MM:SS
  final hhmmss = t.split('T').last.split('.').first;
  return hhmmss;
}

Color _colorFor(Level level) {
  switch (level) {
    case Level.error:
      return Colors.red;
    case Level.warning:
      return Colors.orange;
    case Level.info:
      return Colors.blueGrey;
    case Level.debug:
      return Colors.blue;
    default:
      return Colors.black87;
  }
}

IconData _iconFor(Level level) {
  switch (level) {
    case Level.error:
      return Icons.error_outline;
    case Level.warning:
      return Icons.warning_amber_outlined;
    case Level.info:
      return Icons.info_outline;
    case Level.debug:
      return Icons.bug_report_outlined;
    default:
      return Icons.notes;
  }
}

// подробности теперь показываются через ExpansionTile

String _composeFullText(LogRecord r) {
  final b = StringBuffer()
    ..writeln('[${r.level.name}] ${r.time.toIso8601String()}')
    ..writeln(r.message);
  if (r.error != null) {
    b
      ..writeln('--- Error ---')
      ..writeln(r.error);
  }
  if (r.stackTrace != null) {
    b
      ..writeln('--- StackTrace ---')
      ..writeln(r.stackTrace);
  }
  return b.toString();
}
