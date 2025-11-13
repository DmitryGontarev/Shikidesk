
import 'package:shikidesk/data/entity/common/ImageEntity.dart';
import '../common/GenreEntity.dart';
import '../rates/UserRateEntity.dart';
import '../studio/StudioEntity.dart';
import '../user/StatisticEntity.dart';
import 'AnimeVideoEntity.dart';
import 'ScreenshotEntity.dart';

/// Сущность с детальной информацией по выбранному аниме
///
/// [id] id номер аниме
/// [name] название аниме
/// [nameRu] название аниме на русском
/// [image] ссылка на постер аниме
/// [url] ссылка на страницу сайта с аниме
/// [type] тип релиза аниме (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48)
/// [score] оценка аниме по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [episodes] общее количество эпизодов
/// [episodesAired] количество вышедших эпизодов
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
/// [ageRating] возрастной рейтинг
/// [namesEnglish] название на английском
/// [namesJapanese] название на японском
/// [synonyms] синонимы
/// [duration] длительность аниме
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
/// [updatedAt] дата обновления
/// [nextEpisodeDate] дата трансляции следующего эпизода
/// [genres] список жанров
/// [studios] список студий, работавших над аниме
/// [videos] список видео
/// [screenshots] список скриншотов из аниме
/// [userRate] пользовательский рейтинг аниме
class AnimeDetailsEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? type;
  final String? score;
  final String? status;
  final int? episodes;
  final int? episodesAired;
  final String? dateAired;
  final String? dateReleased;
  final String? ageRating;
  final List<String?>? namesEnglish;
  final List<String?>? namesJapanese;
  final List<String?>? synonyms;
  final int? duration;
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
  final String? updatedAt;
  final String? nextEpisodeDate;
  final List<GenreEntity>? genres;
  final List<StudioEntity>? studios;
  final List<AnimeVideoEntity>? videos;
  final List<ScreenshotEntity>? screenshots;
  final UserRateEntity? userRate;

  const AnimeDetailsEntity({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url,
    required this.type,
    required this.score,
    required this.status,
    required this.episodes,
    required this.episodesAired,
    required this.dateAired,
    required this.dateReleased,
    required this.ageRating,
    required this.namesEnglish,
    required this.namesJapanese,
    required this.synonyms,
    required this.duration,
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
    required this.updatedAt,
    required this.nextEpisodeDate,
    required this.genres,
    required this.studios,
    required this.videos,
    required this.screenshots,
    required this.userRate
  });

  factory AnimeDetailsEntity.fromJson(Map<String, dynamic> json) {
    return AnimeDetailsEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"],
        type: json["kind"],
        score: json["score"],
        status: json["status"],
        episodes: json["episodes"],
        episodesAired: json["episodes_aired"],
        dateAired: json["aired_on"],
        dateReleased: json["released_on"],
        ageRating: json["rating"],
        namesEnglish: json["english"] == null ? null : (json["english"] as List<dynamic>).map((e) => e as String?).toList(),
        namesJapanese: json["japanese"] == null ? null : (json["japanese"] as List<dynamic>).map((e) => e as String?).toList(),
        synonyms: json["synonyms"] == null ? null : (json["synonyms"] as List<dynamic>).map((e) => e as String?).toList(),
        duration: json["duration"],
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
        updatedAt: json["updated_at"],
        nextEpisodeDate: json["next_episode_at"],
        genres: json["genres"] == null ? null : (json["genres"] as List<dynamic>).map((e) => GenreEntity.fromJson(e)).toList(),
        studios: json["studios"] == null ? null : (json["studios"] as List<dynamic>).map((e) => StudioEntity.fromJson(e)).toList(),
        videos: json["videos"] == null ? null : (json["videos"] as List<dynamic>).map((e) => AnimeVideoEntity.fromJson(e)).toList(),
        screenshots: json["screenshots"] == null ? null : (json["screenshots"] as List<dynamic>).map((e) => ScreenshotEntity.fromJson(e)).toList(),
        userRate: json["user_rate"] == null ? null : UserRateEntity.fromJson(json["user_rate"])
    );
  }
}