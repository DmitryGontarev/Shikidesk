import 'package:dartz/dartz.dart';

import '../models/common/Failure.dart';
import '../models/roles/PersonDetailsModel.dart';
import '../models/roles/PersonModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения данных о человеке,
/// принимавшем участие в создании аниме/манги
////////////////////////////////////////////////////////////////////////////////
abstract class PeopleRepository {
  /// Получение информации о персонаже по его ID
  ///
  /// [id] идентификацонный номер персонажа
  Future<Either<Failure, PersonDetailsModel>> getPersonDetails(int id);

  /// Получение списка персонажей по имени
  ///
  /// [characterName] имя персонажа для поиска
  Future<Either<Failure, List<PersonModel>>> getPersonList(String? peopleName, String? role);
}