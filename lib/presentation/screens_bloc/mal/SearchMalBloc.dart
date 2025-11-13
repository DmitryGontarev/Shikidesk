import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/interactors/MyAnimeListInteractor.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SearchMalScreenEvent {
  const SearchMalScreenEvent();
}

/// Событие старта загрузки
class LoadSearch extends SearchMalScreenEvent {
  final int page;

  const LoadSearch({required this.page});
}

/// Событие поиска по строке
class SearchByTitle extends SearchMalScreenEvent {
  final String? text;

  const SearchByTitle({required this.text});
}

/// Событие сброса параметров поиска
class RefreshSearch extends SearchMalScreenEvent {
  const RefreshSearch();
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SearchMalScreenState {
  const SearchMalScreenState();
}

/// Загрузка данных
class SearchLoading extends SearchMalScreenState {
  const SearchLoading();
}

/// Данные загружены
class SearchLoaded extends SearchMalScreenState {
  final List<AnimeMalModel> animeList;

  const SearchLoaded(this.animeList);
}

/// Ошибка загрузки данных
class SearchError extends SearchMalScreenState {}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class SearchMalScreenBloc
    extends Bloc<SearchMalScreenEvent, SearchMalScreenState> {
  final MyAnimeListInteractor malInteractor;

  /// флаг загрузки данных
  bool isLoading = false;

  /// список найденного аниме
  final List<AnimeMalModel> animeSearch = [];

  /// флаг изменения настроек поиска
  bool isSearchSettingsChanged = false;

  /// текущая страница для загрузки
  int nextPage = 1;

  /// флаг загрузки полного списка
  bool endReached = false;

  /// строка для поиска
  String? searchValue = "Jujutsu Kaisen";

  static const String searchFields =
      "start_date, end_date, media_type, status, num_episodes, mean";

  SearchMalScreenBloc({required this.malInteractor})
      : super(const SearchLoading()) {
    /// Загрузка данных
    on<LoadSearch>((event, emit) async {
      emit(const SearchLoading());
      await _loadAnimeByRank(
          page: event.page,
          state: (state) {
            emit(state);
          });
    });

    on<SearchByTitle>((event, emit) async {
      emit(const SearchLoading());
      _reset();
      searchValue = event.text;
      if (searchValue.isNullOrEmpty()) {
        await _loadAnimeByRank(
            page: nextPage,
            state: (state) {
              emit(state);
            });
      } else {
        await _searchAnime(
            page: nextPage,
            search: searchValue.getNullIfEmpty(),
            state: (state) {
              emit(state);
            });
      }
    });

    on<RefreshSearch>((event, emit) async {
      emit(const SearchLoading());
      _fullReset();
      await _loadAnimeByRank(
          page: nextPage,
          state: (state) {
            emit(state);
          });
    });
  }

  Future<void> _searchAnime(
      {int? page = 1,
      int? limit = 100,
      String? search,
      int? offset,
      String? fields = searchFields,
      required Function(SearchMalScreenState state) state}) async {
    try {
      final anime = await malInteractor.getAnimeListByParameters(
          search: search, limit: limit, offset: offset, fields: fields);
      anime.fold((failure) {
        state(SearchError());
      }, (animeList) {
        animeSearch.clear();
        animeSearch.addAll(animeList);
        state(SearchLoaded(animeSearch));
      });
    } catch (e) {
      state(SearchError());
    }
  }

  Future<void> _loadAnimeByRank(
      {int? page = 1,
      RankingType? rankType = RankingType.all,
      int? limit = 500,
      int? offset,
      String? fields = searchFields,
      required Function(SearchMalScreenState state) state}) async {
    try {
      final anime = await malInteractor.getAnimeRankingList(
          rankingType: rankType, limit: limit, offset: offset, fields: fields);
      anime.fold((failure) {
        state(SearchError());
      }, (animeList) {
        animeSearch.clear();
        animeSearch.addAll(animeList);
        state(SearchLoaded(animeSearch));
      });
    } catch (e) {
      state(SearchError());
    }
  }

  void _reset() {
    isSearchSettingsChanged = true;
    endReached = false;
    nextPage = 1;
  }

  void _fullReset() {
    searchValue = null;
    _reset();
  }
}
