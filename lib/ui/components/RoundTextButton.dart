import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/ContainerColor.dart';
import 'package:shikidesk/presentation/items/Texts.dart';

import '../Sizes.dart';
import 'Paddings.dart';

/// Круглая кнопка с текстом
///
class RoundedTextButton extends StatelessWidget {
  final double? padding;
  final String text;
  final Color? textColor;
  final double textSize;
  final double iconPadding;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final Function() onClick;

  const RoundedTextButton(
      {super.key,
      this.padding,
      required this.text,
      this.textColor,
      this.textSize = 18,
      this.iconPadding = 15,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding ?? Doubles.seven),
        child: SizedBox(
          height: Doubles.seventy,
          width: Doubles.seventy,
          child: Card(
            elevation: 0.3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Doubles.fifty),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground)),
            color: backgroundColor?.withAlpha(backgroundAlpha) ??
                (Theme.of(context).colorScheme.surface)
                    .withAlpha(backgroundAlpha),
            child: InkWell(
              onTap: onClick,
              borderRadius:
                  const BorderRadius.all(Radius.circular(Doubles.fifty)),
              child: PaddingAll(
                  all: iconPadding,
                  child: MyTextSemiBold(
                    text: text,
                    fontSize: textSize,
                    color: textColor,
                  )),
            ),
          ),
        )
    );
  }
}

/// Маленькая круглая кнопка с текстом
///
class RoundedTextMiniButton extends StatelessWidget {
  final double? padding;
  final String text;
  final Color? textColor;
  final double textSize;
  final double iconPadding;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final Function() onClick;

  const RoundedTextMiniButton(
      {super.key,
      this.padding,
      required this.text,
      this.textColor,
      this.textSize = 18,
      this.iconPadding = 15,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ContainerColorList(
        padding: padding ?? 0,
        onClick: onClick,
        color: backgroundColor?.withAlpha(backgroundAlpha) ??
            (Theme.of(context).colorScheme.surface).withAlpha(backgroundAlpha),
        widgets: [
          MyTextSemiBold(
            text: text,
            fontSize: textSize,
            color: textColor,
          )
        ]
    );
  }
}
