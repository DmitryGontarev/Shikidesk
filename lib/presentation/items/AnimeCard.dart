
import 'package:flutter/cupertino.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/myanimelist/AnimeMalModel.dart';
import '../../utils/DateUtils.dart';
import '../../utils/StringExtensions.dart';
import '../navigation/NavigationFunctions.dart';
import 'ElementCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка Аниме
////////////////////////////////////////////////////////////////////////////////
class AnimeCard extends StatefulWidget {
  final AnimeModel anime;

  const AnimeCard({super.key, required this.anime});

  @override
  State<StatefulWidget> createState() {
    return _AnimeCardState();
  }
}

class _AnimeCardState extends State<AnimeCard> {

  void navigate() {
    navigateAnimeDetailsScreen(id: widget.anime.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.anime.image?.original,
      titleText: getEmptyIfBothNull(widget.anime.nameRu, widget.anime.name),
      secondTextOne: widget.anime.type.toScreenString(),
      secondTextTwo: getYearString(
          widget.anime.dateReleased ?? widget.anime.dateAired),
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.anime.status,
        score: widget.anime.score,
        episodes: widget.anime.episodes,
        episodesAired: widget.anime.episodesAired,
        dateAired: widget.anime.dateAired,
        dateReleased: widget.anime.dateReleased,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка Аниме MyAnimeList
////////////////////////////////////////////////////////////////////////////////
class AnimeMalCard extends StatefulWidget {
  final AnimeMalModel anime;

  const AnimeMalCard({super.key, required this.anime});

  @override
  State<StatefulWidget> createState() {
    return _AnimeMalCardState();
  }
}

class _AnimeMalCardState extends State<AnimeMalCard> {

  void navigate() {
    navigateAnimeDetailsMalScreen(id: widget.anime.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.anime.image?.large,
      titleText: getEmptyIfBothNull(widget.anime.title, widget.anime.alternativeTitles?.en),
      secondTextOne: widget.anime.type.toScreenString(),
      secondTextTwo: getYearString(
          widget.anime.dateReleased ?? widget.anime.dateAired),
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.anime.status,
        score: widget.anime.score.toString(),
        episodes: widget.anime.episodes,
        dateAired: widget.anime.dateAired,
        dateReleased: widget.anime.dateReleased,
      ),
    );
  }
}