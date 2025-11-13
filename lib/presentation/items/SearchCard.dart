
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/myanimelist/AnimeMalModel.dart';
import '../../ui/Sizes.dart';
import '../navigation/NavigationFunctions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка экрана поиска
////////////////////////////////////////////////////////////////////////////////
class SearchCard extends StatefulWidget {
  final bool isShowInfo;
  final Widget info;
  final String? imageUrl;
  final double imageHeight;
  final double imageWidth;
  final Widget? overPicture;
  final Function()? onCLick;

  const SearchCard(
      {super.key,
        this.isShowInfo = false,
        required this.info,
        this.imageUrl,
        this.imageHeight = ImageSizes.detailsCoverHeight,
        this.imageWidth = ImageSizes.detailsCoverWidth,
        this.overPicture,
        this.onCLick});

  @override
  State<StatefulWidget> createState() {
    return _SearchCardState();
  }
}

class _SearchCardState extends State<SearchCard> {

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
        child: SizedBox(
          height: ImageSizes.horizontalCardHeight,
          width: widget.imageWidth,
          child: Column(
            children: [
              Flexible(
                  child: InkWell(
                    onTap: widget.onCLick,
                    borderRadius: Borders.seven,
                    child: PaddingAll(
                        child: ImageCardWithInfo(
                            isShowInfo: widget.isShowInfo,
                            info: widget.info,
                            imageUrl: widget.imageUrl,
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                            overPicture: widget.overPicture)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка экрана поиска
////////////////////////////////////////////////////////////////////////////////
class SearchAnimeCard extends StatefulWidget {
  final AnimeModel anime;

  const SearchAnimeCard({super.key, required this.anime});

  @override
  State<StatefulWidget> createState() {
    return _SearchAnimeCard();
  }
}

class _SearchAnimeCard extends State<SearchAnimeCard> {
  var isExpanded = false;

  void navigate() {
    navigateAnimeDetailsScreen(id: widget.anime.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SearchCard(
      isShowInfo: isExpanded,
      info: InfoColumn(
        status: widget.anime.status,
        score: widget.anime.score,
        episodes: widget.anime.episodes,
        episodesAired: widget.anime.episodesAired,
        dateAired: widget.anime.dateAired,
        dateReleased: widget.anime.dateReleased,
      ),
      imageUrl: widget.anime.image?.original,
      overPicture: OverPictureTwo(
        leftTopText: widget.anime.type.toScreenString(),
        text: getEmptyIfBothNull(widget.anime.nameRu, widget.anime.name),
        onTitleClick: () {
          navigate();
        },
        onTitleFocus: (focus) {
          setState(() {
            isExpanded = focus;
          });
        },
      ),
      onCLick: () {
        navigate();
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка экрана поиска для MyAnimeList
////////////////////////////////////////////////////////////////////////////////
class SearchAnimeMalCard extends StatefulWidget {
  final AnimeMalModel anime;

  const SearchAnimeMalCard({super.key, required this.anime});

  @override
  State<StatefulWidget> createState() {
    return _SearchAnimeMalCard();
  }
}

class _SearchAnimeMalCard extends State<SearchAnimeMalCard> {
  var isExpanded = false;

  void navigate() {
    navigateAnimeDetailsMalScreen(id: widget.anime.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SearchCard(
      isShowInfo: isExpanded,
      info: InfoColumn(
        status: widget.anime.status,
        score: widget.anime.score.toString(),
        episodes: widget.anime.episodes,
        episodesAired: null,
        dateAired: widget.anime.dateAired,
        dateReleased: widget.anime.dateReleased,
        isMal: true,
      ),
      imageUrl: widget.anime.image?.large,
      overPicture: OverPictureTwo(
        leftTopText: widget.anime.type.toScreenString(),
        text: widget.anime.title,
        onTitleClick: () {
          navigate();
        },
        onTitleFocus: (focus) {
          setState(() {
            isExpanded = focus;
          });
        },
      ),
      onCLick: () {
        navigate();
      },
    );
  }
}