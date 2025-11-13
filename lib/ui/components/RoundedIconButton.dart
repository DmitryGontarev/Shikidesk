
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

import '../../presentation/items/ContainerColor.dart';
import 'ImageFromAsset.dart';

/// Круглая кнопка с иконкой
///
class RoundedIconButton extends StatelessWidget {
  final double? padding;
  final String imagePath;
  final Color? iconColor;
  final double? iconSize;
  final double iconPadding;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final Function() onClick;

  const RoundedIconButton(
      {super.key,
      this.padding,
      required this.imagePath,
      this.iconColor,
      this.iconSize = 24,
      this.iconPadding = 15,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding ?? Doubles.seven),
        child: Card(
          elevation: 0.3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
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
                child: Image(
                  height: iconSize,
                  width: iconSize,
                  image: AssetImage(imagePath),
                  color:
                      iconColor ?? Theme.of(context).colorScheme.onBackground,
                )),
          ),
        ));
  }
}

/// Маленькая круглая кнопка с иконкой
///
class RoundedIconMiniButton extends StatelessWidget {
  final double? padding;
  final String imagePath;
  final Color? iconColor;
  final double? iconSize;
  final double iconPadding;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final Function() onClick;

  const RoundedIconMiniButton(
      {super.key,
      this.padding,
      required this.imagePath,
      this.iconColor,
      this.iconSize = 20,
      this.iconPadding = 15,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ContainerColorList(
        padding: padding ?? Doubles.seven,
        onClick: onClick,
        color: backgroundColor?.withAlpha(backgroundAlpha) ??
            (Theme.of(context).colorScheme.surface).withAlpha(backgroundAlpha),
        borderColor: Theme.of(context).colorScheme.onBackground,
        widgets: [
          ImageFromAsset(
            path: imagePath,
            size: iconSize ?? 0,
            color: iconColor ?? Theme.of(context).colorScheme.onBackground,
          )
        ]);
  }
}

/// Круглая кнопка с иконкой
///
class RotateIconButton extends StatelessWidget {
  final double? padding;
  final String imagePath;
  final Color? iconColor;
  final double? iconSize;
  final double iconPadding;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final bool isIconRotate;
  final double rotateValue;
  final Function() onClick;

  const RotateIconButton(
      {super.key,
      this.padding,
      required this.imagePath,
      this.iconColor,
      this.iconSize = 24,
      this.iconPadding = 15,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      required this.isIconRotate,
      required this.rotateValue,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding ?? Doubles.seven),
        child: Card(
          elevation: 0.3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
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
                child: AnimatedRotation(
                    turns: isIconRotate ? rotateValue : 0.0,
                    duration: DurationsMy.duration300,
                    child: Image(
                      height: iconSize,
                      width: iconSize,
                      image: AssetImage(imagePath),
                      color: iconColor ??
                          Theme.of(context).colorScheme.onBackground,
                    ))),
          ),
        ));
  }
}
