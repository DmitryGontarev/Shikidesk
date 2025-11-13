
import 'package:shikidesk/domain/repository/UserLocalRepository.dart';

import '../models/user/UserAuthStatus.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора для локального сохранения данных пользователя
////////////////////////////////////////////////////////////////////////////////
abstract class UserLocalInteractor {

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

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [UserLocalInteractor]
/// [prefs] локальное хранилище данных пользователя
////////////////////////////////////////////////////////////////////////////////
class UserLocalInteractorImpl implements UserLocalInteractor {

  final UserLocalRepository repository;

  const UserLocalInteractorImpl({required this.repository});

  @override
  Future<bool> setUserId({required int id}) async {
    return await repository.setUserId(id: id);
  }

  @override
  Future<int?> getUserId() async {
    return await repository.getUserId();
  }

  @override
  Future<bool> setUserAuthStatus({required UserAuthStatus userAuthStatus}) async {
    return await repository.setUserAuthStatus(userAuthStatus: userAuthStatus);
  }

  @override
  Future<UserAuthStatus?> getUserAuthStatus() async {
    return await repository.getUserAuthStatus();
  }

  @override
  Future<bool> clearUser() async {
    return await repository.clearUser();
  }
}