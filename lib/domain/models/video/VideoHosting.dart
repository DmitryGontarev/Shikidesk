
import 'VideoModel.dart';

/// Возможные видео хостинги
enum VideoHosting {

  /// ВКонтакте
  vk,

  /// Сибнет
  sibnet,

  /// Совет Романтика
  sovetRomantica,

  /// Сервер Смотреть Аниме
  smotretAnime,

  /// Кодик
  kodik,

  /// Аниме Джой
  animeJoy,

  ///Яндекс Дзен
  dzen,

  /// Неизвестный сервер
  unknown
}

/// Функция перевода строки в тип видеохостинга
extension ToVideoHosting on String? {
  VideoHosting toVideoHosting() {
    // switch (this) {
    //   case ("vk.com"):return VideoHosting.vk;
    //   case ("vk"):return VideoHosting.vk;
    //   case ("video.sibnet.ru"):return VideoHosting.sibnet;
    //   case ("sibnet"):return VideoHosting.sibnet;
    //   case ("sibnet.ru"):return VideoHosting.sibnet;
    //   case ("sovetromantica.com"):return VideoHosting.sovetRomantica;
    //   case ("sovetromantica"):return VideoHosting.sovetRomantica;
    //   case ("smotretanime.ru"):return VideoHosting.smotretAnime;
    //   case ("smotretanime"):return VideoHosting.smotretAnime;
    //   case ("smotret-anime.online"):return VideoHosting.smotretAnime;
    //   case ("smotret-anime.com"):return VideoHosting.smotretAnime;
    //   case ("aniqit.com"):return VideoHosting.kodik;
    //   case ("animejoy.ru"):return VideoHosting.animeJoy;
    //   default: return VideoHosting.unknown;
    // }

    if (this?.contains("vk") == true) {
      return VideoHosting.vk;
    }
    if (this?.contains("sibnet") == true) {
      return VideoHosting.sibnet;
    }
    if (this?.contains("sovetromantica") == true) {
      return VideoHosting.sovetRomantica;
    }
    if (this?.contains("smotret") == true) {
      return VideoHosting.smotretAnime;
    }
    if (this?.contains("aniqit") == true) {
      return VideoHosting.kodik;
    }
    if (this?.contains("animejoy") == true) {
      return VideoHosting.animeJoy;
    }
    if (this?.contains("dzen") == true) {
      return VideoHosting.dzen;
    }
    return VideoHosting.unknown;
  }
}

/// Возвращает флаг, поддерживается ли видеохостинг внутренним плеером
extension IsHostingSupports on String? {
  bool isHostingSupport() {
    VideoHosting hosting = toVideoHosting();
    switch (hosting) {
      case (VideoHosting.sibnet): return true;
      case (VideoHosting.vk): return true;
      case (VideoHosting.smotretAnime): return true;
      case (VideoHosting.sovetRomantica): return true;
      case (VideoHosting.kodik): return true;
      case (VideoHosting.animeJoy): return true;
      case (VideoHosting.dzen): return true;
      default: return false;
    }
  }
}

/// Функция для добавления заголовков в запрос для загрузки видео
extension GetRequestHeaderForHosting on VideoModel? {
  Map<String, String> getRequestHeaderForHosting() {
    VideoHosting hosting = (this?.hosting ?? "").toVideoHosting();
    switch (hosting) {
      case (VideoHosting.sovetRomantica): return { "Referrer": (this?.player ?? "") };
      case (VideoHosting.unknown): return { "Referrer": (this?.player ?? "") };
      case (VideoHosting.sibnet): return { "Referer": (this?.player ?? "") };
      default: return {};
    }
  }
}

/// Функция для возврата флага, нужно ли использовать тег <iframe> в WebView
extension CheckNeedIFrame on String? {
  bool checkNeedIFrame() {
    if (this?.contains("aparat") == true) {
      return false;
    }

    if (this?.contains("ebd") == true) {
      return false;
    }

    if (this?.contains("arven") == true) {
      return false;
    }

    if (this?.contains("animaunt") == true) {
      return false;
    }

    return true;
  }
}