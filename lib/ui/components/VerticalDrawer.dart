
import 'package:flutter/cupertino.dart';

////////////////////////////////////////////////////////////////////////////////
/// Экран с вертикальным меню
////////////////////////////////////////////////////////////////////////////////
class VerticalDrawer extends StatefulWidget {
  final bool isExpand;
  final double? drawerHeight;
  final Widget mainWidget;
  final Widget drawerWidget;

  const VerticalDrawer(
      {super.key,
      required this.isExpand,
      this.drawerHeight,
      required this.mainWidget,
      required this.drawerWidget});

  @override
  State<StatefulWidget> createState() {
    return _VerticalDrawerState();
  }
}

class _VerticalDrawerState extends State<VerticalDrawer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Stack(
              children: [
                AnimatedPositioned(
                  top: widget.isExpand ? 0 : MediaQuery.of(context).size.height,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                      height: widget.drawerHeight ?? constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: widget.drawerWidget),
                ),
                AnimatedPositioned(
                    top: widget.isExpand
                        ? -MediaQuery.of(context).size.height
                        : 0,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: constraints.maxWidth,
                      child: widget.mainWidget,
                    )),
              ],
            ));
  }
}
