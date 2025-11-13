
import 'package:shikidesk/domain/models/user/UserAuthStatus.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс для локального сохранения данных пользователя
////////////////////////////////////////////////////////////////////////////////
abstract class UserLocalRepository {

  /// Метод для сохранения id пользователя в хранилище
  /// [id] идентификационный номер пользователя
  Future<bool> setUserId({required int id});

  /// Метод для получения id пользователя из хранилища
  Future<int?> getUserId();

  /// Метод для установки статуса авторизации пользователя
  /// [userAuthStatus] статус авторизации пользователя
  Future<bool> setUserAuthStatus({required UserAuthStatus userAuthStatus});

  /// Метод для получения статуса авторизации пользователя
  Future<UserAuthStatus?> getUserAuthStatus();

  /// Метод для удаления данных пользователя из локального хранилища
  Future<bool> clearUser();
}