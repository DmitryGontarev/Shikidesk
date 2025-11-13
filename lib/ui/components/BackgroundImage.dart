
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

class BackgroundImage extends StatefulWidget {
  final String? imageUrl;
  final Widget mainWidget;

  const BackgroundImage({super.key, this.imageUrl, required this.mainWidget});

  @override
  State<StatefulWidget> createState() {
    return _BackgroundImage();
  }
}

class _BackgroundImage extends State<BackgroundImage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) =>
        Stack(
          fit: StackFit.passthrough,
          children: [
            Image(fit: BoxFit.cover, image: NetworkImage(widget.imageUrl.orEmpty())),
            Container(
              width: 8000,
              height: 8000,
              color: (Theme.of(context).colorScheme.surface)
                  .withAlpha(Ints.twoHundredThirty),
            ),
            widget.mainWidget
          ],
        )
    );
  }
}
