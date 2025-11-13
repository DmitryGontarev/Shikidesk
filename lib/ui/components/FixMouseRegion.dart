
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:media_kit/ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:win32/win32.dart' as win32;

class FixMouseRegion extends StatefulWidget {
  final Function(PointerEnterEvent)? onEnter;
  final Function(PointerExitEvent)? onExit;
  final Function(PointerHoverEvent)? onHover;
  final MouseCursor cursor;
  final bool opaque;
  final HitTestBehavior? hitTestBehavior;
  final Widget? child;

  const FixMouseRegion({
    super.key,
    this.onEnter,
    this.onExit,
    this.onHover,
    this.cursor = MouseCursor.defer,
    this.opaque = true,
    this.hitTestBehavior,
    this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _FixMouseRegion();
  }
}

class _FixMouseRegion extends State<FixMouseRegion> {
  MouseCursor? lastCursor;

  @override
  Widget build(BuildContext context) {
    if (lastCursor != widget.cursor) {
      Timer(const Duration(milliseconds: 100), () {
        Pointer<POINT> point = malloc();
        win32.GetCursorPos(point);
        win32.SetCursorPos(point.ref.x, point.ref.y);
        free(point);
      });
    }

    lastCursor = widget.cursor;

    return MouseRegion(
      onEnter: widget.onEnter,
      onExit: widget.onExit,
      onHover: widget.onHover,
      cursor: widget.cursor,
      opaque: widget.opaque,
      hitTestBehavior: widget.hitTestBehavior,
      child: widget.child,
    );
  }
}