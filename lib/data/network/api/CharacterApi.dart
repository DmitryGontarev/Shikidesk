import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';

import '../../entity/roles/CharacterDetailsEntity.dart';
import '../../entity/roles/CharacterEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных данных о персонаже
////////////////////////////////////////////////////////////////////////////////
abstract class CharacterApi {
  /// Получение информации о персонаже по его ID
  ///
  /// [id] идентификацонный номер персонажа
  Future<CharacterDetailsEntity> getCharacterDetails(int id);

  /// Получение списка персонажей по имени
  ///
  /// [characterName] имя персонажа для поиска
  Future<List<CharacterEntity>> getCharacterList(String characterName);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерфейса для получения данных о персонаже
////////////////////////////////////////////////////////////////////////////////
class CharacterApiImpl implements CharacterApi {
  final Dio dio;

  CharacterApiImpl({required this.dio});

  @override
  Future<CharacterDetailsEntity> getCharacterDetails(int id) async {
    final response = await dio.get("/api/characters/$id");
    if (response.statusCode == HttpCodes.http200) {
      var characterJson = json.decode(json.encode(response.data));
      return CharacterDetailsEntity.fromJson(characterJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<CharacterEntity>> getCharacterList(String characterName) async {
    final response = await dio.get("/api/characters/search",
        queryParameters: {"search": characterName});
    if (response.statusCode == HttpCodes.http200) {
      List<CharacterEntity> characters = [];
      var characterJson = json.decode(json.encode(response.data));
      for (var i in characterJson) {
        characters.add(CharacterEntity.fromJson(i));
      }
      return characters;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}
