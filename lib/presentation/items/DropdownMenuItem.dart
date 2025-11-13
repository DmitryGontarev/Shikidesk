
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

import '../../ui/Sizes.dart';

class MyDropdownMenuItem extends StatelessWidget {
  final Widget? icon;
  final String? text;

  const MyDropdownMenuItem(
      {super.key, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        start: Doubles.seven,
        end: Doubles.seven,
        bottom: Doubles.seven,
        child: Row(
          children: [
            if (icon != null)
              PaddingBySide(
                  start: Doubles.seven, end: Doubles.seven, child: icon!),
            MyText(text: text, color: Theme.of(context).colorScheme.onPrimary)
          ],
        )
    );
  }
}
