import 'package:flutter/material.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../ui/components/Paddings.dart';
import 'Texts.dart';

class ContainerColor extends StatelessWidget {
  final Color color;
  final int backgroundAlpha;
  final Widget child;
  final Function()? onClick;

  const ContainerColor(
      {super.key,
      this.color = Colors.black,
      this.backgroundAlpha = 100,
      required this.child,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color.withAlpha(backgroundAlpha),
          borderRadius: const BorderRadius.all(Radius.circular(100))),
      child: InkWell(
        hoverColor: Colors.grey.withAlpha(70),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        onTap: () {
          onClick?.let((it) {
            it();
          });
        },
        child: child,
      ),
    );
  }
}

class ContainerColorList extends StatelessWidget {
  final double padding;
  final Color color;
  final Color borderColor;
  final List<Widget> widgets;
  final Function()? onClick;

  const ContainerColorList(
      {super.key,
      this.padding = 17,
      this.color = Colors.black,
      this.borderColor = Colors.white,
      required this.widgets,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: padding,
        child: Container(
          decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: borderColor.withAlpha(50))),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                hoverColor: Colors.grey.withAlpha(50),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                onTap: () {
                  onClick?.let((it) {
                    it();
                  });
                },
                child: PaddingAll(
                  all: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widgets,
                  ),
                )),
          ),
        ));
  }
}
