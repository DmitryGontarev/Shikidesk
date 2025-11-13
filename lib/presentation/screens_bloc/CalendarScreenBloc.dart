
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';
import '../../domain/interactors/CalendarInteractor.dart';
import '../../domain/models/calendar/CalendarModel.dart';
import '../../utils/StringExtensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarScreenEvent {
  const CalendarScreenEvent();
}

/// Событие старта загрузки
class LoadCalendar extends CalendarScreenEvent {}

/// Событие поиска по названию в календаре
class SearchCalendarAnime extends CalendarScreenEvent {
  final String searchTitle;

  const SearchCalendarAnime(this.searchTitle);
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarScreenState {
  const CalendarScreenState();
}

/// Загрузка данных
class CalendarLoading extends CalendarScreenState {
  const CalendarLoading();
}

/// Данные загружены
class CalendarLoaded extends CalendarScreenState {
  final List<CalendarModel> releasedToday;
  final Map<DateTime, List<CalendarModel>> animeMap;

  const CalendarLoaded({required this.releasedToday, required this.animeMap});
}

/// Ошибка загрузки данных
class CalendarError extends CalendarScreenState {
  final int? errorCode;

  const CalendarError({this.errorCode});
}

/// По строке поиска ничего не найдено
class SearchEmpty extends CalendarScreenState {
  final List<CalendarModel> releasedToday;
  final Map<DateTime, List<CalendarModel>> animeMap;

  const SearchEmpty(this.releasedToday, this.animeMap);
}

/// По строке поиска найдены элементы
class SearchNotEmpty extends CalendarScreenState {
  final List<CalendarModel> releasedToday;
  final Map<DateTime, List<CalendarModel>> animeMap;

  const SearchNotEmpty(this.releasedToday, this.animeMap);
}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class CalendarScreenBloc extends Bloc<CalendarScreenEvent, CalendarScreenState> {
  final CalendarInteractor calendarInteractor;

  List<AnimeModel> calendarAnimeList = [];

  final List<CalendarModel> _releasedToday = [];
  final Map<DateTime, List<CalendarModel>> _animeMap = {};

  final List<CalendarModel> _searchToday = [];
  final Map<DateTime, List<CalendarModel>> _searchMap = {};

  CalendarScreenBloc({required this.calendarInteractor})
      : super(const CalendarLoading()) {

    /// Загрузка данных
    on<LoadCalendar>((event, emit) async {
      emit(const CalendarLoading());
      await _loadData((state) {
        emit(state);
      });
    });

    /// Поиск по календарю
    on<SearchCalendarAnime>((event, emit) async {
      _searchInCalendar(event.searchTitle, (state) {
        emit(state);
      });
    });
  }

  /// Загрузка данных Календаря
  Future<void> _loadData(Function(CalendarScreenState state) state) async {
    try {
      final calendar = await calendarInteractor.getCalendar();
      calendar.fold((failure) {
        state(CalendarError(errorCode: failure.code));
      }, (calendarList) {
        _calendarToMap(calendarList.orEmptyList());
        state(
            CalendarLoaded(releasedToday: _releasedToday, animeMap: _animeMap));
      });
    } catch (e) {
      state(CalendarError(errorCode: e.hashCode));
    }
  }

  void _calendarToMap(List<CalendarModel> calendar) async {
    final DateTime currentTime = DateTime.now();

    List<AnimeModel> animeList = [];

    _releasedToday.clear();
    _animeMap.clear();

    for (var calendarModel in calendar) {

      if (calendarModel.anime != null) {
        animeList.add(calendarModel.anime!);
      }

      calendarModel.nextEpisodeDate.fromString()?.let((nextEpisodeDate) {
        if (currentTime.isAfter(nextEpisodeDate)) {
          _releasedToday.add(calendarModel);
        } else {
          if (_animeMap.containsKey(nextEpisodeDate.toStartDay())) {
            _animeMap[nextEpisodeDate.toStartDay()]?.add(calendarModel);
          } else {
            _animeMap[nextEpisodeDate.toStartDay()] = [calendarModel];
          }
        }
      });
    }

    calendarAnimeList = animeList;
  }

  void _searchInCalendar(String input, Function(CalendarScreenState state) state) {
    _searchToday.clear();
    _searchMap.clear();
    if (input.isNotEmpty) {
      for (var element in _releasedToday) {
        if (containsIgnoreCase(element.anime?.name, input) ||
            containsIgnoreCase(element.anime?.nameRu, input)
        ) {
          _searchToday.add(element);
        }
      }

      _animeMap.forEach((key, value) {
        for (var element in value) {
          if (containsIgnoreCase(element.anime?.name, input) ||
              containsIgnoreCase(element.anime?.nameRu, input)
          ) {
            if (_searchMap.containsKey(key)) {
              _searchMap[key]?.add(element);
            } else {
              _searchMap[key] = [element];
            }
          }
        }
      });

      if (_searchToday.isEmpty && _searchMap.isEmpty) {
        state(SearchEmpty(_searchToday, _searchMap));
      } else {
        state(
            SearchNotEmpty(_searchToday, _searchMap));
      }
    } else {
      state(SearchNotEmpty(_releasedToday, _animeMap));
    }
  }
}
