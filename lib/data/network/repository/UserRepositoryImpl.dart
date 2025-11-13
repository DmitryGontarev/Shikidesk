import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/DomainEnumToStringRequest.dart';
import 'package:shikidesk/data/converters/UserEntityToDomain.dart';
import 'package:shikidesk/data/entity/user/UserBriefEntity.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/rates/RateModel.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';
import 'package:shikidesk/domain/models/user/UserDetailsModel.dart';
import 'package:shikidesk/domain/repository/UserRepository.dart';

import '../api/UserApi.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [UserRepository]
///
/// [api] для получения данных пользователя из сети
////////////////////////////////////////////////////////////////////////////////
class UserRepositoryImpl implements UserRepository {
  final UserApi api;

  const UserRepositoryImpl({required this.api});

  ///////////////////////////////////////////////////////////////////////////
  // USERS (Shikimori API v1)
  ///////////////////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<UserBriefModel>>> getUsersList(
      int? page, int? limit) async {
    try {
      final response = await api.getUsersList(page, limit);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserDetailsModel>> getUserProfileById(
      {int? id, String? isNickName}) async {
    try {
      final response = await api.getUserProfileById(id: id, isNickName: isNickName);
      return Right(response.toDomainModel());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserBriefModel>> getUserBriefInfoById(int? id) async {
    try {
      final response = await api.getUserBriefInfoById(id);
      return Right(response.toDomainModel());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserBriefModel>> getCurrentUserBriefInfo() async {
    try {
      final response = await api.getCurrentUserBriefInfo();
      return Right(response.toDomainModel());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code, body: e.body));
    }
  }

  @override
  Future<Either<Failure, bool>> signOutUser() async {
    try {
      final response = await api.signOutUser();
      return Right(response);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<UserBriefModel>>> getUserFriends(int? id) async {
    try {
      final response = await api.getUserFriends(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RateModel>>> getUserAnimeRates(
      {int? id,
      int? page,
      int? limit,
      RateStatus? status,
      bool? censored}) async {
    try {
      final response = await api.getUserAnimeRates(
          id, page, limit, status?.toStringRequest(), censored);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerFailure catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
