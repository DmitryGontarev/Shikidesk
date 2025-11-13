import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/anime/AnimeVideoEntity.dart';
import 'package:shikidesk/data/entity/anime/ScreenshotEntity.dart';
import 'package:shikidesk/data/entity/common/LinkEntity.dart';
import 'package:shikidesk/data/entity/common/RelatedEntity.dart';
import 'package:shikidesk/data/entity/common/RolesEntity.dart';

import '../../../domain/models/common/Failure.dart';
import '../../entity/anime/AnimeDetailsEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных об аниме
////////////////////////////////////////////////////////////////////////////////
abstract class AnimeApi {
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
  Future<List<AnimeEntity>> getAnimeListByParameters(
      int? page,
      int? limit,
      String? order,
      String? kind,
      String? status,
      String? season,
      double? score,
      String? duration,
      String? rating,
      String? genre,
      String? studio,
      List<String>? franchise,
      bool? censored,
      String? myList,
      List<String>? ids,
      List<String>? excludeIds,
      String? search
      );

  /// Получить информацию об аниме по ID
  ///
  /// [id] id номер аниме
  Future<AnimeDetailsEntity> getAnimeDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании аниме по id
  ///
  /// [id] id номер аниме
  Future<List<RolesEntity>> getAnimeRolesById(int id);

  /// Получить список похожих аниме по ID
  ///
  /// [id] id номер аниме
  Future<List<AnimeEntity>> getSimilarAnime(int id);

  /// Получить список аниме, связанных с текущим
  ///
  /// [id] id номер аниме
  Future<List<RelatedEntity>> getRelatedAnime(int id);

  /// Получить список похожих аниме по ID
  ///
  /// [id] id номер аниме
  Future<List<ScreenshotEntity>> getAnimeScreenshotsById(int id);

  /// Получить внешние ссылки на произведение
  ///
  /// [id] id аниме
  Future<List<LinkEntity>> getAnimeExternalLinksById(int id);

  //////////////////////////////////////////////////////////////////////////////
  // Videos API
  //////////////////////////////////////////////////////////////////////////////

  /// Получить список видео относящихся к аниме
  ///
  /// [id] id аниме
  Future<List<AnimeVideoEntity>> getAnimeVideos(int id);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API для получения данных об аниме
////////////////////////////////////////////////////////////////////////////////
class AnimeApiImpl implements AnimeApi {
  final Dio dio;

  AnimeApiImpl({required this.dio});

  @override
  Future<List<AnimeEntity>> getAnimeListByParameters(
      int? page,
      int? limit,
      String? order,
      String? kind,
      String? status,
      String? season,
      double? score,
      String? duration,
      String? rating,
      String? genre,
      String? studio,
      List<String>? franchise,
      bool? censored,
      String? myList,
      List<String>? ids,
      List<String>? excludeIds,
      String? search) async {
    final response =
        await dio.get("/api/animes", queryParameters: {
          "page": page,
          "limit": limit,
          "order": order,
          "kind": kind,
          "status": status,
          "season": season,
          "score": score,
          "duration": duration,
          "rating": rating,
          "genre": genre,
          "studio": studio,
          "franchise": franchise,
          "censored": censored,
          "mylist": myList,
          "ids": ids,
          "exclude_ids": excludeIds,
          "search": search
        });
    if (response.statusCode == HttpCodes.http200) {
      List<AnimeEntity> animes = [];
      final animeSearchJson = json.decode(json.encode(response.data));
      for (var i in animeSearchJson) {
        animes.add(AnimeEntity.fromJson(i));
      }
      return animes;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<AnimeDetailsEntity> getAnimeDetailsById(int id) async {
    final response = await dio.get("/api/animes/$id");
    if (response.statusCode == HttpCodes.http200) {
      final animeDetailsJson = json.decode(json.encode(response.data));
      return AnimeDetailsEntity.fromJson(animeDetailsJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RolesEntity>> getAnimeRolesById(int id) async {
    final response = await dio.get("/api/animes/$id/roles");
    if (response.statusCode == HttpCodes.http200) {
      List<RolesEntity> roles = [];
      final rolesJson = json.decode(json.encode(response.data));
      for (var i in rolesJson) {
        roles.add(RolesEntity.fromJson(i));
      }
      return roles;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<AnimeEntity>> getSimilarAnime(int id) async {
    final response = await dio.get("/api/animes/$id/similar");
    if (response.statusCode == HttpCodes.http200) {
      List<AnimeEntity> animes = [];
      final animesJson = json.decode(json.encode(response.data));
      for (var i in animesJson) {
        animes.add(AnimeEntity.fromJson(i));
      }
      return animes;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RelatedEntity>> getRelatedAnime(int id) async {
    final response = await dio.get("/api/animes/$id/related");
    if (response.statusCode == HttpCodes.http200) {
      List<RelatedEntity> related = [];
      final relatedJson = json.decode(json.encode(response.data));
      for (var i in relatedJson) {
        related.add(RelatedEntity.fromJson(i));
      }
      return related;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<ScreenshotEntity>> getAnimeScreenshotsById(int id) async {
    final response = await dio.get("/api/animes/$id/screenshots");
    if (response.statusCode == HttpCodes.http200) {
      List<ScreenshotEntity> screenshots = [];
      final screenshotsJson = json.decode(json.encode(response.data));
      for (var i in screenshotsJson) {
        screenshots.add(ScreenshotEntity.fromJson(i));
      }
      return screenshots;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<LinkEntity>> getAnimeExternalLinksById(int id) async {
    final response = await dio.get("/api/animes/$id/external_links");
    if (response.statusCode == HttpCodes.http200) {
      List<LinkEntity> externalLinks = [];
      final externalLinksJson = json.decode(json.encode(response.data));
      for (var i in externalLinksJson) {
        externalLinks.add(LinkEntity.fromJson(i));
      }
      return externalLinks;
    } else {
      throw throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<AnimeVideoEntity>> getAnimeVideos(int id) async {
    final response = await dio.get("/api/animes/$id/videos");
    if (response.statusCode == HttpCodes.http200) {
      List<AnimeVideoEntity> videos = [];
      final videosJson = json.decode(json.encode(response.data));
      for (var i in videosJson) {
        videos.add(AnimeVideoEntity.fromJson(i));
      }
      return videos;
    } else {
      throw throw ServerException(code: response.statusCode);
    }
  }
}
