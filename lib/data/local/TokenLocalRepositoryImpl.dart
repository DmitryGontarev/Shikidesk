import 'package:shikidesk/domain/models/auth/TokenModel.dart';
import 'package:shikidesk/domain/repository/TokenLocalRepository.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../appconstants/AppKeys.dart';
import '../../utils/sharedprefs/SharedPreferencesProvider.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [TokenLocalRepository]
/// [prefs] локальное хранилище
////////////////////////////////////////////////////////////////////////////////
class TokenLocalRepositoryImpl implements TokenLocalRepository {
  final SharedPreferencesProvider prefs;

  const TokenLocalRepositoryImpl({required this.prefs});

  @override
  Future<bool> saveToken(TokenModel? token) async {
    return await prefs.putString(
            key: AppKeys.accessToken, string: token?.accessToken ?? "") &&
        await prefs.putString(
            key: AppKeys.refreshToken, string: token?.refreshToken ?? "");
  }

  @override
  Future<TokenModel?> getToken() async {
    String accessToken =
        await prefs.getString(key: AppKeys.accessToken, defaultValue: "");

    String refreshToken =
        await prefs.getString(key: AppKeys.refreshToken, defaultValue: "");

    TokenModel token =
        TokenModel(accessToken: accessToken, refreshToken: refreshToken);

    return token;
  }

  @override
  Future<bool> removeToken() async {
    return await prefs.remove(key: AppKeys.accessToken) &&
        await prefs.remove(key: AppKeys.refreshToken);
  }

  @override
  Future<bool> isTokenExists() async {
    String accessToken =
        await prefs.getString(key: AppKeys.accessToken, defaultValue: "");

    String refreshToken =
        await prefs.getString(key: AppKeys.refreshToken, defaultValue: "");

    return accessToken.isNullOrEmpty().not() &&
        refreshToken.isNullOrEmpty().not();
  }
}
