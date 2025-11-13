
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../appconstants/HttpStatusCode.dart';
import '../../../domain/models/common/Failure.dart';
import '../../entity/common/RelatedEntity.dart';
import '../../entity/common/RolesEntity.dart';
import '../../entity/manga/MangaDetailsEntity.dart';
import '../../entity/manga/MangaEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных о ранобэ
////////////////////////////////////////////////////////////////////////////////
abstract class RanobeApi {
  /// Получение списка ранобэ по указанным параметрам
  ///
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] лимит списка, число максимум 50 (необязательно)
  /// [order] порядок сортировки (id, id_desc, ranked, kind, popularity, name, aired_on, volumes, chapters, status, random, created_at, created_at_desc) (необязательно)
  /// [kind] тип манги (manga, manhwa, manhua, light_novel, novel, one_shot, doujin) (необязательно)
  /// [status] тип релиза (anons, ongoing, released, paused, discontinued) (необязательно)
  /// [season] сезон выхода манги (summer_2017, spring_2016,fall_2016, 2016,!winter_2016, 2016, 2014_2016, 199x) (необязательно)
  /// [score] минимальная оценка манги (необязательно)
  /// [genre] список с id жанров аниме  (необязательно)
  /// [publisher] список и издателями манги
  /// [franchise] список с названиями франшиз манги (необязательно)
  /// [censored] включить цензуру (Set to false to allow hentai, yaoi and yuri) (необязательно)
  /// [myList] статус манги в списке пользователя (planned, watching, rewatching, completed, on_hold, dropped) (необязательно)
  /// [ids] список id номеров манги (необязательно)
  /// [excludeIds] список id номеров манги (необязательно)
  /// [search] поисковая фраза для фильтрации манги по имени (name) (необязательно)
  Future<MangaEntity> getRanobeListByParameters(int id);

  /// Получить информацию о ранобэ по ID
  ///
  /// [id] id номер ранобэ
  Future<MangaDetailsEntity> getRanobeDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании ранобэ по id
  ///
  /// [id] id номер ранобэ
  Future<List<RolesEntity>> getRanobeRolesById(int id);

  /// Получить список похожих ранобэ по ID
  ///
  /// [id] id номер ранобэ
  Future<List<MangaEntity>> getSimilarRanobe(int id);

  /// Получить список ранобэ, связанных с текущим
  ///
  /// [id] id номер ранобэ
  Future<List<RelatedEntity>> getRelatedRanobe(int id);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API для получения данных о ранобэ
////////////////////////////////////////////////////////////////////////////////
class RanobeApiImpl implements RanobeApi {
  final Dio dio;

  RanobeApiImpl({required this.dio});

  @override
  Future<MangaEntity> getRanobeListByParameters(int id) {
    // TODO: implement getRanobeListByParameters
    throw UnimplementedError();
  }

  @override
  Future<MangaDetailsEntity> getRanobeDetailsById(int id) async {
    final response = await dio.get("/api/ranobe/$id");
    if (response.statusCode == HttpCodes.http200) {
      final ranobeDetailsJson = json.decode(json.encode(response.data));
      return MangaDetailsEntity.fromJson(ranobeDetailsJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RolesEntity>> getRanobeRolesById(int id) async {
    final response = await dio.get("/api/ranobe/$id/roles");
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
  Future<List<MangaEntity>> getSimilarRanobe(int id) async {
    final response = await dio.get("/api/ranobe/$id/similar");
    if (response.statusCode == HttpCodes.http200) {
      List<MangaEntity> ranobes = [];
      final ranobeJson = json.decode(json.encode(response.data));
      for (var i in ranobeJson) {
        ranobes.add(MangaEntity.fromJson(i));
      }
      return ranobes;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RelatedEntity>> getRelatedRanobe(int id) async {
    final response = await dio.get("/api/ranobe/$id/related");
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
}