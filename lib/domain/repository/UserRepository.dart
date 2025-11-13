import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';
import 'package:shikidesk/domain/models/user/UserDetailsModel.dart';

import '../models/rates/RateModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения списка пользователей
////////////////////////////////////////////////////////////////////////////////
abstract class UserRepository {
  ///////////////////////////////////////////////////////////////////////////
  // USERS (Shikimori API v1)
  ///////////////////////////////////////////////////////////////////////////

  /// Получение списка пользователей
  ///
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] должно быть числом, 100 максимум (необязательно)
  Future<Either<Failure, List<UserBriefModel>>> getUsersList(
      int? page, int? limit);

  /// Найти пользователя по его id
  ///
  /// [id] пользователя
  /// [isNickName] ник пользователя, если нужно найти пользователя по нику (необязательно)
  Future<Either<Failure, UserDetailsModel>> getUserProfileById(
      {int? id, String? isNickName});

  /// Получить информацию о пользователе по его id
  ///
  /// [id] пользователя
  Future<Either<Failure, UserBriefModel>> getUserBriefInfoById(int? id);

  /// Получить информацию по своему профилю пользователя
  Future<Either<Failure, UserBriefModel>> getCurrentUserBriefInfo();

  /// Разлогинить пользователя
  Future<Either<Failure, bool>> signOutUser();

  /// Получение списка друзей
  ///
  /// [id] пользователя, по которому нужно получить список друзей
  Future<Either<Failure, List<UserBriefModel>>> getUserFriends(int? id);

  /// Получить список клубов пользователя
  ///
  /// [id] пользователя, по которому нужно получить список клубов
  // Future<List<ClubEntity>> getUserClubs(int? id);

  /// Получить пользовательский список с рейтингом аниме
  ///
  /// [id] пользователя, по которому нужно получить список с рейтингом аниме
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] должно быть числом, 5000 максимум (необязательно)
  /// [status] статус аниме (planned, watching, rewatching, completed, on_hold, dropped) (необязательно)
  /// [censored] включть цензуру, true убирает hentai (необязательно)
  Future<Either<Failure, List<RateModel>>> getUserAnimeRates(
      {int? id, int? page, int? limit, RateStatus? status, bool? censored});
}
