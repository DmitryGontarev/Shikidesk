
import 'package:shikidesk/domain/repository/TokenLocalRepository.dart';

import '../models/auth/TokenModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс для интерактора сохранения или получения токена доступа
////////////////////////////////////////////////////////////////////////////////
abstract class TokenLocalInteractor {
  /// сохранить токен
  Future<bool> saveToken(TokenModel? token);

  /// получить токен
  Future<TokenModel?> getToken();

  /// удалить токен
  Future<bool> removeToken();

  /// проверить, сохранён ли токен в памяти приложения
  Future<bool> isTokenExists();
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [TokenLocalInteractor]
///
/// [repository] локальное хранилище токена
////////////////////////////////////////////////////////////////////////////////
class TokenLocalInteractorImpl implements TokenLocalInteractor {
  final TokenLocalRepository repository;

  const TokenLocalInteractorImpl({required this.repository});

  @override
  Future<bool> saveToken(TokenModel? token) async {
    return await repository.saveToken(token);
  }

  @override
  Future<TokenModel?> getToken() async {
    return await repository.getToken();
  }

  @override
  Future<bool> removeToken() async {
    return await repository.removeToken();
  }

  @override
  Future<bool> isTokenExists() async {
    return await repository.isTokenExists();
  }
}