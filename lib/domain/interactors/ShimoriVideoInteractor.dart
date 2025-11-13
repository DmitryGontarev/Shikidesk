import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/ShimoriVideoRepository.dart';

import '../models/common/Failure.dart';
import '../models/video/ShimoriEpisodeModel.dart';
import '../models/video/ShimoriTranslationModel.dart';
import '../models/video/TranslationType.dart';
import '../models/video/VideoModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора получения видео
////////////////////////////////////////////////////////////////////////////////
abstract class ShimoriVideoInteractor {
  /// Получить количество вышедших эпизодов
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  Future<Either<Failure, int>> getEpisodes(
    int malId,
    String name,
  );

  /// Получить информацию по каждому эпизоду
  ///
  /// [malId ]идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  Future<Either<Failure, List<ShimoriEpisodeModel>>> getSeries(
    int malId,
    String name,
  );

  /// Получить информацию по трансляции конкретноого эпизода
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [name] название на английском
  /// [episode] номер эпизода
  /// [hostingId] идентификационный номер хостинга
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  Future<Either<Failure, List<ShimoriTranslationModel>>> getTranslations(
      int malId,
      String name,
      int episode,
      int hostingId,
      TranslationType? translationType);

  /// Получить информацию для потоковой загрузки эпизода
  ///
  /// [malId] идентификационный номер аниме с сайта MyAnimeList
  /// [episode] номер эпизода
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  /// [author] автор загруженного эпизода
  /// [hosting] название хостинга
  /// [hostingId] идентификационный номер хостинга
  /// [videoId] идентификационный номер видео на хостинге
  /// [url] ссылка на видео
  /// [accessToken] токен для загрузки, если нужен
  Future<Either<Failure, VideoModel>> getVideo(
      int malId,
      int episode,
      TranslationType? translationType,
      String? author,
      String hosting,
      int hostingId,
      int? videoId,
      String? url,
      String? accessToken);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [ShimoriVideoInteractor]
///
/// [repository] репозиторий для получения данных о видео
////////////////////////////////////////////////////////////////////////////////
class ShimoriVideoInteractorImpl implements ShimoriVideoInteractor {
  final ShimoriVideoRepository repository;

  ShimoriVideoInteractorImpl({required this.repository});

  @override
  Future<Either<Failure, int>> getEpisodes(int malId, String name) async {
    return await repository.getEpisodes(malId, name);
  }

  @override
  Future<Either<Failure, List<ShimoriEpisodeModel>>> getSeries(
      int malId, String name) async {
    return await repository.getSeries(malId, name);
  }

  @override
  Future<Either<Failure, List<ShimoriTranslationModel>>> getTranslations(
      int malId,
      String name,
      int episode,
      int hostingId,
      TranslationType? translationType) async {
    return await repository.getTranslations(malId, name, episode, hostingId, translationType);
  }

  @override
  Future<Either<Failure, VideoModel>> getVideo(
      int malId,
      int episode,
      TranslationType? translationType,
      String? author,
      String hosting,
      int hostingId,
      int? videoId,
      String? url,
      String? accessToken) async {
    return await repository.getVideo(malId, episode, translationType, author, hosting, hostingId,
        videoId, url, accessToken);
  }
}
