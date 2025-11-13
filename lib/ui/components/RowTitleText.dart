import 'package:flutter/cupertino.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

class RowTitleText extends StatelessWidget {
  final String? text;

  const RowTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PaddingAll(
          all: Doubles.fourteen,
            child: MyTextBold(
                text: text,
              fontSize: TextSize.big,
            )
        )
      ],
    );
  }
}