import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/domain/models/video/ShimoriTranslationModel.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/GenreCard.dart';
import 'package:shikidesk/presentation/items/ListIsEmpty.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens_bloc/EpisodeScreenBloc.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BackgroundImage.dart';
import 'package:shikidesk/ui/components/ColumnRows.dart';
import 'package:shikidesk/ui/components/HorizontalDrawer.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundTextButton.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../ui/Sizes.dart';
import '../../ui/components/ImageFromAsset.dart';
import '../../ui/components/PopupMenuButtons.dart';
import '../items/EpisodeCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Эпизоды с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class EpisodeContainer extends StatelessWidget {
  final int? animeId;
  final String? animeNameRu;
  final String? animeNameEng;
  final String? animeImageUrl;

  const EpisodeContainer(
      {super.key,
      this.animeId,
      this.animeNameRu,
      this.animeNameEng,
      this.animeImageUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EpisodeScreenBloc>(
      create: (context) => diProvider<EpisodeScreenBloc>(),
      child: _EpisodeScreenBlocProvider(
          animeId: animeId,
          animeNameRu: animeNameRu,
          animeNameEng: animeNameEng,
          animeImageUrl: animeImageUrl),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть EpisodeScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _EpisodeScreenBlocProvider extends StatelessWidget {
  final int? animeId;
  final String? animeNameRu;
  final String? animeNameEng;
  final String? animeImageUrl;

  const _EpisodeScreenBlocProvider(
      {this.animeId, this.animeNameRu, this.animeNameEng, this.animeImageUrl});

  @override
  Widget build(BuildContext context) {
    final EpisodeScreenBloc episodeBloc = context.read<EpisodeScreenBloc>();

    return _EpisodeScreen(
      animeId: animeId,
      animeNameRu: animeNameRu,
      animeNameEng: animeNameEng,
      animeImageUrl: animeImageUrl,
      episodeBloc: episodeBloc,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Эпизоды
////////////////////////////////////////////////////////////////////////////////
class _EpisodeScreen extends StatefulWidget {
  final int? animeId;
  final String? animeNameRu;
  final String? animeNameEng;
  final String? animeImageUrl;
  final EpisodeScreenBloc episodeBloc;

  const _EpisodeScreen(
      {super.key,
      this.animeId,
      this.animeNameRu,
      this.animeNameEng,
      this.animeImageUrl,
      required this.episodeBloc});

  @override
  State<StatefulWidget> createState() {
    return _EpisodeScreenState();
  }
}

class _EpisodeScreenState extends State<_EpisodeScreen> {
  var isExpand = false;

  @override
  void initState() {
    super.initState();
    widget.episodeBloc.animeId = widget.animeId;
    widget.episodeBloc.animeNameRu = widget.animeNameRu;
    widget.episodeBloc.animeNameEng = widget.animeNameEng;

    widget.episodeBloc.add(LoadEpisode(
      animeId: widget.animeId,
      animeNameEng: widget.animeNameEng,
      episode: widget.episodeBloc.currentEpisode,
      translationType: widget.episodeBloc.translationType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final EpisodeScreenBloc episodeBloc = widget.episodeBloc;

    List<Widget> episodeBtn = [];

    for (int i = 1; i <= (episodeBloc.episodesNumber ?? 1); i++) {
      episodeBtn.add(
          RoundedTextButton(
              text: "$i",
              textSize: TextSize.defaultForApp,
              backgroundColor: i == episodeBloc.currentEpisode
                  ? Theme.of(context).colorScheme.secondary
                  : null,
              backgroundAlpha:
              i == episodeBloc.currentEpisode ? 110 : 255,
              onClick: () {
                setState(() {
                  episodeBloc.currentEpisode = i;
                  episodeBloc.add(LoadEpisode(
                      animeId: episodeBloc.animeId,
                      animeNameEng: episodeBloc.animeNameEng,
                      episode: episodeBloc.currentEpisode,
                      translationType:
                      episodeBloc.translationType));
                  episodeBloc.showDrawer = false;
                  isExpand = episodeBloc.showDrawer;
                });
              })
      );
    }

    return BlocBuilder<EpisodeScreenBloc, EpisodeScreenState>(
        bloc: episodeBloc,
        builder: (context, state) {
          return Builder(builder: (context) {
            return HorizontalDrawer(
              isExpand: isExpand,
              drawerWidget: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 300,
                child: Center(
                  child: ColumnRows(
                      data: episodeBtn,
                      columnCount: 3
                  ),
                ),
              ),
              mainWidget: BackgroundImage(
                  imageUrl: widget.animeImageUrl,
                  mainWidget: Column(
                    children: [
                      ToolbarForApp(
                        backBtnAlpha: Ints.oneHundredFifty,
                        centerWidget: MyTextSemiBold(
                            text: getEmptyIfBothNull(
                                widget.animeNameRu, widget.animeNameEng)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _EpisodeHeader(
                            episodeBloc: episodeBloc,
                            showDrawer: (show) {
                              setState(() {
                                isExpand = show;
                              });
                            },
                          ),
                          _EpisodesListSection(episodeBloc: episodeBloc)
                        ],
                      )
                    ],
                  )),
            );
          });
        });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Кнопки номера эпизода и типов трансляции над списком эпизодов
////////////////////////////////////////////////////////////////////////////////
class _EpisodeHeader extends StatefulWidget {
  final EpisodeScreenBloc episodeBloc;
  final Function(bool isExpand) showDrawer;

  const _EpisodeHeader({required this.episodeBloc, required this.showDrawer});

  @override
  State<StatefulWidget> createState() {
    return _EpisodeHeaderState();
  }
}

class _EpisodeHeaderState extends State<_EpisodeHeader> {
  @override
  Widget build(BuildContext context) {
    var translationType = widget.episodeBloc.translationType;

    return SizedBox(
      width: double.infinity,
      height: 100,
      child: PaddingBySide(
          start: Doubles.twenty,
          end: Doubles.twenty,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Кнопка с номером текущего эпизода
              if ((widget.episodeBloc.episodesNumber ?? 0) > 0) ...{
                RoundedTextButton(
                    backgroundAlpha: Ints.twoHundred,
                    text: "${widget.episodeBloc.currentEpisode}",
                    onClick: () {
                      setState(() {
                        widget.episodeBloc.showDrawer =
                            !widget.episodeBloc.showDrawer;
                        widget.showDrawer(widget.episodeBloc.showDrawer);
                      });
                    })
              } else ...{
                const Spacer()
              },

              /// Кнопка Субтитры
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExpandedLeftHorizontalCard(
                      isExpand: translationType == TranslationType.subRu,
                      mainWidget: RoundedIconButton(
                          backgroundColor:
                              translationType == TranslationType.subRu
                                  ? Theme.of(context).colorScheme.secondary
                                  : null,
                          backgroundAlpha:
                              translationType == TranslationType.subRu
                                  ? 50
                                  : 255,
                          imagePath: iconSubtitles1,
                          onClick: () {
                            setState(() {
                              widget.episodeBloc.translationType =
                                  TranslationType.subRu;
                              widget.episodeBloc.add(LoadEpisode(
                                  animeId: widget.episodeBloc.animeId,
                                  animeNameEng: widget.episodeBloc.animeNameEng,
                                  episode: widget.episodeBloc.currentEpisode,
                                  translationType: TranslationType.subRu));
                            });
                          }),
                      expandWidget: const MyText(text: subtitlesTitle)),

                  /// Кнопка Озвучка
                  ExpandedLeftHorizontalCard(
                      isExpand: translationType == TranslationType.voiceRu,
                      mainWidget: RoundedIconButton(
                          backgroundColor:
                              translationType == TranslationType.voiceRu
                                  ? Theme.of(context).colorScheme.secondary
                                  : null,
                          backgroundAlpha:
                              translationType == TranslationType.voiceRu
                                  ? 50
                                  : 255,
                          imagePath: iconMicrophone1,
                          onClick: () {
                            setState(() {
                              widget.episodeBloc.translationType =
                                  TranslationType.voiceRu;
                              widget.episodeBloc.add(LoadEpisode(
                                  animeId: widget.episodeBloc.animeId,
                                  animeNameEng: widget.episodeBloc.animeNameEng,
                                  episode: widget.episodeBloc.currentEpisode,
                                  translationType: TranslationType.voiceRu));
                            });
                          }),
                      expandWidget: const MyText(text: dubTitle)),
                ],
              )
            ],
          )),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Сетка состояний списка эпизодов
////////////////////////////////////////////////////////////////////////////////
class _EpisodesListSection extends StatefulWidget {
  final EpisodeScreenBloc episodeBloc;

  const _EpisodesListSection({required this.episodeBloc});

  @override
  State<StatefulWidget> createState() {
    return _EpisodeListSectionState();
  }
}

class _EpisodeListSectionState extends State<_EpisodesListSection> {
  static const String textEmptySubs = "Ничего не найдено\n Попробуйте поискать Озвучку";
  static const String textEmptyDub = "Ничего не найдено\n Попробуйте поискать Субтитры";

  @override
  Widget build(BuildContext context) {
    var translationType = widget.episodeBloc.translationType;

    return BlocBuilder<EpisodeScreenBloc, EpisodeScreenState>(
        bloc: widget.episodeBloc,
        builder: (context, state) {
          return Builder(builder: ((context) {
            if (state is EpisodeLoaded) {
              if (state.translations.isNotEmpty) {
                return _EpisodeList(
                  episodeBloc: widget.episodeBloc,
                  translations: state.translations,
                );
              } else {
                return ListIsEmpty(
                  imageSize: 100,
                  imageColor: Colors.white,
                  text: translationType == TranslationType.subRu
                      ? textEmptySubs
                      : textEmptyDub,
                  textSize: 30,
                );
              }
              ;
            }

            if (state is EpisodeError) {
              return ListIsEmpty(
                imageSize: 100,
                imageColor: Colors.white,
                text: translationType == TranslationType.subRu
                    ? textEmptySubs
                    : textEmptyDub,
                textSize: 30,
              );
            }

            return const ItemLoader(
              imageHeight: 110,
              imageWidth: 110,
            );
          }));
        });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список эпизодов
////////////////////////////////////////////////////////////////////////////////
class _EpisodeList extends StatefulWidget {
  final EpisodeScreenBloc episodeBloc;
  final List<ShimoriTranslationModel> translations;

  const _EpisodeList({required this.episodeBloc, required this.translations});

  @override
  State<StatefulWidget> createState() {
    return _EpisodeListState();
  }
}

class _EpisodeListState extends State<_EpisodeList> {
  List<String> resolutions = [];

  Future loadLinks(
      {required ShimoriTranslationModel translation,
      required RelativeRect position}) async {
    resolutions.clear();

    showMenu(context: context, position: position, items: [
      const PopupMenuItem(
          child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: Loader(),
              )))
    ]);

    await widget.episodeBloc.loadVideo(
        malId: translation.targetId ?? 1,
        episode: translation.episode ?? 1,
        translationType: translation.kind,
        author: translation.author,
        hosting: translation.hosting.orEmpty(),
        hostingId: 1,
        videoId: translation.id,
        url: translation.url,
        links: (qualityMap) {
          resolutions = qualityMap.keys.toList();

          if (ModalRoute.of(context)?.isCurrent == false) {
            navigateBack(context);
          }

          showMenu(
              context: context,
              position: position,
              items: List.generate(resolutions.length, (index) {
                return PopupMenuItem(
                    value: index,
                    onTap: () {
                      navigateBrowser(url: qualityMap[resolutions[index]], useWebView: false);
                    },
                    child: MyText(text: resolutions[index].toSourceResolution()));
              }));
        },

        isError: () {
          if (ModalRoute.of(context)?.isCurrent == false) {
            navigateBack(context);
          }

          showMenu(
              context: context,
              position: position,
              items: [
                const PopupMenuItem(
                    child: MyText(text: requestErrorTitle)
                )
              ]
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        all: Doubles.fourteen,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GridView(
            padding: const EdgeInsets.only(bottom: 400),
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                mainAxisExtent: 200,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            children: [
              for (var i in widget.translations)
                EpisodeCard(
                    author: i.author ?? i.hosting,
                    downloadWidget: PopupIconButtonForShowMenu(
                        message: "Скачать видео",
                        onTap: (position) {
                          loadLinks(translation: i, position: position);
                        },
                        icon: ImageFromAsset(
                          path: iconDownload,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        )),
                    hosting: GenreCard(
                        paddingAll: 0, cardHeight: 45, text: i.hosting),
                    quality: i.quality,
                    onClick: () {
                      navigateVideoScreen(
                          animeId: widget.episodeBloc.animeId,
                          animeNameRu: widget.episodeBloc.animeNameRu,
                          animeNameEng: widget.episodeBloc.animeNameEng,
                          translation: i,
                          context: context);
                    })
            ],
          ),
        ));
  }
}