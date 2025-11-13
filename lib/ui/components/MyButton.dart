
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';

class MyButton extends StatefulWidget {
  final String btnText;
  final Color btnColor;
  final Color borderColor;
  final Function() onClick;

  const MyButton({
    super.key,
    required this.btnText,
    required this.btnColor,
    required this.borderColor,
    required this.onClick
  });

  @override
  State<StatefulWidget> createState() {
    return _MyButtonState();
  }
}

class _MyButtonState extends State<MyButton> {

  bool hover = false;

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(7.0),
      color: widget.btnColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: hover ? Theme.of(context).colorScheme.onPrimary : widget.borderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(7))
      ),
      elevation: 0,
      child:
      InkWell(
        onHover: (h) {
          setState(() {
            hover = !hover;
          });
        },
        onTap: widget.onClick,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: MyText(text: widget.btnText),
        ),
      ),
    );
  }
}