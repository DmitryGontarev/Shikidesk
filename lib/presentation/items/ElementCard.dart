import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/main.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Colors.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/LabelText.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/IntExtensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';
import 'dart:ui' as ui;

import '../../ui/components/ImageFromAsset.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка с вертикальным раскрытием
////////////////////////////////////////////////////////////////////////////////
class ExpandedVerticalCard extends StatelessWidget {
  final bool isExpand;
  final Widget mainWidget;
  final Widget expandWidget;

  const ExpandedVerticalCard(
      {super.key,
      required this.isExpand,
      required this.mainWidget,
      required this.expandWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExpand ? expandWidget : null,
        ),
        mainWidget
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка с горизонтальным раскрытием
////////////////////////////////////////////////////////////////////////////////
class ExpandedHorizontalCard extends StatelessWidget {
  final bool isExpand;
  final Widget mainWidget;
  final Widget expandWidget;

  const ExpandedHorizontalCard(
      {super.key,
      required this.isExpand,
      required this.mainWidget,
      required this.expandWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        mainWidget,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExpand ? expandWidget : null,
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка с горизонтальным раскрытием слева
////////////////////////////////////////////////////////////////////////////////
class ExpandedLeftHorizontalCard extends StatefulWidget {
  final bool isExpand;
  final Widget mainWidget;
  final Widget expandWidget;

  const ExpandedLeftHorizontalCard(
      {super.key,
      required this.isExpand,
      required this.mainWidget,
      required this.expandWidget});

  @override
  State<StatefulWidget> createState() {
    return _ExpandedLeftHorizontalCardState();
  }
}

class _ExpandedLeftHorizontalCardState
    extends State<ExpandedLeftHorizontalCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.isExpand ? widget.expandWidget : null,
        ),
        widget.mainWidget,
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть с информацией для показа под картинкой карточки
////////////////////////////////////////////////////////////////////////////////
class InfoColumn extends StatelessWidget {
  final AiredStatus? status;
  final String? score;
  final int? episodes;
  final int? episodesAired;
  final int? chapters;
  final int? volumes;
  final String? dateAired;
  final String? dateReleased;
  final bool isMal;

  const InfoColumn(
      {super.key,
      this.status,
      this.score,
      this.episodes,
      this.episodesAired,
      this.chapters,
      this.volumes,
      this.dateAired,
      this.dateReleased,
      this.isMal = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PaddingAll(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              text: status?.toScreenString(),
              color: status?.toColor(),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: Doubles.seven, right: Doubles.seven),
                  child: ImageFromAsset(path: iconStar),
                ),
                MyText(text: "$score")
              ],
            ),
          ],
        )),
        if (status == AiredStatus.anons ||
            status == AiredStatus.released ||
            status == AiredStatus.paused ||
            status == AiredStatus.discontinued) ...{
          if (isMoreThan(episodes, 0))
            TextLabel(
              text: "$episodes",
              labelText: episodeText,
            ),
          if (isMoreThan(chapters, 0))
            TextLabel(
              text: "$chapters",
              labelText: chaptersText,
            ),
          if (isMoreThan(volumes, 0))
            TextLabel(
              text: "$volumes",
              labelText: volumesText,
            )
        },
        if (status == AiredStatus.ongoing) ...{
          if (isMal) ...{
            TextLabel(
              text: "$episodes",
              labelText: episodeText,
            )
          } else ...{
            if (episodes != null && episodesAired != null)
              TextLabel(
                text: "$episodesAired из $episodes",
                labelText: episodeText,
              ),
            if (isMoreThan(chapters, 0))
              TextLabel(
                text: "$chapters",
                labelText: chaptersText,
              ),
            if (isMoreThan(volumes, 0))
              TextLabel(
                text: "$volumes",
                labelText: volumesText,
              )
          }
        },
        if (status == AiredStatus.anons || status == AiredStatus.ongoing) ...{
          if (dateAired != null)
            TextLabel(
                text: getDatePeriodFromString(dateStart: dateAired),
                labelText: releaseDateText)
        },
        if (status == AiredStatus.released ||
            status == AiredStatus.paused ||
            status == AiredStatus.discontinued)
          TextLabel(
              text: getDatePeriodFromString(
                  dateStart: dateAired, dateEnd: dateReleased),
              labelText: releaseDateText)
      ],
    );
  }
}

/// базовый масштаб элемента
const double baseElementScale = 1.0;

/// масштаб элемента при наведении курсора
const double hoverElementScale = 1.02;

////////////////////////////////////////////////////////////////////////////////
/// Базовая карточка для всего приложения
////////////////////////////////////////////////////////////////////////////////
class ElementCard extends StatefulWidget {
  final String? imageUrl;
  final double imageHeight;
  final double imageWidth;
  final Widget? overPicture;
  final String? titleText;
  final String? secondTextOne;
  final String? secondTextTwo;
  final Widget? info;
  final Function()? onImageClick;
  final Function()? onTextClick;

