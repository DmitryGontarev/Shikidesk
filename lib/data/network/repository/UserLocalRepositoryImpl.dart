
import 'package:shikidesk/appconstants/SettingsExtras.dart';
import 'package:shikidesk/domain/models/user/UserAuthStatus.dart';
import 'package:shikidesk/domain/repository/UserLocalRepository.dart';

import '../../../appconstants/NetworkConstants.dart';
import '../../../utils/sharedprefs/SharedPreferencesProvider.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [UserLocalRepository]
/// [prefs] локальное хранилище
////////////////////////////////////////////////////////////////////////////////
class UserLocalRepositoryImpl implements UserLocalRepository {
  final SharedPreferencesProvider prefs;

  const UserLocalRepositoryImpl({required this.prefs});

  @override
  Future<bool> setUserId({required int id}) async {
    return await prefs.putInt(key: SettingsExtras.userId, int: id);
  }

  @override
  Future<int?> getUserId() async {
    return await prefs.getInt(key: SettingsExtras.userId, defaultValue: noId);
  }

  @override
  Future<bool> setUserAuthStatus({required UserAuthStatus userAuthStatus}) async {
    return await prefs.putString(key: SettingsExtras.userStatus, string: userAuthStatus.name);
  }

  @override
  Future<UserAuthStatus?> getUserAuthStatus() async {
    String status = await prefs.getString(key: SettingsExtras.userStatus, defaultValue: UserAuthStatus.guest.name);

    if (status == UserAuthStatus.authorized.name) {
      return UserAuthStatus.authorized;
    }

    if (status == UserAuthStatus.unauthorized.name) {
      return UserAuthStatus.unauthorized;
    }

    return UserAuthStatus.guest;
  }

  @override
  Future<bool> clearUser() async {
    await setUserAuthStatus(userAuthStatus: UserAuthStatus.guest);
    return await prefs.remove(key: SettingsExtras.userId);
  }
}