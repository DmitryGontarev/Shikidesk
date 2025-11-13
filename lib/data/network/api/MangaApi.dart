import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/data/entity/common/RolesEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../entity/common/RelatedEntity.dart';
import '../../entity/manga/MangaDetailsEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных о манге
////////////////////////////////////////////////////////////////////////////////
abstract class MangaApi {
  /// Получение списка манги по указанным параметрам
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
  Future<List<MangaEntity>> getMangaListByParameters();

  /// Получить информацию о манге по ID
  ///
  /// [id] id номер манги
  Future<MangaDetailsEntity> getMangaDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании манги по id
  ///
  /// [id] id номер манги
  Future<List<RolesEntity>> getMangaRolesById(int id);

  /// Получить список похожих манги по ID
  ///
  /// [id] id номер манги
  Future<List<MangaEntity>> getSimilarManga(int id);

  /// Получить список аниме, связанных с текущим
  ///
  /// [id] id номер манги
  Future<List<RelatedEntity>> getRelatedManga(int id);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API для получения данных о манге
////////////////////////////////////////////////////////////////////////////////
class MangaApiImpl implements MangaApi {
  final Dio dio;

  MangaApiImpl({required this.dio});

  @override
  Future<List<MangaEntity>> getMangaListByParameters() {
    // TODO: implement getMangaListByParameters
    throw UnimplementedError();
  }

  @override
  Future<MangaDetailsEntity> getMangaDetailsById(int id) async {
    final response = await dio.get("/api/mangas/$id");
    if (response.statusCode == HttpCodes.http200) {
      final mangaDetailsJson = json.decode(json.encode(response.data));
      return MangaDetailsEntity.fromJson(mangaDetailsJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RolesEntity>> getMangaRolesById(int id) async {
    final response = await dio.get("/api/mangas/$id/roles");
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
  Future<List<MangaEntity>> getSimilarManga(int id) async {
    final response = await dio.get("/api/mangas/$id/similar");
    if (response.statusCode == HttpCodes.http200) {
      List<MangaEntity> mangas = [];
      final mangasJson = json.decode(json.encode(response.data));
      for (var i in mangasJson) {
        mangas.add(MangaEntity.fromJson(i));
      }
      return mangas;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RelatedEntity>> getRelatedManga(int id) async {
    final response = await dio.get("/api/mangas/$id/related");
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