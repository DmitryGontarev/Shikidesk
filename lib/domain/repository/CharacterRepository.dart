
import 'package:dartz/dartz.dart';

import '../models/common/Failure.dart';
import '../models/roles/CharacterDetailsModel.dart';
import '../models/roles/CharacterModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения данных о персонаже
////////////////////////////////////////////////////////////////////////////////
abstract class CharacterRepository {
  /// Получение информации о персонаже по его ID
  ///
  /// [id] идентификацонный номер персонажа
  Future<Either<Failure, CharacterDetailsModel>> getCharacterDetails(int id);

  /// Получение списка персонажей по имени
  ///
  /// [characterName] имя персонажа для поиска
  Future<Either<Failure, List<CharacterModel>>> getCharacterList(String characterName);
}