  const ElementCard(
      {super.key,
      required this.imageUrl,
      this.imageHeight = ImageSizes.coverHeight,
      this.imageWidth = ImageSizes.coverWidth,
      this.overPicture,
      required this.titleText,
      this.secondTextOne,
      this.secondTextTwo,
      this.info,
      this.onImageClick,
      this.onTextClick});

  @override
  State<StatefulWidget> createState() {
    return _ElementCardState();
  }
}

class _ElementCardState extends State<ElementCard> {
  double scale = baseElementScale;

  bool textHover = false;

  bool isExpanded = false;

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
        child: SizedBox(
          height: ImageSizes.horizontalCardHeight,
          width: widget.imageWidth,
          child: Column(
            children: [
              Flexible(
                  child: InkWell(
                onTap: widget.onImageClick,
                borderRadius: Borders.seven,
                child: PaddingAll(
                    child: widget.info == null
                        ? ImageCard(
                            imageUrl: widget.imageUrl.orEmpty(),
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                            overPicture: widget.overPicture,
                          )
                        : ImageCardWithInfo(
                            isShowInfo: isExpanded,
                            info: widget.info!,
                            imageUrl: widget.imageUrl,
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                            overPicture: widget.overPicture,
                          )),
              )),
              InkWell(
                onTap: widget.onTextClick,
                borderRadius: Borders.seven,
                onHover: (focus) {
                  setState(() {
                    textHover = focus;
                    isExpanded = focus;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: textHover
                          ? (ShikidroidDesktop.of(context)?.getTheme() ==
                                  ThemeMode.light
                              ? Colors.black.withAlpha(10)
                              : Colors.white.withAlpha(10))
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(Doubles.seven))),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if (widget.titleText.isNullOrEmpty().not())
                        MyText(
                          text: widget.titleText.orEmpty(),
                          maxLines: 1,
                        ),
                      if (widget.secondTextOne.isNullOrEmpty().not() ||
                          widget.secondTextTwo.isNullOrEmpty().not())
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.secondTextOne.isNullOrEmpty().not())
                              MyText(
                                text: widget.secondTextOne.orEmpty(),
                                fontSize: TextSize.min,
                              ),
                            if (widget.secondTextOne.isNullOrEmpty().not() &&
                                widget.secondTextTwo.isNullOrEmpty().not())
                              const DodTextDivider(),
                            if (widget.secondTextTwo.isNullOrEmpty().not())
                              MyTextOnBackground(
                                text: widget.secondTextTwo.orEmpty(),
                                fontSize: TextSize.min,
                              )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Виджет загрузки изображения для карточки
////////////////////////////////////////////////////////////////////////////////
class ImageCard extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final Widget? overPicture;

  const ImageCard(
      {super.key,
      required this.imageUrl,
      this.height = ImageSizes.coverHeight,
      this.width = ImageSizes.coverWidth,
      this.overPicture});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Doubles.seven),
      child: Container(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // CachedNetworkImage(
            //     imageUrl: imageUrl.orEmpty(),
            //   fit: BoxFit.cover,
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //       Center(
            //         child: CircularProgressIndicator(
            //           value: downloadProgress.progress,
            //           color: Theme.of(context).colorScheme.secondary,
            //         ),
            //       ),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            // ),
            Image.network(
              imageUrl.orEmpty(),
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              },
            ),
            if (overPicture != null) overPicture!
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Виджет загрузки изображения для карточки с инофрмацией
///
/// [isShowInfo]
/// [info]
/// [imageUrl]
/// [height]
/// [width]
/// [overPicture]
////////////////////////////////////////////////////////////////////////////////
class ImageCardWithInfo extends StatelessWidget {
  final bool isShowInfo;
  final Widget info;
  final String? imageUrl;
  final double height;
  final double width;
  final Widget? overPicture;

  const ImageCardWithInfo(
      {super.key,
      this.isShowInfo = false,
      required this.info,
      this.imageUrl,
      this.height = ImageSizes.coverHeight,
      this.width = ImageSizes.coverWidth,
      this.overPicture});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Doubles.seven),
      child: Container(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isShowInfo ? info : null,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isShowInfo
                  ? null
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        // CachedNetworkImage(
                        //   imageUrl: imageUrl.orEmpty(),
                        //   fit: BoxFit.cover,
                        //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                        //       Center(
                        //         child: CircularProgressIndicator(
                        //           value: downloadProgress.progress,
                        //           color: Theme.of(context).colorScheme.secondary,
                        //         ),
                        //       ),
                        //   errorWidget: (context, url, error) => const Icon(Icons.error),
                        // ),
                        Image.network(
                          imageUrl.orEmpty(),
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          },
                        )
                      ],
                    ),
            ),
            if (overPicture != null) overPicture!
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Накладываемый на картинку текст в левом верхнем - правом нижнем углах
////////////////////////////////////////////////////////////////////////////////
class OverPictureOne extends StatelessWidget {
  final String? leftTopText;
  final String? rightBottomText;

