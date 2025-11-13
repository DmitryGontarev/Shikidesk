import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';
import 'package:shikidesk/domain/models/video/VideoModel.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';
import 'package:shikidesk/utils/sharedprefs/SharedPreferencesProvider.dart';

import '../../domain/interactors/ShimoriVideoInteractor.dart';
import '../../domain/models/video/ShimoriTranslationModel.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class VideoScreenEvent {
  const VideoScreenEvent();
}

/// Событие старта загрузки
class LoadVideo extends VideoScreenEvent {
  final int? animeId;
  final String? animeNameRu;
  final String? animeNameEng;
  final ShimoriTranslationModel translation;

  const LoadVideo(
      {required this.animeId,
      required this.animeNameRu,
      required this.animeNameEng,
      required this.translation});
}

/// Событие изменения разрешения видео
class ChangeVideoResolution extends VideoScreenEvent {
  final String resolution;
  final int? playerPosition;
  final double? playerVolume;
  final double? playerSpeed;

  const ChangeVideoResolution(
      {required this.resolution,
      required this.playerPosition,
      this.playerVolume,
      this.playerSpeed});
}

/// Событие переключения эпизода
class ChangeVideoTranslation extends VideoScreenEvent {
  final int? episode;
  final double? playerVolume;
  final double? playerSpeed;

  const ChangeVideoTranslation(
      {this.episode, this.playerVolume, this.playerSpeed});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class VideoScreenState {
  const VideoScreenState();
}

/// Загрузка данных
class VideoLoading extends VideoScreenState {
  const VideoLoading();
}

/// Данные загружены
class VideoLoaded extends VideoScreenState {
  final String? url;
  final int? playerPosition;
  final double? playerVolume;
  final double? playerSpeed;
  final ShimoriTranslationModel? translation;
  final VideoModel? video;

  const VideoLoaded(
      {required this.url,
      this.playerPosition,
      this.playerVolume,
      this.playerSpeed,
      this.translation,
      required this.video});
}

/// Ошибка загрузки
class VideoError extends VideoScreenState {
  final ShimoriTranslationModel? translation;

  const VideoError({this.translation});
}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК экрана Видеоплеера
///
////////////////////////////////////////////////////////////////////////////////
class VideoScreenBloc extends Bloc<VideoScreenEvent, VideoScreenState> {
  final ShimoriVideoInteractor shimoriVideoInteractor;
  final SharedPreferencesProvider prefs;

  // ключ для сохранения выбранного разрешения видео
  static const String videoResolutionKey = "VIDEO_RESOLUTION";

  /// id аниме
  int? animeId;

  /// название аниме на русском
  String? animeNameRu;

  /// название аниме на английском (нужно для запроса)
  String? animeNameEng;

  /// словарь {разрешение видео - ссылка}
  Map<String, String> qualityUrlMap = {};

  /// текущий просматриваемый эпизод
  int? currentEpisode = 1;

  /// общее количество эпизодов в трансляции
  int? totalEpisode;

  /// текущее разрешение видео
  String? videoResolution;

  /// данные текущей трансляции
  ShimoriTranslationModel? currentTranslation;

  /// Данные видео
  VideoModel? videoModel;

  bool isPlay = false;

  VideoScreenBloc({required this.shimoriVideoInteractor, required this.prefs})
      : super(const VideoLoading()) {
    on<LoadVideo>((event, emit) async {
      emit(const VideoLoading());

      await event.translation.let((it) async {
        animeId = event.animeId;
        animeNameRu = event.animeNameRu;
        animeNameEng = event.animeNameEng;

        currentTranslation = it;

        totalEpisode = it.episodesTotal;

        currentEpisode = it.episode;

        await _loadVideo(
            malId: it.targetId ?? 1,
            episode: it.episode ?? 1,
            translationType: it.kind,
            author: it.author,
            hosting: it.hosting.orEmpty(),
            videoId: it.id,
            url: it.url,
            state: (state) {
              emit(state);
            });
      });
    });

    on<ChangeVideoResolution>((event, emit) async {
      emit(const VideoLoading());

      String? url = qualityUrlMap[event.resolution];

      videoResolution = event.resolution;

      await Future.delayed(const Duration(seconds: 1), () {
        emit(VideoLoaded(
            url: url,
            playerPosition: event.playerPosition,
            playerVolume: event.playerVolume,
            playerSpeed: event.playerSpeed,
            translation: currentTranslation,
            video: videoModel));
      });
    });

    on<ChangeVideoTranslation>((event, emit) async {
      emit(const VideoLoading());

      await _loadTranslations(
          id: animeId ?? 0,
          name: animeNameEng,
          episode: event.episode ?? 1,
          translationType: currentTranslation?.kind ?? TranslationType.subRu,
          playerVolume: event.playerVolume,
          playerSpeed: event.playerSpeed);
    });
  }

