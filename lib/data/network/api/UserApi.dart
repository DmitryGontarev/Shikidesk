
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/data/entity/club/ClubEntity.dart';
import 'package:shikidesk/data/entity/rates/RateEntity.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';

import '../../../utils/Extensions.dart';
import '../../entity/user/UserBriefEntity.dart';
import '../../entity/user/UserDetailsEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения списка пользователей
////////////////////////////////////////////////////////////////////////////////
abstract class UserApi {
  ///////////////////////////////////////////////////////////////////////////
  // USERS (Shikimori API v1)
  ///////////////////////////////////////////////////////////////////////////

  /// Получение списка пользователей
  ///
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] должно быть числом, 100 максимум (необязательно)
  Future<List<UserBriefEntity>> getUsersList(int? page, int? limit);

  /// Найти пользователя по его id
  ///
  /// [id] пользователя
  /// [isNickName] ник пользователя, если нужно найти пользователя по нику (необязательно)
  Future<UserDetailsEntity> getUserProfileById({int? id, String? isNickName});

  /// Получить информацию о пользователе по его id
  ///
  /// [id] пользователя
  Future<UserBriefEntity> getUserBriefInfoById(int? id);

  /// Получить информацию по своему профилю пользователя
  Future<UserBriefEntity> getCurrentUserBriefInfo();

  /// Разлогинить пользователя
  Future<bool> signOutUser();

  /// Получение списка друзей
  ///
  /// [id] пользователя, по которому нужно получить список друзей
  Future<List<UserBriefEntity>> getUserFriends(int? id);

  /// Получить список клубов пользователя
  ///
  /// [id] пользователя, по которому нужно получить список клубов
  Future<List<ClubEntity>> getUserClubs(int? id);

  /// Получить пользовательский список с рейтингом аниме
  ///
  /// [id] пользователя, по которому нужно получить список с рейтингом аниме
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] должно быть числом, 5000 максимум (необязательно)
  /// [status] статус аниме (planned, watching, rewatching, completed, on_hold, dropped) (необязательно)
  /// [censored] включть цензуру, true убирает hentai (необязательно)
  Future<List<RateEntity>> getUserAnimeRates(
      int? id, int? page, int? limit, String? status, bool? censored);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API для получения данных пользователя
////////////////////////////////////////////////////////////////////////////////
class UserApiImpl implements UserApi {
  final Dio dio;

  UserApiImpl({required this.dio});

  ///////////////////////////////////////////////////////////////////////////
  // USERS (Shikimori API v1)
  ///////////////////////////////////////////////////////////////////////////

  @override
  Future<List<UserBriefEntity>> getUsersList(int? page, int? limit) async {
    final response = await dio
        .get("/api/users", queryParameters: {"page": page, "limit": limit});

    if (response.statusCode == HttpCodes.http200) {
      List<UserBriefEntity> userBriefs = [];
      final userBriefsJson = json.decode(json.encode(response.data));
      for (var i in userBriefsJson) {
        userBriefs.add(UserBriefEntity.fromJson(i));
      }
      return userBriefs;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<UserDetailsEntity> getUserProfileById(
      {int? id, String? isNickName}) async {

    Map<String, dynamic> queries = {};

    isNickName?.let((it) {
      queries["is_nickname"] = isNickName;
    });

    final response = await dio
        .get("/api/users/$id", queryParameters: queries);

    if (response.statusCode == HttpCodes.http200) {
      final userDetailsJson = json.decode(json.encode(response.data));
      return UserDetailsEntity.fromJson(userDetailsJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<UserBriefEntity> getUserBriefInfoById(int? id) async {
    final response = await dio.get("/api/users/$id/info");

    if (response.statusCode == HttpCodes.http200) {
      final userBriefJson = json.decode(json.encode(response.data));
      return UserBriefEntity.fromJson(userBriefJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<UserBriefEntity> getCurrentUserBriefInfo() async {
    final response = await dio.get("/api/users/whoami");

    if (response.statusCode == HttpCodes.http200 && response.data != null) {
      final userBriefJson = json.decode(json.encode(response.data));
      return UserBriefEntity.fromJson(userBriefJson);
    } else {
      throw ServerException(code: response.statusCode, body: response.data);
    }
  }

  @override
  Future<bool> signOutUser() async {
    final response = await dio.get("/api/users/sign_out");

    if (response.statusCode == HttpCodes.http200) {
      return true;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<UserBriefEntity>> getUserFriends(int? id) async {
    final response = await dio.get("/api/users/$id/friends");

    if (response.statusCode == HttpCodes.http200) {
      List<UserBriefEntity> userBriefs = [];
      final userBriefsJson = json.decode(json.encode(response.data));
      for (var i in userBriefsJson) {
        userBriefs.add(UserBriefEntity.fromJson(i));
      }
      return userBriefs;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<ClubEntity>> getUserClubs(int? id) async {
    final response = await dio.get("/api/users/$id/clubs");

    if (response.statusCode == HttpCodes.http200) {
      List<ClubEntity> clubs = [];
      final clubsJson = json.decode(json.encode(response.data));
      for (var i in clubsJson) {
        clubs.add(ClubEntity.fromJson(i));
      }
      return clubs;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<RateEntity>> getUserAnimeRates(
      int? id, int? page, int? limit, String? status, bool? censored) async {

    Map<String, dynamic> queries = {};

    page?.let((it) {
      queries["page"] = page;
    });

    limit?.let((it) {
      queries["limit"] = limit;
    });

    status?.let((it) {
      queries["status"] = status;
    });

    censored?.let((it) {
      queries["censored"] = censored;
    });

    final response = await dio.get("/api/users/$id/anime_rates",
        queryParameters: queries);

    if (response.statusCode == HttpCodes.http200) {
      List<RateEntity> rates = [];
      final userBriefsJson = json.decode(json.encode(response.data));
      for (var i in userBriefsJson) {
        rates.add(RateEntity.fromJson(i));
      }
      return rates;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}
