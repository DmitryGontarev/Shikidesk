import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/utils/Extensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Верхний бар с кнопкой Назад для всего приложения
////////////////////////////////////////////////////////////////////////////////
class ToolbarForApp extends StatefulWidget {
  final int backBtnAlpha;
  final Widget? centerWidget;
  final Widget? endWidget;
  final bool backspaceListen;
  final Function()? callback;

  const ToolbarForApp(
      {super.key,
      this.backBtnAlpha = 255,
      this.centerWidget,
      this.endWidget,
      this.backspaceListen = true,
      this.callback});

  @override
  State<StatefulWidget> createState() {
    return _ToolbarForAppState();
  }
}

class _ToolbarForAppState extends State<ToolbarForApp> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: Doubles.twenty,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawKeyboardListener(
                        focusNode: _focusNode,
                        autofocus: true,
                        onKey: (event) {
                          if (widget.backspaceListen) {
                            if (event is RawKeyUpEvent &&
                                event.logicalKey == LogicalKeyboardKey.escape) {
                              navigateBack(context);
                            }
                          }
                        },
                        child: RoundedIconMiniButton(
                            backgroundAlpha: widget.backBtnAlpha,
                            imagePath: iconBack,
                            onClick: () {
                              widget.callback?.let((it) {
                                it();
                              });
                              navigateBack(context);
                            })),
                    if (widget.centerWidget != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PaddingBySide(
                            start: Doubles.seven,
                            child: widget.centerWidget ?? const SpacerSized()),
                      )
                  ],
                ),
              ),
              if (widget.endWidget != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: widget.endWidget ?? const SpacerSized(),
                )
            ],
          ),
        ));
  }
}
