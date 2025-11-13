import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/interactors/MyAnimeListInteractor.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';

import '../../../utils/StringExtensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarMalScreenEvent {
  const CalendarMalScreenEvent();
}

/// Событие старта загрузки
class LoadCalendar extends CalendarMalScreenEvent {}

/// Событие поиска по названию в календаре
class SearchCalendarAnime extends CalendarMalScreenEvent {
  final String searchTitle;

  const SearchCalendarAnime(this.searchTitle);
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarMalScreenState {
  const CalendarMalScreenState();
}

/// Загрузка данных
class CalendarLoading extends CalendarMalScreenState {
  const CalendarLoading();
}

/// Данные загружены
class CalendarLoaded extends CalendarMalScreenState {
  final Map<String, List<AnimeMalModel>> animeMap;

  const CalendarLoaded({required this.animeMap});
}

/// Ошибка загрузки данных
class CalendarError extends CalendarMalScreenState {
  final int? errorCode;

  const CalendarError({this.errorCode});
}

/// По строке поиска ничего не найдено
class SearchEmpty extends CalendarMalScreenState {
  final Map<String, List<AnimeMalModel>> animeMap;

  const SearchEmpty(this.animeMap);
}

/// По строке поиска найдены элементы
class SearchNotEmpty extends CalendarMalScreenState {
  final Map<String, List<AnimeMalModel>> animeMap;

  const SearchNotEmpty(this.animeMap);
}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class CalendarMalScreenBloc
    extends Bloc<CalendarMalScreenEvent, CalendarMalScreenState> {
  final MyAnimeListInteractor calendarInteractor;

  final Map<String, List<AnimeMalModel>> _animeMap = {};

  final Map<String, List<AnimeMalModel>> _searchMap = {};

  static const String searchFields =
      "start_date, end_date, media_type, status, num_episodes, mean, broadcast";

  CalendarMalScreenBloc({required this.calendarInteractor})
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

  Future<void> _loadData(Function(CalendarMalScreenState state) state) async {
    try {
      final calendar = await calendarInteractor.getAnimeRankingList(
          rankingType: RankingType.airing, limit: 500, fields: searchFields);
      calendar.fold((failure) {
        state(CalendarError(errorCode: failure.code));
      }, (calendarList) {
        _calendarToMap(calendarList.orEmptyList());
        state(CalendarLoaded(animeMap: _animeMap));
      });
    } catch (e) {
      state(CalendarError(errorCode: e.hashCode));
    }
  }

  void _calendarToMap(List<AnimeMalModel> calendar) async {
    int currentDayNumber = getCurrentTime().weekday;
    _animeMap.clear();

    Map<int, List<AnimeMalModel>> map = {};

    for (var anime in calendar) {
      int key = dayNameToInt(dayName: anime.broadcast?.dayOfTheWeek);
      if (map.containsKey(key)) {
        map[key]?.add(anime);
      } else {
        key.let((day) {
          map[day] = [anime];
        });
      }
    }

    // удаляем элементы списка, которые не содержат время выхода
    map.remove(0);

    // сортировка ключей словаря по возрастанию
    List<int> sortKeys = map.keys.toList()..sort();

    // индекс текущего дня в отсортированном списке
    int indexOfCurrentDay = sortKeys.indexOf(currentDayNumber);

    // индекс последнего дня в отсортированном списке
    int indexOfLastDay = sortKeys.indexOf(sortKeys.last);

    // отсортированный от текущего дня словарь
    Map<String, List<AnimeMalModel>> sortMap = {};

    void setSortMapKeys(List<int> keys) {
      for (int i in keys) {
        if (i == currentDayNumber) {
          map[i]?.let((it) {
            sortMap["${i.toDayName()}, ${getCurrentTime().day} ${getCurrentTime().toMonthName(infinitive: false)}"] =
                it;
          });
        } else {
          map[i]?.let((it) {
            sortMap[i.toDayName()] = it;
          });
        }
      }
    }

    if (indexOfCurrentDay == 0) {
      setSortMapKeys(sortKeys);
    }

    // список с сортировкой от текущего дня
    List<int> sortByDaysKeys = [];

    if (indexOfCurrentDay == indexOfLastDay) {
      // добавляем номер текущего дня
      sortByDaysKeys.add(sortKeys[indexOfCurrentDay]);

      // добавляем номера дней из списка перед текущим
      sortByDaysKeys.addAll(sortKeys.getRange(0, indexOfCurrentDay));

      setSortMapKeys(sortByDaysKeys);
    }

    if (indexOfCurrentDay != 0 && indexOfCurrentDay != indexOfLastDay) {
      // добавляем номер текущего дня
      sortByDaysKeys.add(sortKeys[indexOfCurrentDay]);

      // добавляем номера дней из списка после текущего
      sortByDaysKeys
          .addAll(sortKeys.getRange(indexOfCurrentDay + 1, sortKeys.length));

      // добавляем номера дней из списка перед текущим
      sortByDaysKeys.addAll(sortKeys.getRange(0, indexOfCurrentDay));

      setSortMapKeys(sortByDaysKeys);
    }

    _animeMap.addAll(sortMap);
  }

  void _searchInCalendar(
      String input, Function(CalendarMalScreenState state) state) {
    _searchMap.clear();
    if (input.isNotEmpty) {
      _animeMap.forEach((key, value) {
        for (var element in value) {
          if (containsIgnoreCase(element.title, input) ||
              containsIgnoreCase(element.alternativeTitles?.en, input)) {
            if (_searchMap.containsKey(key)) {
              _searchMap[key]?.add(element);
            } else {
              _searchMap[key] = [element];
            }
          }
        }
      });

      if (_searchMap.isEmpty) {
        state(SearchEmpty(_searchMap));
      } else {
        state(SearchNotEmpty(_searchMap));
      }
    } else {
      state(SearchNotEmpty(_animeMap));
    }
  }

  int dayNameToInt({required String? dayName}) {
    switch (dayName) {
      case "monday":
        return 1;
      case "tuesday":
        return 2;
      case "wednesday":
        return 3;
      case "thursday":
        return 4;
      case "friday":
        return 5;
      case "saturday":
        return 6;
      case "sunday":
        return 7;
      default:
        return 0;
    }
  }
}
