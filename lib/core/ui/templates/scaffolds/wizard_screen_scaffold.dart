import 'package:flutter/material.dart';

/// Шаг мастера
class WizardStep {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget content;
  final bool Function()? canProceed;
  final Future<bool> Function()? onNext;
  final VoidCallback? onBack;
  final bool isOptional;
  final bool isCompleted;
  final String? completedMessage;

  const WizardStep({
    required this.id,
    required this.title,
    required this.content,
    this.subtitle,
    this.icon,
    this.canProceed,
    this.onNext,
    this.onBack,
    this.isOptional = false,
    this.isCompleted = false,
    this.completedMessage,
  });

  WizardStep copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Widget? content,
    bool Function()? canProceed,
    Future<bool> Function()? onNext,
    VoidCallback? onBack,
    bool? isOptional,
    bool? isCompleted,
    String? completedMessage,
  }) {
    return WizardStep(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      content: content ?? this.content,
      canProceed: canProceed ?? this.canProceed,
      onNext: onNext ?? this.onNext,
      onBack: onBack ?? this.onBack,
      isOptional: isOptional ?? this.isOptional,
      isCompleted: isCompleted ?? this.isCompleted,
      completedMessage: completedMessage ?? this.completedMessage,
    );
  }
}

/// Тип индикатора прогресса
enum WizardProgressType {
  linear,    // Линейный прогресс-бар
  steps,     // Пошаговый индикатор
  dots,      // Точечный индикатор
  none,      // Без индикатора
}

/// Режим навигации мастера
enum WizardNavigationMode {
  sequential,  // Только последовательно
  flexible,    // Можно перемещаться между пройденными шагами
  free,        // Можно переходить к любому шагу
}

/// Шаблон экрана-мастера
/// Используется для создания многошаговых форм и процессов
class WizardScreenScaffold extends StatefulWidget {
  /// Заголовок мастера
  final String title;

  /// Шаги мастера
  final List<WizardStep> steps;

  /// Текущий индекс шага
  final int currentStep;

  /// Обработчик изменения шага
  final Function(int step)? onStepChanged;

  /// Обработчик завершения мастера
  final Future<void> Function()? onComplete;

  /// Обработчик отмены мастера
  final VoidCallback? onCancel;

  /// Тип индикатора прогресса
  final WizardProgressType progressType;

  /// Режим навигации
  final WizardNavigationMode navigationMode;

  /// Можно ли перейти к следующему шагу
  final bool canProceedToNext;

  /// Можно ли вернуться к предыдущему шагу
  final bool canGoBack;

  /// Состояние загрузки
  final bool isLoading;

  /// Текст кнопки "Далее"
  final String nextButtonText;

  /// Текст кнопки "Назад"
  final String backButtonText;

  /// Текст кнопки "Завершить"
  final String completeButtonText;

  /// Текст кнопки "Отменить"
  final String cancelButtonText;

  /// Показывать ли кнопку отмены
  final bool showCancelButton;

  /// Показывать ли прогресс в процентах
  final bool showProgressPercentage;

  /// Анимировать переходы между шагами
  final bool animateTransitions;

  /// Компактный режим (меньше отступов)
  final bool compact;

  /// Действия в AppBar
  final List<Widget>? actions;

  /// Floating Action Button
  final Widget? floatingActionButton;

  const WizardScreenScaffold({
    super.key,
    required this.title,
    required this.steps,
    this.currentStep = 0,
    this.onStepChanged,
    this.onComplete,
    this.onCancel,
    this.progressType = WizardProgressType.steps,
    this.navigationMode = WizardNavigationMode.sequential,
    this.canProceedToNext = true,
    this.canGoBack = true,
    this.isLoading = false,
    this.nextButtonText = 'Далее',
    this.backButtonText = 'Назад',
    this.completeButtonText = 'Завершить',
    this.cancelButtonText = 'Отменить',
    this.showCancelButton = true,
    this.showProgressPercentage = false,
    this.animateTransitions = true,
    this.compact = false,
    this.actions,
    this.floatingActionButton,
  });

  @override
  State<WizardScreenScaffold> createState() => _WizardScreenScaffoldState();
}

