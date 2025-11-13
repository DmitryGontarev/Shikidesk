
import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/RolesEntityToDomain.dart';

import 'package:shikidesk/domain/models/common/Failure.dart';

import 'package:shikidesk/domain/models/roles/PersonDetailsModel.dart';

import 'package:shikidesk/domain/models/roles/PersonModel.dart';

import '../../../domain/repository/PeopleRepository.dart';
import '../api/PeopleApi.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [PeopleRepository]
/// [api] для получения данных о человеке из сети
////////////////////////////////////////////////////////////////////////////////
class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleApi api;

  PeopleRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, PersonDetailsModel>> getPersonDetails(int id) async {
    try {
      var response = await api.getPersonDetails(id);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<PersonModel>>> getPersonList(String? peopleName, String? role) async {
    try {
      var response = await api.getPersonList(peopleName, role);
      return Right(response.map((e) => e.toDomainModel()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}