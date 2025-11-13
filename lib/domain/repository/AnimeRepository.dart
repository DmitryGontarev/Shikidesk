import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/models/anime/AnimeSearchType.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/anime/ScreenshotModel.dart';
import 'package:shikidesk/domain/models/common/AgeRatingType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/common/LinkModel.dart';
import 'package:shikidesk/domain/models/common/RelatedModel.dart';

import '../models/anime/AnimeDetailsModel.dart';
import '../models/anime/AnimeModel.dart';
import '../models/anime/AnimeVideoModel.dart';
import '../models/common/RolesModel.dart';
import '../models/rates/RateStatus.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения данных об аниме
////////////////////////////////////////////////////////////////////////////////
abstract class AnimeRepository {
  /// Получение списка аниме по указанным параметрам
  ///
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] лимит списка, число максимум 50 (необязательно)
  /// [order] порядок сортировки (id, id_desc, ranked, kind, popularity, name, aired_on, episodes, status, random) (необязательно)
  /// [kind] тип аниме (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48) (необязательно)
  /// [status] тип релиза (anons, ongoing, released) (необязательно)
  /// [season] сезон выхода аниме (summer_2017, 2016, 2014_2016) (необязательно)
  /// [score] оценка аниме (необязательно)
  /// [duration] длительность аниме (S, D, F) (необязательно)
  /// [rating] возрастной рейтинг (none, g, pg, pg_13, r, r_plus, rx) (необязательно)
  /// [genre] список с id жанров аниме  (необязательно)
  /// [studio] список студий, работавших над аниме
  /// [franchise] список с названиями франшиз аниме (необязательно)
  /// [censored] включить цензуру (Set to false to allow hentai, yaoi and yuri) (необязательно)
  /// [myList] статус аниме в списке пользователя (planned, watching, rewatching, completed, on_hold, dropped) (необязательно)
  /// [ids] список id номеров аниме (необязательно)
  /// [excludeIds] список id номеров аниме (необязательно)
  /// [search] поисковая фраза для фильтрации аниме по имени (name) (необязательно)
  Future<Either<Failure, List<AnimeModel>>> getAnimeListByParameters(
      int? page,
      int? limit,
      AnimeSearchType? order,
      List<AnimeType>? kind,
      List<AiredStatus>? status,
      List<(String?, String?)>? season,
      double? score,
      List<AnimeDurationType>? duration,
      List<AgeRatingType>? rating,
      List<int>? genre,
      List<int>? studio,
      List<String>? franchise,
      bool? censored,
      List<RateStatus>? myList,
      List<String>? ids,
      List<String>? excludeIds,
      String? search);

  /// Получить информацию об аниме по ID
  ///
  /// [id] id номер аниме
  Future<Either<Failure, AnimeDetailsModel>> getAnimeDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании аниме по id
  ///
  /// [id] id номер аниме
  Future<Either<Failure, List<RolesModel>>> getAnimeRolesById(int id);

  /// Получить список похожих аниме по ID
  ///
  /// [id] id номер аниме
  Future<Either<Failure, List<AnimeModel>>> getSimilarAnime(int id);

  /// Получить список аниме, связанных с текущим
  ///
  /// [id] id номер аниме
  Future<Either<Failure, List<RelatedModel>>> getRelatedAnime(int id);

  /// Получить список похожих аниме по ID
  ///
  /// [id] id номер аниме
  Future<Either<Failure, List<ScreenshotModel>>> getAnimeScreenshotsById(
      int id);

  /// Получить внешние ссылки на произведение
  ///
  /// [id] id аниме
  Future<Either<Failure, List<LinkModel>>> getAnimeExternalLinksById(int id);

  /// Получить список видео относящихся к аниме
  ///
  /// [id] id аниме
  Future<Either<Failure, List<AnimeVideoModel>>> getAnimeVideos(int id);
}
