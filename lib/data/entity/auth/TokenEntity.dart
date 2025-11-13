
/// Сущность токена
///
/// [accessToken] ключ доступа для взаимодействия с сервером
/// [refreshToken] ключ для обновления доступа
class TokenEntity {
  final String? accessToken;
  final String? refreshToken;

  const TokenEntity({this.accessToken, this.refreshToken});

  factory TokenEntity.fromJson(Map<String, dynamic> json) {
    return TokenEntity(
        accessToken: json["access_token"], refreshToken: json["refresh_token"]);
  }
}
