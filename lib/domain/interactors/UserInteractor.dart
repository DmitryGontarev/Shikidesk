import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/UserRepository.dart';

import '../models/common/Failure.dart';
import '../models/rates/RateModel.dart';
import '../models/rates/RateStatus.dart';
import '../models/user/UserBriefModel.dart';
import '../models/user/UserDetailsModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора для получения/обновления данных пользовательского профиля в сети
////////////////////////////////////////////////////////////////////////////////
abstract class UserInteractor {
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

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [UserInteractor]
///
/// [repository] репозиторий для получения данных пользователя
////////////////////////////////////////////////////////////////////////////////
class UserInteractorImpl implements UserInteractor {
  final UserRepository repository;

  const UserInteractorImpl({required this.repository});

  ///////////////////////////////////////////////////////////////////////////
  // USERS (Shikimori API v1)
  ///////////////////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<UserBriefModel>>> getUsersList(
      int? page, int? limit) async {
    return await repository.getUsersList(page, limit);
  }

  @override
  Future<Either<Failure, UserDetailsModel>> getUserProfileById(
      {int? id, String? isNickName}) async {
    return await repository.getUserProfileById(id: id, isNickName: isNickName);
  }

  @override
  Future<Either<Failure, UserBriefModel>> getUserBriefInfoById(int? id) async {
    return await repository.getUserBriefInfoById(id);
  }

  @override
  Future<Either<Failure, UserBriefModel>> getCurrentUserBriefInfo() async {
    return await repository.getCurrentUserBriefInfo();
  }

  @override
  Future<Either<Failure, bool>> signOutUser() async {
    return await repository.signOutUser();
  }

  @override
  Future<Either<Failure, List<UserBriefModel>>> getUserFriends(int? id) async {
    return await repository.getUserFriends(id);
  }

  @override
  Future<Either<Failure, List<RateModel>>> getUserAnimeRates(
      {int? id,
      int? page,
      int? limit,
      RateStatus? status,
      bool? censored}) async {
    return await repository.getUserAnimeRates(
        id: id, page: page, limit: limit, status: status, censored: censored);
  }
}
