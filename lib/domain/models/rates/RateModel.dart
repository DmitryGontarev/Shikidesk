
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/domain/models/manga/MangaModel.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';

import 'RateStatus.dart';

/// Модель элемента пользовательского списка рейтинга аниме
///
/// [id] id элемента списка
/// [score] оценка пользователя
/// [status] статус чтения или просмотра
/// [text] комментарий
/// [episodes] количество просмотренных эпизодов аниме
/// [chapters] количество прочитанных глав манги
/// [volumes] количество прочитанных томов
/// [textHtml]
/// [rewatches] количество повторных просмотров
/// [createdDateTime] дата добавления в пользовательский список
/// [updatedDateTime] дата обновления в пользовательском списке
/// [user] информация о пользователе
/// [anime] информация о аниме
/// [manga] информация о манге
class RateModel extends Equatable {
  final int? id;
  final int? score;
  final RateStatus? status;
  final String? text;
  final int? episodes;
  final int? chapters;
  final int? volumes;
  final String? textHtml;
  final int? rewatches;
  final String? createdDateTime;
  final String? updatedDateTime;
  final UserBriefModel? user;
  final AnimeModel? anime;
  final MangaModel? manga;

  const RateModel(
      {required this.id,
      required this.score,
      required this.status,
      required this.text,
      required this.episodes,
      required this.chapters,
      required this.volumes,
      required this.textHtml,
      required this.rewatches,
      required this.createdDateTime,
      required this.updatedDateTime,
      required this.user,
      required this.anime,
      required this.manga});

  @override
  List<Object?> get props => [
        id,
        score,
        status,
        text,
        episodes,
        chapters,
        volumes,
        textHtml,
        rewatches,
        createdDateTime,
        updatedDateTime,
        user,
        anime,
        manga
      ];
}
