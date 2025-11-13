import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/BaseUrl.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';

import '../../../domain/models/common/Failure.dart';
import '../../entity/auth/TokenEntity.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для авторизации
////////////////////////////////////////////////////////////////////////////////
abstract class AuthApi {
  /// Метод для получения токена доступа и токена обновления
  ///
  /// [grantType] тип запроса - код авторизации или обновление токена доступа
  /// [clientId] идентификационный номер клиента
  /// [clientSecret] секретный ключ приложения
  /// [code] код
  /// [redirectUri] ссылка для перенаправления
  /// [refreshToken] токен для обновления токена доступа
  Future<TokenEntity> getAccessToken(
      {String? grantType,
      String clientId = BaseUrl.clientId,
      String clientSecret = BaseUrl.clientSecret,
      String? code,
      String? redirectUri = BaseUrl.redirectUri,
      String? refreshToken});
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация [AuthApi]
////////////////////////////////////////////////////////////////////////////////
class AuthApiImpl implements AuthApi {
  final Dio dio;

  const AuthApiImpl({required this.dio});

  @override
  Future<TokenEntity> getAccessToken(
      {String? grantType,
      String clientId = BaseUrl.clientId,
      String clientSecret = BaseUrl.clientSecret,
      String? code,
      String? redirectUri = BaseUrl.redirectUri,
      String? refreshToken}) async {

    final response = await dio.post("/oauth/token", queryParameters: {
      "grant_type": grantType,
      "client_id": clientId,
      "client_secret": clientSecret,
      "code": code,
      "redirect_uri": redirectUri,
      "refresh_token": refreshToken
    });

    if (response.statusCode == HttpCodes.http200) {
      final tokenJson = json.decode(json.encode(response.data));
      return TokenEntity.fromJson(tokenJson);
    } else {
      throw ServerException(
          code: response.statusCode, body: response.data.toString());
    }
  }
}
