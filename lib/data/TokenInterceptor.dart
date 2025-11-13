
import 'package:dio/dio.dart';

import '../domain/repository/TokenLocalRepository.dart';

/// Перехватчик [Interceptor] для создания хэдера запроса токена
class TokenInterceptor extends InterceptorsWrapper {
  final TokenLocalRepository tokenLocalRepository;

  TokenInterceptor({required this.tokenLocalRepository});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (await tokenLocalRepository.isTokenExists()) {
      var token = await tokenLocalRepository.getToken();

      options.headers.addAll({
        "User-agent": "Shikidroid",
        "Authorization": "Bearer ${token?.accessToken}"
      });
    } else {
      options.headers.addAll({
        "User-agent": "Shikidroid",
      });
    }

    handler.next(options);
  }
}