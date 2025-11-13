
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/domain/models/anime/AnimeDetailsModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/anime/AnimeVideoModel.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/manga/MangaDetailsModel.dart';
import 'package:shikidesk/domain/models/manga/MangaType.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/ContainerColor.dart';
import 'package:shikidesk/presentation/items/DropdownMenuItem.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/GenreCard.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigateByLinkType.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/ErrorScreen.dart';
import 'package:shikidesk/presentation/screens_bloc/DetailsScreenBloc.dart';
import 'package:shikidesk/ui/Colors.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BackgroundImage.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/LabelText.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/MeasureSize.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/PopupMenuButtons.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/RowTitleText.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/IntExtensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/anime/ScreenshotModel.dart';
import '../../domain/models/common/GenreModel.dart';
import '../../domain/models/common/LinkModel.dart';
import '../../domain/models/common/RelatedModel.dart';
import '../../domain/models/manga/MangaModel.dart';
import '../../domain/models/roles/CharacterModel.dart';
import '../../ui/AssetsPath.dart';
import '../../ui/components/VerticalDrawer.dart';
import '../items/AnimeCard.dart';
import '../items/MangaCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Календарь с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class DetailsContainer extends StatelessWidget {
  final DetailsScreenType screenType;
  final int? id;

  const DetailsContainer(
      {super.key, this.screenType = DetailsScreenType.anime, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsScreenBloc>(
      create: (context) => diProvider<DetailsScreenBloc>(),
      child: _DetailsScreenBlocProvider(screenType: screenType, id: id),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть DetailsScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _DetailsScreenBlocProvider extends StatelessWidget {
  final DetailsScreenType screenType;
  final int? id;

  const _DetailsScreenBlocProvider(
      {super.key, required this.screenType, this.id});

  @override
  Widget build(BuildContext context) {
    final DetailsScreenBloc detailsBloc = context.read<DetailsScreenBloc>();

    return _DetailsScreen(
      screenType: screenType,
      id: id,
      detailsBloc: detailsBloc,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _DetailsScreen extends StatefulWidget {
  final DetailsScreenType screenType;
  final int? id;
  final DetailsScreenBloc detailsBloc;

  const _DetailsScreen({super.key,
    required this.screenType,
    this.id,
    required this.detailsBloc});

  @override
  State<StatefulWidget> createState() {
    return _DetailsScreenState();
  }
}

class _DetailsScreenState extends State<_DetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.detailsBloc
        .add(LoadDetails(screenType: widget.screenType, id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final DetailsScreenBloc detailsBloc = widget.detailsBloc;

    return BlocBuilder<DetailsScreenBloc, DetailsScreenState>(
        builder: (context, state) {
          return Builder(builder: (context) {
            if (state is DetailsLoading) {
              return const LoaderWithBackButton();
            }

            if (state is AnimeDetailsLoaded) {
              return _AnimeDetailsInfo(
                state: state,
                animeDetails: state.animeDetails,
                characters: state.characters,
                screenshots: state.screenshots,
                animeVideos: state.animeVideos,
                animeRelated: state.animeRelated,
                animeSimilar: state.animeSimilar,
                externalLinks: state.externalLinks,
              );
            }

            if (state is MangaRanobeDetailsLoaded) {
              return _MangaRanobeDetailsInfo(
                  state: state,
                  mangaDetails: state.mangaRanobeDetails,
                  characters: state.characters,
                  mangaRelated: state.mangaRelated,
                  mangaSimilar: state.mangaRanobeSimilar);
            }

            if (state is DetailsError) {
              return ErrorScreen(
                mainCallback: () {
                  detailsBloc.add(
                      LoadDetails(
                          screenType: widget.screenType, id: widget.id));
                },
              );
            }

            return const LoaderWithBackButton();
          });
        });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Основное наполнение экрана Детальной информации Аниме
////////////////////////////////////////////////////////////////////////////////
class _AnimeDetailsInfo extends StatefulWidget {
  final DetailsScreenState state;
  final AnimeDetailsModel animeDetails;
  final List<CharacterModel> characters;
  final List<ScreenshotModel> screenshots;
  final List<AnimeVideoModel> animeVideos;
  final List<RelatedModel> animeRelated;
  final List<AnimeModel> animeSimilar;
  final List<LinkModel> externalLinks;

  const _AnimeDetailsInfo({super.key,
    required this.state,
    required this.animeDetails,
    required this.characters,
    required this.screenshots,
    required this.animeVideos,
    required this.animeRelated,
    required this.animeSimilar,
    required this.externalLinks});

  @override
  State<StatefulWidget> createState() {
    return _AnimeDetailsInfoState();
  }
}

class _AnimeDetailsInfoState extends State<_AnimeDetailsInfo> {

  /// флаг показа выезжающего меню
  bool isDrawerOpen = false;
  /// тип выезжающего меню
  DetailsScreenDrawerType drawerType = DetailsScreenDrawerType.externalLinks;

  /// Список ссылок на кадры из аниме
  List<String> screensUrls = [];
  /// текущий индекс списка кадров
  int screenshotIndex = 0;
  /// флаг показа просмотра кадров аниме
  bool showScreenshot = false;

  @override
  void initState() {
    super.initState();
    for (var i in widget.screenshots) {
      if (i.original != null) {
        screensUrls.add(i.original!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menuWidgets = [
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconWeb,
          color: Theme
              .of(context)
              .colorScheme
              .onPrimary,
        ),
        text: webVersionTitle,
      ),
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconLink,
          color: Theme
              .of(context)
              .colorScheme
              .onPrimary,
        ),
        text: linksTitle,
      ),
    ];

    return BackgroundImage(
      imageUrl: widget.animeDetails.image?.original,
      mainWidget: StackTopContainer(
        topWidget: ToolbarForApp(
          backBtnAlpha: Ints.oneHundredFifty,
          endWidget: PopupMenuBorderIconButton(
              iconPath: iconThreeDots,
              iconColor: Theme
                  .of(context)
                  .colorScheme
                  .onBackground,
              menuWidgets: menuWidgets,
              callback: (index) {
                switch (index) {
                  case (0):
                    navigateBrowser(url: widget.animeDetails.url);
                  default:
                    {
                      setState(() {
                        drawerType = DetailsScreenDrawerType.externalLinks;
                        isDrawerOpen = !isDrawerOpen;
                      });
                    }
                }
              }),
        ),
        mainWidget: Stack(
          children: [

            /// Основная часть экрана
            VerticalDrawer(
              isExpand: isDrawerOpen,
              drawerHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
              mainWidget: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: SingleChildScrollView(
                  reverse: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DetailsHeader(animeDetails: widget.animeDetails),
                        const Divider(),
                        if (widget.animeDetails.description != null)
                          _DetailsDescription(
                              description: widget.animeDetails.description),
                        if (widget.characters.isNotEmpty)
                          _Characters(characters: widget.characters),
                        if (widget.screenshots.isNotEmpty)
                          _Screenshots(
                            screenshots: widget.screenshots,
                            onClick: (index) {
                              setState(() {
                                screenshotIndex = index;
                                showScreenshot = true;
                              });
                            },
                          ),
                        if (widget.animeVideos.isNotEmpty)
                          _Videos(videos: widget.animeVideos),
                        if (widget.animeRelated.isNotEmpty)
                          _Related(relatedList: widget.animeRelated),
                        if (widget.animeSimilar.isNotEmpty)
                          _SimilarAnime(animeSimilar: widget.animeSimilar),
                        const SpacerSized(height: 110)
                      ],
                    ),
                  ),
                ),
              ),
              drawerWidget: Stack(
                children: [
                  if (drawerType == DetailsScreenDrawerType.externalLinks) ...{
                    _ExternalLinksDrawer(externalLinks: widget.externalLinks)
                  }
                ],
              ),
            ),

            /// Показ скриншотов
            if (showScreenshot)...{
              _ScreenshotsViewer(
                screenshots: screensUrls,
                index: screenshotIndex,
                onDismiss: () {
                  setState(() {
                    showScreenshot = false;
                  });
                },
              )
            }
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Основное наполнение экрана Детальной информации о Манге/Ранобэ
////////////////////////////////////////////////////////////////////////////////
class _MangaRanobeDetailsInfo extends StatefulWidget {
  final DetailsScreenState state;
  final MangaDetailsModel mangaDetails;
  final List<CharacterModel> characters;
  final List<RelatedModel> mangaRelated;
  final List<MangaModel> mangaSimilar;

  const _MangaRanobeDetailsInfo({super.key,
    required this.state,
    required this.mangaDetails,
    required this.characters,
    required this.mangaRelated,
    required this.mangaSimilar});

  @override
  State<StatefulWidget> createState() {
    return _MangaRanobeDetailsInfoState();
  }
}

class _MangaRanobeDetailsInfoState extends State<_MangaRanobeDetailsInfo> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuWidgets = [
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconWeb,
          color: Theme
              .of(context)
              .colorScheme
              .onPrimary,
        ),
        text: webVersionTitle,
      )
    ];

    return BackgroundImage(
      imageUrl: widget.mangaDetails.image?.original,
      mainWidget: StackTopContainer(
          topWidget: ToolbarForApp(
            backBtnAlpha: Ints.oneHundredFifty,
            endWidget: PopupMenuBorderIconButton(
                iconPath: iconThreeDots,
                iconColor: Theme
                    .of(context)
                    .colorScheme
                    .onBackground,
                menuWidgets: menuWidgets,
                callback: (index) {
                  navigateBrowser(url: widget.mangaDetails.url);
                }),
          ),
          mainWidget: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              reverse: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DetailsHeader(mangaDetails: widget.mangaDetails),
                    const Divider(),
                    if (widget.mangaDetails.description != null)
                      _DetailsDescription(
                          description: widget.mangaDetails.description),
                    if (widget.characters.isNotEmpty)
                      _Characters(characters: widget.characters),
                    if (widget.mangaRelated.isNotEmpty)
                      _Related(relatedList: widget.mangaRelated),
                    if (widget.mangaSimilar.isNotEmpty)
                      _SimilarManga(mangaSimilar: widget.mangaSimilar),
                    const SpacerSized(height: 110)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Верхняя часть экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _DetailsHeader extends StatelessWidget {
  final AnimeDetailsModel? animeDetails;
  final MangaDetailsModel? mangaDetails;

  const _DetailsHeader({super.key, this.animeDetails, this.mangaDetails});

  @override
  Widget build(BuildContext context) {
    return PaddingAll(
        child: Column(
          children: [
            const SpacerSized(height: 110),
            Row(
              children: [
                if (animeDetails != null)
                  Expanded(
                      flex: 1,
                      child:
                      _LeftLabelAnimeTextHeader(animeDetails: animeDetails!)),
                if (mangaDetails != null)
                  Expanded(
                      child:
                      _LeftLabelTextMangaHeader(mangaDetails: mangaDetails!)),
                Expanded(
                    flex: 1,
                    child: _CenterImageScoreHeader(
                      imageUrl: animeDetails?.image?.original ??
                          mangaDetails?.image?.original,
                      score: animeDetails?.score ?? mangaDetails?.score,
                    )),
                Expanded(
                    flex: 1,
                    child: _RightStatusButtonsHeader(
                        animeDetails: animeDetails, mangaDetails: mangaDetails))
              ],
            ),

            /// Название на русском
            MyTextBold(
              text: animeDetails != null
                  ? getEmptyIfBothNull(animeDetails?.nameRu, animeDetails?.name)
                  : getEmptyIfBothNull(
                  mangaDetails?.nameRu, mangaDetails?.name),
              fontSize: TextSize.extraBig,
              maxLines: 5,
            ),

            /// Название на английском
            MyTextOnBackground(
              text: animeDetails?.name ?? mangaDetails?.name,
              fontSize: TextSize.big,
              maxLines: 5,
            ),

            /// Жанры
            PaddingBySide(
                top: Doubles.seven,
                child: _GenresList(
                    genres: (animeDetails?.genres ?? mangaDetails?.genres) ??
                        []))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Левая часть верхней части экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _LeftLabelAnimeTextHeader extends StatelessWidget {
  final AnimeDetailsModel animeDetails;

  const _LeftLabelAnimeTextHeader({super.key, required this.animeDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// Тип
        TextLabel(
            text: animeDetails.type.toScreenString(), labelText: typeText),

        /// Количество эпизодов
        if (animeDetails.type != AnimeType.movie)
          TextLabel(
              text: animeDetails.episodes.toString(), labelText: episodeText),

        /// Длительность
        if (animeDetails.duration.orZero() > 0)
          TextLabel(
              text: animeDetails.duration.orZero().toEpisodeTime(),
              labelText: episodeTimeText),

        /// Возрастной рейтинг
        if (animeDetails.ageRating != null &&
            animeDetails.ageRating
                .toScreenString()
                .isNotEmpty)
          TextLabel(
              text: animeDetails.ageRating.toScreenString(),
              labelText: ageText),

        /// Дата выхода в зависимости от типа трансляции
        if (animeDetails.anons == true || animeDetails.ongoing == true) ...[

          /// Если анонс, то отображается дата выхода
          if (animeDetails.anons == true)
            if (animeDetails.dateAired != null)
              TextLabel(
                  text: getDatePeriodFromString(
                      dateStart: animeDetails.dateAired),
                  labelText: releaseDateText),

          /// Если онгоинг, то отображается Время до след. эпизода
          if (animeDetails.ongoing == true)
            if (animeDetails.nextEpisodeDate != null)
              TextLabel(
                  text: animeDetails.nextEpisodeDate.getDateBeforeCurrent(),
                  labelText:
                  "до ${animeDetails.episodesAired.orZero() + 1} эп.")
        ] else
          ...[

            /// Если Фильм или Спэшл и уже в релизе, то берём дату из [dateAired] или [dateReleased]
            if (animeDetails.type == AnimeType.movie ||
                animeDetails.type == AnimeType.special) ...[
              if (animeDetails.dateAired != null ||
                  animeDetails.dateReleased != null)
                TextLabel(
                    text: getDatePeriodFromString(
                        dateStart:
                        animeDetails.dateAired ?? animeDetails.dateReleased),
                    labelText: releaseDateText)
            ] else
              ...[

                /// Если НЕ Фильм и НЕ Спэшл, то показываем одну или две даты
                if (animeDetails.dateAired != null &&
                    animeDetails.dateReleased == null)
                  TextLabel(
                      text: getDatePeriodFromString(
                          dateStart: animeDetails.dateAired),
                      labelText: releaseDateText),

                if (animeDetails.dateAired == null &&
                    animeDetails.dateReleased != null)
                  TextLabel(
                      text: getDatePeriodFromString(
                          dateStart: animeDetails.dateReleased),
                      labelText: releaseDateText),

                if (animeDetails.dateAired != null &&
                    animeDetails.dateReleased != null)
                  TextLabel(
                      text: getDatePeriodFromString(
                          dateStart: animeDetails.dateAired,
                          dateEnd: animeDetails.dateReleased),
                      labelText: releaseDateText),
              ]
          ],
      ],
    );
  }
}

class _LeftLabelTextMangaHeader extends StatelessWidget {
  final MangaDetailsModel mangaDetails;

  const _LeftLabelTextMangaHeader({super.key, required this.mangaDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// Тип
        TextLabel(
            text: mangaDetails.type.toScreenString(), labelText: typeText),

        /// Количество глав
        if (mangaDetails.chapters.orZero() > 0)
          TextLabel(text: "${mangaDetails.chapters}", labelText: chaptersText),

        /// Количество томов
        if (mangaDetails.volumes.orZero() > 0)
          TextLabel(text: "${mangaDetails.volumes}", labelText: volumesText),

        /// Если анонс или онгоинг, то отображаем дату начала выхода
        if (mangaDetails.anons == true || mangaDetails.ongoing == true) ...[
          if (mangaDetails.dateAired != null)
            TextLabel(
                text:
                getDatePeriodFromString(dateStart: mangaDetails.dateAired),
                labelText: releaseDateText)
        ] else
          ...[

            /// В противном случае период выхода
            if (mangaDetails.dateAired != null &&
                mangaDetails.dateReleased == null)
              TextLabel(
                  text:
                  getDatePeriodFromString(dateStart: mangaDetails.dateAired),
                  labelText: releaseDateText),

            if (mangaDetails.dateAired == null &&
                mangaDetails.dateReleased != null)
              TextLabel(
                  text: getDatePeriodFromString(
                      dateStart: mangaDetails.dateReleased),
                  labelText: releaseDateText),

            if (mangaDetails.dateAired != null &&
                mangaDetails.dateReleased != null)
              TextLabel(
                  text: getDatePeriodFromString(
                      dateStart: mangaDetails.dateAired,
                      dateEnd: mangaDetails.dateReleased),
                  labelText: releaseDateText),
          ]
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Центральная часть верхней части экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _CenterImageScoreHeader extends StatelessWidget {
  final String? imageUrl;
  final String? score;

  const _CenterImageScoreHeader(
      {super.key, required this.imageUrl, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageCard(
            height: ImageSizes.detailsCoverHeight,
            width: ImageSizes.detailsCoverWidth,
            imageUrl: imageUrl),
        PaddingAll(
            all: Doubles.fourteen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageFromAsset(
                  path: iconStar,
                  size: ImageSizes.seventeen,
                ),
                PaddingBySide(start: Doubles.seven, child: MyText(text: score))
              ],
            ))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Правая часть верхней части экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _RightStatusButtonsHeader extends StatelessWidget {
  final AnimeDetailsModel? animeDetails;
  final MangaDetailsModel? mangaDetails;

  const _RightStatusButtonsHeader(
      {super.key, this.animeDetails, this.mangaDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyTextBold(
          text: (animeDetails?.status ?? mangaDetails?.status).toScreenString(),
          color: (animeDetails?.status ?? mangaDetails?.status).toColor(),
        ),
        if (animeDetails != null && animeDetails?.status != AiredStatus.anons)
          ContainerColorList(
              color: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              borderColor: Theme
                  .of(context)
                  .colorScheme
                  .onBackground,
              onClick: () {
                navigateEpisodeScreen(
                    animeId: animeDetails?.id,
                    animeNameRu: animeDetails?.nameRu,
                    animeNameEng: animeDetails?.name,
                    animeImageUrl: animeDetails?.image?.original,
                    context: context);
              },
              widgets: const [
                MyTextSemiBold(text: startWatchingText),
                PaddingBySide(
                    start: 7,
                    child: ImageFromAsset(
                      path: iconPlay,
                      size: 24,
                    ))
              ])
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Жанрами, находится под Header
////////////////////////////////////////////////////////////////////////////////
class _GenresList extends StatelessWidget {
  final List<GenreModel> genres;

  const _GenresList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (var g in genres.orEmptyList()) GenreCard(useHover: true, text: g.nameRu)
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Описанием, находится под жанрами
////////////////////////////////////////////////////////////////////////////////
class _DetailsDescription extends StatelessWidget {
  final String? description;

  const _DetailsDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleText(text: descriptionTitle),
        PaddingBySide(
            start: Doubles.fourteen,
            end: Doubles.fourteen,
            child: getAnnotationString(
                text: description,
                textSize: TextSize.big,
                primaryColor: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
                annotationColor: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                navigateCallback: (linkType, link, name) {
                  navigateByLinkType(
                      linkType: linkType, link: link, context: context);
                }))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Персонажами, находится под Описанием
////////////////////////////////////////////////////////////////////////////////
class _Characters extends StatelessWidget {
  final List<CharacterModel> characters;

  const _Characters({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: charactersTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (var i in characters)
                        ElementCard(
                          imageUrl: i.image?.original,
                          titleText: getEmptyIfBothNull(i.nameRu, i.name),
                          onImageClick: () {
                            navigateCharacterDetailsScreen(
                                id: i.id, context: context);
                          },
                        )
                    ],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана со Скриншотами из Аниме
////////////////////////////////////////////////////////////////////////////////
class _Screenshots extends StatelessWidget {
  final List<ScreenshotModel> screenshots;
  final Function(int index) onClick;

  const _Screenshots(
      {super.key, required this.screenshots, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: screenshotsTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.screenshotHeight,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var s in screenshots)
                        ScreenshotVideoCard(
                          imageUrl: s.original,
                          onClick: () {
                            int index = screenshots.indexOf(s);
                            onClick(index);
                          },
                        )
                    ],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Виджет для показа скриншотов
////////////////////////////////////////////////////////////////////////////////
class _ScreenshotsViewer extends StatefulWidget {
  final List<String> screenshots;
  final int? index;
  final Function() onDismiss;

  const _ScreenshotsViewer({
    super.key,
    required this.screenshots,
    this.index = 0,
    required this.onDismiss});

  @override
  State<StatefulWidget> createState() {
    return _ScreenshotsViewerState();
  }
}

class _ScreenshotsViewerState extends State<_ScreenshotsViewer> {

  int currentIndex = 0;

  int screensLength = 0;

  double containerHeight = 0;
  double containerWidth = 0;

  double screenshotHeight = 0;
  double screenshotWidth = 0;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    if (widget.screenshots.isNotEmpty) {
      screensLength = widget.screenshots.length - 1;
    }
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void getNextLeftIndex() {
    int index = currentIndex - 1;
    if (index < 0) {
      setState(() {
        currentIndex = screensLength;
      });
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  void getNextRightIndex() {
    int index = currentIndex + 1;
    if (index > screensLength) {
      setState(() {
        currentIndex = 0;
      });
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  void closeScreenshotsViewer() {
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      containerHeight = MediaQuery.of(context).size.height * 0.7;
      containerWidth = MediaQuery.of(context).size.width  * 0.7;
      _focusNode.requestFocus();
    });

    return Stack(
      children: [
        SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Container(
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .background
                      .withAlpha(200)
              )),
        ),

        Center(
          child: SizedBox(
            width: containerWidth,
            height: containerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MeasureSize(
                    onChange: (size) {
                      setState(() {
                        screenshotWidth = size.width;
                        screenshotHeight = size.height;
                      });
                    },
                    child: Image.network(
                        widget.screenshots[currentIndex],
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
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                            ),
                          );
                        }
                    )
                ),

                SizedBox(
                  width: screenshotWidth,
                  height: screenshotHeight,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: RoundedIconMiniButton(
                        imagePath: iconClose,
                        iconColor: ShikidroidColors.defaultColorPrimary,
                        onClick: () {
                          closeScreenshotsViewer();
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (event) {
              /// Нажатие на левую стрелку
              if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                getNextLeftIndex();
              }

              /// Нажатие на правую стрелку
              if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                getNextRightIndex();
              }

              /// Нажатие на Esc
              if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
                closeScreenshotsViewer();
              }
            },
            child: Center(
              child: PaddingAll(
                all: Doubles.fifty,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedIconMiniButton(
                          imagePath: iconChevronLeft,
                          onClick: () {
                            getNextLeftIndex();
                          }
                      ),

                      RoundedIconMiniButton(
                          imagePath: iconChevronRight,
                          onClick: () {
                            getNextRightIndex();
                          }
                      )
                    ],
                  )
              ),
            )
        )

      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Видео из Аниме
////////////////////////////////////////////////////////////////////////////////
class _Videos extends StatelessWidget {
  final List<AnimeVideoModel> videos;

  const _Videos({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: videoTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.videoScreenshotHeight + 60,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var v in videos)
                        ElementCard(
                            imageHeight: ImageSizes.videoScreenshotHeight,
                            imageWidth: ImageSizes.videoScreenshotWidth,
                            imageUrl: v.imageUrl,
                            titleText: v.name,
                            secondTextOne: v.hosting?.toUpperCase(),
                            onImageClick: () {
                              navigateBrowser(url: v.url ?? v.playerUrl);
                            }
                        )
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана со Связанным
////////////////////////////////////////////////////////////////////////////////
class _Related extends StatelessWidget {
  final List<RelatedModel> relatedList;

  const _Related({super.key, required this.relatedList});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: relatedTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (var i in relatedList) _RelatedCard(related: i)
                    ],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка элемента Связанного
////////////////////////////////////////////////////////////////////////////////
class _RelatedCard extends StatefulWidget {
  final RelatedModel related;

  const _RelatedCard({super.key, required this.related});

  @override
  State<StatefulWidget> createState() {
    return _RelatedCardState();
  }
}

class _RelatedCardState extends State<_RelatedCard> {

  void navigate() {
    if (widget.related.anime != null) {
      navigateAnimeDetailsScreen(
          id: widget.related.anime?.id, context: context);
    }
    if (widget.related.manga != null) {
      if (widget.related.manga?.type != MangaType.novel &&
          widget.related.manga?.type != MangaType.lightNovel) {
        navigateMangaDetailsScreen(
            id: widget.related.manga?.id, context: context);
      } else {
        navigateRanobeDetailsScreen(
            id: widget.related.manga?.id, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.related.anime?.image?.original ??
          widget.related.manga?.image?.original,
      titleText: widget.related.relationRu,
      secondTextOne: widget.related.anime != null
          ? widget.related.anime?.type.toScreenString()
          : widget.related.manga?.type.toScreenString(),
      secondTextTwo: widget.related.anime != null
          ? getYearString(widget.related.anime?.dateReleased ??
          widget.related.anime?.dateAired)
          : getYearString(widget.related.manga?.dateReleased ??
          widget.related.manga?.dateAired),
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.related.anime?.status ?? widget.related.manga?.status,
        score: widget.related.anime?.score ?? widget.related.manga?.score,
        episodes: widget.related.anime?.episodes,
        episodesAired: widget.related.anime?.episodesAired,
        chapters: widget.related.manga?.chapters,
        volumes: widget.related.manga?.volumes,
        dateAired:
        widget.related.anime?.dateAired ?? widget.related.manga?.dateAired,
        dateReleased: widget.related.anime?.dateReleased ??
            widget.related.manga?.dateReleased,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Похожим Аниме
////////////////////////////////////////////////////////////////////////////////
class _SimilarAnime extends StatelessWidget {
  final List<AnimeModel> animeSimilar;

  const _SimilarAnime({super.key, required this.animeSimilar});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: similarTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [for (var i in animeSimilar) AnimeCard(anime: i)],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Похожей Мангой/Ранобэ
////////////////////////////////////////////////////////////////////////////////
class _SimilarManga extends StatelessWidget {
  final List<MangaModel> mangaSimilar;

  const _SimilarManga({super.key, required this.mangaSimilar});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: similarTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [for (var i in mangaSimilar) MangaCard(manga: i)],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Вертикальное меню с ссылками на связанные сайты
////////////////////////////////////////////////////////////////////////////////
class _ExternalLinksDrawer extends StatelessWidget {
  final List<LinkModel> externalLinks;

  const _ExternalLinksDrawer({super.key, required this.externalLinks});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
      top: Doubles.fourteen,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          reverse: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpacerSized(height: 110),
                const RowTitleText(text: linksTitle),
                for (var i in externalLinks) ...{
                  PaddingAll(child: MyTextSemiBold(text: i.name))
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
