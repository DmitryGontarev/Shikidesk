import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/domain/models/rates/SortBy.dart';
import 'package:shikidesk/presentation/converters/EnumToPresentation.dart';
import 'package:shikidesk/presentation/items/AnimeRateCard.dart';
import 'package:shikidesk/presentation/items/ContainerColor.dart';
import 'package:shikidesk/presentation/items/ListIsEmpty.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/ErrorScreen.dart';
import 'package:shikidesk/presentation/screens_bloc/RateScreenBloc.dart';
import 'package:shikidesk/ui/components/BaseTextFrom.dart';
import 'package:shikidesk/ui/components/HorizontalDrawer.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/PopupMenuButtons.dart';
import 'package:shikidesk/ui/components/RoundedIconButton.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';

import '../../domain/models/rates/RateModel.dart';
import '../../domain/models/rates/RateStatus.dart';
import '../../ui/AssetsPath.dart';
import '../../ui/Sizes.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Списков с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class RateContainer extends StatelessWidget {
  const RateContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("Rate"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => BlocProvider<RateScreenBloc>(
                  create: (context) => diProvider<RateScreenBloc>(),
                  child: const _RateScreenBlocProvider(),
                )),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть CalendarScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _RateScreenBlocProvider extends StatelessWidget {
  const _RateScreenBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final RateScreenBloc rateBloc = context.read<RateScreenBloc>();

    return _RateScreen(rateBloc: rateBloc);
  }
}

const double drawerWidth = 300;

////////////////////////////////////////////////////////////////////////////////
/// Экран Списки
////////////////////////////////////////////////////////////////////////////////
class _RateScreen extends StatefulWidget {
  final RateScreenBloc rateBloc;

  const _RateScreen({super.key, required this.rateBloc});

  @override
  State<StatefulWidget> createState() {
    return _RateScreenState();
  }
}

class _RateScreenState extends State<_RateScreen> {

  /// флаг показа бокового меню
  bool isExpand = false;

  /// количество аниме в каждой категории
  Map<RateStatus, int> animeRateSize = {};

  /// выбранный пользовательский статус
  RateStatus rateStatus = RateStatus.planned;

  /// текущий пользовательский список для показа
  List<RateModel> rateList = [];

  /// тип сортировки списка (По названию, по оценке)
  SortBy sortBy = SortBy.byName;

  /// поиск по возрастанию/убыванию
  bool isSortAscending = true;

  /// высота поля поиска
  double searchHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.rateBloc.add(const LoadRates());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.rateBloc,
        listener: (BuildContext context, RateScreenState state) {
          if (state is RateLoaded) {
            setState(() {
              animeRateSize = state.animeRateSize;
              rateStatus = state.rateStatus;
              rateList = state.list;
              sortBy = state.sortBy;
              isSortAscending = state.isSortAscending;
            });
          }
        },
        child: BlocBuilder(
          bloc: widget.rateBloc,
          builder: (context, state) {
            if (state is RateError) {
              ErrorScreen(
                showBackButton: false,
                mainCallback: () {
                  widget.rateBloc.add(const LoadRates());
                },
              );
            }

            return StackTopContainer(
              spacer: (height) {
                setState(() {
                  searchHeight = height;
                });
              },
              topWidget: RowSearchField(
                clearText: false,
                backgroundAlpha: Ints.oneHundredFifty,
                changedCallback: (text) {
                  widget.rateBloc.add(SearchInRateList(searchValue: text));
                },
                submitCallback: (text) {},
                startWidgets: [
                  /// кнопка показа бокового меню
                  RoundedIconButton(
                      backgroundAlpha: Ints.oneHundredFifty,
                      imagePath: rateStatus.toRateIconPath(),
                      iconColor: rateStatus.toColor(),
                      onClick: () {
                        setState(() {
                          isExpand = !isExpand;
                        });
                      })
                ],
                endWidgets: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// кнопка обновления
                      RoundedIconButton(
                          backgroundAlpha: Ints.oneHundredFifty,
                          imagePath: iconReload,
                          onClick: () {
                            widget.rateBloc.add(const LoadRates());
                          }),

                      /// кнопка типа сортировки
                      PopupMenuTextButton(
                          buttonText: sortBy.toScreenString(),
                          menuWidgets: widget.rateBloc.sortByTitles.map((e) =>
                              MyText(
                                  text: e.toScreenString(),
                                color: e == sortBy ? Theme.of(context).colorScheme.secondary : null,
                              )).toList(),
                          callback: (index) {
                            widget.rateBloc.add(ChangeSortBy(
                                sortBy: widget.rateBloc.sortByTitles[index],
                                isSortAscending: isSortAscending
                            ));
                          }
                      ),

                      /// кнопка сортировки по убыванию/возрастанию
                      RotateIconButton(
                          backgroundAlpha: Ints.oneHundredFifty,
                          imagePath: iconArrowDown,
                          isIconRotate: isSortAscending,
                          rotateValue: 0.5,
                          onClick: () {
                            setState(() {
                              isSortAscending = !isSortAscending;
                            });
                            widget.rateBloc.add(ChangeSortBy(
                                sortBy: sortBy,
                                isSortAscending: isSortAscending
                            ));
                          }
                      )
                    ],
                  )
                ],
              ),
              mainWidget: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: HorizontalDrawer(
                    isExpand: isExpand,
                    mainWidget: _RateListSection(
                        rateBloc: widget.rateBloc, list: rateList, spacer: searchHeight),
                    drawerWidget: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: drawerWidth,
                        child: (state is RateLoading)
                            ? const SpacerSized()
                            : _RateListsDrawer(
                                rateBloc: widget.rateBloc,
                                mapSize: animeRateSize)),
                  )),
            );
          },
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Боковое меню выбора списка
////////////////////////////////////////////////////////////////////////////////
class _RateListsDrawer extends StatelessWidget {
  final RateScreenBloc rateBloc;
  final Map<RateStatus, int> mapSize;

