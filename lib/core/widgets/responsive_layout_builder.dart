import 'package:flutter/material.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints);

class ResponsiveLayoutBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder small;
  final ResponsiveWidgetBuilder? medium;
  final ResponsiveWidgetBuilder? large;
  final double mediumBreakpoint;
  final double largeBreakpoint;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.small,
    this.medium,
    this.large,
    this.mediumBreakpoint = 600.0,
    this.largeBreakpoint = 900.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= largeBreakpoint && large != null) {
          return large!(context, constraints);
        } else if (constraints.maxWidth >= mediumBreakpoint && medium != null) {
          return medium!(context, constraints);
        } else {
          return small(context, constraints);
        }
      },
    );
  }
}
