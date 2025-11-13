import 'package:flutter/material.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import '../Strings.dart';

////////////////////////////////////////////////////////////////////////////////
/// Поле поиска для всех экранов
////////////////////////////////////////////////////////////////////////////////
class RowSearchField extends StatelessWidget {
  final double width;
  final int backgroundAlpha;
  final bool clearText;
  final String? labelText;
  final bool? isError;
  final List<Widget>? startWidgets;
  final List<Widget>? endWidgets;
  final Function(String onChanged) changedCallback;
  final Function(String onSubmit) submitCallback;

  const RowSearchField(
      {super.key,
      this.width = 800,
      this.backgroundAlpha = 255,
      required this.clearText,
      this.labelText,
      this.isError,
      this.startWidgets,
      this.endWidgets,
      required this.changedCallback,
      required this.submitCallback});

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: Doubles.twenty,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (startWidgets != null) ...?startWidgets,
            SizedBox(
              width: (MediaQuery.of(context).size.width > 1280) ? width : MediaQuery.of(context).size.width * 0.5,
              child: ShikiTextField(
                  labelText: labelText,
                  isError: isError,
                  backgroundAlpha: backgroundAlpha,
                  clearText: clearText,
                  changedCallback: changedCallback,
                  submitCallback: submitCallback),
            ),
            if (endWidgets != null) ...?endWidgets
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Поле ввода для всего приложения
////////////////////////////////////////////////////////////////////////////////
class ShikiTextField extends StatefulWidget {
  final int backgroundAlpha;
  final bool clearText;
  final String? labelText;
  final bool? isError;
  final Function(String onChanged) changedCallback;
  final Function(String onSubmit) submitCallback;

  const ShikiTextField(
      {super.key,
      this.backgroundAlpha = 255,
      required this.clearText,
      this.labelText = searchByTitleText,
      this.isError,
      required this.changedCallback,
      required this.submitCallback});

  @override
  State<StatefulWidget> createState() {
    return _BaseSearchForm();
  }
}

class _BaseSearchForm extends State<ShikiTextField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clearText) {
      _textController.clear();
    }

    return TextFormField(
      onChanged: (text) {
        widget.changedCallback(text);
      },
      onFieldSubmitted: (text) {
        widget.submitCallback(text);
      },
      controller: _textController,
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
          filled: true,
          fillColor: (Theme.of(context).colorScheme.surface)
              .withAlpha(widget.backgroundAlpha),
          labelText: widget.labelText,
          hoverColor: Theme.of(context).colorScheme.secondaryContainer,
          labelStyle: TextStyle(
              color: widget.isError == true
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onBackground),
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(Radius.circular(Doubles.seven)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground)),
          focusedBorder: OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(Radius.circular(Doubles.seven)),
              borderSide: BorderSide(
                  color: widget.isError == true
                      ? Colors.red
                      : Theme.of(context).colorScheme.secondary)),
          suffixIcon: _textController.text.isNotEmpty
              ? RoundedIconButton(
                  imagePath: iconClose,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  iconSize: 25,
                  iconPadding: 5,
                  onClick: () {
                    _textController.clear();
                    widget.changedCallback("");
                  })
              : null),
      maxLines: 1,
    );
  }
}
