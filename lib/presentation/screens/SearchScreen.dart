import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/presentation/screens_bloc/SearchScreenBloc.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BaseTextFrom.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../ui/AssetsPath.dart';
import '../../ui/Sizes.dart';
import '../../ui/components/RoundedIconButton.dart';
import '../items/SearchCard.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Поиск с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("Search"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => BlocProvider<SearchScreenBloc>(
                  create: (context) => diProvider<SearchScreenBloc>(),
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
    final SearchScreenBloc searchBloc = context.read<SearchScreenBloc>();

    return SearchScreen(searchBloc: searchBloc);
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Поиска
////////////////////////////////////////////////////////////////////////////////
class SearchScreen extends StatefulWidget {
  final SearchScreenBloc searchBloc;

  const SearchScreen({super.key, required this.searchBloc});

  @override
  State<StatefulWidget> createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends State<SearchScreen> {

  /// высота поля поиска
  double searchHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.searchBloc.add(LoadSearch(page: widget.searchBloc.nextPage));
  }

  @override
  Widget build(BuildContext context) {
    final SearchScreenBloc searchBloc = widget.searchBloc;

    return BlocBuilder<SearchScreenBloc, SearchScreenState>(
        bloc: searchBloc,
        builder: (context, state) {
          return StackTopContainer(
            spacer: (height) {
              setState(() {
                searchHeight = height;
              });
            },
              topWidget: RowSearchField(
                  labelText: searchByTitleText,
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
                          searchBloc.add(const RefreshSearch());
                        })
                  ],
                  changedCallback: (t) {
                    if (t.isNullOrEmpty()) {
                      searchBloc.add(SearchByTitle(text: t));
                    }
                  },
                  submitCallback: (t) {
                    searchBloc.add(SearchByTitle(text: t));
                  }),
              mainWidget: Builder(builder: ((context) {
                return SearchList(searchBloc: searchBloc, spacer: searchHeight);
              })));
        });
  }
}

class SearchList extends StatefulWidget {
  final SearchScreenBloc searchBloc;
  final double spacer;

  const SearchList({super.key, required this.searchBloc, required this.spacer});

  @override
  State<StatefulWidget> createState() {
    return _SearchList();
  }
}

class _SearchList extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: widget.spacer, bottom: widget.spacer),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisExtent: 400,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: widget.searchBloc.animeSearch.length,
      itemBuilder: (BuildContext context, index) {
        if (index == widget.searchBloc.animeSearch.length - 1 &&
            !widget.searchBloc.endReached) {
          widget.searchBloc.nextPage += 1;
          widget.searchBloc.add(LoadSearch(page: widget.searchBloc.nextPage));
        }
        return SearchAnimeCard(anime: widget.searchBloc.animeSearch[index]);
      },
    );
  }
}
