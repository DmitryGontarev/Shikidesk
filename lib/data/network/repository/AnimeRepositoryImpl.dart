import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/DomainEnumToStringRequest.dart';
import 'package:shikidesk/data/converters/SearchToStringRequest.dart';
import 'package:shikidesk/data/network/api/AnimeApi.dart';
import 'package:shikidesk/domain/models/anime/AnimeDetailsModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeVideoModel.dart';
import 'package:shikidesk/domain/models/anime/ScreenshotModel.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/common/LinkModel.dart';
import 'package:shikidesk/domain/models/common/RelatedModel.dart';
import 'package:shikidesk/domain/models/common/RolesModel.dart';
import 'package:shikidesk/domain/repository/AnimeRepository.dart';

import '../../../domain/models/anime/AnimeSearchType.dart';
import '../../../domain/models/anime/AnimeType.dart';
import '../../../domain/models/common/AgeRatingType.dart';
import '../../../domain/models/common/AiredStatus.dart';
import '../../../domain/models/rates/RateStatus.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [AnimeRepository]
/// [api] для получения данных об аниме из сети
////////////////////////////////////////////////////////////////////////////////
class AnimeRepositoryImpl implements AnimeRepository {
  final AnimeApi api;

  const AnimeRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, List<AnimeModel>>> getAnimeListByParameters(
      int? page,
      int? limit,
      AnimeSearchType? order,
      List<AnimeType>? kind,
      List<AiredStatus>? status,
      List<(String?, String?)>? season,
      double? score,
      List<AnimeDurationType>? duration,
      List<AgeRatingType>? rating,
      List<int>? genre,
      List<int>? studio,
      List<String>? franchise,
      bool? censored,
      List<RateStatus>? myList,
      List<String>? ids,
      List<String>? excludeIds,
      String? search) async {
    try {
      final response = await api.getAnimeListByParameters(
          page,
          limit,
          order?.toStringRequest(),
          kind?.toStringRequestAnimeType(),
          status?.toStringRequestAiredStatuses(),
          season?.toStringRequestSeason(),
          score,
          duration?.toStringRequestDuration(),
          rating?.toStringRequestAgeRatingType(),
          genre?.toStringOrNull(),
          studio?.toStringOrNull(),
          franchise?.toNullIfEmpty(),
          censored,
          myList?.toStringRequestRateStatus(),
          ids?.toNullIfEmpty(),
          excludeIds?.toNullIfEmpty(),
          search);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, AnimeDetailsModel>> getAnimeDetailsById(int id) async {
    try {
      final response = await api.getAnimeDetailsById(id);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RolesModel>>> getAnimeRolesById(int id) async {
    try {
      final response = await api.getAnimeRolesById(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<AnimeModel>>> getSimilarAnime(int id) async {
    try {
      final response = await api.getSimilarAnime(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<RelatedModel>>> getRelatedAnime(int id) async {
    try {
      final response = await api.getRelatedAnime(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<ScreenshotModel>>> getAnimeScreenshotsById(
      int id) async {
    try {
      final response = await api.getAnimeScreenshotsById(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<LinkModel>>> getAnimeExternalLinksById(
      int id) async {
    try {
      final response = await api.getAnimeExternalLinksById(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<AnimeVideoModel>>> getAnimeVideos(int id) async {
    try {
      final response = await api.getAnimeVideos(id);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
