import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Адаптивный AppBar для разных размеров экранов
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileAppBar(context),
      medium: (context, constraints) => _buildTabletAppBar(context),
      large: (context, constraints) => _buildDesktopAppBar(context),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile AppBar (стандартный)
  Widget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      bottom: bottom,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  /// Tablet AppBar (немного увеличенный)
  Widget _buildTabletAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: actions?.map((action) {
        // Увеличиваем размер кнопок для планшета
        if (action is IconButton) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: action,
          );
        }
        return action;
      }).toList(),
      leading: leading,
      bottom: bottom,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 2,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: 64, // Немного увеличиваем высоту
    );
  }

  /// Desktop AppBar (интегрированный в content area)
  Widget _buildDesktopAppBar(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 72, // Увеличенная высота для desktop
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                if (actions != null) ...[
                  const SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!
                        .map((action) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: action,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      (bottom?.preferredSize.height ?? 0.0) +
      // Динамическая высота в зависимости от экрана
      72.0, // Базовая высота для desktop
    );
  }
}

/// Адаптивная высота AppBar в зависимости от размера экрана
class AdaptiveAppBarHeight {
  static double getHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1000) return 72; // Desktop
    if (width >= 600) return 64;  // Tablet
    return 56; // Mobile (стандартная высота)
  }
}