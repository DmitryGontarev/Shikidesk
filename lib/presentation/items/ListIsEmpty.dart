import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/utils/Extensions.dart';

class ListIsEmpty extends StatelessWidget {
  final double imageSize;
  final Color? imageColor;
  final double textSize;
  final String? text;

  const ListIsEmpty({super.key, this.imageSize = 150, this.textSize = 50, this.text, this.imageColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageFromAsset(
              path: iconNotFound,
            size: imageSize,
            color: imageColor ?? Theme.of(context).colorScheme.secondary,
          ),
          MyTextBold(
            text: text ?? emptySearchTitle,
            fontSize: textSize,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}