  /// Загрузка данных видео
  ///
  /// [id] идентификационный номер аниме
  /// [name] название аниме на английском
  /// [episode] номер эпизода
  /// [hostingId] идентификационный номер хостинга
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  Future<void> _loadVideo(
      {required int malId,
      int episode = 1,
      required TranslationType? translationType,
      required String? author,
      required String hosting,
      int hostingId = 1,
      required int? videoId,
      required String? url,
      String? accessToken,
      double? playerVolume,
      double? playerSpeed,
      required Function(VideoScreenState state) state}) async {
    try {
      final videoSource = await shimoriVideoInteractor.getVideo(
          malId,
          episode,
          translationType,
          author ?? hosting,
          hosting,
          hostingId,
          videoId,
          url,
          accessToken);
      videoSource.fold((failure) {
        currentEpisode = episode;
        state(VideoError(translation: currentTranslation));
      }, (video) {
        videoModel = video;

        qualityUrlMap.clear();

        if (video.tracks == null || video.tracks?.isEmpty == true) {
          state(VideoError(translation: currentTranslation));
          return;
        }

        video.tracks?.let((tracks) {
          for (var track in (tracks)) {
            track?.let((it) {
              qualityUrlMap[it.quality.orEmpty()] = it.url.orEmpty();
            });
          }

          currentEpisode = episode;

          videoResolution = tracks.first?.quality.orEmpty();

          state(VideoLoaded(
              url: qualityUrlMap[videoResolution],
              translation: currentTranslation,
              video: video,
              playerVolume: playerVolume,
              playerSpeed: playerSpeed));
        });
      });
    } catch (e) {
      state(VideoError(translation: currentTranslation));
    }
  }

  /// Загрузка данных трансляции
  ///
  /// [id] идентификационный номер аниме
  /// [name] название аниме на английском
  /// [episode] номер эпизода
  /// [hostingId] идентификационный номер хостинга
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  Future<void> _loadTranslations(
      {required int id,
      String? name,
      int episode = 1,
      int hostingId = 1,
      TranslationType translationType = TranslationType.subRu,
      double? playerVolume,
      double? playerSpeed}) async {
    try {
      final translation = await shimoriVideoInteractor.getTranslations(
          id, name.orEmpty(), episode, hostingId, translationType);
      translation.fold((failure) {
        _loadTranslations(
            id: id,
            name: name,
            episode: episode,
            playerVolume: playerVolume,
            playerSpeed: playerSpeed);
      }, (episode) {
        var translation = episode.find((item) {
          if (currentTranslation?.author != null) {
            return item.author == currentTranslation?.author && item.hosting == currentTranslation?.hosting;
          } else {
            return item.hosting == currentTranslation?.hosting;
          }
        });

        translation?.let((it) async {
          currentTranslation = it;
          await _loadVideo(
              malId: it.targetId ?? 1,
              episode: it.episode ?? 1,
              translationType: it.kind,
              author: it.author,
              hosting: it.hosting.orEmpty(),
              videoId: it.id,
              url: it.url,
              playerVolume: playerVolume,
              playerSpeed: playerSpeed,
              state: (state) {
                emit(state);
              });
        });
      });
    } catch (e) {
      _loadTranslations(
          id: id,
          name: name,
          episode: episode,
          playerVolume: playerVolume,
          playerSpeed: playerSpeed);
    }
  }
}
