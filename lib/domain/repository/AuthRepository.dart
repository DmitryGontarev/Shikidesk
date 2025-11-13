
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';

import '../models/auth/TokenModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория авторизации
////////////////////////////////////////////////////////////////////////////////
abstract class AuthRepository {

  /// Метод для получения токена доступа (Access Token)
  ///
  /// [authCode] код авторизации, полученный с сайта
  Future<Either<Failure, TokenModel>> signIn({required String authCode});

  /// Метод для получения нового токена доступа и токена обновления
  ///
  /// [refreshToken] токен для обновления доступа
  Future<Either<Failure, TokenModel>> refreshToken({required String refreshToken});
}