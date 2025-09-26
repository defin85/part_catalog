import 'package:flutter/material.dart';

/// Секция с многошаговой навигацией
/// Идеально подходит для мастеров настройки и многоэтапных форм
class StepperSection extends StatefulWidget {
  final List<StepperItem> steps;
  final int currentStep;
  final ValueChanged<int>? onStepChanged;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onFinish;
  final StepperType type;
  final EdgeInsets? padding;
  final bool showControls;
  final String? nextText;
  final String? previousText;
  final String? finishText;
  final bool canGoNext;
  final bool canGoPrevious;

  const StepperSection({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.onStepChanged,
    this.onNext,
    this.onPrevious,
    this.onFinish,
    this.type = StepperType.vertical,
    this.padding,
    this.showControls = true,
    this.nextText,
    this.previousText,
    this.finishText,
    this.canGoNext = true,
    this.canGoPrevious = true,
  });

  @override
  State<StepperSection> createState() => _StepperSectionState();
}

class _StepperSectionState extends State<StepperSection> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep.clamp(0, widget.steps.length - 1);
  }

  @override
  void didUpdateWidget(StepperSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _currentStep = widget.currentStep.clamp(0, widget.steps.length - 1);
    }
  }

  void _onStepTapped(int step) {
    if (step == _currentStep || !widget.steps[step].isActive) return;

    setState(() {
      _currentStep = step;
    });
    widget.onStepChanged?.call(step);
  }

  void _onNext() {
    if (_currentStep < widget.steps.length - 1 && widget.canGoNext) {
      setState(() {
        _currentStep++;
      });
      widget.onStepChanged?.call(_currentStep);
      widget.onNext?.call();
    } else if (_currentStep == widget.steps.length - 1) {
      widget.onFinish?.call();
    }
  }

  void _onPrevious() {
    if (_currentStep > 0 && widget.canGoPrevious) {
      setState(() {
        _currentStep--;
      });
      widget.onStepChanged?.call(_currentStep);
      widget.onPrevious?.call();
    }
  }

  bool get _isLastStep => _currentStep == widget.steps.length - 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stepper(
            type: widget.type,
            currentStep: _currentStep,
            onStepTapped: _onStepTapped,
            controlsBuilder: widget.showControls ? _buildControls : (_, __) => const SizedBox.shrink(),
            steps: widget.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final stepItem = entry.value;

              return Step(
                title: Text(stepItem.title),
                content: stepItem.content,
                subtitle: stepItem.subtitle != null ? Text(stepItem.subtitle!) : null,
                isActive: stepItem.isActive && index <= _currentStep,
                state: _getStepState(index, stepItem),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  StepState _getStepState(int index, StepperItem stepItem) {
    if (!stepItem.isActive) {
      return StepState.disabled;
    }
    if (stepItem.hasError) {
      return StepState.error;
    }
    if (index < _currentStep) {
      return stepItem.isCompleted ? StepState.complete : StepState.indexed;
    }
    if (index == _currentStep) {
      return StepState.indexed;
    }
    return StepState.indexed;
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: widget.canGoPrevious ? _onPrevious : null,
              child: Text(widget.previousText ?? 'Назад'),
            ),
          const SizedBox(width: 8),
          if (_currentStep < widget.steps.length - 1)
            FilledButton(
              onPressed: widget.canGoNext ? _onNext : null,
              child: Text(widget.nextText ?? 'Далее'),
            ),
          if (_isLastStep)
            FilledButton(
              onPressed: widget.canGoNext ? _onNext : null,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(widget.finishText ?? 'Завершить'),
            ),
          const Spacer(),
          Text(
            'Шаг ${_currentStep + 1} из ${widget.steps.length}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Элемент шага в многошаговой навигации
class StepperItem {
  final String title;
  final Widget content;
  final String? subtitle;
  final bool isActive;
  final bool isCompleted;
  final bool hasError;

  const StepperItem({
    required this.title,
    required this.content,
    this.subtitle,
    this.isActive = true,
    this.isCompleted = false,
    this.hasError = false,
  });

  StepperItem copyWith({
    String? title,
    Widget? content,
    String? subtitle,
    bool? isActive,
    bool? isCompleted,
    bool? hasError,
  }) {
    return StepperItem(
      title: title ?? this.title,
      content: content ?? this.content,
      subtitle: subtitle ?? this.subtitle,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Горизонтальная версия степпера для небольших экранов
class HorizontalStepperSection extends StatefulWidget {
  final List<StepperItem> steps;
  final int currentStep;
  final ValueChanged<int>? onStepChanged;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onFinish;
  final EdgeInsets? padding;
  final bool showControls;

  const HorizontalStepperSection({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.onStepChanged,
    this.onNext,
    this.onPrevious,
    this.onFinish,
    this.padding,
    this.showControls = true,
  });

  @override
  State<HorizontalStepperSection> createState() => _HorizontalStepperSectionState();
}

class _HorizontalStepperSectionState extends State<HorizontalStepperSection> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep.clamp(0, widget.steps.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Горизонтальный индикатор прогресса
        Container(
          padding: widget.padding ?? const EdgeInsets.all(16),
          child: Column(
            children: [
              // Прогресс-бар
              LinearProgressIndicator(
                value: (_currentStep + 1) / widget.steps.length,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
              const SizedBox(height: 8),
              // Названия шагов
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isActive = index <= _currentStep;
                  final isCurrent = index == _currentStep;

                  return Expanded(
                    child: Text(
                      step.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isActive
                          ? (isCurrent ? colorScheme.primary : colorScheme.onSurface)
                          : colorScheme.onSurfaceVariant,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // Контент текущего шага
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.steps[_currentStep].content,
          ),
        ),
        // Контролы навигации
        if (widget.showControls)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                      widget.onStepChanged?.call(_currentStep);
                      widget.onPrevious?.call();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Назад'),
                  ),
                const Spacer(),
                Text(
                  'Шаг ${_currentStep + 1} из ${widget.steps.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (_currentStep < widget.steps.length - 1)
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentStep++;
                      });
                      widget.onStepChanged?.call(_currentStep);
                      widget.onNext?.call();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Далее'),
                  )
                else
                  FilledButton.icon(
                    onPressed: () => widget.onFinish?.call(),
                    icon: const Icon(Icons.check),
                    label: const Text('Завершить'),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}