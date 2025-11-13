
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/rates/SortBy.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';

import '../../domain/interactors/UserInteractor.dart';
import '../../domain/interactors/UserLocalInteractor.dart';
import '../../domain/models/rates/RateModel.dart';
import '../../domain/models/rates/RateStatus.dart';
import '../../utils/sharedprefs/SharedPreferencesProvider.dart';

// ключ для сохранения типа списка аниме/манга
const listTypeKey = "LIST_TYPE";

// ключ для сохранения типа пользовательского статуса списка аниме (Запланировано, Просмотрено)
const selectedAnimeRateStatusKey = "SELECTED_ANIME_RATE_STATUS";

// ключ для сохранения типа пользовательского статуса списка манги (Запланировано, Прочитано)
const selectedMangaRateStatusKey = "SELECTED_MANGA_RATE_STATUS";

// ключ для сохранения выбранного типа сортировки списка
const sortByKey = "SORT_BY";

// ключ для сортировки по возрастанию/убыванию
const sortAscendDescendKey = "SORT_ASCEND_DESCEND";

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class RateScreenEvent {
  const RateScreenEvent();
}

/// Событие старта загрузки
class LoadRates extends RateScreenEvent {
  const LoadRates();
}

/// Событие смены списка
class ChangeRateList extends RateScreenEvent {
  final RateStatus status;

  const ChangeRateList({required this.status});
}

/// Событие смены типа сортировки списка
class ChangeSortBy extends RateScreenEvent {
  final SortBy sortBy;
  final bool isSortAscending;

  const ChangeSortBy({required this.sortBy, required this.isSortAscending});
}

/// Событие поиска по списку
class SearchInRateList extends RateScreenEvent {
  final String searchValue;

  const SearchInRateList({required this.searchValue});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class RateScreenState {
  const RateScreenState();
}

/// Загрузка данных
class RateLoading extends RateScreenState {
  const RateLoading();
}

/// Данные загружены
class RateLoaded extends RateScreenState {
  final Map<RateStatus, int> animeRateSize;
  final RateStatus rateStatus;
  final List<RateModel> list;
  final SortBy sortBy;
  final bool isSortAscending;

