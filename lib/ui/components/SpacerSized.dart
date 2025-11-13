import 'package:flutter/cupertino.dart';

class SpacerSized extends StatelessWidget {
  final double height;
  final double width;

  const SpacerSized({
    super.key,
    this.height = 80,
    this.width = double.infinity
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}