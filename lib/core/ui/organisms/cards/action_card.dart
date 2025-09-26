import 'package:flutter/material.dart';

/// Карточка с действиями
class ActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<ActionCardButton> actions;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool compact;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.actions,
    this.padding,
    this.backgroundColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: padding ?? EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            if (icon != null || title.isNotEmpty) ...[
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: compact ? 20 : 24),
                    SizedBox(width: compact ? 8 : 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: (compact
                                  ? Theme.of(context).textTheme.titleSmall
                                  : Theme.of(context).textTheme.titleMedium)
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: compact ? 2 : 4),
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
                ],
              ),
              SizedBox(height: compact ? 12 : 16),
            ],

            // Действия
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    if (compact) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions.map((action) => _buildActionButton(context, action, true)).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions
          .map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildActionButton(context, action, false),
              ))
          .toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, ActionCardButton action, bool isCompact) {
    Widget button;

    switch (action.type) {
      case ActionCardButtonType.primary:
        button = FilledButton.icon(
          onPressed: action.onPressed,
          icon: action.icon != null ? Icon(action.icon, size: isCompact ? 16 : 18) : const SizedBox.shrink(),
          label: Text(action.label),
        );
        break;
      case ActionCardButtonType.secondary:
        button = OutlinedButton.icon(
          onPressed: action.onPressed,
          icon: action.icon != null ? Icon(action.icon, size: isCompact ? 16 : 18) : const SizedBox.shrink(),
          label: Text(action.label),
        );
        break;
      case ActionCardButtonType.text:
        button = TextButton.icon(
          onPressed: action.onPressed,
          icon: action.icon != null ? Icon(action.icon, size: isCompact ? 16 : 18) : const SizedBox.shrink(),
          label: Text(action.label),
        );
        break;
      case ActionCardButtonType.destructive:
        button = FilledButton.icon(
          onPressed: action.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          icon: action.icon != null ? Icon(action.icon, size: isCompact ? 16 : 18) : const SizedBox.shrink(),
          label: Text(action.label),
        );
        break;
    }

    if (action.tooltip != null) {
      button = Tooltip(
        message: action.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Кнопка действия в карточке
class ActionCardButton {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ActionCardButtonType type;
  final String? tooltip;

  const ActionCardButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.type = ActionCardButtonType.secondary,
    this.tooltip,
  });

  const ActionCardButton.primary({
    required this.label,
    this.onPressed,
    this.icon,
    this.tooltip,
  }) : type = ActionCardButtonType.primary;

  const ActionCardButton.secondary({
    required this.label,
    this.onPressed,
    this.icon,
    this.tooltip,
  }) : type = ActionCardButtonType.secondary;

  const ActionCardButton.text({
    required this.label,
    this.onPressed,
    this.icon,
    this.tooltip,
  }) : type = ActionCardButtonType.text;

  const ActionCardButton.destructive({
    required this.label,
    this.onPressed,
    this.icon,
    this.tooltip,
  }) : type = ActionCardButtonType.destructive;
}

/// Типы кнопок действий
enum ActionCardButtonType {
  primary,
  secondary,
  text,
  destructive,
}