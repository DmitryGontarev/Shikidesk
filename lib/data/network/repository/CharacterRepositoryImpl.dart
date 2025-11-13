import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/RolesEntityToDomain.dart';
import 'package:shikidesk/data/network/api/CharacterApi.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/repository/CharacterRepository.dart';

import '../../../domain/models/roles/CharacterDetailsModel.dart';
import '../../../domain/models/roles/CharacterModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [CharacterRepository]
/// [api] для получения данных о персонаже из сети
////////////////////////////////////////////////////////////////////////////////
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApi api;

  CharacterRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, CharacterDetailsModel>> getCharacterDetails(int id) async {
    try {
      var response = await api.getCharacterDetails(id);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<CharacterModel>>> getCharacterList(String characterName) async {
    try {
      var response = await api.getCharacterList(characterName);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}
