import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/atoms/buttons/primary_button.dart';
import 'package:part_catalog/core/ui/atoms/buttons/secondary_button.dart';
import 'package:part_catalog/core/ui/molecules/loading_overlay.dart';
import 'package:part_catalog/core/ui/molecules/escape_handler.dart';

/// Универсальный шаблон для экранов с формами
/// Поддерживает валидацию, сохранение состояния, автоматическую раскладку
class FormScreenScaffold extends StatefulWidget {
  // Основные параметры
  final String title;
  final PreferredSizeWidget? appBar;
  final List<Widget> children;
  final GlobalKey<FormState>? formKey;

  // Действия и кнопки
  final String? submitText;
  final VoidCallback? onSubmit;
  final String? cancelText;
  final VoidCallback? onCancel;
  final List<FormAction>? additionalActions;

  // Состояние и загрузка
  final bool isLoading;
  final String? loadingMessage;
  final bool hasChanges;
  final VoidCallback? onDiscard;

  // Layout параметры
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final FormLayoutType layoutType;
  final double fieldSpacing;

  // Автоматические функции
  final bool showUnsavedChangesDialog;
  final bool scrollToFirstError;
  final bool autovalidate;

  // Дополнительные элементы
  final Widget? header;
  final Widget? footer;
  final Widget? floatingActionButton;

  // Принудительное закрытие
  final bool enableForceClose;
  final VoidCallback? onForceClose;

  const FormScreenScaffold({
    super.key,
    required this.title,
    required this.children,
    this.appBar,
    this.formKey,
    this.submitText,
    this.onSubmit,
    this.cancelText,
    this.onCancel,
    this.additionalActions,
    this.isLoading = false,
    this.loadingMessage,
    this.hasChanges = false,
    this.onDiscard,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.layoutType = FormLayoutType.adaptive,
    this.fieldSpacing = AppSpacing.lg,
    this.showUnsavedChangesDialog = true,
    this.scrollToFirstError = true,
    this.autovalidate = false,
    this.header,
    this.footer,
    this.floatingActionButton,
    this.enableForceClose = true,
    this.onForceClose,
  });

  /// Создает форму создания/редактирования
  const FormScreenScaffold.edit({
    super.key,
    required this.title,
    required this.children,
    required this.onSubmit,
    this.formKey,
    this.onCancel,
    this.submitText = 'Сохранить',
    this.cancelText = 'Отмена',
    this.additionalActions,
    this.isLoading = false,
    this.loadingMessage,
    this.hasChanges = false,
    this.onDiscard,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.layoutType = FormLayoutType.adaptive,
    this.fieldSpacing = AppSpacing.lg,
    this.scrollToFirstError = true,
    this.autovalidate = false,
    this.header,
    this.footer,
    this.floatingActionButton,
    this.enableForceClose = true,
    this.onForceClose,
  })  : appBar = null,
        showUnsavedChangesDialog = true;

  /// Создает простую форму настроек
  const FormScreenScaffold.settings({
    super.key,
    required this.title,
    required this.children,
    this.onSubmit,
    this.formKey,
    this.submitText = 'Применить',
    this.additionalActions,
    this.isLoading = false,
    this.loadingMessage,
    this.hasChanges = false,
    this.onDiscard,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.layoutType = FormLayoutType.sections,
    this.fieldSpacing = AppSpacing.md,
    this.autovalidate = true,
    this.header,
    this.footer,
    this.floatingActionButton,
    this.enableForceClose = true,
    this.onForceClose,
  })  : appBar = null,
        onCancel = null,
        cancelText = null,
        showUnsavedChangesDialog = false,
        scrollToFirstError = false;

  @override
  State<FormScreenScaffold> createState() => _FormScreenScaffoldState();
}

