
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/data/entity/myanimelist/AnimeMalEntity.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../../appconstants/HttpStatusCode.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API MyAnimeList
////////////////////////////////////////////////////////////////////////////////
abstract class MyAnimeListApi {
  /// Получение списка аниме через Поиск
  ///
  /// [search] название аниме
  /// [limit] количество аниме для показа (максимум 100)
  Future<List<AnimeMalEntity>> getAnimeListByParameters(
      {String? search, int? limit, int? offset, String? fields});

  /// Получение списка аниме по параметру ранжирования
  ///
  /// [rankingType] тип ранжирования аниме
  /// [limit] количество аниме для показа (максимум 500)
  Future<List<AnimeMalEntity>> getAnimeRankingList(
      {String? rankingType, int? limit, int? offset, String? fields});

  /// Получить информацию об аниме по ID
  ///
  /// [id] id номер аниме
  Future<AnimeMalEntity> getAnimeDetailsById({int? id, String? fields});
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API MyAnimeList
////////////////////////////////////////////////////////////////////////////////
class MyAnimeListApiImpl extends MyAnimeListApi {
  final Dio dio;

  MyAnimeListApiImpl({required this.dio});

  @override
  Future<List<AnimeMalEntity>> getAnimeListByParameters(
      {String? search, int? limit, int? offset, String? fields}) async {
    final response = await dio.get("/anime", queryParameters: {
      "q": search,
      "limit": limit,
      "offset": offset,
      "fields": fields,
      "nsfw": false
    });
    if (response.statusCode == HttpCodes.http200) {
      List<AnimeMalEntity> animes = [];

      final animeSearchJson = json.decode(json.encode(response.data));
      var data = DataMalEntity.fromJson(animeSearchJson);

      data.data?.let((node) {
        for (var i in node) {
          if (i.animeMalEntity != null) {
            animes.add(i.animeMalEntity!);
          }
        }
      });

      return animes;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<AnimeMalEntity>> getAnimeRankingList(
      {String? rankingType, int? limit, int? offset, String? fields}) async {
    final response = await dio.get("/anime/ranking", queryParameters: {
      "ranking_type": rankingType,
      "limit": limit,
      "offset": offset,
      "fields": fields,
      "nsfw": false
    });

    if (response.statusCode == HttpCodes.http200) {
      List<AnimeMalEntity> animes = [];

      final animeSearchJson = json.decode(json.encode(response.data));
      var data = DataMalEntity.fromJson(animeSearchJson);

      data.data?.let((node) {
        for (var i in node) {
          if (i.animeMalEntity != null) {
            animes.add(i.animeMalEntity!);
          }
        }
      });

      return animes;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<AnimeMalEntity> getAnimeDetailsById(
      {int? id, String? fields}) async {
    final response = await dio.get("/anime/$id", queryParameters: {
      "fields": fields,
    });

    if (response.statusCode == HttpCodes.http200) {
      final detailsJson = json.decode(json.encode(response.data));
      return AnimeMalEntity.fromJson(detailsJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}
