import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/data/entity/roles/PersonEntity.dart';

import '../../../appconstants/HttpStatusCode.dart';
import '../../../domain/models/common/Failure.dart';
import '../../entity/roles/PersonDetailsEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных о человеке,
/// принимавшем участие в создании аниме/манги
////////////////////////////////////////////////////////////////////////////////
abstract class PeopleApi {

  /// Получение информации о человеке по его ID
  ///
  /// [id] идентификацонный номер человека
  Future<PersonDetailsEntity> getPersonDetails(int id);

  /// Получение списка создателей
  ///
  /// [peopleName] имя создателя для поиска
  /// [role] роль человека (должно быть одно из 3-ёх: seyu, mangaka, producer)
  Future<List<PersonEntity>> getPersonList(String? peopleName, String? role);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерфейса [PeopleApi]
/// принимавшем участие в создании аниме/манги
////////////////////////////////////////////////////////////////////////////////
class PeopleApiImpl implements PeopleApi {
  final Dio dio;

  PeopleApiImpl({required this.dio});

  @override
  Future<PersonDetailsEntity> getPersonDetails(int id) async {
    final response = await dio.get("/api/people/$id");
    if (response.statusCode == HttpCodes.http200) {
      var personJson = json.decode(json.encode(response.data));
      return PersonDetailsEntity.fromJson(personJson);
    } else {
      throw ServerException(code: response.statusCode);
    }
  }

  @override
  Future<List<PersonEntity>> getPersonList(String? peopleName, String? role) async {
    final response = await dio.get("/api/people/search",
        queryParameters: {"search": peopleName, "kind" : role});
    if (response.statusCode == HttpCodes.http200) {
      List<PersonEntity> persons = [];
      var characterJson = json.decode(json.encode(response.data));
      for (var i in characterJson) {
        persons.add(PersonEntity.fromJson(i));
      }
      return persons;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}