class _FormScreenScaffoldState extends State<FormScreenScaffold> {
  late GlobalKey<FormState> _formKey;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: LoadingOverlay(
        isLoading: widget.isLoading,
        message: widget.loadingMessage,
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
          floatingActionButton: widget.floatingActionButton,
          persistentFooterButtons: _buildFooterButtons(context),
        ),
      ),
    );

    // Добавляем обработку принудительного закрытия если включено
    if (widget.enableForceClose) {
      content = EscapeHandlerPresets.form(
        onEscape: widget.onForceClose,
        child: content,
      );
    }

    return content;
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (widget.appBar != null) return widget.appBar;

    return AppBar(
      title: Text(widget.title),
      actions: [
        if (widget.hasChanges && widget.onDiscard != null)
          TextButton(
            onPressed: widget.onDiscard,
            child: Text(widget.cancelText ?? 'Отмена'),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: widget.padding ?? EdgeInsets.all(AppSpacing.adaptive(context)),
        child: Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            // Заголовок формы
            if (widget.header != null) ...[
              widget.header!,
              SizedBox(height: widget.fieldSpacing),
            ],

            // Основные поля формы
            ..._buildFormFields(),

            // Подвал формы
            if (widget.footer != null) ...[
              SizedBox(height: widget.fieldSpacing),
              widget.footer!,
            ],

            // Отступ для кнопок в футере
            if (_buildFooterButtons(context).isNotEmpty)
              const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final List<Widget> fields = [];

    switch (widget.layoutType) {
      case FormLayoutType.single:
        // Одна колонка
        for (int i = 0; i < widget.children.length; i++) {
          fields.add(widget.children[i]);
          if (i < widget.children.length - 1) {
            fields.add(SizedBox(height: widget.fieldSpacing));
          }
        }
        break;

      case FormLayoutType.adaptive:
        // Адаптивная раскладка
        if (AppBreakpoints.isDesktop(context)) {
          fields.addAll(_buildTwoColumnLayout());
        } else {
          fields.addAll(_buildSingleColumnLayout());
        }
        break;

      case FormLayoutType.sections:
        // Группировка по секциям
        fields.addAll(_buildSectionLayout());
        break;

      case FormLayoutType.grid:
        // Сетка полей
        fields.addAll(_buildGridLayout(context));
        break;
    }

    return fields;
  }

  List<Widget> _buildSingleColumnLayout() {
    final List<Widget> fields = [];
    for (int i = 0; i < widget.children.length; i++) {
      fields.add(widget.children[i]);
      if (i < widget.children.length - 1) {
        fields.add(SizedBox(height: widget.fieldSpacing));
      }
    }
    return fields;
  }

  List<Widget> _buildTwoColumnLayout() {
    final List<Widget> fields = [];

    for (int i = 0; i < widget.children.length; i += 2) {
      final leftField = widget.children[i];
      final rightField = i + 1 < widget.children.length
          ? widget.children[i + 1]
          : const SizedBox();

      fields.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: leftField),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: rightField),
          ],
        ),
      );

      if (i + 2 < widget.children.length) {
        fields.add(SizedBox(height: widget.fieldSpacing));
      }
    }

    return fields;
  }

  List<Widget> _buildSectionLayout() {
    // Простая реализация - группируем по 3-4 поля
    final List<Widget> sections = [];
    const int fieldsPerSection = 4;

    for (int i = 0; i < widget.children.length; i += fieldsPerSection) {
      final sectionFields = widget.children
          .skip(i)
          .take(fieldsPerSection)
          .toList();

      sections.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                for (int j = 0; j < sectionFields.length; j++) ...[
                  sectionFields[j],
                  if (j < sectionFields.length - 1)
                    SizedBox(height: widget.fieldSpacing * 0.75),
                ],
              ],
            ),
          ),
        ),
      );

      if (i + fieldsPerSection < widget.children.length) {
        sections.add(SizedBox(height: widget.fieldSpacing));
      }
    }

    return sections;
  }

  List<Widget> _buildGridLayout(BuildContext context) {
    final crossAxisCount = AppBreakpoints.isDesktop(context) ? 3 : 2;
    final List<Widget> rows = [];

    for (int i = 0; i < widget.children.length; i += crossAxisCount) {
      final rowFields = <Widget>[];

      for (int j = 0; j < crossAxisCount; j++) {
        if (i + j < widget.children.length) {
          rowFields.add(Expanded(child: widget.children[i + j]));
        } else {
          rowFields.add(const Expanded(child: SizedBox()));
        }

        if (j < crossAxisCount - 1) {
          rowFields.add(const SizedBox(width: AppSpacing.lg));
        }
      }

      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowFields,
      ));

      if (i + crossAxisCount < widget.children.length) {
        rows.add(SizedBox(height: widget.fieldSpacing));
      }
    }

    return rows;
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    if (widget.onSubmit == null && widget.onCancel == null &&
        (widget.additionalActions?.isEmpty ?? true)) {
      return [];
    }

    final buttons = <Widget>[];

    // Дополнительные действия
    if (widget.additionalActions != null) {
      for (final action in widget.additionalActions!) {
        buttons.add(_buildActionButton(action));
      }
    }

    // Кнопка отмены
    if (widget.onCancel != null) {
      buttons.add(
        SecondaryButton(
          text: widget.cancelText ?? 'Отмена',
          onPressed: widget.onCancel,
        ),
      );
    }

    // Кнопка сохранения
    if (widget.onSubmit != null) {
      buttons.add(
        PrimaryButton(
          text: widget.submitText ?? 'Сохранить',
          onPressed: _handleSubmit,
          isLoading: widget.isLoading,
        ),
      );
    }

    return buttons;
  }

  Widget _buildActionButton(FormAction action) {
    switch (action.style) {
      case FormActionStyle.primary:
        return PrimaryButton(
          text: action.text,
          onPressed: action.onPressed,
          icon: action.icon,
        );
      case FormActionStyle.secondary:
        return SecondaryButton(
          text: action.text,
          onPressed: action.onPressed,
          icon: action.icon,
        );
      case FormActionStyle.text:
        return SecondaryButton.text(
          text: action.text,
          onPressed: action.onPressed,
          icon: action.icon,
        );
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      if (widget.scrollToFirstError) {
        _scrollToFirstError();
      }
      return;
    }

    widget.onSubmit?.call();
  }

  void _scrollToFirstError() {
    // Простая реализация - прокручиваем наверх
    _scrollController.animateTo(
      0,
      duration: AppDurations.normal,
      curve: AppDurations.defaultCurve,
    );
  }

  Future<bool> _onWillPop() async {
    if (!widget.showUnsavedChangesDialog || !widget.hasChanges) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Несохраненные изменения'),
        content: const Text('У вас есть несохраненные изменения. Выйти без сохранения?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Остаться'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

/// Типы раскладки формы
enum FormLayoutType {
  single,    // Одна колонка
  adaptive,  // Адаптивная раскладка
  sections,  // Группировка по секциям
  grid,      // Сетка полей
}

/// Действие в форме
class FormAction {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final FormActionStyle style;

  const FormAction({
    required this.text,
    this.onPressed,
    this.icon,
    this.style = FormActionStyle.secondary,
  });

  const FormAction.primary({
    required this.text,
    this.onPressed,
    this.icon,
  }) : style = FormActionStyle.primary;

  const FormAction.secondary({
    required this.text,
    this.onPressed,
    this.icon,
  }) : style = FormActionStyle.secondary;

  const FormAction.text({
    required this.text,
    this.onPressed,
    this.icon,
  }) : style = FormActionStyle.text;
}

/// Стили действий формы
enum FormActionStyle {
  primary,
  secondary,
  text,
}

/// Фабрика для создания типовых форм
class FormScreenFactory {
  /// Создает форму клиента
  static Widget clientForm({
    required String title,
    required List<Widget> fields,
    required VoidCallback onSave,
    VoidCallback? onCancel,
    bool isLoading = false,
    bool hasChanges = false,
  }) {
    return FormScreenScaffold.edit(
      title: title,
      onSubmit: onSave,
      onCancel: onCancel,
      isLoading: isLoading,
      hasChanges: hasChanges,
      layoutType: FormLayoutType.adaptive,
      children: fields,
    );
  }

  /// Создает форму настроек
  static Widget settingsForm({
    required String title,
    required List<Widget> sections,
    VoidCallback? onApply,
    bool isLoading = false,
  }) {
    return FormScreenScaffold.settings(
      title: title,
      onSubmit: onApply,
      isLoading: isLoading,
      layoutType: FormLayoutType.sections,
      children: sections,
    );
  }

  /// Создает мастер создания
  static Widget creationWizard({
    required String title,
    required List<Widget> steps,
    required VoidCallback onCreate,
    VoidCallback? onCancel,
    bool isLoading = false,
  }) {
    return FormScreenScaffold.edit(
      title: title,
      onSubmit: onCreate,
      onCancel: onCancel,
      submitText: 'Создать',
      isLoading: isLoading,
      layoutType: FormLayoutType.sections,
      children: steps,
    );
  }
}