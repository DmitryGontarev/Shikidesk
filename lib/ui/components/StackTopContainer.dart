
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';

import 'MeasureSize.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер с накладываемой верхней частью, которая скрывается по скроллу
///
/// [topWidget] верхняя часть экрана поверх основной
/// [mainWidget] основная часть экрана
/// [spacer] коллбэк с высотой верхнего виджета
////////////////////////////////////////////////////////////////////////////////
class StackTopContainer extends StatefulWidget {
  final Widget topWidget;
  final Widget mainWidget;
  final Function (double spacer)? spacer;

  const StackTopContainer(
      {super.key, required this.topWidget, required this.mainWidget, this.spacer});

  @override
  State<StatefulWidget> createState() {
    return _StackTopContainer();
  }
}

class _StackTopContainer extends State<StackTopContainer> {

  /// высота верхнего виджета
  double topHeight = 0;

  /// флаг скрытия верхнего виджета
  bool hideTop = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Stack(
              children: [
                /// Основная часть экрана
                NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll is ScrollUpdateNotification) {
                      if ((scroll.scrollDelta ?? 0) > 0) {
                        setState(() {
                          hideTop = true;
                        });
                      } else {
                        setState(() {
                          hideTop = false;
                        });
                      }
                    }
                    return true;
                  },
                  child: widget.mainWidget,
                ),

                /// Виджет, лежащий поверх основной части экрана
                AnimatedPositioned(
                  width: constraints.maxWidth,
                  top: hideTop ? -topHeight : 0,
                  duration: DurationsMy.duration300,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MeasureSize(
                        onChange: (size) {
                          setState(() {
                            topHeight = size.height;
                            if (widget.spacer != null) {
                              widget.spacer!(topHeight);
                            }
                          });
                        },
                        child: widget.topWidget
                    ),
                  ),
                )
              ],
            ));
  }
}
