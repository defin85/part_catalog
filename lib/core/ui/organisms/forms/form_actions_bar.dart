import 'package:flutter/material.dart';

/// Панель действий для форм
class FormActionsBar extends StatelessWidget {
  /// Основные действия (например, Сохранить, Отменить)
  final List<FormAction> actions;

  /// Вторичные действия (например, дополнительные кнопки)
  final List<FormAction>? secondaryActions;

  /// Выравнивание действий
  final MainAxisAlignment alignment;

  /// Цвет фона панели
  final Color? backgroundColor;

  /// Показывать верхнюю границу
  final bool showTopBorder;

  /// Отступы панели
  final EdgeInsets? padding;

  /// Направление размещения кнопок (горизонтально или вертикально)
  final Axis direction;

  /// Использовать разделители между действиями
  final bool useDividers;

  /// Компактный режим (меньше отступы)
  final bool compact;

  /// Липкая панель (зафиксирована внизу)
  final bool sticky;

  /// Максимальная ширина кнопок
  final double? maxButtonWidth;

  const FormActionsBar({
    super.key,
    required this.actions,
    this.secondaryActions,
    this.alignment = MainAxisAlignment.end,
    this.backgroundColor,
    this.showTopBorder = true,
    this.padding,
    this.direction = Axis.horizontal,
    this.useDividers = false,
    this.compact = false,
    this.sticky = false,
    this.maxButtonWidth,
  });

  /// Создает простую панель с кнопками Сохранить/Отменить
  factory FormActionsBar.saveCancel({
    Key? key,
    VoidCallback? onSave,
    VoidCallback? onCancel,
    bool isSaving = false,
    bool canSave = true,
    String saveLabel = 'Сохранить',
    String cancelLabel = 'Отменить',
    MainAxisAlignment alignment = MainAxisAlignment.end,
    Color? backgroundColor,
    bool showTopBorder = true,
    EdgeInsets? padding,
    bool compact = false,
    bool sticky = false,
  }) {
    return FormActionsBar(
      key: key,
      actions: [
        FormAction.secondary(
          label: cancelLabel,
          onPressed: onCancel,
          icon: Icons.close,
        ),
        FormAction.primary(
          label: saveLabel,
          onPressed: canSave ? onSave : null,
          icon: Icons.save,
          isLoading: isSaving,
        ),
      ],
      alignment: alignment,
      backgroundColor: backgroundColor,
      showTopBorder: showTopBorder,
      padding: padding,
      compact: compact,
      sticky: sticky,
    );
  }

  /// Создает панель с возможностью удаления
  factory FormActionsBar.withDelete({
    Key? key,
    VoidCallback? onSave,
    VoidCallback? onCancel,
    VoidCallback? onDelete,
    bool isSaving = false,
    bool isDeleting = false,
    bool canSave = true,
    bool canDelete = true,
    String saveLabel = 'Сохранить',
    String cancelLabel = 'Отменить',
    String deleteLabel = 'Удалить',
    MainAxisAlignment alignment = MainAxisAlignment.spaceBetween,
    Color? backgroundColor,
    bool showTopBorder = true,
    EdgeInsets? padding,
    bool compact = false,
    bool sticky = false,
  }) {
    return FormActionsBar(
      key: key,
      actions: [
        FormAction.destructive(
          label: deleteLabel,
          onPressed: canDelete ? onDelete : null,
          icon: Icons.delete_outline,
          isLoading: isDeleting,
        ),
      ],
      secondaryActions: [
        FormAction.secondary(
          label: cancelLabel,
          onPressed: onCancel,
          icon: Icons.close,
        ),
        FormAction.primary(
          label: saveLabel,
          onPressed: canSave ? onSave : null,
          icon: Icons.save,
          isLoading: isSaving,
        ),
      ],
      alignment: alignment,
      backgroundColor: backgroundColor,
      showTopBorder: showTopBorder,
      padding: padding,
      compact: compact,
      sticky: sticky,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (sticky) {
      content = Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(child: content),
      );
    } else if (backgroundColor != null) {
      content = Container(
        color: backgroundColor,
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.all(compact ? 12 : 16),
      decoration: showTopBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            )
          : null,
      child: direction == Axis.horizontal
          ? _buildHorizontalLayout(context)
          : _buildVerticalLayout(context),
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    final allActions = [
      ...actions,
      if (secondaryActions != null) ...secondaryActions!,
    ];

    if (alignment == MainAxisAlignment.spaceBetween &&
        actions.isNotEmpty &&
        secondaryActions != null &&
        secondaryActions!.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildActionWidgets(context, actions),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildActionWidgets(context, secondaryActions!),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: alignment,
      children: _buildActionWidgets(context, allActions),
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    final allActions = [
      ...actions,
      if (secondaryActions != null) ...secondaryActions!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildActionWidgets(context, allActions, isVertical: true),
    );
  }

  List<Widget> _buildActionWidgets(
    BuildContext context,
    List<FormAction> actionList,
    {bool isVertical = false}
  ) {
    final widgets = <Widget>[];

    for (int i = 0; i < actionList.length; i++) {
      final action = actionList[i];

      widgets.add(_buildActionButton(context, action));

      if (i < actionList.length - 1) {
        if (useDividers) {
          widgets.add(
            isVertical
                ? Divider(height: compact ? 16 : 20)
                : VerticalDivider(width: compact ? 16 : 20),
          );
        } else {
          widgets.add(
            SizedBox(
              width: isVertical ? 0 : (compact ? 8 : 12),
              height: isVertical ? (compact ? 8 : 12) : 0,
            ),
          );
        }
      }
    }

    return widgets;
  }

  Widget _buildActionButton(BuildContext context, FormAction action) {
    Widget button;

    switch (action.type) {
      case FormActionType.primary:
        button = _buildPrimaryButton(context, action);
        break;
      case FormActionType.secondary:
        button = _buildSecondaryButton(context, action);
        break;
      case FormActionType.destructive:
        button = _buildDestructiveButton(context, action);
        break;
      case FormActionType.text:
        button = _buildTextButton(context, action);
        break;
    }

    if (maxButtonWidth != null) {
      button = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxButtonWidth!),
        child: button,
      );
    }

    return button;
  }

