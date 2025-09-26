import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/atoms/typography/body_text.dart';

/// Оверлей загрузки с различными вариантами отображения
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final LoadingStyle style;
  final LoadingSize size;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool adaptive;
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.style = LoadingStyle.overlay,
    this.size = LoadingSize.medium,
    this.backgroundColor,
    this.progressColor,
    this.adaptive = true,
    this.dismissible = false,
  });

  /// Создает оверлей с полупрозрачным фоном
  const LoadingOverlay.modal({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.size = LoadingSize.medium,
    this.backgroundColor,
    this.progressColor,
    this.adaptive = true,
    this.dismissible = false,
  }) : style = LoadingStyle.modal;

  /// Создает встроенный индикатор загрузки
  const LoadingOverlay.inline({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.size = LoadingSize.medium,
    this.progressColor,
    this.adaptive = true,
  })  : style = LoadingStyle.inline,
        backgroundColor = null,
        dismissible = false;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    switch (style) {
      case LoadingStyle.overlay:
        return Stack(
          children: [
            child,
            _buildLoadingOverlay(context),
          ],
        );

      case LoadingStyle.modal:
        return Stack(
          children: [
            child,
            _buildModalOverlay(context),
          ],
        );

      case LoadingStyle.inline:
        return _buildInlineLoading(context);
    }
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: _getBackgroundColor(context),
        child: Center(
          child: _buildLoadingIndicator(context),
        ),
      ),
    );
  }

  Widget _buildModalOverlay(BuildContext context) {
    Widget content = Container(
      color: _getModalBackgroundColor(context),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(_getModalPadding()),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildLoadingIndicator(context),
        ),
      ),
    );

    if (dismissible) {
      content = GestureDetector(
        onTap: () {
          // Закрыть оверлей при тапе вне области
        },
        child: content,
      );
    }

    return Positioned.fill(child: content);
  }

  Widget _buildInlineLoading(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getInlinePadding()),
        child: _buildLoadingIndicator(context),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _getProgressSize(),
          height: _getProgressSize(),
          child: CircularProgressIndicator(
            strokeWidth: _getStrokeWidth(),
            valueColor: AlwaysStoppedAnimation(
              progressColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          SizedBox(height: _getMessageSpacing()),
          BodyText(
            message!,
            size: _getMessageTextSize(),
            textAlign: TextAlign.center,
            adaptive: adaptive,
            color: style == LoadingStyle.modal
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ],
      ],
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ??
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.8);
  }

  Color _getModalBackgroundColor(BuildContext context) {
    return backgroundColor ??
        Colors.black.withValues(alpha: 0.5);
  }

  double _getProgressSize() {
    switch (size) {
      case LoadingSize.small:
        return 24.0;
      case LoadingSize.medium:
        return 32.0;
      case LoadingSize.large:
        return 48.0;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2.0;
      case LoadingSize.medium:
        return 3.0;
      case LoadingSize.large:
        return 4.0;
    }
  }

  double _getModalPadding() {
    switch (size) {
      case LoadingSize.small:
        return AppSpacing.lg;
      case LoadingSize.medium:
        return AppSpacing.xl;
      case LoadingSize.large:
        return AppSpacing.xxl;
    }
  }

  double _getInlinePadding() {
    switch (size) {
      case LoadingSize.small:
        return AppSpacing.md;
      case LoadingSize.medium:
        return AppSpacing.lg;
      case LoadingSize.large:
        return AppSpacing.xl;
    }
  }

  double _getMessageSpacing() {
    switch (size) {
      case LoadingSize.small:
        return AppSpacing.md;
      case LoadingSize.medium:
        return AppSpacing.lg;
      case LoadingSize.large:
        return AppSpacing.xl;
    }
  }

  BodyTextSize _getMessageTextSize() {
    switch (size) {
      case LoadingSize.small:
        return BodyTextSize.small;
      case LoadingSize.medium:
        return BodyTextSize.medium;
      case LoadingSize.large:
        return BodyTextSize.large;
    }
  }
}

/// Стили отображения загрузки
enum LoadingStyle {
  overlay,  // Простой оверлей поверх контента
  modal,    // Модальный оверлей с карточкой
  inline,   // Встроенный индикатор вместо контента
}

/// Размеры индикатора загрузки
enum LoadingSize {
  small,
  medium,
  large,
}

/// Линейный индикатор прогресса
class LinearProgressOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double? value; // null для неопределенного прогресса
  final String? message;
  final Color? progressColor;
  final Color? backgroundColor;
  final LinearProgressPosition position;

  const LinearProgressOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.value,
    this.message,
    this.progressColor,
    this.backgroundColor,
    this.position = LinearProgressPosition.top,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final progressBar = LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation(
        progressColor ?? Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: backgroundColor ??
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
    );

    switch (position) {
      case LinearProgressPosition.top:
        return Column(
          children: [
            progressBar,
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: BodyText.small(
                  message!,
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(child: child),
          ],
        );

      case LinearProgressPosition.bottom:
        return Column(
          children: [
            Expanded(child: child),
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: BodyText.small(
                  message!,
                  textAlign: TextAlign.center,
                ),
              ),
            progressBar,
          ],
        );
    }
  }
}

/// Позиция линейного прогресс-бара
enum LinearProgressPosition {
  top,
  bottom,
}

/// Скелетон-загрузка для контента
class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final SkeletonShape shape;
  final double? width;
  final double? height;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.shape = SkeletonShape.rectangle,
    this.width,
    this.height,
    this.baseColor,
    this.highlightColor,
  });

  const SkeletonLoader.text({
    super.key,
    required this.child,
    required this.isLoading,
    this.width,
    this.height = 16,
    this.baseColor,
    this.highlightColor,
  }) : shape = SkeletonShape.rectangle;

  const SkeletonLoader.circle({
    super.key,
    required this.child,
    required this.isLoading,
    required double size,
    this.baseColor,
    this.highlightColor,
  })  : width = size,
        height = size,
        shape = SkeletonShape.circle;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    final theme = Theme.of(context);
    final baseColor = widget.baseColor ??
        theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ??
        theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5 + _animation.value * 0.1,
                1.0,
              ],
            ),
            borderRadius: widget.shape == SkeletonShape.circle
                ? BorderRadius.circular((widget.height ?? 16) / 2)
                : BorderRadius.circular(AppRadius.sm),
          ),
        );
      },
    );
  }
}

/// Формы скелетона
enum SkeletonShape {
  rectangle,
  circle,
}