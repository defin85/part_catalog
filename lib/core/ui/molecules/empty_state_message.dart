import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/atoms/buttons/primary_button.dart';
import 'package:part_catalog/core/ui/atoms/buttons/secondary_button.dart';
import 'package:part_catalog/core/ui/atoms/typography/heading.dart';
import 'package:part_catalog/core/ui/atoms/typography/body_text.dart';

/// Сообщение о пустом состоянии с поддержкой действий
class EmptyStateMessage extends StatelessWidget {
  final IconData? iconData;
  final Widget? icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final Widget? action;
  final EmptyStateSize size;
  final bool adaptive;

  const EmptyStateMessage({
    super.key,
    this.iconData,
    this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.medium,
    this.adaptive = true,
  });

  /// Создает пустое состояние для списка
  const EmptyStateMessage.list({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.medium,
    this.adaptive = true,
  }) : iconData = Icons.list_alt,
       icon = null;

  /// Создает пустое состояние для поиска
  const EmptyStateMessage.search({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.medium,
    this.adaptive = true,
  }) : iconData = Icons.search_off,
       icon = null;

  /// Создает пустое состояние для ошибки соединения
  const EmptyStateMessage.connection({
    super.key,
    this.title = 'Нет соединения',
    this.subtitle = 'Проверьте подключение к интернету и попробуйте еще раз',
    this.actionText = 'Повторить',
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.medium,
    this.adaptive = true,
  }) : iconData = Icons.wifi_off,
       icon = null;

  /// Создает пустое состояние для ошибки загрузки
  const EmptyStateMessage.error({
    super.key,
    this.title = 'Ошибка загрузки',
    this.subtitle = 'Что-то пошло не так при загрузке данных',
    this.actionText = 'Попробовать снова',
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.medium,
    this.adaptive = true,
  }) : iconData = Icons.error_outline,
       icon = null;