  const OverPictureOne({super.key, this.leftTopText, this.rightBottomText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (leftTopText.isNullOrEmpty().not())
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Doubles.seven)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Doubles.three),
                child: MyText(
                  text: leftTopText.orEmpty(),
                  textAlign: TextAlign.left,
                  color: ShikidroidColors.defaultColorPrimary,
                ),
              ),
            ),
          ),
        if (rightBottomText.isNullOrEmpty().not())
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Doubles.seven)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Doubles.three),
                child: MyText(
                  text: rightBottomText.orEmpty(),
                  textAlign: TextAlign.left,
                  color: ShikidroidColors.defaultColorPrimary,
                ),
              ),
            ),
          )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Накладываемый на картинку текст снизу по центру и в левом верхнем углу
////////////////////////////////////////////////////////////////////////////////
class OverPictureTwo extends StatefulWidget {
  final String? leftTopText;
  final String? text;
  final Function()? onTitleClick;
  final Function(bool focus)? onTitleFocus;

  const OverPictureTwo(
      {super.key,
      this.leftTopText,
      required this.text,
      this.onTitleClick,
      this.onTitleFocus});

  @override
  State<StatefulWidget> createState() {
    return _OverPictureTwoState();
  }
}

class _OverPictureTwoState extends State<OverPictureTwo> {
  bool textHover = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.leftTopText.isNullOrEmpty().not())
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Doubles.seven)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Doubles.three),
                child: MyText(
                  text: widget.leftTopText.orEmpty(),
                  textAlign: TextAlign.left,
                  color: ShikidroidColors.defaultColorPrimary,
                ),
              ),
            ),
          ),
        if (widget.text.isNullOrEmpty().not())
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: widget.onTitleClick,
              borderRadius: Borders.seven,
              onHover: (f) {
                setState(() {
                  textHover = !textHover;
                  if (widget.onTitleFocus != null) {
                    widget.onTitleFocus!(f);
                  }
                });
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: textHover
                      ? Colors.black.withAlpha(235)
                      : Colors.black.withAlpha(200),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(Doubles.seven)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Doubles.three),
                  child: MyText(
                    text: widget.text.orEmpty(),
                    textAlign: TextAlign.center,
                    color: ShikidroidColors.defaultColorPrimary,
                    maxLines: 5,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Накладываемый на картинку текст в левом верхнем - правом нижнем углах
////////////////////////////////////////////////////////////////////////////////
class CalendarOverPicture extends StatelessWidget {
  final String? leftTopText;
  final RateStatus? rateStatusTopCorner;

  const CalendarOverPicture(
      {super.key, this.leftTopText, this.rateStatusTopCorner});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (leftTopText.isNullOrEmpty().not())
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Doubles.seven)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Doubles.three),
                child: MyText(
                  text: leftTopText.orEmpty(),
                  textAlign: TextAlign.left,
                  color: ShikidroidColors.defaultColorPrimary,
                ),
              ),
            ),
          ),
        if (rateStatusTopCorner != null) ...{
          Align(
            alignment: Alignment.topRight,
            child: PaddingAll(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    shape: BoxShape.circle,
                  ),
                  child: PaddingAll(
                      all: Doubles.seven,
                      child: Image(
                        height: Doubles.thirty,
                        width: Doubles.thirty,
                        image: AssetImage(rateStatusTopCorner!.toRateIconPath()),
                        color: rateStatusTopCorner?.toColor(),
                      )
                  ),
                )
            ),
          )
        }
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка для скриншота
////////////////////////////////////////////////////////////////////////////////
class ScreenshotVideoCard extends StatefulWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final Function()? onClick;

  const ScreenshotVideoCard(
      {super.key,
      this.imageUrl,
      this.height = ImageSizes.screenshotHeight,
      this.width = ImageSizes.screenshotWidth,
      this.onClick});

  @override
  State<StatefulWidget> createState() {
    return _ScreenshotVideoCardState();
  }
}

class _ScreenshotVideoCardState extends State<ScreenshotVideoCard> {
  double scale = baseElementScale;

  void setScale({required bool isHover}) {
    if (isHover) {
      scale = hoverElementScale;
    } else {
      scale = baseElementScale;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (d) {
        setScale(isHover: true);
      },
      onExit: (d) {
        setScale(isHover: false);
      },
      child: Transform.scale(
        scale: scale,
        child: InkWell(
          onTap: widget.onClick,
          child: PaddingAll(
              child: ImageCard(
            imageUrl: widget.imageUrl,
            height: widget.height,
            width: widget.width,
          )),
        ),
      ),
    );
  }
}

class ScreenshotViewerPicture extends StatelessWidget {
  final String url;
  final Function(Image image) callback;

  const ScreenshotViewerPicture(
      {super.key, required this.url, required this.callback});

  @override
  Widget build(BuildContext context) {
    final Image image = Image.network(url, fit: BoxFit.cover, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
              : null,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    });

    callback(image);

    return image;
  }
}

Future<List<int>> getImageSize({required Image image}) async {
  Completer<ui.Image> completer = Completer<ui.Image>();

  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo image, bool _) {
    completer.complete(image.image);
  }));
  ui.Image info = await completer.future;

  int width = info.width;
  int height = info.height;

  List<int> sizes = [width, height];

  return sizes;
}
