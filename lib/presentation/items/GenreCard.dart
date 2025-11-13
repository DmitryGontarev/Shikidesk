
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/Colors.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

import 'ElementCard.dart';

class GenreCard extends StatefulWidget {
  final double? paddingAll;
  final bool? useHover;
  final double? cardHeight;
  final String? text;
  final double textSize;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Function()? onClick;

  const GenreCard(
      {super.key,
        this.paddingAll,
        this.useHover = false,
        this.cardHeight,
        this.text,
        this.textSize = TextSize.defaultForApp,
        this.color,
        this.backgroundColor,
        this.borderColor,
        this.onClick});

  @override
  State<StatefulWidget> createState() {
    return _GenreCardState();
  }
}

class _GenreCardState extends State<GenreCard> {
  double scale = baseElementScale;
  bool hover = false;
  Color borderHoverColor = ShikidroidColors.darkColorSecondaryLightVariant.withAlpha(200);

  @override
  Widget build(BuildContext context) {

    void setHover({ required bool hover }) {
      if (widget.useHover == true) {
        if (hover) {
          setState(() {
            scale = hoverElementScale;
            hover = true;
            borderHoverColor = Theme.of(context).colorScheme.onPrimary;
          });
        } else {
          setState(() {
            scale = baseElementScale;
            hover = false;
            borderHoverColor = ShikidroidColors.darkColorSecondaryLightVariant.withAlpha(200);
          });
        }
      }
    }

    return MouseRegion(
      onEnter: (d) {
        setHover(hover: true);
      },
      onExit: (d) {
        setHover(hover: false);
      },
      child: Transform.scale(
        scale: scale,
        child: PaddingAll(
            all: widget.paddingAll ?? Doubles.seven,
            child: SizedBox(
              height:  widget.cardHeight ?? 60,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: borderHoverColor),
                ),
                color:  widget.backgroundColor ?? Colors.transparent,
                child: InkWell(
                  onTap:  widget.onClick,
                  borderRadius: Borders.thirty,
                  child: PaddingBySide(
                      start: 10,
                      top: 5,
                      end: 10,
                      bottom: 5,
                      child: MyTextSemiBold(
                        text:  widget.text,
                        fontSize:  widget.textSize,
                        color:  widget.color ?? Theme.of(context).colorScheme.secondary,
                      )),
                ),
              ),
            )),
      ),
    );
  }
}