  Widget _buildPrimaryButton(BuildContext context, FormAction action) {
    if (action.isLoading) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        label: Text(action.label),
      );
    }

    if (action.icon != null) {
      return ElevatedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon),
        label: Text(action.label),
      );
    }

    return ElevatedButton(
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, FormAction action) {
    if (action.isLoading) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text(action.label),
      );
    }

    if (action.icon != null) {
      return OutlinedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon),
        label: Text(action.label),
      );
    }

    return OutlinedButton(
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }

  Widget _buildDestructiveButton(BuildContext context, FormAction action) {
    final destructiveColor = Theme.of(context).colorScheme.error;

    if (action.isLoading) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: destructiveColor,
          ),
        ),
        label: Text(action.label),
        style: OutlinedButton.styleFrom(
          foregroundColor: destructiveColor,
          side: BorderSide(color: destructiveColor),
        ),
      );
    }

    if (action.icon != null) {
      return OutlinedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon),
        label: Text(action.label),
        style: OutlinedButton.styleFrom(
          foregroundColor: destructiveColor,
          side: BorderSide(color: destructiveColor),
        ),
      );
    }

    return OutlinedButton(
      onPressed: action.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: destructiveColor,
        side: BorderSide(color: destructiveColor),
      ),
      child: Text(action.label),
    );
  }

  Widget _buildTextButton(BuildContext context, FormAction action) {
    if (action.isLoading) {
      return TextButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text(action.label),
      );
    }

    if (action.icon != null) {
      return TextButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon),
        label: Text(action.label),
      );
    }

    return TextButton(
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }
}

/// Действие в панели форм
class FormAction {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final FormActionType type;
  final bool isLoading;

  const FormAction({
    required this.label,
    this.onPressed,
    this.icon,
    required this.type,
    this.isLoading = false,
  });

  /// Создает основное действие (выделенная кнопка)
  const FormAction.primary({
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = FormActionType.primary;

  /// Создает вторичное действие (контурная кнопка)
  const FormAction.secondary({
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = FormActionType.secondary;

  /// Создает деструктивное действие (красная кнопка)
  const FormAction.destructive({
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = FormActionType.destructive;

  /// Создает текстовое действие (текстовая кнопка)
  const FormAction.text({
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = FormActionType.text;
}

/// Типы действий форм
enum FormActionType {
  primary,     // Основное действие (ElevatedButton)
  secondary,   // Вторичное действие (OutlinedButton)
  destructive, // Деструктивное действие (OutlinedButton с красной темой)
  text,        // Текстовое действие (TextButton)
}