
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/utils/IntExtensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';

import '../../../di/DiProvider.dart';
import '../../../domain/models/common/AiredStatus.dart';
import '../../../domain/models/common/GenreModel.dart';
import '../../../domain/models/manga/MangaDetailsModel.dart';
import '../../../domain/models/myanimelist/AnimeMalModel.dart';
import '../../../ui/AssetsPath.dart';
import '../../../ui/Sizes.dart';
import '../../../ui/Strings.dart';
import '../../../ui/components/BackgroundImage.dart';
import '../../../ui/components/ImageFromAsset.dart';
import '../../../ui/components/LabelText.dart';
import '../../../ui/components/Loader.dart';
import '../../../ui/components/Paddings.dart';
import '../../../ui/components/RowTitleText.dart';
import '../../../ui/components/SpacerSized.dart';
import '../../../ui/components/StackTopContainer.dart';
import '../../../ui/components/ToolbarForApp.dart';
import '../../../utils/DateUtils.dart';
import '../../../utils/StringExtensions.dart';
import '../../ScreenEnums.dart';
import '../../items/AnimeCard.dart';
import '../../items/ContainerColor.dart';
import '../../items/DropdownMenuItem.dart';
import '../../items/ElementCard.dart';
import '../../items/GenreCard.dart';
import '../../items/Texts.dart';
import '../../navigation/NavigateByLinkType.dart';
import '../../navigation/NavigationFunctions.dart';
import '../../screens_bloc/mal/DetailsMalBloc.dart';
import '../ErrorScreen.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Календарь с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class DetailsMalContainer extends StatelessWidget {
  final DetailsScreenType screenType;
  final int? id;

  const DetailsMalContainer(
      {super.key, this.screenType = DetailsScreenType.anime, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsMalScreenBloc>(
      create: (context) => diProvider<DetailsMalScreenBloc>(),
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
    final DetailsMalScreenBloc detailsBloc = context.read<DetailsMalScreenBloc>();

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
  final DetailsMalScreenBloc detailsBloc;

  const _DetailsScreen(
      {super.key,
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
    final DetailsMalScreenBloc detailsBloc = widget.detailsBloc;

    return BlocBuilder<DetailsMalScreenBloc, DetailsMalScreenState>(
        builder: (context, state) {
          return Builder(builder: (context) {
            if (state is DetailsLoading) {
              return const LoaderWithBackButton();
            }

            if (state is AnimeDetailsLoaded) {
              return _AnimeDetailsInfo(
                state: state,
                animeDetails: state.animeDetails,
              );
            }

            if (state is DetailsError) {
              return ErrorScreen(
                mainCallback: () {
                  detailsBloc.add(
                      LoadDetails(screenType: widget.screenType, id: widget.id));
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
  final DetailsMalScreenState state;
  final AnimeMalModel animeDetails;

  const _AnimeDetailsInfo({
    super.key,
    required this.state,
    required this.animeDetails,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimeDetailsInfoState();
  }
}

class _AnimeDetailsInfoState extends State<_AnimeDetailsInfo> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuWidgets = [
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconWeb,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        text: webVersionTitle,
      )
    ];

    return BackgroundImage(
      imageUrl: widget.animeDetails.image?.large,
      mainWidget: StackTopContainer(
          topWidget: const ToolbarForApp(
            backBtnAlpha: Ints.oneHundredFifty,
          ),
          mainWidget: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              reverse: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DetailsHeader(animeDetails: widget.animeDetails),
                    const Divider(),
                    if (widget.animeDetails.synopsys != null)
                      _DetailsDescription(
                          description: widget.animeDetails.synopsys),
                    if (widget.animeDetails.backgroundInfo?.isNotEmpty == true)
                      _DetailsAdditionalDescription(
                          description: widget.animeDetails.backgroundInfo),
                    if (widget.animeDetails.pictures?.isNotEmpty == true)
                      _Screenshots(screenshots: widget.animeDetails.pictures),
                    if (widget.animeDetails.relatedAnime?.isNotEmpty == true)
                      _Related(relatedList: widget.animeDetails.relatedAnime),
                    if (widget.animeDetails.recommendations?.isNotEmpty == true)
                      _SimilarAnime(animeSimilar: widget.animeDetails.recommendations),
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
  final AnimeMalModel? animeDetails;
  final MangaDetailsModel? mangaDetails;

  const _DetailsHeader({super.key,
    this.animeDetails,
    this.mangaDetails
  });

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
                Expanded(
                    flex: 1,
                    child: _CenterImageScoreHeader(
                      imageUrl: animeDetails?.image?.large,
                      score: animeDetails?.score.toString()
                    )),
                Expanded(
                    flex: 1,
                    child: _RightStatusButtonsHeader(
                        animeDetails: animeDetails, mangaDetails: mangaDetails))
              ],
            ),
            MyTextBold(
              text: animeDetails != null
                  ? getEmptyIfBothNull(animeDetails?.title, animeDetails?.alternativeTitles?.en)
                  : getEmptyIfBothNull(mangaDetails?.nameRu, mangaDetails?.name),
              fontSize: TextSize.extraBig,
              maxLines: 5,
            ),
            MyTextOnBackground(
              text: animeDetails?.alternativeTitles?.ja ?? mangaDetails?.name,
              fontSize: TextSize.big,
              maxLines: 5,
            ),
            PaddingBySide(
                top: Doubles.seven,
                child: _GenresList(
                    genres: (animeDetails?.genres ?? mangaDetails?.genres) ?? []))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Левая часть верхней части экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class _LeftLabelAnimeTextHeader extends StatelessWidget {
  final AnimeMalModel animeDetails;

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
        if (animeDetails.episodeDuration.orZero() > 0)
          TextLabel(
              text: animeDetails.episodeDuration.orZero().toEpisodeTime(isMal: true),
              labelText: episodeTimeText),

        /// Возрастной рейтинг
        if (animeDetails.ageRating != null &&
            animeDetails.ageRating.toScreenString().isNotEmpty)
          TextLabel(
              text: animeDetails.ageRating.toScreenString(),
              labelText: ageText),

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
        ] else ...[
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
  final AnimeMalModel? animeDetails;
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
              onClick: () {
                navigateEpisodeScreen(
                    animeId: animeDetails?.id,
                    animeNameRu: animeDetails?.title,
                    animeNameEng: animeDetails?.title,
                    animeImageUrl: animeDetails?.image?.large,
                    context: context);
              },
              widgets: const [
                MyTextSemiBold(text: startWatchingText),
                PaddingBySide(
                    start: 7,
                    child: ImageFromAsset(
                      path: iconPlay,
                      size: 24,
                    )
                )
              ]
          )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Жанрамия, находится под Header
////////////////////////////////////////////////////////////////////////////////
class _GenresList extends StatelessWidget {
  final List<GenreModel> genres;

  const _GenresList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (var g in genres.orEmptyList()) GenreCard(text: g.name)
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
                primaryColor: Theme.of(context).colorScheme.onPrimary,
                annotationColor: Theme.of(context).colorScheme.secondary,
                navigateCallback: (linkType, link, name) {
                  navigateByLinkType(
                      linkType: linkType, link: link, context: context);
                }))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Описанием, находится под описанием
////////////////////////////////////////////////////////////////////////////////
class _DetailsAdditionalDescription extends StatelessWidget {
  final String? description;

  const _DetailsAdditionalDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleText(text: additionalDescriptionTitle),
        PaddingBySide(
            start: Doubles.fourteen,
            end: Doubles.fourteen,
            child: getAnnotationString(
                text: description,
                textSize: TextSize.big,
                primaryColor: Theme.of(context).colorScheme.onPrimary,
                annotationColor: Theme.of(context).colorScheme.secondary,
                navigateCallback: (linkType, link, name) {
                  navigateByLinkType(
                      linkType: linkType, link: link, context: context);
                }))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана со Скриншотами из Аниме
////////////////////////////////////////////////////////////////////////////////
class _Screenshots extends StatelessWidget {
  final List<MainPictureModel>? screenshots;

  const _Screenshots({super.key, required this.screenshots});

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
                  height: 500,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var s in screenshots ?? [])
                        ScreenshotVideoCard(
                          // width: 425,
                          // height: 600,
                          width: 325,
                          height: 500,
                          imageUrl: s.large,
                        )
                    ],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана со Связанным
////////////////////////////////////////////////////////////////////////////////
class _Related extends StatelessWidget {
  final List<RelatedAnimeModel>? relatedList;

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
                      for (var i in relatedList ?? []) ...{
                        _RelatedCard(related: i)
                      }
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
  final RelatedAnimeModel related;

  const _RelatedCard({super.key, required this.related});

  @override
  State<StatefulWidget> createState() {
    return _RelatedCardState();
  }
}

class _RelatedCardState extends State<_RelatedCard> {

  void navigate() {
    if (widget.related.anime != null) {
      navigateAnimeDetailsMalScreen(
          id: widget.related.anime?.id, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.related.anime?.image?.large,
      titleText: widget.related.anime?.title,
      secondTextOne: widget.related.anime?.type.toScreenString(),
      secondTextTwo: widget.related.relationTypeFormatted,
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.related.anime?.status,
        score: widget.related.anime?.score.toString(),
        episodes: widget.related.anime?.episodes,
        episodesAired: null,
        dateAired: widget.related.anime?.dateAired,
        dateReleased: widget.related.anime?.dateReleased,
        isMal: true
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Часть экрана с Похожим Аниме
////////////////////////////////////////////////////////////////////////////////
class _SimilarAnime extends StatelessWidget {
  final List<AnimeMalModel?>? animeSimilar;

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
                    children: [for (var i in animeSimilar ?? []) AnimeMalCard(anime: i)],
                  ),
                ))
          ],
        ));
  }
}