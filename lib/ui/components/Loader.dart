import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';

import '../../presentation/navigation/NavigationFunctions.dart';
import '../AssetsPath.dart';
import '../Sizes.dart';
import 'RoundedIconButton.dart';

/// Круглый индикатор загрузки в центре экрана
///
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

/// Круглый индикатор загрузки в центре экрана с кнопкой 'Назад'
///
class LoaderWithBackButton extends StatefulWidget {
  final int backBtnAlpha;

  const LoaderWithBackButton({super.key, this.backBtnAlpha = 255});

  @override
  State<StatefulWidget> createState() {
    return _LoaderWithBackButtonState();
  }
}

class _LoaderWithBackButtonState extends State<LoaderWithBackButton> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        PaddingAll(
            all: Doubles.twenty,
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RawKeyboardListener(
                      focusNode: _focusNode,
                      autofocus: true,
                      onKey: (event) {
                        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
                          navigateBack(context);
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RoundedIconMiniButton(
                            backgroundAlpha: widget.backBtnAlpha,
                            imagePath: iconBack,
                            onClick: () {
                              navigateBack(context);
                            }),
                      )
                  )
                ],
              ),
            )
        )
      ],
    );
  }
}

/// Круглый индикатор для использования в списках
///
class ItemLoader extends StatelessWidget {
  final double imageHeight;
  final double imageWidth;

  const ItemLoader({
    super.key,
    this.imageHeight = ImageSizes.coverHeight,
    this.imageWidth = ImageSizes.coverWidth
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageHeight,
      width: imageWidth,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

/// Круглый индикатор с возможностью установки размера
///
class SizedLoader extends StatelessWidget {
  final double size;

  const SizedLoader({
    super.key,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}