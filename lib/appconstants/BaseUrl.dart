
/// Базовые URL-адреса для запросов
class BaseUrl {
  ///////////////////////////////////////////////////////////////////////////
  // URL-адресы сайта
  ///////////////////////////////////////////////////////////////////////////

  /// Первая часть доменного имени сайта Shikimori
  static const String domainFirst = "shikimori";

  /// Вторая часть доменного имени сайта Shikimori
  static const String domainSecond = "io";

  /// Базовый URL-адрес сайта Shikimori
  static const String shikimoriBaseUrl = "https://$domainFirst.$domainSecond/";

  /// Второй базовый URL-адрес для просмотра видео
  static const String shimoriVideoUrl = "https://shimori-us.herokuapp.com/";

  ///////////////////////////////////////////////////////////////////////////
  // Адресы и токены приложения
  ///////////////////////////////////////////////////////////////////////////

  /// Стандартное URI сайта Shikimori для перенаправления
  static const String redirectUri = "urn:ietf:wg:oauth:2.0:oob";

  /// Секретный ID приложения (клиента)
  static const String clientId = "t_wuix2_x_4PypSGg5aH2qM1qqWRJWQnWWOag3EyGtY";

  /// Секретный ключ приложения (клиента)
  static const String clientSecret =
      "4NtXSjFbNQyx9oYE5orO24IzM_rx_9iWNLvn5CtLjMQ";

  /// URL-адрес для запроса авторизации на сайте через WebView
  static const String authUrl =
      "${shikimoriBaseUrl}oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=user_rates+comments+topics";

  ///////////////////////////////////////////////////////////////////////////
  // Адресы и токены приложения для MyAnimeList
  ///////////////////////////////////////////////////////////////////////////

  /// Базовый URL-адрес сайта MyAnimeList
  static const String myAnimeListBaseUrl = "https://api.myanimelist.net/v2/";

  /// Секретный ID приложения (клиента)
  static const String myAnimeListClientId = "97bb91d1c4507140e37895d3a9d6c530";
}
