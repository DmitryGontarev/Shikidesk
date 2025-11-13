import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Colors.dart';

////////////////////////////////////////////////////////////////////////////////
/// Цвета Светлой темы
////////////////////////////////////////////////////////////////////////////////
ThemeData createLightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: ShikidroidColors.defaultColorPrimary,
      textTheme: createLightTextTheme(),
      scaffoldBackgroundColor: ShikidroidColors.defaultColorPrimary,
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: ShikidroidColors.defaultColorPrimary,
          primary: ShikidroidColors.defaultColorPrimary,
          onPrimary: ShikidroidColors.defaultColorOnPrimary,
          background: ShikidroidColors.defaultColorBackground,
          onBackground: ShikidroidColors.defaultColorOnBackground,
          surface: ShikidroidColors.defaultColorSurface,
          onSurface: ShikidroidColors.defaultColorOnSurface,
          secondary: ShikidroidColors.defaultColorSecondary,
          secondaryContainer: ShikidroidColors.defaultColorSecondaryVariant),
      useMaterial3: true);
}

TextTheme createLightTextTheme() {
  return const TextTheme(
      titleLarge: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.defaultColorOnPrimary),
      displaySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.defaultColorOnPrimary),
      displayMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.defaultColorOnPrimary),
      displayLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ShikidroidColors.defaultColorOnPrimary));
}

////////////////////////////////////////////////////////////////////////////////
/// Цвета Тёмной темы
////////////////////////////////////////////////////////////////////////////////
ThemeData createDarkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ShikidroidColors.darkColorPrimary,
      textTheme: createDarkTextTheme(),
      scaffoldBackgroundColor: ShikidroidColors.darkColorPrimary,
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: ShikidroidColors.darkColorPrimary,
          primary: ShikidroidColors.darkColorPrimary,
          onPrimary: ShikidroidColors.darkColorOnPrimary,
          background: ShikidroidColors.darkColorBackground,
          onBackground: ShikidroidColors.darkColorOnBackground,
          surface: ShikidroidColors.darkColorSurface,
          onSurface: ShikidroidColors.darkColorOnSurface,
          secondary: ShikidroidColors.darkColorSecondary,
          secondaryContainer: ShikidroidColors.darkColorSecondaryVariant),
      useMaterial3: true);
}

TextTheme createDarkTextTheme() {
  return const TextTheme(
      titleLarge: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.darkColorOnPrimary),
      displaySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.darkColorOnPrimary),
      displayMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ShikidroidColors.darkColorOnPrimary),
      displayLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ShikidroidColors.darkColorOnPrimary));
}