  const _RateListsDrawer({required this.rateBloc, required this.mapSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: drawerWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i in mapSize.keys) ...{
              PaddingAll(
                child: InkWell(
                  onTap: () {
                    rateBloc.add(ChangeRateList(status: i));
                  },
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Doubles.fifty)),
                  child: ContainerColor(
                      backgroundAlpha: 20,
                      onClick: () {
                        rateBloc.add(ChangeRateList(status: i));
                      },
                      color: i == rateBloc.animeRateStatus
                          ? i.toBackgroundColor()
                          : Colors.transparent,
                      child: PaddingAll(
                        all: Doubles.fourteen,
                        child: SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageFromAsset(
                                path: i.toRateIconPath(),
                                color: i == rateBloc.animeRateStatus
                                    ? i.toColor()
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                              MyTextSemiBold(
                                  text: i.toAnimePresentationString(),
                                  color: i == rateBloc.animeRateStatus
                                      ? i.toColor()
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              MyTextSemiBold(
                                  text: "${mapSize[i]}",
                                  color: i == rateBloc.animeRateStatus
                                      ? i.toColor()
                                      : Theme.of(context).colorScheme.onPrimary)
                            ],
                          ),
                        ),
                      )),
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Основная часть экрана с пользовательским списком
////////////////////////////////////////////////////////////////////////////////
class _RateListSection extends StatefulWidget {
  final RateScreenBloc rateBloc;
  final List<RateModel> list;
  final double spacer;

  const _RateListSection({required this.rateBloc, required this.list, required this.spacer});

  @override
  State<StatefulWidget> createState() {
    return _RateListSectionState();
  }
}

class _RateListSectionState extends State<_RateListSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: widget.rateBloc,
        builder: (context, state) {
          return Builder(builder: (context) {

            if (state is RateLoading) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Loader());
            }

            if (state is SearchRateEmpty) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: const ListIsEmpty(),
                  ));
            }

            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: GridView.builder(
                padding: EdgeInsets.only(top: widget.spacer, bottom: widget.spacer),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 800,
                    mainAxisExtent: 370,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, index) {
                  return AnimeRateCard(
                      anime: widget.list[index].anime!,
                      userScore: widget.list[index].score,
                      userEpisodes: widget.list[index].episodes,
                      onClick: () {
                        navigateAnimeDetailsScreen(
                            id: widget.list[index].anime?.id, context: context);
                      });
                },
              ),
            );
          });
        });
  }
}
