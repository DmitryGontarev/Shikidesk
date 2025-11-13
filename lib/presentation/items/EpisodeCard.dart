
import 'package:flutter/material.dart';
import 'package:shikidesk/main.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

import '../../ui/Sizes.dart';
import 'ElementCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка для элемента списка экрана Эпизоды
////////////////////////////////////////////////////////////////////////////////
class EpisodeCard extends StatefulWidget {
  final double? padding;
  final double width;
  final double height;
  final String? author;
  final Widget? hosting;
  final String? quality;
  final Widget? downloadWidget;
  final int backgroundAlpha;
  final Function() onClick;

  const EpisodeCard(
      {super.key,
        this.padding,
        this.width = 100,
        this.height = 50,
        this.author,
        this.hosting,
        this.quality,
        this.downloadWidget,
        this.backgroundAlpha = 255,
        required this.onClick});

  @override
  State<StatefulWidget> createState() {
    return _EpisodeCardState();
  }
}

class _EpisodeCardState extends State<EpisodeCard> {

  double scale = baseElementScale;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (d) {
        setState(() {
          scale = hoverElementScale;
        });
      },
      onExit: (d) {
        setState(() {
          scale = baseElementScale;
        });
      },
      child: Transform.scale(
        scale: scale,
        child: Padding(
          padding: EdgeInsets.all(widget.padding ?? Doubles.seven),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: Borders.seven,
                  side: BorderSide(
                      color: ShikidroidDesktop.of(context)?.getTheme() ==
                          ThemeMode.light
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onBackground)),
              color: (Theme.of(context).colorScheme.surface)
                  .withAlpha(widget.backgroundAlpha),
              child: InkWell(
                onTap: widget.onClick,
                borderRadius: Borders.seven,
                child: PaddingAll(
                    all: Doubles.fourteen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextSemiBold(
                                  text: widget.author,
                                ),
                                if (widget.hosting != null) widget.hosting!
                              ],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.downloadWidget ?? const Spacer(),
                                MyText(
                                  text: widget.quality,
                                  textAlign: TextAlign.end,
                                )
                              ],
                            )
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
