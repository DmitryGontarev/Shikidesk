
import 'package:shikidesk/domain/models/auth/TokenModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения токена из локального хранилища
////////////////////////////////////////////////////////////////////////////////
abstract class TokenLocalRepository {

  /// сохранить токен
  Future<bool> saveToken(TokenModel? token);

  /// получить токен
  Future<TokenModel?> getToken();

  /// удалить токен
  Future<bool> removeToken();

  /// проверить, сохранён ли токен в памяти приложения
  Future<bool> isTokenExists();
}