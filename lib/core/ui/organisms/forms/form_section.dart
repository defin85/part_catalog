import 'package:flutter/material.dart';

/// Секция формы с заголовком и группой полей
/// Используется для логической группировки связанных полей формы
class FormSection extends StatelessWidget {
  /// Заголовок секции
  final String title;

  /// Подзаголовок или описание
  final String? subtitle;

  /// Иконка секции
  final IconData? icon;

  /// Дочерние поля формы
  final List<Widget> children;

  /// Можно ли сворачивать секцию
  final bool collapsible;

  /// Развернута ли секция по умолчанию
  final bool initiallyExpanded;

  /// Обработчик изменения состояния сворачивания
  final ValueChanged<bool>? onExpansionChanged;

  /// Паддинг содержимого
  final EdgeInsetsGeometry? contentPadding;

  /// Показывать ли разделитель сверху
  final bool showTopDivider;

  /// Показывать ли разделитель снизу
  final bool showBottomDivider;

  /// Цвет фона секции
  final Color? backgroundColor;

  /// Радиус скругления
  final BorderRadius? borderRadius;

  /// Обязательна ли секция (показывает звездочку)
  final bool isRequired;

  /// Есть ли ошибки в секции
  final bool hasErrors;

  /// Сообщения об ошибках
  final List<String>? errorMessages;

  /// Дополнительные действия в заголовке
  final List<Widget>? actions;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.contentPadding,
    this.showTopDivider = false,
    this.showBottomDivider = false,
    this.backgroundColor,
    this.borderRadius,
    this.isRequired = false,
    this.hasErrors = false,
    this.errorMessages,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (collapsible) {
      return _buildCollapsibleSection(context);
    } else {
      return _buildStaticSection(context);
    }
  }

  Widget _buildCollapsibleSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: hasErrors
            ? Border.all(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTopDivider) const Divider(height: 1),
          ExpansionTile(
            title: _buildTitle(context),
            subtitle: subtitle != null ? Text(subtitle!) : null,
            leading: icon != null
                ? Icon(icon, color: _getIconColor(context))
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (actions != null) ...actions!,
                if (hasErrors)
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.expand_more),
              ],
            ),
            initiallyExpanded: initiallyExpanded,
            onExpansionChanged: onExpansionChanged,
            children: [
              if (hasErrors && errorMessages != null)
                _buildErrorSection(context),
              Padding(
                padding: contentPadding ??
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
          if (showBottomDivider) const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildStaticSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: hasErrors
            ? Border.all(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTopDivider) const Divider(height: 1),
          _buildHeader(context),
          if (hasErrors && errorMessages != null)
            _buildErrorSection(context),
          Padding(
            padding: contentPadding ??
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          if (showBottomDivider) const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: _getIconColor(context),
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
          if (hasErrors)
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: hasErrors
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
        children: [
          TextSpan(text: title),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errorMessages!.map((error) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    if (hasErrors) return Theme.of(context).colorScheme.error;
    return Theme.of(context).colorScheme.primary;
  }
}