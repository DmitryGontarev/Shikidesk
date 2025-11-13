import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../../di/DiProvider.dart';
import '../../../ui/AssetsPath.dart';
import '../../../ui/Sizes.dart';
import '../../../ui/Strings.dart';
import '../../../ui/components/BaseTextFrom.dart';
import '../../../ui/components/Loader.dart';
import '../../../ui/components/Paddings.dart';
import '../../../ui/components/RoundedIconButton.dart';
import '../../../ui/components/StackTopContainer.dart';
import '../../items/SearchCard.dart';
import '../../screens_bloc/mal/SearchMalBloc.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Поиск с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class SearchMalContainer extends StatelessWidget {
  const SearchMalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("SearchMal"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => BlocProvider<SearchMalScreenBloc>(
                  create: (context) => diProvider<SearchMalScreenBloc>(),
                  child: const _SearchScreenBlocProvider(),
                )),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть SearchScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _SearchScreenBlocProvider extends StatelessWidget {
  const _SearchScreenBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchMalScreenBloc searchBloc = context.read<SearchMalScreenBloc>();

    return SearchScreen(searchBloc: searchBloc);
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Поиска
////////////////////////////////////////////////////////////////////////////////
class SearchScreen extends StatefulWidget {
  final SearchMalScreenBloc searchBloc;

  const SearchScreen({super.key, required this.searchBloc});

  @override
  State<StatefulWidget> createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends State<SearchScreen> {
  String labelString = searchByTitleText;
  bool isError = false;

  void setLabelText(String? text) {
    if (text.orEmpty().length >= 3) {
      labelString = searchByTitleText;
      isError = false;
    } else {
      labelString = minThreeSymbolsErrorText;
      isError = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.searchBloc.add(LoadSearch(page: widget.searchBloc.nextPage));
  }

  @override
  Widget build(BuildContext context) {
    final SearchMalScreenBloc searchBloc = widget.searchBloc;

    return BlocBuilder<SearchMalScreenBloc, SearchMalScreenState>(
        bloc: searchBloc,
        builder: (context, state) {
          return StackTopContainer(
              topWidget: RowSearchField(
                  labelText: labelString,
                  isError: isError,
                  backgroundAlpha: Ints.oneHundredFifty,
                  clearText: searchBloc.searchValue.isNullOrEmpty(),
                  startWidgets: [
                    if (state is SearchLoading)
                      const PaddingBySide(
                          end: Doubles.fourteen,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Loader(),
                          ))
                  ],
                  endWidgets: [
                    RoundedIconButton(
                        backgroundAlpha: Ints.oneHundredFifty,
                        imagePath: iconReload,
                        onClick: () {
                          setLabelText("text");
                          searchBloc.add(const RefreshSearch());
                        })
                  ],
                  changedCallback: (t) {
                    if (t.isNullOrEmpty()) {
                      setLabelText("text");
                      searchBloc.add(SearchByTitle(text: t));
                    }
                  },
                  submitCallback: (t) {
                    if (t.trim().length >= 3) {
                      searchBloc.add(SearchByTitle(text: t));
                    }
                    setLabelText(t);
                  }),
              mainWidget: Builder(builder: ((context) {
                return SearchList(searchBloc: searchBloc);
              })));
        });
  }
}

class SearchList extends StatefulWidget {
  final SearchMalScreenBloc searchBloc;

  const SearchList({super.key, required this.searchBloc});

  @override
  State<StatefulWidget> createState() {
    return _SearchList();
  }
}

class _SearchList extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisExtent: 500,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: widget.searchBloc.animeSearch.length,
      itemBuilder: (BuildContext context, index) {
        // if (index == widget.searchBloc.animeSearch.length - 1 &&
        //     !widget.searchBloc.endReached) {
        //   widget.searchBloc.nextPage += 1;
        //   widget.searchBloc.add(LoadSearch(page: widget.searchBloc.nextPage));
        // }
        return SearchAnimeMalCard(anime: widget.searchBloc.animeSearch[index]);
      },
    );
  }
}
