import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/ListIsEmpty.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/ErrorScreen.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BaseTextFrom.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import '../../../domain/models/myanimelist/AnimeMalModel.dart';
import '../../../ui/AssetsPath.dart';
import '../../../utils/StringExtensions.dart';
import '../../screens_bloc/mal/CalendarMalBloc.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Календаря с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class CalendarMalContainer extends StatelessWidget {
  const CalendarMalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("CalendarMal"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => BlocProvider<CalendarMalScreenBloc>(
              create: (context) => diProvider<CalendarMalScreenBloc>(),
              child: const _CalendarScreenBlocProvider(),
            )
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
    final CalendarMalScreenBloc calendarBloc = context.read<CalendarMalScreenBloc>();

    return _CalendarScreen(calendarBloc: calendarBloc);
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Календаря
////////////////////////////////////////////////////////////////////////////////
class _CalendarScreen extends StatefulWidget {
  final CalendarMalScreenBloc calendarBloc;

  const _CalendarScreen({super.key, required this.calendarBloc});

  @override
  State<_CalendarScreen> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<_CalendarScreen> {

  @override
  void initState() {
    super.initState();
    widget.calendarBloc.add(LoadCalendar());
  }

  @override
  Widget build(BuildContext context) {
    final CalendarMalScreenBloc calendarBloc = widget.calendarBloc;

    return BlocBuilder<CalendarMalScreenBloc, CalendarMalScreenState>(
        bloc: calendarBloc,
        builder: (context, state) {
          return StackTopContainer(
              topWidget: RowSearchField(
                labelText: inputTitleText,
                  backgroundAlpha: Ints.oneHundredFifty,
                  clearText: state is CalendarLoading,
                  endWidgets: [
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
                    calendar: state.animeMap,
                    block: calendarBloc,
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
                    calendar: state.animeMap,
                    block: calendarBloc,
                  );
                }

                return const Loader();
              })));
        });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Весь список с выходящим или вышедшим аниме
////////////////////////////////////////////////////////////////////////////////
class CalendarList extends StatelessWidget {
  final Map<String, List<AnimeMalModel>> calendar;
  final CalendarMalScreenBloc block;

  const CalendarList(
      {super.key,
        required this.calendar,
        required this.block});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        const SpacerSized(),
        for (var el in calendar.entries)
          RowDayAnime(
              title:
              el.key,
              animeList: el.value),
        const SpacerSized()
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список день - выходящие аниме
////////////////////////////////////////////////////////////////////////////////
class RowDayAnime extends StatelessWidget {
  final String title;
  final List<AnimeMalModel> animeList;

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
              for (var anime in animeList) CalendarMalCard(anime: anime)
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
class CalendarMalCard extends StatefulWidget {
  final AnimeMalModel anime;

  const CalendarMalCard({super.key, required this.anime});

  @override
  State<StatefulWidget> createState() {
    return _CalendarMalCard();
  }
}

class _CalendarMalCard extends State<CalendarMalCard> {

  void navigate() {
    navigateAnimeDetailsMalScreen(id: widget.anime.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ElementCard(
      imageUrl: widget.anime.image?.large,
      overPicture: OverPictureOne(
          leftTopText: widget.anime.broadcast?.startTime
      ),
      titleText: getEmptyIfBothNull(
          widget.anime.title, widget.anime.alternativeTitles?.ja),
      secondTextTwo: "${widget.anime.episodes} эп.",
      onImageClick: () {
        navigate();
      },
      onTextClick: () {
        navigate();
      },
      info: InfoColumn(
        status: widget.anime.status,
        score: widget.anime.score.toString(),
        episodes: widget.anime.episodes,
        dateAired: widget.anime.dateAired,
        dateReleased: widget.anime.dateReleased,
        isMal: true,
      ),
    );
  }
}
