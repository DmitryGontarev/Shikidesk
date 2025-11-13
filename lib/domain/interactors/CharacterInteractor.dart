
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/CharacterRepository.dart';

import '../models/common/Failure.dart';
import '../models/roles/CharacterDetailsModel.dart';
import '../models/roles/CharacterModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора получения данных о персонаже
////////////////////////////////////////////////////////////////////////////////
abstract class CharacterInteractor {
  /// Получение информации о персонаже по его ID
  ///
  /// [id] идентификацонный номер персонажа
  Future<Either<Failure, CharacterDetailsModel>> getCharacterDetails(int id);

  /// Получение списка персонажей по имени
  ///
  /// [characterName] имя персонажа для поиска
  Future<Either<Failure, List<CharacterModel>>> getCharacterList(String characterName);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [CharacterInteractor]
///
/// [repository] репозиторий для получения данных о персонаже
////////////////////////////////////////////////////////////////////////////////
class CharacterInteractorImpl implements CharacterInteractor {
  final CharacterRepository repository;
  
  CharacterInteractorImpl({required this.repository});

  @override
  Future<Either<Failure, CharacterDetailsModel>> getCharacterDetails(int id) async {
    return await repository.getCharacterDetails(id);
  }

  @override
  Future<Either<Failure, List<CharacterModel>>> getCharacterList(String characterName) async {
    return await repository.getCharacterList(characterName);
  }
}