class _WizardScreenScaffoldState extends State<WizardScreenScaffold> {
  late PageController _pageController;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WizardScreenScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _animateToStep(widget.currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: Text('Нет шагов для отображения'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
      ),
      floatingActionButton: widget.floatingActionButton,
      body: Column(
        children: [
          if (widget.progressType != WizardProgressType.none)
            _buildProgressIndicator(),
          Expanded(
            child: _buildStepContent(),
          ),
          _buildNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final padding = widget.compact
        ? const EdgeInsets.all(12)
        : const EdgeInsets.all(16);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildProgressWidget(),
          if (widget.showProgressPercentage) ...[
            const SizedBox(height: 8),
            _buildProgressPercentage(),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressWidget() {
    switch (widget.progressType) {
      case WizardProgressType.linear:
        return _buildLinearProgress();
      case WizardProgressType.steps:
        return _buildStepsProgress();
      case WizardProgressType.dots:
        return _buildDotsProgress();
      case WizardProgressType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLinearProgress() {
    final progress = (widget.currentStep + 1) / widget.steps.length;

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildStepsProgress() {
    return Row(
      children: widget.steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index == widget.currentStep;
        final isCompleted = index < widget.currentStep || step.isCompleted;
        final canNavigate = _canNavigateToStep(index);

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: canNavigate ? () => _navigateToStep(index) : null,
                  child: _buildStepIndicator(
                    index: index,
                    step: step,
                    isActive: isActive,
                    isCompleted: isCompleted,
                    canNavigate: canNavigate,
                  ),
                ),
              ),
              if (index < widget.steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepIndicator({
    required int index,
    required WizardStep step,
    required bool isActive,
    required bool isCompleted,
    required bool canNavigate,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Theme.of(context).colorScheme.primary
                : isActive
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
            border: isActive && !isCompleted
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              : step.icon != null
                  ? Icon(
                      step.icon,
                      size: 18,
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
        ),
        const SizedBox(height: 8),
        Text(
          step.title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDotsProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.steps.asMap().entries.map((entry) {
        final index = entry.key;
        final isActive = index == widget.currentStep;
        final isCompleted = index < widget.currentStep;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressPercentage() {
    final percentage = ((widget.currentStep + 1) / widget.steps.length * 100).round();

    return Text(
      '$percentage% завершено',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildStepContent() {
    if (widget.animateTransitions) {
      return PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.steps.length,
        itemBuilder: (context, index) {
          return _buildStepPage(widget.steps[index]);
        },
      );
    } else {
      return _buildStepPage(widget.steps[widget.currentStep]);
    }
  }

  Widget _buildStepPage(WizardStep step) {
    final padding = widget.compact
        ? const EdgeInsets.all(12)
        : const EdgeInsets.all(16);

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step.subtitle != null) ...[
            Text(
              step.subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
          ],
          step.content,
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    final isLastStep = widget.currentStep == widget.steps.length - 1;

    return Container(
      padding: EdgeInsets.all(widget.compact ? 12 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (widget.showCancelButton)
              TextButton(
                onPressed: widget.onCancel,
                child: Text(widget.cancelButtonText),
              ),
            const Spacer(),
            if (widget.canGoBack && widget.currentStep > 0)
              TextButton(
                onPressed: widget.isLoading ? null : _goBack,
                child: Text(widget.backButtonText),
              ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: widget.isLoading || !_canProceedFromCurrentStep()
                  ? null
                  : isLastStep
                      ? _complete
                      : _goNext,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isLastStep ? widget.completeButtonText : widget.nextButtonText),
            ),
          ],
        ),
      ),
    );
  }

  bool _canNavigateToStep(int stepIndex) {
    switch (widget.navigationMode) {
      case WizardNavigationMode.sequential:
        return stepIndex <= widget.currentStep;
      case WizardNavigationMode.flexible:
        return stepIndex <= widget.currentStep || widget.steps[stepIndex].isCompleted;
      case WizardNavigationMode.free:
        return true;
    }
  }

  bool _canProceedFromCurrentStep() {
    final step = widget.steps[widget.currentStep];
    return step.canProceed?.call() ?? widget.canProceedToNext;
  }

  void _onPageChanged(int index) {
    if (!_isTransitioning) {
      widget.onStepChanged?.call(index);
    }
  }

  Future<void> _navigateToStep(int stepIndex) async {
    if (stepIndex == widget.currentStep) return;

    widget.onStepChanged?.call(stepIndex);
    await _animateToStep(stepIndex);
  }

  Future<void> _animateToStep(int stepIndex) async {
    if (!widget.animateTransitions) return;

    _isTransitioning = true;
    await _pageController.animateToPage(
      stepIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _isTransitioning = false;
  }

  Future<void> _goNext() async {
    final currentStep = widget.steps[widget.currentStep];

    if (currentStep.onNext != null) {
      final canProceed = await currentStep.onNext!();
      if (!canProceed) return;
    }

    final nextStep = widget.currentStep + 1;
    if (nextStep < widget.steps.length) {
      widget.onStepChanged?.call(nextStep);
    }
  }

  void _goBack() {
    final currentStep = widget.steps[widget.currentStep];
    currentStep.onBack?.call();

    final previousStep = widget.currentStep - 1;
    if (previousStep >= 0) {
      widget.onStepChanged?.call(previousStep);
    }
  }

  Future<void> _complete() async {
    await widget.onComplete?.call();
  }
}