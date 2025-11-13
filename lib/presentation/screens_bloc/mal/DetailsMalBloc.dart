
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/anime/ScreenshotModel.dart';
import 'package:shikidesk/domain/models/manga/MangaModel.dart';
import 'package:shikidesk/domain/models/roles/CharacterModel.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../../domain/interactors/MyAnimeListInteractor.dart';
import '../../../domain/models/anime/AnimeModel.dart';
import '../../../domain/models/common/RelatedModel.dart';
import '../../../domain/models/common/RolesModel.dart';
import '../../../domain/models/manga/MangaDetailsModel.dart';
import '../../../domain/models/myanimelist/AnimeMalModel.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class DetailsMalScreenEvent {
  const DetailsMalScreenEvent();
}

/// Событие старта загрузки
class LoadDetails extends DetailsMalScreenEvent {
  final DetailsScreenType screenType;
  final int? id;

  const LoadDetails({required this.screenType, required this.id});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class DetailsMalScreenState {
  const DetailsMalScreenState();
}

/// Загрузка данных Детальной информации
class DetailsLoading extends DetailsMalScreenState {
  const DetailsLoading();
}

/// Данные Детальной информации об Аниме загружены
class AnimeDetailsLoaded extends DetailsMalScreenState {
  final AnimeMalModel animeDetails;
  final List<CharacterModel> characters;
  final List<ScreenshotModel> screenshots;
  final List<RelatedModel> animeRelated;
  final List<AnimeModel> animeSimilar;

  const AnimeDetailsLoaded(
      {required this.animeDetails,
      required this.characters,
      required this.screenshots,
      required this.animeRelated,
      required this.animeSimilar});
}

/// Данные Детальной информации о Манге загружены
class MangaRanobeDetailsLoaded extends DetailsMalScreenState {
  final MangaDetailsModel mangaRanobeDetails;
  final List<CharacterModel> characters;
  final List<RelatedModel> mangaRelated;
  final List<MangaModel> mangaRanobeSimilar;

  const MangaRanobeDetailsLoaded(
      {required this.mangaRanobeDetails,
      required this.characters,
      required this.mangaRelated,
      required this.mangaRanobeSimilar});
}

/// Ошибка загрузки данных
class DetailsError extends DetailsMalScreenState {}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК экрана Детальной информации
///
////////////////////////////////////////////////////////////////////////////////
class DetailsMalScreenBloc
    extends Bloc<DetailsMalScreenEvent, DetailsMalScreenState> {
  DetailsScreenType screenType;
  final MyAnimeListInteractor malInteractor;

  AnimeMalModel? _animeDetails;
  MangaDetailsModel? _mangaRanobeDetails;
  List<RolesModel> _roles = [];
  List<CharacterModel> _characters = [];
  List<CharacterModel> _mainCharacters = [];
  List<CharacterModel> _supportingCharacters = [];
  List<ScreenshotModel> _screenshots = [];
  List<RelatedModel> _related = [];
  List<AnimeModel> _animeSimilar = [];
  List<MangaModel> _mangaRanobeSimilar = [];

  static const String mainCharacter = "Main";
  static const String supportingCharacter = "Supporting";

  static const String detailsFields =
      "id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics";

  DetailsMalScreenBloc(
      {this.screenType = DetailsScreenType.anime, required this.malInteractor})
      : super(const DetailsLoading()) {
    /// Загрузка данных
    on<LoadDetails>((event, emit) async {
      emit(const DetailsLoading());

      screenType = event.screenType;

      if (screenType == DetailsScreenType.anime) {
        await _loadAnimeData(event.id, (state) {
          emit(state);
        });
      } else {
        await _loadMangaRanobeData(event.id, (state) {
          emit(state);
        });
      }
    });
  }

  /// Загрузка всей информации об аниме
  Future<void> _loadAnimeData(
      int? id, Function(DetailsMalScreenState state) state) async {
    await _loadAnimeDetails(id);

    if (_animeDetails != null) {
      state(AnimeDetailsLoaded(
          animeDetails: _animeDetails!,
          characters: _characters,
          screenshots: _screenshots,
          animeRelated: _related,
          animeSimilar: _animeSimilar));
    } else {
      state(DetailsError());
    }
  }

  /// Загрузка всей информации о Манге или Ранобэ
  Future<void> _loadMangaRanobeData(
      int? id, Function(DetailsMalScreenState state) state) async {
    // await _loadMangaRanobeDetails(id);

    if (_mangaRanobeDetails != null) {
      state(MangaRanobeDetailsLoaded(
          mangaRanobeDetails: _mangaRanobeDetails!,
          characters: _characters,
          mangaRelated: _related,
          mangaRanobeSimilar: _mangaRanobeSimilar));
    } else {
      state(DetailsError());
    }
  }

  /// Загрузка Детальной информации об Аниме
  Future<void> _loadAnimeDetails(int? id) async {
    await id?.let((it) async {
      try {
        final animeDetails = await malInteractor.getAnimeDetailsById(
            id: id, fields: detailsFields);
        animeDetails.fold((failure) {
          _animeDetails = null;
        }, (details) {
          _animeDetails = details;
        });
      } catch (e) {
        _animeDetails = null;
      }
    });
  }
}
