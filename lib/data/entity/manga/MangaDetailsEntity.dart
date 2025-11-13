
import 'package:shikidesk/data/entity/common/ImageEntity.dart';
import '../common/GenreEntity.dart';
import '../rates/UserRateEntity.dart';
import '../user/StatisticEntity.dart';

/// Сущность с детальной информацией по выбранной манге
///
/// [id] id номер манги
/// [name] название манги
/// [nameRu] название манги на русском
/// [image] ссылка на постер аниме
/// [url] ссылка на страницу сайта с аниме
/// [type] тип релиза манги (manga, manhwa, manhua, light_novel, novel, one_shot, doujin)
/// [score] оценка аниме по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [volumes] количество томов
/// [chapters] количество глав
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
/// [namesEnglish] название на английском
/// [namesJapanese] название на японском
/// [synonyms] синонимы
/// [description] описание
/// [descriptionHtml] описание в HTML
/// [descriptionSource] название источника описания
/// [franchise] название франшизы
/// [favoured] в избранном (true or false)
/// [anons] в статусе анонса (true or false)
/// [ongoing] в статусе онгоинга (true or false)
/// [threadId] номер треда
/// [topicId] номер топика
/// [myAnimeListId] номер в списке пользователя, если есть
/// [rateScoresStats] статистика по оценкам
/// [rateStatusesStats] статистика по статусам
/// [genres] список жанров
/// [userRate] пользовательский рейтинг аниме
class MangaDetailsEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? type;
  final String? score;
  final String? status;
  final int? volumes;
  final int? chapters;
  final String? dateAired;
  final String? dateReleased;
  final List<String?>? namesEnglish;
  final List<String?>? namesJapanese;
  final List<String?>? synonyms;
  final String? description;
  final String? descriptionHtml;
  final String? descriptionSource;
  final String? franchise;
  final bool? favoured;
  final bool? anons;
  final bool? ongoing;
  final int? threadId;
  final int? topicId;
  final int? myAnimeListId;
  final List<RateScoresEntity>? rateScoresStats;
  final List<RateStatusesEntity>? rateStatusesStats;
  final List<GenreEntity>? genres;
  final UserRateEntity? userRate;

  const MangaDetailsEntity({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url,
    required this.type,
    required this.score,
    required this.status,
    required this.volumes,
    required this.chapters,
    required this.dateAired,
    required this.dateReleased,
    required this.namesEnglish,
    required this.namesJapanese,
    required this.synonyms,
    required this.description,
    required this.descriptionHtml,
    required this.descriptionSource,
    required this.franchise,
    required this.favoured,
    required this.anons,
    required this.ongoing,
    required this.threadId,
    required this.topicId,
    required this.myAnimeListId,
    required this.rateScoresStats,
    required this.rateStatusesStats,
    required this.genres,
    required this.userRate
  });

  factory MangaDetailsEntity.fromJson(Map<String, dynamic> json) {
    return MangaDetailsEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"],
        type: json["kind"],
        score: json["score"],
        status: json["status"],
        volumes: json["volumes"],
        chapters: json["chapters"],
        dateAired: json["aired_on"],
        dateReleased: json["released_on"],
        namesEnglish: json["english"] == null ? null : (json["english"] as List<dynamic>).map((e) => e as String?).toList(),
        namesJapanese: json["japanese"] == null ? null : (json["japanese"] as List<dynamic>).map((e) => e as String?).toList(),
        synonyms: json["synonyms"] == null ? null : (json["synonyms"] as List<dynamic>).map((e) => e as String?).toList(),
        description: json["description"],
        descriptionHtml: json["description_html"],
        descriptionSource: json["description_source"],
        franchise: json["franchise"],
        favoured: json["favoured"],
        anons: json["anons"],
        ongoing: json["ongoing"],
        threadId: json["thread_id"],
        topicId: json["topic_id"],
        myAnimeListId: json["myanimelist_id"],
        rateScoresStats: json["rates_scores_stats"] == null ? null : (json["rates_scores_stats"] as List<dynamic>).map((e) => RateScoresEntity.fromJson(e)).toList(),
        rateStatusesStats: json["rates_statuses_stats"] == null ? null : (json["rates_statuses_stats"] as List<dynamic>).map((e) => RateStatusesEntity.fromJson(e)).toList(),
        genres: json["genres"] == null ? null : (json["genres"] as List<dynamic>).map((e) => GenreEntity.fromJson(e)).toList(),
        userRate: json["user_rate"] == null ? null : UserRateEntity.fromJson(json["user_rate"])
    );
  }
}