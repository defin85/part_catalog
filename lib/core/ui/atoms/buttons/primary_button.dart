import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';

/// Основная кнопка приложения
/// Используется для главных действий (сохранить, создать, подтвердить)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final ButtonSize size;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.width,
  });

  const PrimaryButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getHeight();
    final buttonStyle = ElevatedButton.styleFrom(
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

    if (width != null) {
      return SizedBox(
        width: width,
        child: _buildButton(buttonStyle),
      );
    }

    return _buildButton(buttonStyle);
  }

  Widget _buildButton(ButtonStyle style) {
    final child = _buildButtonContent();

    if (icon != null && !isLoading) {
      return ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: style,
        icon: icon!,
        label: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
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
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

/// Размеры кнопок
enum ButtonSize {
  small,
  medium,
  large,
}