import 'package:flutter/material.dart';

/// Централизованная система отступов и размеров
/// Обеспечивает консистентность в размещении элементов UI
class AppSpacing {
  AppSpacing._();

  // =======================
  // БАЗОВЫЕ ОТСТУПЫ (8pt grid system)
  // =======================

  /// Базовая единица отступа (8pt)
  static const double base = 8.0;

  /// Очень маленький отступ
  static const double xs = base * 0.5; // 4pt

  /// Маленький отступ
  static const double sm = base; // 8pt

  /// Средний отступ
  static const double md = base * 2; // 16pt

  /// Большой отступ
  static const double lg = base * 3; // 24pt

  /// Очень большой отступ
  static const double xl = base * 4; // 32pt

  /// Экстра большой отступ
  static const double xxl = base * 5; // 40pt

  /// Массивный отступ
  static const double xxxl = base * 6; // 48pt

  // =======================
  // СПЕЦИАЛИЗИРОВАННЫЕ ОТСТУПЫ
  // =======================

  /// Отступы для карточек
  static const double cardPadding = md; // 16pt
  static const double cardMargin = sm; // 8pt
  static const double cardRadius = md; // 16pt

  /// Отступы для списков
  static const double listItemPadding = md; // 16pt
  static const double listItemSpacing = sm; // 8pt
  static const double listSectionSpacing = lg; // 24pt

  /// Отступы для форм
  static const double formFieldSpacing = md; // 16pt
  static const double formSectionSpacing = xl; // 32pt
  static const double formPadding = md; // 16pt

  /// Отступы для кнопок
  static const double buttonPadding = md; // 16pt
  static const double buttonSpacing = sm; // 8pt
  static const double buttonRadius = sm; // 8pt

  /// Отступы для экранов
  static const double screenPadding = md; // 16pt
  static const double screenMargin = sm; // 8pt

  /// Отступы для диалогов
  static const double dialogPadding = lg; // 24pt
  static const double dialogMargin = md; // 16pt
  static const double dialogRadius = md; // 16pt

  // =======================
  // РАЗМЕРЫ ЭЛЕМЕНТОВ
  // =======================

  /// Высоты элементов
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double tabHeight = 48.0;
  static const double listItemHeight = 72.0;
  static const double chipHeight = 32.0;
  static const double iconButtonSize = 48.0;

  /// Размеры иконок
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;

  /// Размеры аватаров
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;

  // =======================
  // АДАПТИВНЫЕ ОТСТУПЫ
  // =======================

  /// Боковые отступы экрана в зависимости от размера
  static double getScreenHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return md; // 16pt на мобильных
    } else if (width < 1200) {
      return xl; // 32pt на планшетах
    } else {
      return xxxl; // 48pt на десктопах
    }
  }

  /// Вертикальные отступы экрана в зависимости от размера
  static double getScreenVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    if (height < 600) {
      return sm; // 8pt на маленьких экранах
    } else {
      return md; // 16pt на больших экранах
    }
  }

  /// Размер сетки для контента
  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return width; // Полная ширина на мобильных
    } else if (width < 1200) {
      return 800; // Ограничение на планшетах
    } else {
      return 1200; // Максимум на десктопах
    }
  }

  // =======================
  // ГОТОВЫЕ EDGE INSETS
  // =======================

  /// Стандартные отступы для разных элементов
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// Горизонтальные отступы
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  /// Вертикальные отступы
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  /// Отступы только снизу (для списков)
  static const EdgeInsets bottomXs = EdgeInsets.only(bottom: xs);
  static const EdgeInsets bottomSm = EdgeInsets.only(bottom: sm);
  static const EdgeInsets bottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets bottomLg = EdgeInsets.only(bottom: lg);
  static const EdgeInsets bottomXl = EdgeInsets.only(bottom: xl);

  /// Отступы только сверху
  static const EdgeInsets topXs = EdgeInsets.only(top: xs);
  static const EdgeInsets topSm = EdgeInsets.only(top: sm);
  static const EdgeInsets topMd = EdgeInsets.only(top: md);
  static const EdgeInsets topLg = EdgeInsets.only(top: lg);
  static const EdgeInsets topXl = EdgeInsets.only(top: xl);

  /// Специальные комбинации отступов
  static const EdgeInsets cardPadding_ = EdgeInsets.all(cardPadding);
  static const EdgeInsets formPadding_ = EdgeInsets.all(formPadding);
  static const EdgeInsets buttonPadding_ = EdgeInsets.all(buttonPadding);
  static const EdgeInsets screenPadding_ = EdgeInsets.all(screenPadding);

  // =======================
  // РАЗМЕРЫ КОНТЕЙНЕРОВ
  // =======================

  /// Размеры для разных типов контейнеров
  static const Size buttonSize = Size.fromHeight(buttonHeight);
  static const Size inputSize = Size.fromHeight(inputHeight);
  static const Size chipSize = Size.fromHeight(chipHeight);
  static const Size iconButtonSize_ = Size.square(iconButtonSize);

  // =======================
  // РАДИУСЫ СКРУГЛЕНИЯ
  // =======================

  /// Стандартные радиусы
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusRound = 1000.0; // Для полностью круглых элементов

  /// Готовые BorderRadius
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(radiusRound));

  /// Специальные радиусы для элементов
  static const BorderRadius cardRadius_ = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius buttonRadius_ = BorderRadius.all(Radius.circular(buttonRadius));
  static const BorderRadius dialogRadius_ = BorderRadius.all(Radius.circular(dialogRadius));

  // =======================
  // УТИЛИТАРНЫЕ МЕТОДЫ
  // =======================

  /// Создать SizedBox с заданной высотой
  static Widget heightXs([Widget? child]) => SizedBox(height: xs, child: child);
  static Widget heightSm([Widget? child]) => SizedBox(height: sm, child: child);
  static Widget heightMd([Widget? child]) => SizedBox(height: md, child: child);
  static Widget heightLg([Widget? child]) => SizedBox(height: lg, child: child);
  static Widget heightXl([Widget? child]) => SizedBox(height: xl, child: child);

  /// Создать SizedBox с заданной шириной
  static Widget widthXs([Widget? child]) => SizedBox(width: xs, child: child);
  static Widget widthSm([Widget? child]) => SizedBox(width: sm, child: child);
  static Widget widthMd([Widget? child]) => SizedBox(width: md, child: child);
  static Widget widthLg([Widget? child]) => SizedBox(width: lg, child: child);
  static Widget widthXl([Widget? child]) => SizedBox(width: xl, child: child);

  /// Создать Divider с нужными отступами
  static Widget divider({double? indent, double? endIndent}) => Divider(
    indent: indent ?? md,
    endIndent: endIndent ?? md,
  );

  /// Создать вертикальный Divider с нужными отступами
  static Widget verticalDivider({double? indent, double? endIndent}) => VerticalDivider(
    indent: indent ?? md,
    endIndent: endIndent ?? md,
  );

  /// Создать Container с адаптивными отступами
  static Widget adaptiveContainer({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
  }) {
    final horizontalPadding = getScreenHorizontalPadding(context);
    final verticalPadding = getScreenVerticalPadding(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: getContentMaxWidth(context),
      ),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: child,
    );
  }

  /// Создать SafeArea с отступами
  static Widget safeArea({
    required Widget child,
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }
}