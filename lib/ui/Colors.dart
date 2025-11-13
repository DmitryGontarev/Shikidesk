import 'dart:ui';

abstract class ShikidroidColors {
  /// Цвет статуса выхода аниме/манги
  static const anonsColor = Color(0xFFFD855F);
  static const ongoingColor = Color(0xFF0088FF);
  static const releasedColor = Color(0xFF00A700);

  /// Цвета списков пользовательского рейтинга
  static const plannedColor = Color(0xFF9357FF);
  static const reWatchingColor = Color(0xFFFD855F);
  static const watchingColor = Color(0xFF4FA4FF);
  static const completedColor = Color(0xFF00A700);
  static const droppedColor = Color(0xFFFF4444);
  static const onHoldColor = Color(0xFFFFE500);
  static const backgroundPlannedColor = Color(0x1A9357FF);
  static const backgroundReWatchingColor = Color(0x1AFD855F);
  static const backgroundWatchingColor = Color(0x1A4FA4FF);
  static const backgroundCompletedColor = Color(0x1A00A700);
  static const backgroundDroppedColor = Color(0x1AFF4444);
  static const backgroundOnHoldColor = Color(0x1AFFE500);
  static const backgroundUnselectedColor = Color(0x1A8B8B8B);

  /// Цвета тёмной темы
  static const defaultColorPrimary = Color(0xFFFFFFFF);
  static const defaultColorPrimaryVariant = Color(0xFFC7C7C7);
  static Color defaultColorPrimaryBorderVariant = const Color(0xFFC7C7C7).withAlpha(12);
  static const defaultColorSecondary = Color(0xFFFF7043);
  static const defaultColorSecondaryVariant = Color(0x1AFD855F);
  static const defaultColorSecondaryLightVariant = Color(0xFFFD855F);
  static const defaultColorBackground = Color(0xFFFFFFFF);
  static const defaultColorSurface = Color(0xFFFFFFFF);
  static const defaultColorOnPrimary = Color(0xFF000000);
  static const defaultColorOnSecondary = Color(0xFFFFFFFF);
  static const defaultColorOnBackground = Color(0xFF7B8084);
  static const defaultColorOnSurface = Color(0xFF000000);
// цвет статус бара
  static const defaultColorStatusBar = Color(0xDEFFFFFF);
// цвет выбранного элемента для AndroidTV
  static const defaultColorTvSelectable = Color(0x1A7B8084);
  
  /// Цвета тёмной темы
  static const darkColorPrimary = Color(0xFF000000);
  static const darkColorPrimaryVariant = Color(0x99FFFFFF);
  static Color darkColorPrimaryBorderVariant = const Color(0x99FFFFFF).withAlpha(12);
  static const darkColorSecondary = Color(0xFFFF7043);
  static const darkColorSecondaryVariant = Color(0x1AFD855F);
  static const darkColorSecondaryLightVariant = Color(0xFFFD855F);
  static const darkColorBackground = Color(0xFF000000);
  static const darkColorSurface = Color(0xFF000000);
  static const darkColorOnPrimary = Color(0xFFFFFFFF);
  static const darkColorOnSecondary = Color(0xFF000000);
  static const darkColorOnBackground = Color(0x61FFFFFF);
  static const darkColorOnSurface = Color(0xDEFFFFFF);
// цвет статус бара
  static const darkColorStatusBar = Color(0xFF000000);
// цвет выбранного элемента для AndroidTV
  static const darkColorTvSelectable = Color(0x1A7B8084);
}