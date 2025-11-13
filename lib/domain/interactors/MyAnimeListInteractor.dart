
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/domain/repository/MyAnimeListRepository.dart';

import '../models/common/Failure.dart';
import '../models/myanimelist/RankingType.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора MyAnimeList
////////////////////////////////////////////////////////////////////////////////
abstract class MyAnimeListInteractor {
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

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [MyAnimeListInteractor]
///
/// [repository] репозиторий для получения данных
////////////////////////////////////////////////////////////////////////////////
class MyAnimeListInteractorImpl implements MyAnimeListInteractor {
  final MyAnimeListRepository repository;

  MyAnimeListInteractorImpl({required this.repository});

  @override
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeListByParameters(
      {String? search, int? limit, int? offset, String? fields}) async {
    return await repository.getAnimeListByParameters(
        search: search, limit: limit, offset: offset, fields: fields);
  }

  @override
  Future<Either<ServerFailure, List<AnimeMalModel>>> getAnimeRankingList(
      {RankingType? rankingType, int? limit, int? offset, String? fields}) async {
    return await repository.getAnimeRankingList(
      rankingType: rankingType,
      limit: limit,
      offset: offset,
      fields: fields
    );
  }

  @override
  Future<Either<ServerFailure, AnimeMalModel>> getAnimeDetailsById({int? id, String? fields}) async {
    return await repository.getAnimeDetailsById(
      id: id,
      fields: fields
    );
  }
}
