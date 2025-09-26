import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/ui/index.dart';

/// Вкладка тестирования подключения к поставщику
class TestingTab extends ConsumerStatefulWidget {
  final String? supplierCode;

  const TestingTab({
    super.key,
    this.supplierCode,
  });

  @override
  ConsumerState<TestingTab> createState() => _TestingTabState();
}

class _TestingTabState extends ConsumerState<TestingTab> {
  ConnectionTestStatus _connectionStatus = ConnectionTestStatus.unknown;
  String? _testResultMessage;

  @override
  Widget build(BuildContext context) {

    return FormScreenScaffold.settings(
      title: '', // Заголовок уже в TabbedScreen
      children: [
        // Секция проверки соединения
        _ConnectionTestSection(
          status: _connectionStatus,
          message: _testResultMessage,
          onTest: _testConnection,
          isLoading: _connectionStatus == ConnectionTestStatus.testing,
        ),

        // Секция тестирования данных
        _DataTestSection(
          supplierCode: widget.supplierCode,
          onVkorgTest: widget.supplierCode == 'armtek' ? _loadVkorgList : null,
          onBrandsTest: widget.supplierCode == 'armtek' ? _loadBrandsList : null,
          onGenericTest: widget.supplierCode != 'armtek' ? _loadTestData : null,
        ),

        // Секция результатов
        if (_testResultMessage != null)
          _TestResultsSection(
            status: _connectionStatus,
            message: _testResultMessage!,
            onClear: () => setState(() {
              _testResultMessage = null;
              _connectionStatus = ConnectionTestStatus.unknown;
            }),
          ),
      ],
    );
  }

  Future<void> _testConnection() async {
    setState(() {
      _connectionStatus = ConnectionTestStatus.testing;
      _testResultMessage = null;
    });

    try {
      // Симуляция тестирования подключения
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Реализовать реальное тестирование подключения
      setState(() {
        _connectionStatus = ConnectionTestStatus.success;
        _testResultMessage = 'Соединение установлено успешно';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_testResultMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _connectionStatus = ConnectionTestStatus.error;
        _testResultMessage = 'Ошибка тестирования: $e';
      });
    }
  }

  Future<void> _loadVkorgList() async {
    // TODO: Реализовать загрузку списка VKORG
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Загрузка списка VKORG...')),
    );
  }

  Future<void> _loadBrandsList() async {
    // TODO: Реализовать загрузку списка брендов
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Загрузка списка брендов...')),
    );
  }

  Future<void> _loadTestData() async {
    // TODO: Реализовать загрузку тестовых данных
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Загрузка тестовых данных...')),
    );
  }
}

/// Секция проверки соединения
class _ConnectionTestSection extends StatelessWidget {
  final ConnectionTestStatus status;
  final String? message;
  final VoidCallback onTest;
  final bool isLoading;

  const _ConnectionTestSection({
    required this.status,
    required this.message,
    required this.onTest,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wifi_tethering,
                  color: _getStatusColor(),
                ),
                const SizedBox(width: AppSpacing.sm),
                'Проверка соединения'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            'Health Check проверяет доступность API и корректность аутентификации'
              .asBodySmall(color: Colors.grey.shade600),

            const SizedBox(height: AppSpacing.lg),

            // Кнопка тестирования
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: isLoading ? 'Проверка...' : 'Проверить соединение',
                onPressed: isLoading ? null : onTest,
                isLoading: isLoading,
                icon: isLoading ? null : const Icon(Icons.play_arrow),
              ),
            ),

            // Статус соединения
            if (status != ConnectionTestStatus.unknown) ...[
              const SizedBox(height: AppSpacing.md),
              _buildStatusIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: 'Соединение установлено успешно'
                  .asBodyMedium(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ],
          ),
        );

      case ConnectionTestStatus.error:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade700),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: 'Ошибка соединения'
                  .asBodyMedium(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ],
          ),
        );

      case ConnectionTestStatus.testing:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.blue.shade300),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.blue.shade700),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: 'Проверка соединения...'
                  .asBodyMedium(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ],
          ),
        );

      case ConnectionTestStatus.unknown:
        return const SizedBox.shrink();
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Colors.green;
      case ConnectionTestStatus.error:
        return Colors.red;
      case ConnectionTestStatus.testing:
        return Colors.blue;
      case ConnectionTestStatus.unknown:
        return Colors.grey;
    }
  }
}

