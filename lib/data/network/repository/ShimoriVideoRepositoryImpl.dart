import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/DomainEnumToStringRequest.dart';
import 'package:shikidesk/data/converters/ShimodriVideoEntityToDomain.dart';
import 'package:shikidesk/data/network/api/ShimoriVideoApi.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/video/ShimoriEpisodeModel.dart';
import 'package:shikidesk/domain/models/video/ShimoriTranslationModel.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';
import 'package:shikidesk/domain/models/video/VideoModel.dart';
import 'package:shikidesk/domain/repository/ShimoriVideoRepository.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [ShimoriVideoRepository]
///
/// [api] для получения данных видое из сети
////////////////////////////////////////////////////////////////////////////////
class ShimoriVideoRepositoryImpl implements ShimoriVideoRepository {
  final ShimoriVideoApi api;

  const ShimoriVideoRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, int>> getEpisodes(int malId, String name) async {
    try {
      final response = await api.getEpisodes(malId, name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<ShimoriEpisodeModel>>> getSeries(
      int malId, String name) async {
    try {
      final response = await api.getSeries(malId, name);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<ShimoriTranslationModel>>> getTranslations(
      int malId,
      String name,
      int episode,
      int hostingId,
      TranslationType? translationType) async {
    try {
      final response = await api.getTranslations(
          malId,
          name,
          episode,
          hostingId,
          translationType?.toStringRequest()
      );
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, VideoModel>> getVideo(
      int malId,
      int episode,
      TranslationType? translationType,
      String? author,
      String hosting,
      int hostingId,
      int? videoId,
      String? url,
      String? accessToken) async {
    try {
      final response = await api.getVideo(
          malId,
          episode,
          translationType?.toStringRequest(),
          author,
          hosting,
          hostingId,
          videoId,
          url,
          accessToken);
      return Right(response.toDomianModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