  const RateLoaded({
    required this.animeRateSize,
    required this.rateStatus,
    required this.list,
    required this.sortBy,
    required this.isSortAscending
  });
}

/// Ошибка загрузки данных
class RateError extends RateScreenState {
  const RateError();
}

/// Не найдено в списке
class SearchRateEmpty extends RateScreenState {
  const SearchRateEmpty();
}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class RateScreenBloc extends Bloc<RateScreenEvent, RateScreenState> {
  final UserInteractor userInteractor;
  final UserLocalInteractor userLocalInteractor;
  final SharedPreferencesProvider prefs;

  /// список аниме/манги для показа
  List<RateModel> _showList = [];

  /// словарь пользовательского статуса произведения и модели данных произведения
  final Map<RateStatus, List<RateModel>> _animeMap = {};

  /// количество аниме в каждой категории
  final Map<RateStatus, int> _animeRateSize = {
    RateStatus.watching: 0,
    RateStatus.planned: 0,
    RateStatus.completed: 0,
    RateStatus.onHold: 0,
    RateStatus.dropped: 0,
  };

  /// выбранный пользовательский статуса для списка аниме (Запланировано, Просмотрено)
  RateStatus animeRateStatus = RateStatus.planned;

  /// список с типами сортировки для выпадающего меню
  List<SortBy> sortByTitles = SortBy.values.filter((item) {
    return item != SortBy.byChapters;
  });

  /// тип сортировки списка (По названию, по оценке)
  SortBy _sortBy = SortBy.byName;

  /// поиск по возрастанию/убыванию
  bool _isSortAscend = true;

  /// поиск названия аниме/манги
  String? searchTitleName = '';

  /// список аниме для показа статуса в календаре
  List<RateModel> animeRatesForCalendar = [];

  RateScreenBloc(
      {required this.userInteractor,
      required this.userLocalInteractor,
      required this.prefs}) : super(const RateLoading()) {

    /// старт загрузки
    on<LoadRates>((event, emit) async {
      emit(const RateLoading());

      await _loadRatesSize();

      await _loadRates();

      _sortBy = (await prefs.getString(key: sortByKey, defaultValue: SortBy.byName.toScreenString())).toSortBy();

      _isSortAscend = await prefs.getBoolean(key: sortAscendDescendKey, defaultValue: true);

      animeRateStatus = (await prefs.getString(key: selectedAnimeRateStatusKey, defaultValue: RateStatus.planned.toAnimePresentationString())).toAnimeRateStatus();

      await _changeRateList(status: animeRateStatus);

      await _sortListByOrder();

      emit(RateLoaded(animeRateSize: _animeRateSize, rateStatus: animeRateStatus, list: _showList, sortBy: _sortBy, isSortAscending: _isSortAscend));
    });

    /// изменение типа списка
    on<ChangeRateList>((event, emit) async {

      await prefs.putString(key: selectedAnimeRateStatusKey, string: event.status.toAnimePresentationString());

      await _changeRateList(status: event.status);

      await _sortListByOrder();

      await searchInList(value: searchTitleName);
      if (_showList.isNotEmpty) {
        await _sortListByOrder();
        emit(RateLoaded(animeRateSize: _animeRateSize, rateStatus: animeRateStatus, list: _showList, sortBy: _sortBy, isSortAscending: _isSortAscend));
      } else {
        emit(const SearchRateEmpty());
      }

      // emit(RateLoaded(animeRateSize: _animeRateSize, rateStatus: animeRateStatus, list: _showList, sortBy: _sortBy, isSortAscending: _isSortAscend));
    });

    /// изменение типа сортировки списка
    on<ChangeSortBy>((event, emit) async {
      _sortBy = event.sortBy;
      await prefs.putString(key: sortByKey, string: event.sortBy.toScreenString());

      _isSortAscend = event.isSortAscending;
      await prefs.putBoolean(key: sortAscendDescendKey, boolean: event.isSortAscending);

      await _sortListByOrder();

      emit(RateLoaded(animeRateSize: _animeRateSize, rateStatus: animeRateStatus, list: _showList, sortBy: _sortBy, isSortAscending: _isSortAscend));
    });

    /// поиск по списку
    on<SearchInRateList>((event, emit) async {
      searchTitleName = event.searchValue;
      await searchInList(value: event.searchValue);

      if (_showList.isNotEmpty) {
        await _sortListByOrder();
        emit(RateLoaded(animeRateSize: _animeRateSize, rateStatus: animeRateStatus, list: _showList, sortBy: _sortBy, isSortAscending: _isSortAscend));
      } else {
        emit(const SearchRateEmpty());
      }
    });
  }

  /// Загрузка размера списков
  Future<void> _loadRatesSize() async {
    try {
      final userId = await userLocalInteractor.getUserId();

      final ratesSize = await userInteractor.getUserProfileById(id: userId);

      ratesSize.fold((failure) {
        _loadRatesSize();
      }, (sizes) {
        // _animeRateSize.clear();

        sizes.stats?.fullStatuses?.anime?.let((stats) {
          for (var i in stats) {
            if ((i.size ?? 0) > 0) {
              _animeRateSize[i.name ?? RateStatus.planned] = i.size ?? 0;
            } else {
              _animeRateSize.remove(i.name);
            }
          }
        });

        _animeRateSize.keys.firstOrNull?.let((it) {
          animeRateStatus = it;
        });
      });
    } catch (e) {
      _loadRatesSize();
    }
  }

  /// Загрузка списов пользователя
  Future<void> _loadRates({int page = 1}) async {
    try {
      final userId = await userLocalInteractor.getUserId();

      final ratesResponse = await userInteractor.getUserAnimeRates(
          id: userId, page: page, limit: 5000);

      ratesResponse.fold((failure) {
        _loadRates(page: page);
      }, (rates) {
        animeRatesForCalendar = rates;

        _animeMap.clear();

        for (var i in rates) {
          if (_animeMap.containsKey(i.status) == false) {
            _animeMap[i.status ?? RateStatus.planned] = [i];
          } else {
            if (_animeMap[i.status]?.contains(i) == false) {
              _animeMap[i.status]?.add(i);
            }
          }
        }
      });
    } catch (e) {
      _loadRates(page: page);
    }
  }

  /// Смена списка
  /// [status] статус просмотра
  Future<void> _changeRateList({required RateStatus status}) async {
    if (_animeRateSize.keys.contains(status)) {
      animeRateStatus = status;
      _animeMap[status]?.let((it) {
        _showList = it;
      });
    }
  }

  /// Отсортировать список
  Future<void> _sortListByOrder() async {

    if (_sortBy == SortBy.byName) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.anime?.nameRu ?? '');
    }

    if (_sortBy == SortBy.byProgress) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.anime?.episodes ?? 0);
    }

    if (_sortBy == SortBy.byReleaseDate) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.anime?.dateReleased ?? i.anime?.dateAired ?? '');
    }

    if (_sortBy == SortBy.byAddDate) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.createdDateTime ?? '');
    }

    if (_sortBy == SortBy.byRefreshDate) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.updatedDateTime ?? '');
    }

    if (_sortBy == SortBy.byScore) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.anime?.score ?? '');
    }

    if (_sortBy == SortBy.byEpisodes) {
      _showList = _showList.sortedByAscendDescend(ascending: _isSortAscend, key: (i) => i.anime?.episodes ?? 0);
    }
  }

  /// Найти элемент в списке по имени
  Future<void> searchInList({required String? value}) async {
    if (value == null && value?.isEmpty == true) {
      _showList = _animeMap[animeRateStatus] ?? [];
    } else {
      _showList = (_animeMap[animeRateStatus] ?? []).filter((item) {
        return
          item.anime?.nameRu?.toLowerCase().contains(value?.toLowerCase() ?? '') == true ||
              item.anime?.name?.toLowerCase().contains(value?.toLowerCase() ?? '') == true;
      });
    }
  }
}