/// Секция тестирования данных
class _DataTestSection extends StatelessWidget {
  final String? supplierCode;
  final VoidCallback? onVkorgTest;
  final VoidCallback? onBrandsTest;
  final VoidCallback? onGenericTest;

  const _DataTestSection({
    required this.supplierCode,
    this.onVkorgTest,
    this.onBrandsTest,
    this.onGenericTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.data_usage, color: Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                'Тестирование данных'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            'Загрузка тестовых данных для проверки корректности работы'
              .asBodySmall(color: Colors.grey.shade600),

            const SizedBox(height: AppSpacing.lg),

            // Кнопки для тестирования разных типов данных
            if (supplierCode == 'armtek') ...[
              _buildTestButton(
                icon: Icons.business_center,
                text: 'Загрузить список VKORG',
                onPressed: onVkorgTest,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTestButton(
                icon: Icons.category,
                text: 'Загрузить список брендов',
                onPressed: onBrandsTest,
              ),
            ] else ...[
              _buildTestButton(
                icon: Icons.download,
                text: 'Загрузить тестовые данные',
                onPressed: onGenericTest,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton({
    required IconData icon,
    required String text,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: SecondaryButton.icon(
        text: text,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

/// Секция результатов тестирования
class _TestResultsSection extends StatelessWidget {
  final ConnectionTestStatus status;
  final String message;
  final VoidCallback onClear;

  const _TestResultsSection({
    required this.status,
    required this.message,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assessment, color: Colors.purple),
                const SizedBox(width: AppSpacing.sm),
                'Результаты тестирования'.asH5(),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                  tooltip: 'Очистить результаты',
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: _getBorderColor()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getIcon(), color: _getIconColor(), size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      _getStatusText().asBodyMedium(
                        color: _getTextColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  message.asBodySmall(color: _getTextColor()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case ConnectionTestStatus.success:
        return 'Тестирование успешно';
      case ConnectionTestStatus.error:
        return 'Тестирование завершено с ошибкой';
      case ConnectionTestStatus.testing:
        return 'Тестирование...';
      case ConnectionTestStatus.unknown:
        return 'Неизвестный статус';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Icons.check_circle;
      case ConnectionTestStatus.error:
        return Icons.error;
      case ConnectionTestStatus.testing:
        return Icons.hourglass_empty;
      case ConnectionTestStatus.unknown:
        return Icons.help;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Colors.green.shade50;
      case ConnectionTestStatus.error:
        return Colors.red.shade50;
      case ConnectionTestStatus.testing:
        return Colors.blue.shade50;
      case ConnectionTestStatus.unknown:
        return Colors.grey.shade50;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Colors.green.shade300;
      case ConnectionTestStatus.error:
        return Colors.red.shade300;
      case ConnectionTestStatus.testing:
        return Colors.blue.shade300;
      case ConnectionTestStatus.unknown:
        return Colors.grey.shade300;
    }
  }

  Color _getIconColor() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Colors.green.shade700;
      case ConnectionTestStatus.error:
        return Colors.red.shade700;
      case ConnectionTestStatus.testing:
        return Colors.blue.shade700;
      case ConnectionTestStatus.unknown:
        return Colors.grey.shade700;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ConnectionTestStatus.success:
        return Colors.green.shade800;
      case ConnectionTestStatus.error:
        return Colors.red.shade800;
      case ConnectionTestStatus.testing:
        return Colors.blue.shade800;
      case ConnectionTestStatus.unknown:
        return Colors.grey.shade800;
    }
  }
}

/// Статусы тестирования соединения
enum ConnectionTestStatus {
  unknown,
  testing,
  success,
  error,
}