  /// Создает пустое состояние для новых пользователей
  const EmptyStateMessage.welcome({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText = 'Начать',
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.action,
    this.size = EmptyStateSize.large,
    this.adaptive = true,
  }) : iconData = Icons.celebration,
       icon = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null || iconData != null) ...[
                icon ?? Icon(
                  iconData!,
                  size: _getIconSize(),
                  color: _getIconColor(context),
                ),
                SizedBox(height: _getIconSpacing()),
              ],
              Heading(
                title,
                level: _getTitleLevel(),
                textAlign: TextAlign.center,
                adaptive: adaptive,
              ),
              if (subtitle != null) ...[
                SizedBox(height: _getSubtitleSpacing()),
                BodyText(
                  subtitle!,
                  size: _getSubtitleSize(),
                  textAlign: TextAlign.center,
                  adaptive: adaptive,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
              if (action != null || actionText != null || secondaryActionText != null) ...[
                SizedBox(height: _getActionSpacing()),
                action ?? _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final actions = <Widget>[];

    if (actionText != null && onAction != null) {
      actions.add(
        PrimaryButton(
          text: actionText!,
          onPressed: onAction,
          size: _getButtonSize(),
        ),
      );
    }

    if (secondaryActionText != null && onSecondaryAction != null) {
      if (actions.isNotEmpty) {
        actions.add(SizedBox(width: AppSpacing.md));
      }
      actions.add(
        SecondaryButton(
          text: secondaryActionText!,
          onPressed: onSecondaryAction,
          size: _getButtonSize(),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    // На мобильных устройствах располагаем кнопки вертикально
    if (adaptive && AppBreakpoints.isMobile(context) && actions.length > 1) {
      return Column(
        children: [
          actions[0],
          const SizedBox(height: AppSpacing.sm),
          if (actions.length > 1) actions[1],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: actions,
    );
  }

  double _getIconSize() {
    switch (size) {
      case EmptyStateSize.small:
        return 48;
      case EmptyStateSize.medium:
        return 64;
      case EmptyStateSize.large:
        return 80;
    }
  }

  Color _getIconColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
  }

  double _getPadding(BuildContext context) {
    if (!adaptive) return 24.0; // AppSpacing.xl;

    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 16.0;
    } else if (width < 1200) {
      return 32.0;
    } else {
      return 48.0;
    }
  }

  double _getMaxWidth(BuildContext context) {
    if (!adaptive) return 400;

    if (AppBreakpoints.isMobile(context)) {
      return MediaQuery.of(context).size.width * 0.9;
    } else if (AppBreakpoints.isTablet(context)) {
      return 480;
    } else {
      return 520;
    }
  }

  HeadingLevel _getTitleLevel() {
    switch (size) {
      case EmptyStateSize.small:
        return HeadingLevel.h5;
      case EmptyStateSize.medium:
        return HeadingLevel.h4;
      case EmptyStateSize.large:
        return HeadingLevel.h3;
    }
  }

  BodyTextSize _getSubtitleSize() {
    switch (size) {
      case EmptyStateSize.small:
        return BodyTextSize.small;
      case EmptyStateSize.medium:
        return BodyTextSize.medium;
      case EmptyStateSize.large:
        return BodyTextSize.large;
    }
  }

  ButtonSize _getButtonSize() {
    switch (size) {
      case EmptyStateSize.small:
        return ButtonSize.small;
      case EmptyStateSize.medium:
        return ButtonSize.medium;
      case EmptyStateSize.large:
        return ButtonSize.large;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case EmptyStateSize.small:
        return AppSpacing.lg;
      case EmptyStateSize.medium:
        return AppSpacing.xl;
      case EmptyStateSize.large:
        return AppSpacing.xxl;
    }
  }

  double _getSubtitleSpacing() {
    switch (size) {
      case EmptyStateSize.small:
        return AppSpacing.sm;
      case EmptyStateSize.medium:
        return AppSpacing.md;
      case EmptyStateSize.large:
        return AppSpacing.lg;
    }
  }

  double _getActionSpacing() {
    switch (size) {
      case EmptyStateSize.small:
        return AppSpacing.lg;
      case EmptyStateSize.medium:
        return AppSpacing.xl;
      case EmptyStateSize.large:
        return AppSpacing.xxl;
    }
  }
}

/// Размеры пустого состояния
enum EmptyStateSize {
  small,   // Компактное отображение
  medium,  // Обычное отображение
  large,   // Расширенное отображение для важных состояний
}

/// Готовые конфигурации для типичных случаев
class EmptyStateConfigs {
  /// Конфигурация для пустого списка клиентов
  static EmptyStateMessage clients({
    VoidCallback? onAddClient,
    VoidCallback? onImportClients,
  }) {
    return EmptyStateMessage.list(
      title: 'Нет клиентов',
      subtitle: 'Добавьте первого клиента для начала работы',
      actionText: onAddClient != null ? 'Добавить клиента' : null,
      onAction: onAddClient,
      secondaryActionText: onImportClients != null ? 'Импорт' : null,
      onSecondaryAction: onImportClients,
    );
  }

  /// Конфигурация для пустого списка заказов
  static EmptyStateMessage orders({
    VoidCallback? onCreateOrder,
  }) {
    return EmptyStateMessage.list(
      title: 'Заказы отсутствуют',
      subtitle: 'Создайте первый заказ для начала работы с системой',
      actionText: onCreateOrder != null ? 'Создать заказ' : null,
      onAction: onCreateOrder,
    );
  }

  /// Конфигурация для результатов поиска
  static EmptyStateMessage searchResults({
    required String query,
    VoidCallback? onClearSearch,
  }) {
    return EmptyStateMessage.search(
      title: 'Ничего не найдено',
      subtitle: 'По запросу "$query" результаты отсутствуют',
      actionText: onClearSearch != null ? 'Очистить поиск' : null,
      onAction: onClearSearch,
    );
  }

  /// Конфигурация для ошибки сети
  static EmptyStateMessage networkError({
    VoidCallback? onRetry,
  }) {
    return EmptyStateMessage.connection(
      onAction: onRetry,
    );
  }

  /// Конфигурация для общей ошибки
  static EmptyStateMessage genericError({
    String? message,
    VoidCallback? onRetry,
  }) {
    return EmptyStateMessage.error(
      subtitle: message ?? 'Что-то пошло не так при загрузке данных',
      onAction: onRetry,
    );
  }

  /// Конфигурация для первого запуска
  static EmptyStateMessage welcome({
    required String title,
    String? subtitle,
    VoidCallback? onGetStarted,
  }) {
    return EmptyStateMessage.welcome(
      title: title,
      subtitle: subtitle,
      onAction: onGetStarted,
    );
  }
}