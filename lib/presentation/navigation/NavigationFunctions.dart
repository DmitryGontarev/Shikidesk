
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/domain/models/video/VideoHosting.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/presentation/screens/AuthoriztionScreen.dart';
import 'package:shikidesk/presentation/screens/DetailsScreen.dart';
import 'package:shikidesk/presentation/screens/EpisodeScreen.dart';
import 'package:shikidesk/presentation/screens/VideoPlayerScreen.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/video/ShimoriTranslationModel.dart';
import '../screens/CharacterPeopleScreen.dart';
import '../screens/mal/DetailsMalScreen.dart';
import '../screens/EnterScreen.dart';
import '../screens/RailScreens.dart';
import '../screens/VideoScreen.dart';

/// Возвращает на предыдущий экран
void navigateBack(BuildContext context) {
  Navigator.pop(context);
}

/// Навигация на экран выбора входа Гость/Авторизация
void navigateEnterScreen({required BuildContext context}) {
  Route route = MaterialPageRoute(builder: (context) => const EnterScreen());
  Navigator.pushReplacement(context, route);
}

/// Навигация на экран выбора входа Гость/Авторизация
void navigateAuthorizationScreen({required BuildContext context}) {
  Route route = MaterialPageRoute(builder: (context) => const AuthorizationContainer());
  Navigator.push(context, route);
}

/// Навигация на экраны Гостя
void navigateGuestRail({required BuildContext context}) {
  Route route = MaterialPageRoute(builder: (context) => const GuestRail());
  Navigator.push(context, route);
}

/// Навигация на экраны Авторизованного пользователя
void navigateAllScreensRail({required BuildContext context}) {
  Route route = MaterialPageRoute(builder: (context) => const AuthRail());
  Navigator.push(context, route);
}

/// Навигация на экран Гостевых экранов
void navigateMalRail({required BuildContext context}) {
  Route route = MaterialPageRoute(builder: (context) => const MalRail());
  Navigator.pushReplacement(context, route);
}

/// Навигация на экран детальной информации об Аниме
/// [id] идентификационный номер
void navigateAnimeDetailsScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => DetailsContainer(
            id: id,
            screenType: DetailsScreenType.anime,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран детальной информации об Аниме
/// [id] идентификационный номер
void navigateAnimeDetailsMalScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => DetailsMalContainer(
            id: id,
            screenType: DetailsScreenType.anime,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран детальной информации о Манге
/// [id] идентификационный номер
void navigateMangaDetailsScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => DetailsContainer(
            id: id,
            screenType: DetailsScreenType.manga,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран детальной информации о Ранобэ
/// [id] идентификационный номер
void navigateRanobeDetailsScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => DetailsContainer(
            id: id,
            screenType: DetailsScreenType.ranobe,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран детальной информации о Персонаже
/// [id] идентификационный номер
void navigateCharacterDetailsScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => CharacterPeopleContainer(
            id: id,
            screenType: CharacterPeopleScreenType.character,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран детальной информации о Человеке
/// [id] идентификационный номер
void navigatePeopleDetailsScreen(
    {required int? id, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => CharacterPeopleContainer(
            id: id,
            screenType: CharacterPeopleScreenType.people,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран Эпизоды
/// [animeId] идентификационный номер аниме
/// [animeNameRu] название аниме на русском
/// [animeNameEng] название аниме на английском
/// [animeImageUrl] ссылка на картинку с аниме
void navigateEpisodeScreen(
    {required int? animeId,
    String? animeNameRu,
    String? animeNameEng,
    String? animeImageUrl,
    required BuildContext context}) {
  Route route = MaterialPageRoute(
      settings: const RouteSettings(name: "EpisodeScreen"),
      builder: (context) => EpisodeContainer(
            animeId: animeId,
            animeNameRu: animeNameRu,
            animeNameEng: animeNameEng,
            animeImageUrl: animeImageUrl,
          ));
  Navigator.push(context, route);
}

/// Навигация на экран Видеоплеера
/// [animeId] идентификационный номер аниме
/// [animeNameRu] название аниме на русском
/// [animeNameEng] название аниме на английском
/// [translation] данные для загрузки видео
void navigateVideoScreen(
    {required int? animeId,
    required String? animeNameRu,
    required String? animeNameEng,
    required ShimoriTranslationModel translation,
    required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => VideoContainer(
            animeId: animeId,
            animeNameRu: animeNameRu,
            animeNameEng: animeNameEng,
            translation: translation,
          ));
  Navigator.push(context, route);
}

/// Навигация для запуска браузера системы по умолчанию
/// [url] ссылка
/// [useWebView] флаг открытия ссылки в вебвью
void navigateBrowser({required String? url, bool useWebView = true, bool useIFrame = false}) async {
  url?.let((link) async {
    if (useWebView && await WebviewWindow.isWebviewAvailable()) {
      final webView = await WebviewWindow.create();

      if (useIFrame) {
        bool needIFrame = link.checkNeedIFrame();
        if (needIFrame) {
          final Uri uri = Uri.dataFromString("<html><body style='margin:0;padding:0;'><iframe src='$link' width='100%' height='100%'  frameborder='0' allowfullscreen></iframe></body></html>", mimeType: "text/html");
          webView.launch(uri.toString());
        } else {
          webView.launch(link);
        }
      } else {
        webView.launch(link);
      }
    } else {
      final Uri uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        return;
      }
    }
  });
}

/// Навигация на экран Видеоплеера для проигрывания локальных файлов
/// [playlist] список путей к файлам для проигрывания
/// [context] контекст приложения
void navigateVideoPlayer(
    {required List<String> playlist, required BuildContext context}) {
  Route route = MaterialPageRoute(
      builder: (context) => VideoPlayerScreen(playlist: playlist));
  Navigator.push(context, route);
}
