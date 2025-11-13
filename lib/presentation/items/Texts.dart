import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Разделитель текста Точка
////////////////////////////////////////////////////////////////////////////////
class DodTextDivider extends StatelessWidget {
  final String text;
  final double fontSize;

  const DodTextDivider(
      {super.key, this.text = "·", this.fontSize = TextSize.defaultForApp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Doubles.three),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Стандартный Текст для всего приложения
////////////////////////////////////////////////////////////////////////////////
class MyText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final int maxLines;
  final Color? color;
  final TextAlign textAlign;

  const MyText(
      {super.key,
      required this.text,
      this.fontSize = TextSize.defaultForApp,
      this.maxLines = 1,
      this.color,
      this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.orEmpty(),
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
          color: color ?? Theme.of(context).colorScheme.onPrimary),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Текст с цветом onBackground для контраста на фоне основного текста
////////////////////////////////////////////////////////////////////////////////
class MyTextOnBackground extends StatelessWidget {
  final String? text;
  final double fontSize;
  final int maxLines;
  final TextAlign textAlign;

  const MyTextOnBackground(
      {super.key,
        required this.text,
        this.fontSize = TextSize.defaultForApp,
        this.maxLines = 1,
        this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.orEmpty(),
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).colorScheme.onBackground),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Полужирный Текст
////////////////////////////////////////////////////////////////////////////////
class MyTextSemiBold extends StatelessWidget {
  final String? text;
  final double fontSize;
  final int maxLines;
  final Color? color;
  final TextAlign textAlign;

  const MyTextSemiBold(
      {super.key,
        required this.text,
        this.fontSize = TextSize.defaultForApp,
        this.maxLines = 1,
        this.color,
        this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.orEmpty(),
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color ?? Theme.of(context).colorScheme.onPrimary),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Жирный Текст
////////////////////////////////////////////////////////////////////////////////
class MyTextBold extends StatelessWidget {
  final String? text;
  final double fontSize;
  final int maxLines;
  final Color? color;
  final TextAlign textAlign;

  const MyTextBold(
      {super.key,
      required this.text,
      this.fontSize = TextSize.defaultForApp,
      this.maxLines = 1,
      this.color,
      this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.orEmpty(),
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.onPrimary),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}
