
import 'package:dartz/dartz.dart';

import '../models/common/Failure.dart';
import '../models/roles/PersonDetailsModel.dart';
import '../models/roles/PersonModel.dart';
import '../repository/PeopleRepository.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора для получения данных о человеке,
/// принимавшем участие в создании аниме/манги
////////////////////////////////////////////////////////////////////////////////
abstract class PeopleInteractor {

  /// Получение информации о персонаже по его ID
  ///
  /// [id] идентификацонный номер персонажа
  Future<Either<Failure, PersonDetailsModel>> getPersonDetails(int id);

  /// Получение списка персонажей по имени
  ///
  /// [characterName] имя персонажа для поиска
  Future<Either<Failure, List<PersonModel>>> getPersonList(String? peopleName, String? role);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [PeopleInteractor]
///
/// [repository] репозиторий для получения данных о человеке
////////////////////////////////////////////////////////////////////////////////
class PeopleInteractorImpl implements PeopleInteractor {
  final PeopleRepository repository;

  PeopleInteractorImpl({required this.repository});

  @override
  Future<Either<Failure, PersonDetailsModel>> getPersonDetails(int id) async {
    return await repository.getPersonDetails(id);
  }

  @override
  Future<Either<Failure, List<PersonModel>>> getPersonList(String? peopleName, String? role) async {
    return await repository.getPersonList(peopleName, role);
  }
}