import 'package:flutter/material.dart';

/// Сводка ошибок валидации для форм
/// Показывает все ошибки валидации в удобном для пользователя виде
class ValidationSummary extends StatelessWidget {
  final List<ValidationError> errors;
  final String? title;
  final bool showIcon;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? errorStyle;
  final bool collapsible;
  final bool isCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final Widget? actions;

  const ValidationSummary({
    super.key,
    required this.errors,
    this.title,
    this.showIcon = true,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.titleStyle,
    this.errorStyle,
    this.collapsible = false,
    this.isCollapsed = false,
    this.onCollapsedChanged,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ??
      colorScheme.errorContainer.withValues(alpha:0.1);
    final effectiveBorderColor = borderColor ?? colorScheme.error.withValues(alpha:0.3);
    final effectiveIcon = icon ?? Icons.error_outline;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border.all(color: effectiveBorderColor),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InkWell(
            onTap: collapsible ? () => onCollapsedChanged?.call(!isCollapsed) : null,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular((borderRadius ?? BorderRadius.circular(8)).topLeft.x),
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (showIcon) ...[
                    Icon(
                      effectiveIcon,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? _getDefaultTitle(),
                          style: titleStyle ?? theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!collapsible || !isCollapsed) ...[
                          const SizedBox(height: 4),
                          Text(
                            _getSummaryText(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (collapsible)
                    Icon(
                      isCollapsed ? Icons.expand_more : Icons.expand_less,
                      color: colorScheme.error,
                    ),
                  if (actions != null) ...[
                    const SizedBox(width: 8),
                    actions!,
                  ],
                ],
              ),
            ),
          ),
          // Errors list
          if (!collapsible || !isCollapsed)
            _buildErrorsList(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildErrorsList(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha:0.5),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular((borderRadius ?? BorderRadius.circular(8)).bottomLeft.x),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: errors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final error = errors[index];
          return _buildErrorItem(error, theme, colorScheme);
        },
      ),
    );
  }

  Widget _buildErrorItem(ValidationError error, ThemeData theme, ColorScheme colorScheme) {
    return InkWell(
      onTap: error.onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: _getSeverityColor(error.severity, colorScheme),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error.field != null) ...[
                    Text(
                      error.field!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    error.message,
                    style: errorStyle ?? theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (error.onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  String _getDefaultTitle() {
    return errors.length == 1 ? 'Ошибка валидации' : 'Ошибки валидации';
  }

  String _getSummaryText() {
    if (errors.length == 1) {
      return 'Исправьте указанную ошибку для продолжения';
    }
    return 'Исправьте ${errors.length} ошибок для продолжения';
  }

  Color _getSeverityColor(ValidationSeverity severity, ColorScheme colorScheme) {
    switch (severity) {
      case ValidationSeverity.error:
        return colorScheme.error;
      case ValidationSeverity.warning:
        return colorScheme.tertiary;
      case ValidationSeverity.info:
        return colorScheme.primary;
    }
  }
}

/// Элемент ошибки валидации
class ValidationError {
  final String message;
  final String? field;
  final ValidationSeverity severity;
  final VoidCallback? onTap;
  final String? code;

  const ValidationError({
    required this.message,
    this.field,
    this.severity = ValidationSeverity.error,
    this.onTap,
    this.code,
  });

  /// Создает ошибку для конкретного поля
  ValidationError.field({
    required String fieldName,
    required String message,
    VoidCallback? onTap,
    String? code,
  }) : this(
    message: message,
    field: fieldName,
    onTap: onTap,
    code: code,
  );

  /// Создает предупреждение
  ValidationError.warning({
    required String message,
    String? field,
    VoidCallback? onTap,
    String? code,
  }) : this(
    message: message,
    field: field,
    severity: ValidationSeverity.warning,
    onTap: onTap,
    code: code,
  );

  /// Создает информационное сообщение
  ValidationError.info({
    required String message,
    String? field,
    VoidCallback? onTap,
    String? code,
  }) : this(
    message: message,
    field: field,
    severity: ValidationSeverity.info,
    onTap: onTap,
    code: code,
  );
}

/// Уровень серьезности ошибки валидации
enum ValidationSeverity {
  error,
  warning,
  info,
}

/// Компактная версия ValidationSummary для небольших форм
class CompactValidationSummary extends StatelessWidget {
  final List<ValidationError> errors;
  final int maxVisibleErrors;
  final String? moreErrorsText;

  const CompactValidationSummary({
    super.key,
    required this.errors,
    this.maxVisibleErrors = 3,
    this.moreErrorsText,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final visibleErrors = errors.take(maxVisibleErrors).toList();
    final hasMoreErrors = errors.length > maxVisibleErrors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: colorScheme.error.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visibleErrors.map((error) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error.field != null ? '${error.field}: ${error.message}' : error.message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          )),
          if (hasMoreErrors)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                moreErrorsText ?? 'и ещё ${errors.length - maxVisibleErrors} ошибок...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onErrorContainer.withValues(alpha:0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Утилиты для работы с ошибками валидации
class ValidationUtils {
  /// Группирует ошибки по полям
  static Map<String, List<ValidationError>> groupByField(List<ValidationError> errors) {
    final Map<String, List<ValidationError>> grouped = {};

    for (final error in errors) {
      final field = error.field ?? 'general';
      grouped[field] = (grouped[field] ?? [])..add(error);
    }

    return grouped;
  }

  /// Фильтрует ошибки по уровню серьезности
  static List<ValidationError> filterBySeverity(
    List<ValidationError> errors,
    ValidationSeverity severity,
  ) {
    return errors.where((error) => error.severity == severity).toList();
  }

  /// Возвращает только ошибки (без предупреждений и информационных сообщений)
  static List<ValidationError> getErrorsOnly(List<ValidationError> errors) {
    return filterBySeverity(errors, ValidationSeverity.error);
  }

  /// Возвращает true, если есть критические ошибки
  static bool hasErrors(List<ValidationError> errors) {
    return getErrorsOnly(errors).isNotEmpty;
  }

  /// Создает ошибки из `Map<String, String>`
  static List<ValidationError> fromMap(Map<String, String> errorMap) {
    return errorMap.entries.map((entry) =>
      ValidationError.field(
        fieldName: entry.key,
        message: entry.value,
      )
    ).toList();
  }
}