import 'package:flutter/cupertino.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

class TextLabel extends StatelessWidget {
  final double paddingAll;
  final String? text;
  final String labelText;
  final double textSize;
  final double labelSize;

  const TextLabel({super.key,
    this.paddingAll = Doubles.seven,
    required this.text,
    required this.labelText,
    this.textSize = TextSize.defaultForApp,
    this.labelSize = TextSize.min
  });

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              text: text.orEmpty(),
              fontSize: textSize,
            ),
            MyTextOnBackground(
              text: labelText,
              fontSize: labelSize,
            )
          ],
        )
    );
  }
}

class LabelText extends StatelessWidget {
  final double paddingAll;
  final String? text;
  final String labelText;
  final double textSize;
  final double labelSize;
  final Color? textColor;

  const LabelText({super.key,
    this.paddingAll = Doubles.seven,
    required this.text,
    required this.labelText,
    this.textSize = TextSize.defaultForApp,
    this.labelSize = TextSize.min,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextOnBackground(
              text: labelText,
              fontSize: labelSize,
            ),
            MyText(
              text: text.orEmpty(),
              fontSize: textSize,
              color: textColor,
            )
          ],
        )
    );
  }
}