import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../Sizes.dart';

////////////////////////////////////////////////////////////////////////////////
/// Кнопка с текстом и всплывающим меню
////////////////////////////////////////////////////////////////////////////////
class PopupMenuTextButton extends StatefulWidget {
  final String? buttonText;
  final String? message;
  final Color? color;
  final Offset offset;
  final EdgeInsetsGeometry padding;
  final List<Widget> menuWidgets;
  final Function(int index) callback;

  const PopupMenuTextButton(
      {super.key,
      required this.buttonText,
      this.message,
      this.color,
      this.offset = Offset.zero,
      this.padding = const EdgeInsets.all(8.0),
      required this.menuWidgets,
      required this.callback});

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuTextButtonState();
  }
}

class _PopupMenuTextButtonState extends State<PopupMenuTextButton> {
  @override
  Widget build(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;

    RelativeRect position = const RelativeRect.fromLTRB(100, 100, 100, 100);

    if (button != null && overlay != null) {
      position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(widget.offset, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );
    }

    return Tooltip(
      message: widget.message ?? '',
      child: InkWell(
        onTap: () {},
        hoverColor: Theme.of(context).colorScheme.onBackground.withAlpha(30),
        child: TextButton(
            child: MyText(text: widget.buttonText, color: widget.color),
            onPressed: () {
              showMenu(
                  context: context,
                  position: position,
                  items: List.generate(widget.menuWidgets.length, (index) {
                    return PopupMenuItem(
                        value: index,
                        onTap: () {
                          widget.callback(index);
                        },
                        child: Wrap(
                          children: [widget.menuWidgets[index]],
                        ));
                  }));
            }),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Кнопка с иконкой с всплывающим меню
////////////////////////////////////////////////////////////////////////////////
class PopupMenuIconButton extends StatefulWidget {
  final Widget icon;
  final String? message;
  final Color? color;
  final Offset offset;
  final EdgeInsetsGeometry padding;
  final List<Widget> menuWidgets;
  final Color? borderColor;
  final Function()? onTap;
  final Function(int index) callback;

  const PopupMenuIconButton(
      {super.key,
      required this.icon,
      this.message = "",
      this.color,
      this.offset = Offset.zero,
      this.padding = const EdgeInsets.all(8.0),
      required this.menuWidgets,
      this.borderColor,
      this.onTap,
      required this.callback});

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuIconButtonState();
  }
}

class _PopupMenuIconButtonState extends State<PopupMenuIconButton> {
  List<Widget> widg = [];

  RenderBox? button;
  RenderBox? overlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      button = context.findRenderObject() as RenderBox?;
      overlay = Navigator.of(context).overlay?.context.findRenderObject()
          as RenderBox?;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widg = widget.menuWidgets;
    });

    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;

    RelativeRect position = const RelativeRect.fromLTRB(100, 100, 100, 100);

    if (button != null && overlay != null) {
      position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(widget.offset, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );
    }

    return Tooltip(
      message: widget.message,
      child: InkWell(
        onTap: () {},
        borderRadius:
            const BorderRadius.all(Radius.circular(Doubles.oneHundred)),
        hoverColor: Theme.of(context).colorScheme.onBackground.withAlpha(30),
        child: IconButton(
            icon: widget.icon,
            color: widget.color ?? Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              widget.onTap?.let((it) {
                it();
              });
              showMenu(
                  context: context,
                  position: position,
                  items: List.generate(widg.length, (index) {
                    return PopupMenuItem(
                        value: index,
                        onTap: () {
                          widget.callback(index);
                        },
                        child: Wrap(
                          children: [widg[index]],
                        ));
                  }));
            }),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Кнопка с иконкой с всплывающим меню
////////////////////////////////////////////////////////////////////////////////
class TooltipButton extends StatefulWidget {
  final String icon;
  final String? message;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Function() onClick;

  const TooltipButton(
      {super.key,
      required this.icon,
      this.message = "",
      this.color,
      this.padding = const EdgeInsets.all(8.0),
      this.borderColor,
      required this.onClick});

  @override
  State<StatefulWidget> createState() {
    return _TooltipButtonState();
  }
}

class _TooltipButtonState extends State<TooltipButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.message,
      child: InkWell(
        onTap: () {},
        borderRadius:
            const BorderRadius.all(Radius.circular(Doubles.oneHundred)),
        hoverColor: Theme.of(context).colorScheme.onBackground.withAlpha(30),
        child: IconButton(
            icon: ImageFromAsset(
                path: widget.icon,
                color: widget.color ?? Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              widget.onClick();
            }),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Кнопка с иконкой с всплывающим меню
////////////////////////////////////////////////////////////////////////////////
class PopupMenuBorderIconButton extends StatefulWidget {
  final String iconPath;
  final Color? iconColor;
  final String? message;
  final Offset offset;
  final double? padding;
  final List<Widget> menuWidgets;
  final Color? backgroundColor;
  final int backgroundAlpha;
  final Function()? onTap;
  final Function(int index) callback;

  const PopupMenuBorderIconButton(
      {super.key,
      required this.iconPath,
      this.iconColor,
      this.message = "",
      this.offset = Offset.zero,
      this.padding,
      required this.menuWidgets,
      this.backgroundColor,
      this.backgroundAlpha = 255,
      this.onTap,
      required this.callback});

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuBorderIconButtonState();
  }
}

class _PopupMenuBorderIconButtonState extends State<PopupMenuBorderIconButton> {
  List<Widget> widg = [];

  RenderBox? button;
  RenderBox? overlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      button = context.findRenderObject() as RenderBox?;
      overlay = Navigator.of(context).overlay?.context.findRenderObject()
          as RenderBox?;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widg = widget.menuWidgets;
    });

    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;

    RelativeRect position = const RelativeRect.fromLTRB(100, 100, 100, 100);

    if (button != null && overlay != null) {
      position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(widget.offset, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );
    }

    return Tooltip(
      message: widget.message,
      child: RoundedIconMiniButton(
        padding: widget.padding,
        imagePath: widget.iconPath,
        iconColor: widget.iconColor,
        onClick: () {
          widget.onTap?.let((it) {
            it();
          });
          showMenu(
              context: context,
              position: position,
              items: List.generate(widg.length, (index) {
                return PopupMenuItem(
                    value: index,
                    onTap: () {
                      widget.callback(index);
                    },
                    child: Wrap(
                      children: [widg[index]],
                    ));
              }));
        },
        backgroundColor:
            widget.backgroundColor?.withAlpha(widget.backgroundAlpha) ??
                (Theme.of(context).colorScheme.surface)
                    .withAlpha(widget.backgroundAlpha),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Кнопка с иконкой и всплывающим меню
////////////////////////////////////////////////////////////////////////////////
class PopupIconButtonForShowMenu extends StatefulWidget {
  final Widget icon;
  final String? message;
  final Offset offset;
  final EdgeInsetsGeometry padding;
  final Function(RelativeRect position)? onTap;

  const PopupIconButtonForShowMenu(
      {super.key,
      required this.icon,
      this.message = "",
      this.offset = Offset.zero,
      this.padding = const EdgeInsets.all(8.0),
      this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _PopupIconButtonForShowMenuState();
  }
}

class _PopupIconButtonForShowMenuState
    extends State<PopupIconButtonForShowMenu> {
  List<Widget> widg = [];

  RenderBox? button;
  RenderBox? overlay;

  bool disp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      button = context.findRenderObject() as RenderBox?;
      overlay = Navigator.of(context).overlay?.context.findRenderObject()
          as RenderBox?;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    RelativeRect position = const RelativeRect.fromLTRB(100, 100, 100, 100);

    void setPosition(Offset value) {
      if (overlay != null) {
        var x = value.dx - 100;
        var y = value.dy;
        var offs = Offset(x, y);
        position = RelativeRect.fromRect(
          Rect.fromPoints(offs, offs),
          Offset.zero & overlay!.size,
        );
      }
    }

    return Tooltip(
      message: widget.message,
      child: InkWell(
        onTap: () {},
        borderRadius:
            const BorderRadius.all(Radius.circular(Doubles.oneHundred)),
        hoverColor: Theme.of(context).colorScheme.onBackground.withAlpha(30),
        child: MouseRegion(
          onEnter: (drt) {
            setPosition(drt.position);
          },
          child: IconButton(
              icon: widget.icon,
              onPressed: () {
                widget.onTap?.let((it) {
                  it(position);
                });
              }),
        ),
      ),
    );
  }
}
