
import 'package:flutter/cupertino.dart';
import 'package:shikidesk/presentation/items/Texts.dart';

class DotTextDivider extends StatelessWidget {

  const DotTextDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyTextOnBackground(
        text: "·",
    );
  }
}