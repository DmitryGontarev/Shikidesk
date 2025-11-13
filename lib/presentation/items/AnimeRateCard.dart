import 'package:flutter/material.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/main.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../ui/Sizes.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка Аниме экрана Списки
///
/// [padding]
/// [width]
/// [height]
/// [backgroundAlpha]
////////////////////////////////////////////////////////////////////////////////
class AnimeRateCard extends StatefulWidget {
  final double? padding;
  final double width;
  final double height;
  final int backgroundAlpha;
  final AnimeModel anime;
  final int? userScore;
  final int? userEpisodes;
  final Function() onClick;

  const AnimeRateCard(
      {super.key,
      this.padding,
      this.width = 100,
      this.height = 50,
      this.backgroundAlpha = 255,
      required this.anime,
      this.userScore,
      this.userEpisodes,
      required this.onClick});

  @override
  State<StatefulWidget> createState() {
    return _AnimeRateCardState();
  }
}

class _AnimeRateCardState extends State<AnimeRateCard> {
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
        child: PaddingAll(
          all: widget.padding ?? Doubles.seven,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageCard(
                      imageUrl: widget.anime.image?.original,
                      overPicture: OverPictureOne(
                        leftTopText: "${widget.anime.score}",
                        rightBottomText: ((widget.userScore ?? 0) > 0)
                            ? "${widget.userScore}"
                            : null,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: PaddingAll(
                            all: Doubles.fourteen,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Верхняя часть карточки
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Название
                                    MyText(
                                      text: getEmptyIfBothNull(
                                          widget.anime.nameRu,
                                          widget.anime.name),
                                      maxLines: 5,
                                      textAlign: TextAlign.start,
                                    ),

                                    /// Строка с информацией о статусе релиза, типе трансляции, кол-во эпизодов и т.д.
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        /// Статус выхода
                                        MyText(
                                          text: widget.anime.status
                                              .toScreenString(),
                                          color: widget.anime.status.toColor(),
                                        ),
                                        const DodTextDivider(),

                                        /// Год выхода
                                        if (widget.anime.dateAired != null ||
                                            widget.anime.dateReleased !=
                                                null) ...{
                                          if (widget.anime.type ==
                                                  AnimeType.movie &&
                                              widget.anime.status !=
                                                  AiredStatus.anons) ...{
                                            MyTextOnBackground(
                                                text: getYearString(widget
                                                        .anime.dateReleased ??
                                                    widget.anime.dateAired)),
                                            const DodTextDivider()
                                          } else ...{
                                            if (widget.anime.status ==
                                                AiredStatus.anons) ...{
                                              MyTextOnBackground(
                                                  text: widget.anime.dateAired
                                                      ?.formatDate()),
                                              const DodTextDivider(),
                                            } else ...{
                                              MyTextOnBackground(
                                                  text: getYearString(widget
                                                          .anime.dateReleased ??
                                                      widget.anime.dateAired)),
                                              const DodTextDivider(),
                                            }
                                          }
                                        },

                                        /// Тип аниме (TV, Фильм, OVA и т.д.)
                                        MyTextOnBackground(
                                            text: widget.anime.type
                                                ?.toScreenString()),

                                        /// Количество эпизодов
                                        if (widget.anime.type !=
                                            AnimeType.movie) ...{
                                          if (widget.anime.status ==
                                                  AiredStatus.anons &&
                                              widget.anime.episodes != 0) ...{
                                            const DodTextDivider(),
                                            MyTextOnBackground(
                                                text:
                                                    "${widget.anime.episodesAired} / ${widget.anime.episodes} эп.")
                                          },
                                          if (widget.anime.status ==
                                              AiredStatus.ongoing) ...{
                                            const DodTextDivider(),
                                            MyTextOnBackground(
                                                text:
                                                    "${widget.anime.episodesAired} / ${widget.anime.episodes} эп.")
                                          },
                                          if (widget.anime.status ==
                                              AiredStatus.released) ...{
                                            const DodTextDivider(),
                                            MyTextOnBackground(
                                                text:
                                                    "${widget.anime.episodes} эп.")
                                          }
                                        }
                                      ],
                                    )
                                  ],
                                ),

                                /// Строка с количеством просмотренных эпизодов и кнопками
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    /// Количество просмотренных эпизодов
                                    MyText(
                                        text: ((widget.userEpisodes ?? 0) > 0)
                                            ? "${widget.userEpisodes}"
                                            : ""),

                                    /// Кнопка перехода на экран Эпизоды
                                    RoundedIconMiniButton(
                                        imagePath: iconPlay,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        onClick: () {
                                          navigateEpisodeScreen(
                                              animeId: widget.anime.id,
                                              animeImageUrl:
                                                  widget.anime.image?.original,
                                              animeNameRu: widget.anime.nameRu,
                                              animeNameEng: widget.anime.name,
                                              context: context);
                                        })
                                  ],
                                )
                              ],
                            )))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
