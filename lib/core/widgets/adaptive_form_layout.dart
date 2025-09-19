import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Адаптивная компоновка формы
/// Desktop: 2-3 колонки, Tablet: 2 колонки, Mobile: 1 колонка
class AdaptiveFormLayout extends StatelessWidget {
  final List<Widget> fields;
  final EdgeInsets? padding;
  final double spacing;
  final double runSpacing;

  const AdaptiveFormLayout({
    super.key,
    required this.fields,
    this.padding,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildSingleColumn(),
      medium: (context, constraints) => _buildTwoColumns(constraints),
      large: (context, constraints) => _buildThreeColumns(constraints),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Одна колонка (мобайл)
  Widget _buildSingleColumn() {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields
            .map((field) => Padding(
                  padding: EdgeInsets.only(bottom: runSpacing),
                  child: field,
                ))
            .toList(),
      ),
    );
  }

  /// Две колонки (планшет)
  Widget _buildTwoColumns(BoxConstraints constraints) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: fields.map((field) {
          final fieldWidth = (constraints.maxWidth - spacing) / 2;
          return SizedBox(
            width: fieldWidth,
            child: field,
          );
        }).toList(),
      ),
    );
  }

  /// Три колонки (десктоп)
  Widget _buildThreeColumns(BoxConstraints constraints) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: fields.map((field) {
          final fieldWidth = (constraints.maxWidth - (spacing * 2)) / 3;
          return SizedBox(
            width: fieldWidth,
            child: field,
          );
        }).toList(),
      ),
    );
  }
}

/// Виджет для полей, которые должны занимать всю ширину
class FullWidthField extends StatelessWidget {
  final Widget child;

  const FullWidthField({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}

/// Виджет для группировки полей в секции
class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets? padding;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Адаптивные отступы в зависимости от размера экрана
class AdaptiveSpacing {
  static double padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 32;
    if (width > 800) return 24;
    if (width > 600) return 16;
    return 12;
  }

  static double margin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 24;
    if (width > 800) return 16;
    if (width > 600) return 12;
    return 8;
  }

  static double fieldSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) return 16;
    return 12;
  }

  static double sectionSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) return 32;
    return 24;
  }
}