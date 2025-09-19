import 'package:flutter/material.dart';
import 'package:part_catalog/features/suppliers/services/smart_validation_service.dart';

/// Виджет для отображения результата валидации
class ValidationFeedbackWidget extends StatelessWidget {
  final ValidationResult? result;
  final bool showSuccessMessage;

  const ValidationFeedbackWidget({
    super.key,
    this.result,
    this.showSuccessMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const SizedBox.shrink();
    }

    if (result!.isValid &&
        result!.level == ValidationLevel.success &&
        !showSuccessMessage) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(context),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result!.errorMessage != null)
                  Text(
                    result!.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getTextColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                if (result!.suggestion != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    result!.suggestion!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getTextColor(context).withOpacity(0.8),
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (result!.level) {
      case ValidationLevel.success:
        return Colors.green.withOpacity(0.1);
      case ValidationLevel.warning:
        return Colors.orange.withOpacity(0.1);
      case ValidationLevel.error:
        return Theme.of(context).colorScheme.errorContainer.withOpacity(0.3);
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (result!.level) {
      case ValidationLevel.success:
        return Colors.green.withOpacity(0.3);
      case ValidationLevel.warning:
        return Colors.orange.withOpacity(0.3);
      case ValidationLevel.error:
        return Theme.of(context).colorScheme.error.withOpacity(0.3);
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (result!.level) {
      case ValidationLevel.success:
        return Colors.green;
      case ValidationLevel.warning:
        return Colors.orange;
      case ValidationLevel.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (result!.level) {
      case ValidationLevel.success:
        return Colors.green.shade800;
      case ValidationLevel.warning:
        return Colors.orange.shade800;
      case ValidationLevel.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  IconData _getIcon() {
    switch (result!.level) {
      case ValidationLevel.success:
        return Icons.check_circle;
      case ValidationLevel.warning:
        return Icons.warning;
      case ValidationLevel.error:
        return Icons.error;
    }
  }
}

/// Виджет для отображения множественных результатов валидации
class MultiValidationFeedbackWidget extends StatelessWidget {
  final List<ValidationResult> results;
  final bool showSuccessMessage;

  const MultiValidationFeedbackWidget({
    super.key,
    required this.results,
    this.showSuccessMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    // Фильтруем результаты для отображения
    final filteredResults = results.where((result) {
      if (result.isValid &&
          result.level == ValidationLevel.success &&
          !showSuccessMessage) {
        return false;
      }
      return true;
    }).toList();

    if (filteredResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: filteredResults
          .map((result) => ValidationFeedbackWidget(
                result: result,
                showSuccessMessage: showSuccessMessage,
              ))
          .toList(),
    );
  }
}

/// Компактный виджет статуса валидации для использования в полях ввода
class ValidationStatusIcon extends StatelessWidget {
  final ValidationResult? result;
  final VoidCallback? onTap;

  const ValidationStatusIcon({
    super.key,
    this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Icon(
          _getIcon(),
          color: _getIconColor(context),
          size: 20,
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (result!.level) {
      case ValidationLevel.success:
        return Colors.green;
      case ValidationLevel.warning:
        return Colors.orange;
      case ValidationLevel.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  IconData _getIcon() {
    switch (result!.level) {
      case ValidationLevel.success:
        return Icons.check_circle;
      case ValidationLevel.warning:
        return Icons.warning;
      case ValidationLevel.error:
        return Icons.error;
    }
  }
}

/// Виджет автодополнения для URL
class UrlAutoCompleteWidget extends StatelessWidget {
  final String supplierCode;
  final String currentValue;
  final Function(String) onSelected;
  final TextEditingController controller;

  const UrlAutoCompleteWidget({
    super.key,
    required this.supplierCode,
    required this.currentValue,
    required this.onSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: currentValue),
      optionsBuilder: (textEditingValue) {
        return SmartValidationService.getSuggestedUrls(
          supplierCode,
          textEditingValue.text,
        );
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        // Синхронизируем с внешним контроллером
        this.controller.text = controller.text;
        this.controller.selection = controller.selection;

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (value) => onFieldSubmitted(),
          decoration: InputDecoration(
            labelText: 'Базовый URL API',
            helperText: _getUrlHelper(),
            hintText: _getUrlHint(),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.link),
            suffixIcon: ValidationStatusIcon(
              result: SmartValidationService.validateUrl(
                controller.text,
                supplierCode,
              ),
            ),
          ),
          onChanged: (value) {
            this.controller.text = value;
            onSelected(value);
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.link, size: 16),
                    title: Text(
                      option,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _getUrlHelper() {
    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        return 'Для Армтек обычно: https://ws.armtek.ru или https://api2.autotrade.su';
      case 'custom':
        return 'Укажите полный URL до API вашего поставщика';
      default:
        return 'Базовый URL для подключения к API поставщика';
    }
  }

  String _getUrlHint() {
    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        return 'https://ws.armtek.ru';
      case 'custom':
        return 'https://api.yourprovider.com';
      default:
        return 'https://api.supplier.com';
    }
  }
}