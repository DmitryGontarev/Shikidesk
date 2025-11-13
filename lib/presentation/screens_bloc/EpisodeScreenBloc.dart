import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/interactors/ShimoriVideoInteractor.dart';
import '../../domain/models/video/ShimoriTranslationModel.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class EpisodeScreenEvent {
  const EpisodeScreenEvent();
}

/// Событие старта загрузки
class LoadEpisode extends EpisodeScreenEvent {
  final int? animeId;
  final String? animeNameEng;
  final int? episode;
  final TranslationType? translationType;

  const LoadEpisode(
      {this.animeId, this.animeNameEng, this.episode, this.translationType});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class EpisodeScreenState {
  const EpisodeScreenState();
}

/// Загрузка данных
class EpisodeLoading extends EpisodeScreenState {
  const EpisodeLoading();
}

/// Данные загружены
class EpisodeLoaded extends EpisodeScreenState {
  final List<ShimoriTranslationModel> translations;

  const EpisodeLoaded({required this.translations});
}

class EpisodeError extends EpisodeScreenState {
  const EpisodeError();
}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК экрана Эпизоды
///
////////////////////////////////////////////////////////////////////////////////
class EpisodeScreenBloc extends Bloc<EpisodeScreenEvent, EpisodeScreenState> {
  final ShimoriVideoInteractor shimoriVideoInteractor;

  bool isLoading = false;

  bool showDrawer = false;

  int? animeId;
  String? animeNameRu;
  String? animeNameEng;
  int? currentEpisode = 1;
  int? episodesNumber;
  TranslationType translationType = TranslationType.subRu;

  List<ShimoriTranslationModel> translations = [];

  /// словарь {разрешение видео - ссылка}
  Map<String, String> qualityUrlMap = {};

  EpisodeScreenBloc({required this.shimoriVideoInteractor})
      : super(const EpisodeLoading()) {

    on<LoadEpisode>((event, emit) async {
      emit(const EpisodeLoading());

      await event.animeId?.let((id) async {
        animeId = event.animeId;
        currentEpisode = event.episode;
        translationType = event.translationType ?? TranslationType.subRu;

        if (episodesNumber == null) {
          await _loadEpisodeSize(
              id: id,
              name: event.animeNameEng);
        }

        await _loadTranslations(
            id: id,
            name: event.animeNameEng,
            episode: event.episode ?? 1,
            translationType: translationType,
            state: (state) {
              emit(state);
            });
      });
    });
  }

  /// Загрузка информации о количестве эпизодов в аниме
  Future<void> _loadEpisodeSize(
      {required int id,
      required String? name}) async {
    try {
      final episodesSize =
          await shimoriVideoInteractor.getEpisodes(id, name.orEmpty());
      episodesSize.fold((failure) {
        _loadEpisodeSize(id: id, name: name);
      }, (eps) {
        episodesNumber = eps;
      });
    } catch (e) {
      _loadEpisodeSize(id: id, name: name);
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
      required Function(EpisodeScreenState state) state}) async {
    try {
      final translation = await shimoriVideoInteractor.getTranslations(
          id, name.orEmpty(), episode, hostingId, translationType);
      translation.fold((failure) {
        state(const EpisodeError());
        _loadTranslations(id: id, name: name, episode: episode, state: state);
      }, (episode) {
        translations = episode;
        state(EpisodeLoaded(translations: translations));
      });
    } catch (e) {
      state(const EpisodeError());
      _loadTranslations(id: id, name: name, episode: episode, state: state);
    }
  }

  /// Загрузка данных видео
  ///
  /// [id] идентификационный номер аниме
  /// [name] название аниме на английском
  /// [episode] номер эпизода
  /// [hostingId] идентификационный номер хостинга
  /// [translationType] тип трансляции (оригинал, субтитры, озвучка)
  Future<void> loadVideo(
      {required int malId,
        int episode = 1,
        required TranslationType? translationType,
        required String? author,
        required String hosting,
        int hostingId = 1,
        required int? videoId,
        required String? url,
        String? accessToken,
      required Function (Map<String, String> links) links,
      required Function () isError}) async {
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
        isError();
      }, (video) {
        qualityUrlMap.clear();

        if (video.tracks == null || video.tracks?.isEmpty == true) {
          isError();
          return;
        }

        video.tracks?.let((tracks) {
          for (var track in (tracks)) {
            track?.let((it) {
              qualityUrlMap[it.quality.orEmpty()] = it.url.orEmpty().toDownloadLink();
            });
          }
        });

        links(qualityUrlMap);
      });
    } catch (e) {
      isError();
    }
  }
}
