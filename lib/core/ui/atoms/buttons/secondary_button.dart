import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/atoms/buttons/primary_button.dart';

/// Вторичная кнопка приложения
/// Используется для второстепенных действий (отмена, назад, дополнительные опции)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final ButtonSize size;
  final double? width;
  final SecondaryButtonVariant variant;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.width,
    this.variant = SecondaryButtonVariant.outlined,
  });

  const SecondaryButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.width,
    this.variant = SecondaryButtonVariant.outlined,
  });

  const SecondaryButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.width,
  }) : variant = SecondaryButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getHeight();

    if (width != null) {
      return SizedBox(
        width: width,
        child: _buildButton(context, buttonHeight),
      );
    }

    return _buildButton(context, buttonHeight);
  }

  Widget _buildButton(BuildContext context, double buttonHeight) {
    final child = _buildButtonContent();

    switch (variant) {
      case SecondaryButtonVariant.outlined:
        return _buildOutlinedButton(buttonHeight, child);
      case SecondaryButtonVariant.text:
        return _buildTextButton(buttonHeight, child);
      case SecondaryButtonVariant.filled:
        return _buildFilledButton(context, buttonHeight, child);
    }
  }

  Widget _buildOutlinedButton(double buttonHeight, Widget child) {
    final buttonStyle = OutlinedButton.styleFrom(
      minimumSize: Size(width ?? 0, buttonHeight),
      maximumSize: width != null ? Size(width!, buttonHeight) : null,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );

    if (icon != null && !isLoading) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        icon: icon!,
        label: child,
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }

  Widget _buildTextButton(double buttonHeight, Widget child) {
    final buttonStyle = TextButton.styleFrom(
      minimumSize: Size(width ?? 0, buttonHeight),
      maximumSize: width != null ? Size(width!, buttonHeight) : null,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );

    if (icon != null && !isLoading) {
      return TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        icon: icon!,
        label: child,
      );
    }

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }

  Widget _buildFilledButton(BuildContext context, double buttonHeight, Widget child) {
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      minimumSize: Size(width ?? 0, buttonHeight),
      maximumSize: width != null ? Size(width!, buttonHeight) : null,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );

    if (icon != null && !isLoading) {
      return FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        icon: icon!,
        label: child,
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == SecondaryButtonVariant.text
                    ? Colors.grey
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.buttonHeightSmall;
      case ButtonSize.medium:
        return AppSizes.buttonHeight;
      case ButtonSize.large:
        return AppSizes.buttonHeightLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.md;
      case ButtonSize.medium:
        return AppSpacing.lg;
      case ButtonSize.large:
        return AppSpacing.xl;
    }
  }

  double _getVerticalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.sm;
      case ButtonSize.medium:
        return AppSpacing.md;
      case ButtonSize.large:
        return AppSpacing.lg;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 18.0;
      case ButtonSize.large:
        return 20.0;
    }
  }
}

/// Варианты вторичной кнопки
enum SecondaryButtonVariant {
  outlined,  // С границей
  text,      // Только текст
  filled,    // Заливка вторичным цветом
}