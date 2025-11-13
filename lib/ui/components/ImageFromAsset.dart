
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

class ImageFromAsset extends StatelessWidget {
  final String? path;
  final double size;
  final Color? color;

  const ImageFromAsset(
      {super.key, required this.path, this.size = ImageSizes.seventeen, this.color});

  @override
  Widget build(BuildContext context) {
    return Image(
        width: size,
        image: AssetImage(path.orEmpty()),
      color: color ?? Theme.of(context).colorScheme.secondary,
    );
  }
}
