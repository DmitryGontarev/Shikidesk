
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AgeRatingType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import '../common/GenreModel.dart';
import '../common/ImageModel.dart';
import '../studio/StudioModel.dart';
import '../user/StatisticModel.dart';
import '../user/UserRateModel.dart';
import 'AnimeVideoModel.dart';
import 'ScreenshotModel.dart';

/// Модель domain слоя с детальной информацие об аниме
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
/// [anons ]в статусе анонса (true or false)
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
class AnimeDetailsModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;
  final AnimeType? type;
  final String? score;
  final AiredStatus? status;
  final int? episodes;
  final int? episodesAired;
  final String? dateAired;
  final String? dateReleased;
  final AgeRatingType? ageRating;
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
  final List<RateScoresModel>? rateScoresStats;
  final List<RateStatusesModel>? rateStatusesStats;
  final String? updatedAt;
  final String? nextEpisodeDate;
  final List<GenreModel>? genres;
  final List<StudioModel>? studios;
  final List<AnimeVideoModel>? videos;
  final List<ScreenshotModel>? screenshots;
  final UserRateModel? userRate;

  const AnimeDetailsModel(
      {required this.id,
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
      required this.userRate});

  @override
  List<Object?> get props => [
        id,
        name,
        nameRu,
        image,
        url,
        type,
        score,
        status,
        episodes,
        episodesAired,
        dateAired,
        dateReleased,
        ageRating,
        namesEnglish,
        namesJapanese,
        synonyms,
        duration,
        description,
        descriptionHtml,
        descriptionSource,
        franchise,
        favoured,
        anons,
        ongoing,
        threadId,
        topicId,
        myAnimeListId,
        rateScoresStats,
        rateStatusesStats,
        updatedAt,
        nextEpisodeDate,
        genres,
        studios,
        videos,
        screenshots,
        userRate
      ];
}
