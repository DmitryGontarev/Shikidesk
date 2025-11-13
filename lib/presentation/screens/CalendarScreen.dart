import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/ListIsEmpty.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/ErrorScreen.dart';
import 'package:shikidesk/presentation/screens_bloc/RateScreenBloc.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BaseTextFrom.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';
import '../../domain/models/calendar/CalendarModel.dart';
import '../../domain/models/rates/RateModel.dart';
import '../../ui/AssetsPath.dart';
import '../../utils/StringExtensions.dart';
import '../screens_bloc/CalendarScreenBloc.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Календаря с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class CalendarContainer extends StatelessWidget {
  const CalendarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("Calendar"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<CalendarScreenBloc>(
                      create: (context) => diProvider<CalendarScreenBloc>()),
                  BlocProvider<RateScreenBloc>(
                      create: (context) => diProvider<RateScreenBloc>()),
                ], child: const _CalendarScreenBlocProvider())
            ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть CalendarScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _CalendarScreenBlocProvider extends StatelessWidget {
  const _CalendarScreenBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarScreenBloc calendarBloc = context.read<CalendarScreenBloc>();
    final RateScreenBloc rateBloc = context.read<RateScreenBloc>();

    return _CalendarScreen(calendarBloc: calendarBloc, rateBloc: rateBloc);
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Календаря
////////////////////////////////////////////////////////////////////////////////
class _CalendarScreen extends StatefulWidget {
  final CalendarScreenBloc calendarBloc;
  final RateScreenBloc rateBloc;

  const _CalendarScreen(
      {super.key, required this.calendarBloc, required this.rateBloc});

  @override
  State<_CalendarScreen> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<_CalendarScreen> {
  /// высота поля поиска
  double searchHeight = 0;

  List<RateModel> rateList = [];

  List<CalendarModel> released = [];
  Map<DateTime, List<CalendarModel>> map = {};

  /// Функция установки списка пользовательского рейтинга с аниме из календаря
  Future<void> setRateList({required List<AnimeModel> list}) async {
    List<RateModel> rates = [];

    for (AnimeModel calendarAnime in list) {
      if (calendarAnime.id != null) {
        widget.rateBloc.animeRatesForCalendar.find((rate) {
          return calendarAnime.id == rate.anime?.id;
        })?.let((it) => {
              if (!rates.contains(it)) {rates.add(it)}
            });
      }
    }

    setState(() {
      rateList = rates;
    });
  }

  /// функция получения горизонтального списка Календаря с учётом списка пользователя
  /// [itemList] элементы горизонтального списка
  Future<List<CalendarModel>> getCalendarRow(
      {required List<CalendarModel> itemList}) async {
    List<CalendarModel> calendarRow = [];

    if (rateList.isNotEmpty) {
      // аниме, которые есть в списках пользователя
      List<CalendarModel> rates = [];

      // список остальных аниме
      List<CalendarModel> others = [];

      int ratesListSize = rateList.length;

      for (CalendarModel calendarModel in itemList) {
        // цикл для добавления аниме в список пользователя
        for (int index = 0; index < ratesListSize; index++) {
          RateModel rate = rateList[index];

          if (calendarModel.anime?.id == rate.anime?.id) {
            if (!rates.contains(calendarModel)) {
              CalendarModel calendarModelWithStatus = CalendarModel(
                  nextEpisode: calendarModel.nextEpisode,
                  nextEpisodeDate: calendarModel.nextEpisodeDate,
                  duration: calendarModel.duration,
                  anime: calendarModel.anime,
                  status: rate.status);
              rates.add(calendarModelWithStatus);
            }
          }
        }

        // после конца внутреннего цикла добавляем данные во второй список,
        // если они не были добавлены в первый список
        if (!rates.contains(calendarModel)) {
          if (!others.contains(calendarModel)) {
            others.add(calendarModel);
          }
        }
      }

      calendarRow.addAll(rates);
      calendarRow.addAll(others);
    }

    if (calendarRow.isEmpty) {
      return itemList;
    } else {
      return calendarRow;
    }
  }

  /// функция получения горизонтального списка из словаря
  /// [map] словарь дата-список
  Future<Map<DateTime, List<CalendarModel>>> getRowMap(
      {required Map<DateTime, List<CalendarModel>> map}) async {
    final Map<DateTime, List<CalendarModel>> animeMap = {};

    map.forEach((key, value) async {
      animeMap[key] = await getCalendarRow(itemList: value);
    });

    return animeMap;
  }

  @override
  void initState() {
    super.initState();
    widget.calendarBloc.add(LoadCalendar());
  }

  @override
  Widget build(BuildContext context) {
    final CalendarScreenBloc calendarBloc = widget.calendarBloc;
    final RateScreenBloc rateBlock = widget.rateBloc;

    // Испольуется слушатель двух блоков,
    // так как ответ для Календаря может запаздывать
    return MultiBlocListener(
      listeners: [
        /// слушатель экрана Календарь
        BlocListener<CalendarScreenBloc, CalendarScreenState>(
            listener: (BuildContext context, CalendarScreenState state) async {
          if (state is CalendarLoaded) {
            await setRateList(list: calendarBloc.calendarAnimeList);
            released = await getCalendarRow(itemList: state.releasedToday);
            map = await getRowMap(map: state.animeMap);
            setState(() {});
          }

          if (state is SearchNotEmpty) {
            released = await getCalendarRow(itemList: state.releasedToday);
            map = await getRowMap(map: state.animeMap);
            setState(() {});
          }
        }),

        /// слушатель экрана Списки
        BlocListener<RateScreenBloc, RateScreenState>(
            listener: (BuildContext context, RateScreenState state) async {
          if (state is RateLoaded) {
            await setRateList(list: calendarBloc.calendarAnimeList);
          }
        }),
      ],
      child: BlocBuilder<CalendarScreenBloc, CalendarScreenState>(
          bloc: calendarBloc,
          builder: (context, state) {
            return StackTopContainer(
                spacer: (height) {
                  setState(() {
                    searchHeight = height;
                  });
                },
                topWidget: RowSearchField(
                    labelText: inputTitleText,
                    backgroundAlpha: Ints.oneHundredFifty,
                    clearText: state is CalendarLoading,
                    endWidgets: [
                      /// кнопка обновления
                      RoundedIconButton(
                          backgroundAlpha: Ints.oneHundredFifty,
                          imagePath: iconReload,
                          onClick: () {
                            calendarBloc.add(LoadCalendar());
                          })
                    ],
                    changedCallback: (t) {
                      calendarBloc.add(SearchCalendarAnime(t));
                    },
                    submitCallback: (t) {
                      // block.add(SearchCalendarAnime(t));
                    }),
                mainWidget: Builder(builder: ((context) {
                  if (state is CalendarLoading) {
                    return const Loader();
                  }

                  if (state is CalendarLoaded) {
                    return CalendarList(
                      releasedToday: released,
                      calendar: map,
                      calendarBlock: calendarBloc,
                      rateBlock: rateBlock,
                      spacer: searchHeight,
                    );
                  }

                  if (state is CalendarError) {
                    return ErrorScreen(
                      errorCode: state.errorCode,
                      showBackButton: false,
                      mainCallback: () {
                        calendarBloc.add(LoadCalendar());
                      },
                    );
                  }

                  if (state is SearchEmpty) {
                    return const ListIsEmpty();
                  }

                  if (state is SearchNotEmpty) {
                    return CalendarList(
                      releasedToday: released,
                      calendar: map,
                      calendarBlock: calendarBloc,
                      rateBlock: rateBlock,
                      spacer: searchHeight,
                    );
                  }

                  return const Loader();
                })));
          }),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Весь список с выходящим или вышедшим аниме
////////////////////////////////////////////////////////////////////////////////
class CalendarList extends StatefulWidget {
  final List<CalendarModel> releasedToday;
  final Map<DateTime, List<CalendarModel>> calendar;
  final CalendarScreenBloc calendarBlock;
  final RateScreenBloc rateBlock;
  final double spacer;

  const CalendarList(
      {super.key,
      required this.releasedToday,
      required this.calendar,
      required this.calendarBlock,
      required this.rateBlock,
      required this.spacer});

  @override
  State<StatefulWidget> createState() {
    return _CalendarListState();
  }
}

class _CalendarListState extends State<CalendarList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: widget.spacer),
      shrinkWrap: true,
      children: <Widget>[
        SpacerSized(height: widget.spacer),
        if (widget.releasedToday.isNotEmpty) ...{
          RowDayAnime(title: releasedText, animeList: widget.releasedToday)
        },
        for (var el in widget.calendar.entries) ...{
          RowDayAnime(
              title:
                  "${el.key.toDayName()}, ${el.key.day} ${el.key.toMonthName(infinitive: false)}",
              animeList: el.value)
        }
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список день - выходящие аниме
////////////////////////////////////////////////////////////////////////////////
class RowDayAnime extends StatelessWidget {
  final String title;
  final List<CalendarModel> animeList;

  const RowDayAnime({super.key, required this.title, required this.animeList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaddingAll(
            all: Doubles.thirty,
            child: MyTextBold(
              text: title,
              fontSize: TextSize.big,
            )),
        SizedBox(
          height: ImageSizes.horizontalCardHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              for (var anime in animeList) CalendarCard(model: anime)
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onBackground,
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Карточка элемента календаря
////////////////////////////////////////////////////////////////////////////////
class CalendarCard extends StatefulWidget {
  final CalendarModel model;

  const CalendarCard({super.key, required this.model});

  @override
  State<StatefulWidget> createState() {
    return _CalendarCard();
  }
}

class _CalendarCard extends State<CalendarCard> {
  var isExpanded = false;

  /// текущее время
  var currentTime = getCurrentTime();

  @override
  Widget build(BuildContext context) {
    /// время эпизода
    var nextEpisodeDate =
        widget.model.nextEpisodeDate.fromString() ?? currentTime;

    void navigate() {
      navigateAnimeDetailsScreen(id: widget.model.anime?.id, context: context);
    }

    return ElementCard(
      imageUrl: widget.model.anime?.image?.original,
      overPicture: CalendarOverPicture(
          leftTopText:
              widget.model.nextEpisodeDate.fromString()?.isAfter(currentTime) ==
                      true
                  ? widget.model.nextEpisodeDate.formatDate(pattern: HH_mm)
                  : null,
          rateStatusTopCorner: widget.model.status),
      titleText: getEmptyIfBothNull(
          widget.model.anime?.nameRu, widget.model.anime?.name),
      secondTextOne: "${widget.model.nextEpisode} эп.",
      secondTextTwo: nextEpisodeDate.isAfter(currentTime)
          ? widget.model.nextEpisodeDate.getDateBeforeCurrent()
          : null,
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.model.anime?.status,
        score: widget.model.anime?.score,
        episodes: widget.model.anime?.episodes,
        episodesAired: widget.model.anime?.episodesAired,
        dateAired: widget.model.anime?.dateAired,
        dateReleased: widget.model.anime?.dateReleased,
      ),
    );
  }
}
