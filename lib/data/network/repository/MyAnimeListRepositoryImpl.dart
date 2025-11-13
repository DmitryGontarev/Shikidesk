
import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/AnimeMalEntityToDomain.dart';
import 'package:shikidesk/data/converters/DomainMalEnumToStringRequest.dart';
import 'package:shikidesk/data/network/api/MyAnimeListApi.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';
import 'package:shikidesk/domain/repository/MyAnimeListRepository.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../../domain/models/common/Failure.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [MyAnimeListRepositoryImpl]
/// [api] для получения графика выхода эпизодов
////////////////////////////////////////////////////////////////////////////////
class MyAnimeListRepositoryImpl implements MyAnimeListRepository {
  final MyAnimeListApi api;

  MyAnimeListRepositoryImpl({required this.api});

  @override
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeListByParameters(
      {String? search, int? limit, int? offset, String? fields}) async {
    try {
      final response = await api.getAnimeListByParameters(
          search: search, limit: limit, offset: offset, fields: fields);

      List<AnimeMalModel> animes = [];

      for (var i in response) {
        animes.add(i.toDomainModel());
      }

      return Right(animes);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeRankingList(
      {RankingType? rankingType,
      int? limit,
      int? offset,
      String? fields}) async {
    try {
      final response = await api.getAnimeRankingList(
          rankingType: rankingType?.toStringRequest(),
          limit: limit,
          offset: offset,
          fields: fields);

      List<AnimeMalModel> animes = [];

      for (var i in response) {
        animes.add(i.toDomainModel());
      }

      return Right(animes);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<ServerFailure, AnimeMalModel>> getAnimeDetailsById(
      {int? id, String? fields}) async {
    try {
      final response = await api.getAnimeDetailsById(id: id, fields: fields);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
