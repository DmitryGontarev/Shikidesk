import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/interactors/AnimeInteractor.dart';
import 'package:shikidesk/domain/models/anime/AnimeSearchType.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/common/AgeRatingType.dart';
import '../../domain/models/rates/RateStatus.dart';

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SearchScreenEvent {
  const SearchScreenEvent();
}

/// Событие старта загрузки
class LoadSearch extends SearchScreenEvent {
  final int page;

  const LoadSearch({required this.page});
}

/// Событие поиска по строке
class SearchByTitle extends SearchScreenEvent {
  final String? text;

  const SearchByTitle({required this.text});
}

/// Событие сброса параметров поиска
class RefreshSearch extends SearchScreenEvent {
  const RefreshSearch();
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SearchScreenState {
  const SearchScreenState();
}

/// Загрузка данных
class SearchLoading extends SearchScreenState {
  const SearchLoading();
}

/// Данные загружены
class SearchLoaded extends SearchScreenState {
  final List<AnimeModel> animeList;

  const SearchLoaded(this.animeList);
}

/// Ошибка загрузки данных
class SearchError extends SearchScreenState {}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  final AnimeInteractor animeInteractor;

  /// флаг загрузки данных
  bool isLoading = false;

  /// список найденного аниме
  final List<AnimeModel> animeSearch = [];

  /// флаг изменения настроек поиска
  bool isSearchSettingsChanged = false;

  /// текущая страница для загрузки
  int nextPage = 1;

  /// флаг загрузки полного списка
  bool endReached = false;

  /// строка для поиска
  String? searchValue;

  SearchScreenBloc({required this.animeInteractor})
      : super(const SearchLoading()) {
    /// Загрузка данных
    on<LoadSearch>((event, emit) async {
      emit(const SearchLoading());
      await _loadAnime(
          page: event.page,
          search: searchValue.getNullIfEmpty(),
          state: (state) {
            emit(state);
          });
    });

    on<SearchByTitle>((event, emit) async {
      emit(const SearchLoading());
      _reset();
      searchValue = event.text;
      await _loadAnime(
          page: nextPage,
          search: searchValue.getNullIfEmpty(),
          state: (state) {
            emit(state);
          });
    });

    on<RefreshSearch>((event, emit) async {
      emit(const SearchLoading());
      _fullReset();
      await _loadAnime(
          page: nextPage,
          search: searchValue.getNullIfEmpty(),
          state: (state) {
            emit(state);
          });
    });
  }

  Future<void> _loadAnime(
      {int? page = 1,
      int? limit = 50,
      AnimeSearchType? order = AnimeSearchType.ranked,
      List<AnimeType>? kind,
      List<AiredStatus>? status,
      List<(String?, String?)>? season,
      double? score,
      List<AnimeDurationType>? duration,
      List<AgeRatingType>? rating,
      List<int>? genre,
      List<int>? studio,
      List<String>? franchise,
      bool? censored = true,
      List<RateStatus>? myList,
      List<String>? ids,
      List<String>? excludeIds,
      String? search,
      required Function(SearchScreenState state) state}) async {
    try {
      final anime = await animeInteractor.getAnimeListByParameters(
          page,
          limit,
          order,
          kind,
          status,
          season,
          score,
          duration,
          rating,
          genre,
          studio,
          franchise,
          censored,
          myList,
          ids,
          excludeIds,
          search);
      anime.fold((failure) {
        page?.let((it) {
          nextPage = it;
        });
        state(SearchError());
      }, (animeList) {
        if (animeList.isEmpty && nextPage == 1) {
          animeSearch.clear();
          endReached = true;
        }

        if (animeList.isEmpty && nextPage > 1) {
          endReached = true;
        }
        if (isSearchSettingsChanged == true) {
          animeSearch.clear();
          isSearchSettingsChanged = false;
        }

        // for (var anime in animeList) {
        //   if (animeSearch.contains(anime) == false) {
        //     animeSearch.add(anime);
        //   }
        // }

        animeSearch.addAll(animeList);
        state(SearchLoaded(animeSearch));
      });
    } catch (e) {
      page?.let((it) {
        nextPage = it;
      });
      state(SearchError());
    }
  }

  void _reset() {
    animeSearch.clear();
    isSearchSettingsChanged = true;
    endReached = false;
    nextPage = 1;
  }

  void _fullReset() {
    searchValue = null;
    _reset();
  }
}
