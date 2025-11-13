
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для MyAnimeList
////////////////////////////////////////////////////////////////////////////////
abstract class MyAnimeListRepository {

  /// Получение списка аниме через Поиск
  ///
  /// [search] название аниме
  /// [limit] количество аниме для показа (максимум 100)
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeListByParameters(
      {String? search, int? limit, int? offset, String? fields});

  /// Получение списка аниме по параметру ранжирования
  ///
  /// [rankingType] тип ранжирования аниме
  /// [limit] количество аниме для показа (максимум 500)
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeRankingList(
      {RankingType? rankingType, int? limit, int? offset, String? fields});

  /// Получение списка аниме по параметру ранжирования
  ///
  /// [rankingType] тип ранжирования аниме
  /// [limit] количество аниме для показа (максимум 500)
  Future<Either<ServerFailure, AnimeMalModel>> getAnimeDetailsById(
      {int? id, String? fields});
}
