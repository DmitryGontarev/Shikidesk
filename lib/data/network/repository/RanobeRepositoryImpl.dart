import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/MangaEntityToDomain.dart';

import '../../../domain/models/common/Failure.dart';
import '../../../domain/models/common/RelatedModel.dart';
import '../../../domain/models/common/RolesModel.dart';
import '../../../domain/models/manga/MangaDetailsModel.dart';
import '../../../domain/models/manga/MangaModel.dart';
import '../../../domain/repository/RanobeRepository.dart';
import '../api/RanobeApi.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [RanobeRepository]
///
/// [api] для получения данных о ранобэ из сети
////////////////////////////////////////////////////////////////////////////////
class RanobeRepositoryImpl implements RanobeRepository {
  final RanobeApi api;

  RanobeRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, List<MangaModel>>> getRanobeListByParameters() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MangaDetailsModel>> getRanobeDetailsById(
      int id) async {
    try {
      final response = await api.getRanobeDetailsById(id);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RolesModel>>> getRanobeRolesById(int id) async {
    try {
      final response = await api.getRanobeRolesById(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<MangaModel>>> getSimilarRanobe(int id) async {
    try {
      final response = await api.getSimilarRanobe(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RelatedModel>>> getRelatedRanobe(int id) async {
    try {
      final response = await api.getRelatedRanobe(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
