import 'package:flutter/cupertino.dart';
import 'package:shikidesk/ui/Sizes.dart';

////////////////////////////////////////////////////////////////////////////////
/// Отступ для всех сторон
////////////////////////////////////////////////////////////////////////////////
class PaddingAll extends StatelessWidget{
  final double all;
  final Widget child;

  const PaddingAll({
    super.key,
    this.all = Doubles.seven,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(all),
      child: child,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Отступ для определённой стороны
////////////////////////////////////////////////////////////////////////////////
class PaddingBySide extends StatelessWidget {
  final double start;
  final double top;
  final double end;
  final double bottom;
  final Widget child;

  const PaddingBySide({
    super.key,
    this.start = 0,
    this.top = 0,
    this.end = 0,
    this.bottom = 0,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: start,
          top: top,
          right: end,
          bottom: bottom
        ),
      child: child,
    );
  }
}