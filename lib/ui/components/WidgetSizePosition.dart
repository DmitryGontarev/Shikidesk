
import 'package:flutter/material.dart';

/// Класс для получения Размера виджета или его Позиции на экране
///
class WidgetSizePosition {

  getSizes(GlobalKey key) {
    Size? size = key.currentContext?.size;
    // print("SIZE: $sizeRed");
    return [size?.width, size?.height];
  }

  getPositions(GlobalKey key) {
    final RenderBox? renderBoxRed = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBoxRed?.localToGlobal(Offset.zero);
    // print("POSITION: $positionRed ");
    return [position?.dx, position?.dy];
  }
}