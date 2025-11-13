
import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';
import 'package:shikidesk/data/entity/user/UserBriefEntity.dart';

/// Сущность элемента пользовательского списка рейтинга аниме
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
class RateEntity {
  final int? id;
  final int? score;
  final String? status;
  final String? text;
  final int? episodes;
  final int? chapters;
  final int? volumes;
  final String? textHtml;
  final int? rewatches;
  final String? createdDateTime;
  final String? updatedDateTime;
  final UserBriefEntity? user;
  final AnimeEntity? anime;
  final MangaEntity? manga;

  const RateEntity({
    this.id,
    this.score,
    this.status,
    this.text,
    this.episodes,
    this.chapters,
    this.volumes,
    this.textHtml,
    this.rewatches,
    this.createdDateTime,
    this.updatedDateTime,
    this.user,
    this.anime,
    this.manga
  });

  factory RateEntity.fromJson(Map<String, dynamic> json) {
    return RateEntity(
      id: json["id"],
      score: json["score"],
      status: json["status"],
      text: json["text"],
      episodes: json["episodes"],
      chapters: json["chapters"],
      volumes: json["volumes"],
      textHtml: json["text_html"],
      rewatches: json["rewatches"],
      createdDateTime: json["created_at"],
      updatedDateTime: json["updated_at"],
      user: json["user"] == null ? null : UserBriefEntity.fromJson(json["user"]),
      anime: json["anime"] == null ? null : AnimeEntity.fromJson(json["anime"]),
      manga: json["manga"] == null ? null : MangaEntity.fromJson(json["manga"])
    );
  }
}