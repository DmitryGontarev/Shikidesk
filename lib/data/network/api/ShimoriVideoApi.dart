import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';

import '../../entity/video/ShimoriEpisodeEntity.dart';
import '../../entity/video/ShimoriTranslationEntity.dart';
import '../../entity/video/VideoEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных видео
////////////////////////////////////////////////////////////////////////////////
abstract class ShimoriVideoApi {
  /// Получить количество вышедших эпизодов
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  Future<int> getEpisodes(
    int malId,
    String name,
  );

  /// Получить информацию по каждому эпизоду
  ///
  /// [malId ]идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  Future<List<ShimoriEpisodeEntity>> getSeries(
    int malId,
    String name,
  );

  /// Получить информацию по трансляции конкретноого эпизода
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  /// [episode] номер эпизода
  /// [hostingId] идентификационный номер хостинга
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  Future<List<ShimoriTranslationEntity>> getTranslations(
      int malId,
      String name,
      int episode,
      int hostingId,
      String? translationType
  );

  /// Получить информацию для потоковой загрузки эпизода
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [episode] номер эпизода
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  /// [author] автор загруженного эпизода
  /// [hosting] название хостинга
  /// [hostingId] идентификационный номер хостинга
  /// [videoId] идентификационный номер видео на хостинге
  /// [url] ссылка на видео
  /// [accessToken] токен для загрузки, если нужен
  Future<VideoEntity> getVideo(
      int malId,
      int episode,
      String? translationType,
      String? author,
      String hosting,
      int hostingId,
      int? videoId,
      String? url,
      String? accessToken
  );
}

class ShimoriVideoApiImpl implements ShimoriVideoApi {
  final Dio dio;

  ShimoriVideoApiImpl({required this.dio});

  @override
  Future<int> getEpisodes(int malId, String name) async {
    final response = await dio.get(
        "/api/anime/episodes",
      queryParameters: {
        "id": malId,
        "name": name
      }
    );
    if (response.statusCode == HttpCodes.http200) {
      final episodeJson = json.decode(json.encode(response.data));
      return episodeJson;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<ShimoriEpisodeEntity>> getSeries(int malId, String name) async {
    final response = await dio.get(
        "/api/anime/series",
        queryParameters: {
          "id": malId,
          "name": name
        }
    );
    if (response.statusCode == HttpCodes.http200) {
      List<ShimoriEpisodeEntity> series = [];
      final seriesJson = json.decode(json.encode(response.data));
      for (var i in seriesJson) {
        seriesJson.add(ShimoriEpisodeEntity.fromJson(i));
      }
      return series;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<ShimoriTranslationEntity>> getTranslations(
      int malId,
      String name,
      int episode,
      int hostingId,
      String? translationType
  ) async {
    final response = await dio.get(
        "/api/anime/query",
        queryParameters: {
          "id": malId,
          "name": name,
          "episode": episode,
          "hostingId": hostingId,
          "kind": translationType
        }
    );
    if (response.statusCode == HttpCodes.http200) {
      List<ShimoriTranslationEntity> translations = [];
      final translationJson = json.decode(json.encode(response.data));
      for (var i in translationJson) {
        translations.add(ShimoriTranslationEntity.fromJson(i));
      }
      return translations;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<VideoEntity> getVideo(
      int malId,
      int episode,
      String? translationType,
      String? author,
      String hosting,
      int hostingId,
      int? videoId,
      String? url,
      String? accessToken
  ) async {
    final response = await dio.get(
        "/api/anime/video",
        queryParameters: {
          "id": malId,
          "episode": episode,
          "kind": translationType,
          "author": author,
          "hosting": hosting,
          "hostingId": hostingId,
          "videoId": videoId,
          "url": url,
          // "accessToken": accessToken
        }
    );
    if (response.statusCode == HttpCodes.http200) {
      final videoJson = json.decode(json.encode(response.data));
      return VideoEntity.fromJson(videoJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}