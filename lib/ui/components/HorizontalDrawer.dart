import 'package:flutter/cupertino.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/MeasureSize.dart';

////////////////////////////////////////////////////////////////////////////////
/// Экран с горизонтальной боковой панелью навигации слева
////////////////////////////////////////////////////////////////////////////////
class HorizontalRailDrawer extends StatefulWidget {
  final bool isExpand;
  final bool hideDrawer;
  final Widget mainWidget;
  final double leftMainWidgetPosition;
  final Widget drawerWidget;

  const HorizontalRailDrawer(
      {super.key,
      required this.isExpand,
      this.hideDrawer = false,
      required this.mainWidget,
      this.leftMainWidgetPosition = 0,
      required this.drawerWidget,});

  @override
  State<StatefulWidget> createState() {
    return _HorizontalRailDrawerState();
  }
}

class _HorizontalRailDrawerState extends State<HorizontalRailDrawer> {
  bool isDrawerHide = false;

  double drawerWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => MouseRegion(
              onHover: (h) {
                if (widget.hideDrawer) {
                  if (h.position.dx <= (widget.leftMainWidgetPosition * 0.7)) {
                    setState(() {
                      isDrawerHide = false;
                    });
                  } else {
                    setState(() {
                      isDrawerHide = true;
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  /// Боковое меню
                  AnimatedPositioned(
                    left: isDrawerHide ? -drawerWidth : 0,
                    duration: DurationsMy.duration300,
                    child: MeasureSize(
                        onChange: (size) {
                          setState(() {
                            drawerWidth = size.width;
                          });
                        },
                        child: widget.drawerWidget),
                  ),

                  /// Основная часть экрана
                  AnimatedPositioned(
                      left: isDrawerHide
                          ? 0
                          : (widget.isExpand
                              ? drawerWidth
                              : widget.leftMainWidgetPosition),
                      duration: DurationsMy.duration300,
                      child: SizedBox(
                        width: isDrawerHide
                            ? constraints.maxWidth
                            : (constraints.maxWidth -
                                widget.leftMainWidgetPosition),
                        child: widget.mainWidget,
                      )),
                ],
              ),
            ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран с горизонтальным меню слева
////////////////////////////////////////////////////////////////////////////////
class HorizontalDrawer extends StatefulWidget {
  final bool isExpand;
  final Widget mainWidget;
  final Widget drawerWidget;

  const HorizontalDrawer(
      {super.key,
      required this.isExpand,
      required this.mainWidget,
      required this.drawerWidget});

  @override
  State<StatefulWidget> createState() {
    return _HorizontalDrawerState();
  }
}

class _HorizontalDrawerState extends State<HorizontalDrawer> {

  double drawerWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Stack(
              children: [
                /// Боковое меню
                MeasureSize(
                    onChange: (size) {
                      setState(() {
                        drawerWidth = size.width;
                      });
                    },
                    child: widget.drawerWidget
                ),

                /// Основная часть экрана
                AnimatedPositioned(
                    left: widget.isExpand ? drawerWidth : 0,
                    duration: DurationsMy.duration300,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: widget.mainWidget,
                    )),
              ],
            ));
  }
}
