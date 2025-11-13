
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/AuthRepository.dart';

import '../models/auth/TokenModel.dart';
import '../models/common/Failure.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора авторизаци
////////////////////////////////////////////////////////////////////////////////
abstract class AuthInteractor {

  /// Метод для получения токена доступа (Access Token)
  ///
  /// [authCode] код авторизации, полученный с сайта
  Future<Either<Failure, TokenModel>> signIn(String authCode);

  /// Метод для получения нового токена доступа и токена обновления
  ///
  /// [refreshToken] токен для обновления доступа
  Future<Either<Failure, TokenModel>> refreshToken(String refreshToken);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [AuthInteractor]
///
/// [repository] репозиторий авторизации
////////////////////////////////////////////////////////////////////////////////
class AuthInteractorImpl implements AuthInteractor {
  final AuthRepository repository;

  const AuthInteractorImpl({required this.repository});

  @override
  Future<Either<Failure, TokenModel>> signIn(String authCode) async {
    return await repository.signIn(authCode: authCode);
  }

  @override
  Future<Either<Failure, TokenModel>> refreshToken(String refreshToken) async {
    return await repository.refreshToken(refreshToken: refreshToken);
  }
}