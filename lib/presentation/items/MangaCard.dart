import 'package:flutter/cupertino.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';

import '../../domain/models/manga/MangaModel.dart';
import '../../domain/models/manga/MangaType.dart';
import '../../utils/DateUtils.dart';
import '../../utils/StringExtensions.dart';
import '../navigation/NavigationFunctions.dart';
import 'ElementCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Карточка Аниме экрана Детальной информации
////////////////////////////////////////////////////////////////////////////////
class MangaCard extends StatefulWidget {
  final MangaModel manga;

  const MangaCard({super.key, required this.manga});

  @override
  State<StatefulWidget> createState() {
    return _MangaCardState();
  }
}

class _MangaCardState extends State<MangaCard> {

  void navigate() {
    if (widget.manga.type != MangaType.novel &&
        widget.manga.type != MangaType.lightNovel) {
      navigateMangaDetailsScreen(id: widget.manga.id, context: context);
    } else {
      navigateRanobeDetailsScreen(
          id: widget.manga.id, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.manga.image?.original,
      titleText: getEmptyIfBothNull(widget.manga.nameRu, widget.manga.name),
      secondTextOne: widget.manga.type.toScreenString(),
      secondTextTwo: getYearString(
          widget.manga.dateReleased ?? widget.manga.dateAired),
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.manga.status,
        score: widget.manga.score,
        chapters: widget.manga.chapters,
        volumes: widget.manga.volumes,
        dateAired: widget.manga.dateAired,
        dateReleased: widget.manga.dateReleased,
      ),
    );
  }
}