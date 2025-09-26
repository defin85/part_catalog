import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Универсальный компонент для обработки принудительного закрытия экранов
///
/// Предоставляет несколько способов закрытия экрана:
/// - Клавиша Escape (для настольных платформ)
/// - Свайп вниз (для мобильных устройств)
/// - Двойной тап по области контента
/// - Жест "back" на Android
class EscapeHandler extends StatelessWidget {
  const EscapeHandler({
    super.key,
    required this.child,
    this.onEscape,
    this.enableKeyboardEscape = true,
    this.enableSwipeToClose = true,
    this.enableDoubleTapToClose = false,
    this.enableBackGesture = true,
    this.showCloseButton = false,
    this.closeButtonPosition = CloseButtonPosition.topRight,
  });

  final Widget child;
  final VoidCallback? onEscape;
  final bool enableKeyboardEscape;
  final bool enableSwipeToClose;
  final bool enableDoubleTapToClose;
  final bool enableBackGesture;
  final bool showCloseButton;
  final CloseButtonPosition closeButtonPosition;

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // Добавляем обработку клавиши Escape
    if (enableKeyboardEscape) {
      content = KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            _handleEscape(context);
          }
        },
        child: content,
      );
    }

    // Добавляем обработку свайпа для закрытия
    if (enableSwipeToClose) {
      content = GestureDetector(
        onPanUpdate: (details) {
          // Свайп вниз для закрытия (минимум 100 пикселей)
          if (details.delta.dy > 0 && details.delta.dy > 10) {
            // Можно добавить визуальную обратную связь
          }
        },
        onPanEnd: (details) {
          // Если свайп вниз достаточно быстрый и длинный
          if (details.velocity.pixelsPerSecond.dy > 300) {
            _handleEscape(context);
          }
        },
        child: content,
      );
    }

    // Добавляем обработку двойного тапа
    if (enableDoubleTapToClose) {
      content = GestureDetector(
        onDoubleTap: () => _handleEscape(context),
        child: content,
      );
    }

    // Добавляем обработку системной кнопки "назад"
    if (enableBackGesture) {
      content = PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleEscape(context);
          }
        },
        child: content,
      );
    }

    // Добавляем кнопку закрытия если необходимо
    if (showCloseButton) {
      content = Stack(
        children: [
          content,
          Positioned(
            top: closeButtonPosition == CloseButtonPosition.topRight ||
                   closeButtonPosition == CloseButtonPosition.topLeft ? 16 : null,
            bottom: closeButtonPosition == CloseButtonPosition.bottomRight ||
                     closeButtonPosition == CloseButtonPosition.bottomLeft ? 16 : null,
            right: closeButtonPosition == CloseButtonPosition.topRight ||
                    closeButtonPosition == CloseButtonPosition.bottomRight ? 16 : null,
            left: closeButtonPosition == CloseButtonPosition.topLeft ||
                   closeButtonPosition == CloseButtonPosition.bottomLeft ? 16 : null,
            child: _buildCloseButton(context),
          ),
        ],
      );
    }

    return content;
  }

  Widget _buildCloseButton(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: Theme.of(context).colorScheme.surface,
      child: IconButton(
        onPressed: () => _handleEscape(context),
        icon: const Icon(Icons.close),
        tooltip: 'Закрыть (Esc)',
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  void _handleEscape(BuildContext context) {
    if (onEscape != null) {
      onEscape!();
    } else {
      // По умолчанию - закрыть экран
      Navigator.of(context).maybePop();
    }
  }
}

/// Позиция кнопки закрытия
enum CloseButtonPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Предустановленные конфигурации EscapeHandler
class EscapeHandlerPresets {

  /// Конфигурация для полноэкранных модальных окон
  static EscapeHandler modal({
    Key? key,
    required Widget child,
    VoidCallback? onEscape,
  }) {
    return EscapeHandler(
      key: key,
      onEscape: onEscape,
      enableKeyboardEscape: true,
      enableSwipeToClose: true,
      enableDoubleTapToClose: false,
      enableBackGesture: true,
      showCloseButton: true,
      closeButtonPosition: CloseButtonPosition.topRight,
      child: child,
    );
  }

  /// Конфигурация для экранов настроек
  static EscapeHandler settings({
    Key? key,
    required Widget child,
    VoidCallback? onEscape,
  }) {
    return EscapeHandler(
      key: key,
      onEscape: onEscape,
      enableKeyboardEscape: true,
      enableSwipeToClose: false, // Отключаем свайп для избежания случайного закрытия
      enableDoubleTapToClose: false,
      enableBackGesture: true,
      showCloseButton: true,
      closeButtonPosition: CloseButtonPosition.topLeft,
      child: child,
    );
  }

  /// Конфигурация для экранов форм
  static EscapeHandler form({
    Key? key,
    required Widget child,
    VoidCallback? onEscape,
  }) {
    return EscapeHandler(
      key: key,
      onEscape: onEscape,
      enableKeyboardEscape: true,
      enableSwipeToClose: false, // Отключаем для избежания потери данных
      enableDoubleTapToClose: false,
      enableBackGesture: true,
      showCloseButton: false, // Полагаемся на AppBar
      child: child,
    );
  }

  /// Конфигурация для экранов просмотра
  static EscapeHandler viewer({
    Key? key,
    required Widget child,
    VoidCallback? onEscape,
  }) {
    return EscapeHandler(
      key: key,
      onEscape: onEscape,
      enableKeyboardEscape: true,
      enableSwipeToClose: true,
      enableDoubleTapToClose: true, // Удобно для быстрого закрытия
      enableBackGesture: true,
      showCloseButton: false,
      child: child,
    );
  }

  /// Минималистичная конфигурация - только Escape и системная кнопка назад
  static EscapeHandler minimal({
    Key? key,
    required Widget child,
    VoidCallback? onEscape,
  }) {
    return EscapeHandler(
      key: key,
      onEscape: onEscape,
      enableKeyboardEscape: true,
      enableSwipeToClose: false,
      enableDoubleTapToClose: false,
      enableBackGesture: true,
      showCloseButton: false,
      child: child,
    );
  }
}