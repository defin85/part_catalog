import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/atoms/buttons/primary_button.dart';
import 'package:part_catalog/core/ui/molecules/loading_overlay.dart';

/// Карточка для тестирования подключений к внешним сервисам
/// Отображает статус соединения и позволяет запускать тесты
class ConnectionTestCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final ConnectionTestStatus status;
  final String? lastTestTime;
  final String? statusMessage;
  final List<ConnectionTestStep>? testSteps;
  final VoidCallback? onTestPressed;
  final VoidCallback? onConfigurePressed;
  final bool isLoading;
  final bool showDetails;
  final Map<String, dynamic>? connectionParams;
  final Duration? timeout;

  const ConnectionTestCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.status,
    this.lastTestTime,
    this.statusMessage,
    this.testSteps,
    this.onTestPressed,
    this.onConfigurePressed,
    this.isLoading = false,
    this.showDetails = true,
    this.connectionParams,
    this.timeout,
  });

  @override
  State<ConnectionTestCard> createState() => _ConnectionTestCardState();
}

class _ConnectionTestCardState extends State<ConnectionTestCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(theme, colorScheme),

              // Details (expandable)
              if (_isExpanded && widget.showDetails) ...[
                const Divider(height: 1),
                _buildDetails(theme, colorScheme),
              ],

              // Actions
              _buildActions(theme, colorScheme),
            ],
          ),

          // Loading overlay
          if (widget.isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LoadingOverlay(
                  isLoading: true,
                  message: 'Тестирование соединения...',
                  child: Container(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return InkWell(
      onTap: widget.showDetails ? () => setState(() => _isExpanded = !_isExpanded) : null,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            if (widget.icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 24,
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Status indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.lastTestTime != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.lastTestTime!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),

            // Expand icon
            if (widget.showDetails) ...[
              const SizedBox(width: 8),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status message
          if (widget.statusMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor().withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: 16,
                    color: _getStatusColor(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.statusMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Test steps
          if (widget.testSteps != null && widget.testSteps!.isNotEmpty) ...[
            Text(
              'Результаты тестирования:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.testSteps!.map((step) => _buildTestStep(step, theme, colorScheme)),
            const SizedBox(height: 12),
          ],

          // Connection parameters
          if (widget.connectionParams != null && widget.connectionParams!.isNotEmpty) ...[
            Text(
              'Параметры подключения:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.connectionParams!.entries.map((entry) => _buildParameter(
              entry.key,
              entry.value.toString(),
              theme,
              colorScheme,
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildTestStep(ConnectionTestStep step, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            step.isSuccess ? Icons.check_circle : Icons.error,
            size: 16,
            color: step.isSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              step.name,
              style: theme.textTheme.bodySmall,
            ),
          ),
          if (step.duration != null)
            Text(
              '${step.duration!.inMilliseconds}ms',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParameter(String key, String value, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$key:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _isSecureField(key) ? _maskValue(value) : value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          if (widget.onTestPressed != null)
            PrimaryButton(
              onPressed: widget.isLoading ? null : widget.onTestPressed,
              text: 'Тестировать',
              icon: const Icon(Icons.play_arrow, size: 16),
              size: ButtonSize.small,
            ),
          const SizedBox(width: 8),
          if (widget.onConfigurePressed != null)
            OutlinedButton.icon(
              onPressed: widget.onConfigurePressed,
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('Настроить'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: theme.textTheme.bodySmall,
              ),
            ),
          const Spacer(),
          if (widget.timeout != null)
            Text(
              'Таймаут: ${widget.timeout!.inSeconds}с',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case ConnectionTestStatus.success:
        return Colors.green;
      case ConnectionTestStatus.failed:
        return Colors.red;
      case ConnectionTestStatus.warning:
        return Colors.orange;
      case ConnectionTestStatus.pending:
        return Colors.grey;
      case ConnectionTestStatus.testing:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.status) {
      case ConnectionTestStatus.success:
        return Icons.check_circle;
      case ConnectionTestStatus.failed:
        return Icons.error;
      case ConnectionTestStatus.warning:
        return Icons.warning;
      case ConnectionTestStatus.pending:
        return Icons.schedule;
      case ConnectionTestStatus.testing:
        return Icons.sync;
    }
  }

  String _getStatusText() {
    switch (widget.status) {
      case ConnectionTestStatus.success:
        return 'Подключен';
      case ConnectionTestStatus.failed:
        return 'Ошибка';
      case ConnectionTestStatus.warning:
        return 'Предупреждение';
      case ConnectionTestStatus.pending:
        return 'Ожидание';
      case ConnectionTestStatus.testing:
        return 'Тестируется';
    }
  }

  bool _isSecureField(String key) {
    final secureFields = ['password', 'token', 'key', 'secret', 'pass'];
    return secureFields.any((field) => key.toLowerCase().contains(field));
  }

  String _maskValue(String value) {
    if (value.length <= 4) return '***';
    return '${value.substring(0, 2)}***${value.substring(value.length - 2)}';
  }
}

/// Статус тестирования соединения
enum ConnectionTestStatus {
  success,
  failed,
  warning,
  pending,
  testing,
}

/// Шаг тестирования соединения
class ConnectionTestStep {
  final String name;
  final bool isSuccess;
  final Duration? duration;
  final String? errorMessage;

  const ConnectionTestStep({
    required this.name,
    required this.isSuccess,
    this.duration,
    this.errorMessage,
  });
}

/// Предустановленные конфигурации для разных типов соединений
class ConnectionTestPresets {
  /// Тест HTTP API соединения
  static ConnectionTestCard httpApi({
    required String title,
    required String url,
    required ConnectionTestStatus status,
    VoidCallback? onTest,
    VoidCallback? onConfigure,
    String? lastTestTime,
    List<ConnectionTestStep>? steps,
  }) {
    return ConnectionTestCard(
      title: title,
      subtitle: url,
      icon: Icons.api,
      status: status,
      lastTestTime: lastTestTime,
      testSteps: steps,
      onTestPressed: onTest,
      onConfigurePressed: onConfigure,
      connectionParams: {
        'URL': url,
        'Method': 'GET',
        'Timeout': '30s',
      },
      timeout: const Duration(seconds: 30),
    );
  }

  /// Тест подключения к базе данных
  static ConnectionTestCard database({
    required String title,
    required String host,
    required int port,
    required String database,
    required ConnectionTestStatus status,
    VoidCallback? onTest,
    VoidCallback? onConfigure,
    String? lastTestTime,
    List<ConnectionTestStep>? steps,
  }) {
    return ConnectionTestCard(
      title: title,
      subtitle: '$host:$port/$database',
      icon: Icons.storage,
      status: status,
      lastTestTime: lastTestTime,
      testSteps: steps,
      onTestPressed: onTest,
      onConfigurePressed: onConfigure,
      connectionParams: {
        'Host': host,
        'Port': port.toString(),
        'Database': database,
        'SSL': 'Enabled',
      },
      timeout: const Duration(seconds: 15),
    );
  }

  /// Тест FTP соединения
  static ConnectionTestCard ftp({
    required String title,
    required String host,
    required int port,
    required ConnectionTestStatus status,
    VoidCallback? onTest,
    VoidCallback? onConfigure,
    String? lastTestTime,
    List<ConnectionTestStep>? steps,
  }) {
    return ConnectionTestCard(
      title: title,
      subtitle: '$host:$port',
      icon: Icons.folder_shared,
      status: status,
      lastTestTime: lastTestTime,
      testSteps: steps,
      onTestPressed: onTest,
      onConfigurePressed: onConfigure,
      connectionParams: {
        'Host': host,
        'Port': port.toString(),
        'Protocol': 'SFTP',
        'Passive Mode': 'Yes',
      },
      timeout: const Duration(seconds: 20),
    );
  }
}