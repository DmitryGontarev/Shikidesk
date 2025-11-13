
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

/// Кнопка для бокового меню навигации
class RailButton extends StatefulWidget {
  final bool isSelected;
  final String btnImage;
  final String btnText;
  final Color color;
  final Color backgroundColor;
  final Function() onClick;
  final Function(bool focus) focus;

  const RailButton(
      {super.key,
      required this.isSelected,
      required this.btnImage,
      required this.btnText,
      required this.color,
      required this.backgroundColor,
      required this.onClick,
        required this.focus
      });

  @override
  State<StatefulWidget> createState() {
    return _RailButton();
  }
}

class _RailButton extends State<RailButton> {

  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Doubles.seven),
      child: Padding(
        padding: const EdgeInsets.all(Doubles.ten),
        child: MouseRegion(
          onEnter: (d) {
            setState(() {
              focus = true;
              widget.focus(focus);
            });
          },
          onExit: (d) {
            setState(() {
              focus = false;
              widget.focus(focus);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: widget.onClick,
                  borderRadius: const BorderRadius.all(Radius.circular(Doubles.fifty)),
                  child: PaddingAll(
                    all: Doubles.fourteen,
                    child: Image(
                      width: Doubles.twenty,
                      height: Doubles.twenty,
                      image: AssetImage(widget.btnImage),
                      color: widget.color,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                  child: PaddingBySide(
                    start: Doubles.seven,
                      child: Visibility(
                          visible: focus,
                          child: Padding(
                            padding: const EdgeInsets.all(Doubles.three),
                            child: Text(
                              widget.btnText,
                              style: TextStyle(color: widget.color),
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
