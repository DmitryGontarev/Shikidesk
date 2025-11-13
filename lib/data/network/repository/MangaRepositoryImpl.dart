
import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/MangaEntityToDomain.dart';
import 'package:shikidesk/data/network/api/MangaApi.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/common/RelatedModel.dart';
import 'package:shikidesk/domain/models/common/RolesModel.dart';
import 'package:shikidesk/domain/models/manga/MangaDetailsModel.dart';
import 'package:shikidesk/domain/models/manga/MangaModel.dart';
import 'package:shikidesk/domain/repository/MangaRepository.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [MangaRepository]
/// [api] для получения данных о манге из сети
////////////////////////////////////////////////////////////////////////////////
class MangaRepositoryImpl implements MangaRepository {
  final MangaApi api;

  MangaRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, List<MangaModel>>> getMangaListByParameters() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MangaDetailsModel>> getMangaDetailsById(int id) async {
    try {
      final response = await api.getMangaDetailsById(id);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RolesModel>>> getMangaRolesById(int id) async {
    try {
      final response = await api.getMangaRolesById(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<MangaModel>>> getSimilarManga(int id) async {
    try {
      final response = await api.getSimilarManga(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RelatedModel>>> getRelatedManga(int id) async {
    try {
      final response = await api.getRelatedManga(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}