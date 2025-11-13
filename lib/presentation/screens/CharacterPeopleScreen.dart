import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/domain/models/roles/PersonDetailsModel.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/presentation/items/ElementCard.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/ErrorScreen.dart';
import 'package:shikidesk/presentation/screens_bloc/CharacterPeopleScreenBloc.dart';
import 'package:shikidesk/ui/Colors.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/BackgroundImage.dart';
import 'package:shikidesk/ui/components/LabelText.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';
import 'package:shikidesk/utils/DateUtils.dart';
import 'package:shikidesk/utils/ListExtensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/manga/MangaModel.dart';
import '../../domain/models/roles/CharacterDetailsModel.dart';
import '../../domain/models/roles/CharacterModel.dart';
import '../../domain/models/roles/WorkModel.dart';
import '../../ui/AssetsPath.dart';
import '../../ui/components/ImageFromAsset.dart';
import '../../ui/components/Loader.dart';
import '../../ui/components/Paddings.dart';
import '../../ui/components/PopupMenuButtons.dart';
import '../../ui/components/RowTitleText.dart';
import '../../ui/components/SpacerSized.dart';
import '../items/AnimeCard.dart';
import '../items/DropdownMenuItem.dart';
import '../items/MangaCard.dart';
import '../navigation/NavigateByLinkType.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Информации о Персонаже или Человеке с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class CharacterPeopleContainer extends StatelessWidget {
  final CharacterPeopleScreenType screenType;
  final int? id;

  const CharacterPeopleContainer(
      {super.key, required this.screenType, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterPeopleScreenBloc>(
        create: (context) => diProvider<CharacterPeopleScreenBloc>(),
        child:
            _CharacterPeopleScreenBlocProvider(screenType: screenType, id: id));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Промежуточный виджет, чтобы прокинуть DetailsScreenBloc для вызова initState
////////////////////////////////////////////////////////////////////////////////
class _CharacterPeopleScreenBlocProvider extends StatelessWidget {
  final CharacterPeopleScreenType screenType;
  final int? id;

  const _CharacterPeopleScreenBlocProvider(
      {super.key, required this.screenType, required this.id});

  @override
  Widget build(BuildContext context) {
    final CharacterPeopleScreenBloc characterPeopleBloc =
        context.read<CharacterPeopleScreenBloc>();

    return _CharacterPeopleScreen(
        screenType: screenType,
        id: id,
        characterPeopleBloc: characterPeopleBloc);
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Детальной информации о Персонаже или Человеке
////////////////////////////////////////////////////////////////////////////////
class _CharacterPeopleScreen extends StatefulWidget {
  final CharacterPeopleScreenType screenType;
  final int? id;
  final CharacterPeopleScreenBloc characterPeopleBloc;

  const _CharacterPeopleScreen(
      {super.key,
      required this.screenType,
      required this.id,
      required this.characterPeopleBloc});

  @override
  State<StatefulWidget> createState() {
    return _CharacterPeopleScreenState();
  }
}

class _CharacterPeopleScreenState extends State<_CharacterPeopleScreen> {
  @override
  void initState() {
    super.initState();
    widget.characterPeopleBloc.add(
        LoadCharacterPeopleData(screenType: widget.screenType, id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final CharacterPeopleScreenBloc characterPeopleBloc =
        widget.characterPeopleBloc;

    return BlocBuilder<CharacterPeopleScreenBloc, CharacterPeopleScreenState>(
        builder: (context, state) {
      return Builder(builder: (context) {
        if (state is CharacterDataLoaded) {
          return _CharacterDetails(characterDetails: state.characterDetails);
        }

        if (state is PeopleDataLoaded) {
          return _PersonDetails(
            personDetails: state.personDetails,
            seyuBestRoles: state.seyuBestRoles,
          );
        }

        if (state is CharacterPeopleError) {
          return ErrorScreen(
            mainCallback: () {
              characterPeopleBloc.add(LoadCharacterPeopleData(
                  screenType: widget.screenType, id: widget.id));
            },
          );
        }

        return const LoaderWithBackButton();
      });
    });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Информация о Персонаже
////////////////////////////////////////////////////////////////////////////////
class _CharacterDetails extends StatefulWidget {
  final CharacterDetailsModel characterDetails;

  const _CharacterDetails({required this.characterDetails});

  @override
  State<StatefulWidget> createState() {
    return _CharacterDetailsState();
  }
}

class _CharacterDetailsState extends State<_CharacterDetails> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuWidgets = [
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconWeb,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        text: webVersionTitle,
      )
    ];

    return BackgroundImage(
        imageUrl: widget.characterDetails.image?.original,
        mainWidget: StackTopContainer(
            topWidget: ToolbarForApp(
              backBtnAlpha: Ints.oneHundredFifty,
              endWidget: PopupMenuBorderIconButton(
                  iconPath: iconThreeDots,
                  iconColor: Theme.of(context).colorScheme.onBackground,
                  menuWidgets: menuWidgets,
                  callback: (index) {
                    navigateBrowser(url: widget.characterDetails.url);
                  }),
            ),
            mainWidget: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                reverse: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpacerSized(height: 110),
                      _CharacterHeader(
                          characterDetails: widget.characterDetails),
                      if (widget.characterDetails.description
                          .isNullOrEmpty()
                          .not())
                        _CharacterDescription(
                            description: widget.characterDetails.description!),
                      if (widget.characterDetails.seyu?.isNotEmpty == true)
                        _Seyu(characterDetails: widget.characterDetails),
                      if (widget.characterDetails.animes?.isNotEmpty == true)
                        _CharacterAnime(
                            animes:
                                widget.characterDetails.animes.orEmptyList()),
                      if (widget.characterDetails.mangas?.isNotEmpty == true)
                        _CharacterManga(
                            mangas:
                                widget.characterDetails.mangas.orEmptyList()),
                      const SpacerSized()
                    ],
                  ),
                ),
              ),
            )));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Верхняя часть экрана Информация о Персонаже
////////////////////////////////////////////////////////////////////////////////
class _CharacterHeader extends StatelessWidget {
  final CharacterDetailsModel characterDetails;

  const _CharacterHeader({required this.characterDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Center(
              child: ImageCard(imageUrl: characterDetails.image?.original),
            )),
        Expanded(
            flex: 1,
            child: Center(
              child: Column(
                children: [
                  if (characterDetails.nameRu.isNullOrEmpty().not())
                    LabelText(
                        labelText: nameOnRussianText,
                        text: characterDetails.nameRu.orEmpty()),
                  if (characterDetails.name.isNullOrEmpty().not())
                    LabelText(
                      labelText: nameOnEnglishText,
                      text: characterDetails.name.orEmpty(),
                    ),
                  if (characterDetails.nameJp.isNullOrEmpty().not())
                    LabelText(
                        labelText: nameOnJapaneseText,
                        text: characterDetails.nameJp.orEmpty()),
                  if (characterDetails.nameAlt.isNullOrEmpty().not())
                    LabelText(
                        labelText: othersText,
                        text: characterDetails.nameAlt.orEmpty())
                ],
              ),
            ))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Описание Персонажа
////////////////////////////////////////////////////////////////////////////////
class _CharacterDescription extends StatefulWidget {
  final String description;

  const _CharacterDescription({required this.description});

  @override
  State<StatefulWidget> createState() {
    return _CharacterDescriptionState();
  }
}

class _CharacterDescriptionState extends State<_CharacterDescription> {
  var isExpand = false;

  @override
  Widget build(BuildContext context) {
    String spoiler = getSpoilerText(widget.description);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleText(text: descriptionTitle),
        PaddingBySide(
            start: Doubles.fourteen,
            end: Doubles.fourteen,
            child: getAnnotationString(
                text: widget.description,
                textSize: TextSize.big,
                primaryColor: Theme.of(context).colorScheme.onPrimary,
                annotationColor: Theme.of(context).colorScheme.secondary,
                navigateCallback: (linkType, link, name) {
                  navigateByLinkType(
                      linkType: linkType, link: link, context: context);
                })),
        if (spoiler.isNotEmpty)
          PaddingBySide(
              start: Doubles.fourteen,
              end: Doubles.fourteen,
              child: ExpandedVerticalCard(
                  isExpand: isExpand,
                  mainWidget: InkWell(
                    onTap: () {
                      setState(() {
                        isExpand = !isExpand;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        PaddingBySide(
                            top: Doubles.fourteen,
                            child: MyTextBold(
                                text: isExpand
                                    ? collapseSpoilerTitle
                                    : spoilerTitle,
                                color: ShikidroidColors.ongoingColor))
                      ],
                    ),
                  ),
                  expandWidget: getAnnotationString(
                      text: spoiler,
                      textSize: TextSize.big,
                      primaryColor: Theme.of(context).colorScheme.onPrimary,
                      annotationColor: Theme.of(context).colorScheme.secondary,
                      navigateCallback: (linkType, link, name) {
                        navigateByLinkType(
                            linkType: linkType, link: link, context: context);
                      })))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список сэйю
////////////////////////////////////////////////////////////////////////////////
class _Seyu extends StatelessWidget {
  final CharacterDetailsModel characterDetails;

  const _Seyu({required this.characterDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleText(text: seyuTitle),
        PaddingBySide(
            start: Doubles.seven,
            end: Doubles.seven,
            child: SizedBox(
              height: ImageSizes.horizontalCardHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  for (var seyu in characterDetails.seyu.orEmptyList())
                    ElementCard(
                      imageUrl: seyu.image?.original,
                      titleText: getEmptyIfBothNull(seyu.nameRu, seyu.name),
                      onImageClick: () {
                        navigatePeopleDetailsScreen(
                            id: seyu.id, context: context);
                      },
                    )
                ],
              ),
            ))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список Аниме с участием персонажа
////////////////////////////////////////////////////////////////////////////////
class _CharacterAnime extends StatelessWidget {
  final List<AnimeModel> animes;

  const _CharacterAnime({required this.animes});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: animeTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [for (var i in animes) AnimeCard(anime: i)],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Список Манги с участием персонажа
////////////////////////////////////////////////////////////////////////////////
class _CharacterManga extends StatelessWidget {
  final List<MangaModel> mangas;

  const _CharacterManga({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: mangaTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [for (var i in mangas) MangaCard(manga: i)],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Информация о Человеке
////////////////////////////////////////////////////////////////////////////////
class _PersonDetails extends StatefulWidget {
  final PersonDetailsModel personDetails;

  final List<CharacterModel> seyuBestRoles;

  const _PersonDetails(
      {required this.personDetails, required this.seyuBestRoles});

  @override
  State<StatefulWidget> createState() {
    return _PersonDetailsState();
  }
}

class _PersonDetailsState extends State<_PersonDetails> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuWidgets = [
      MyDropdownMenuItem(
        icon: ImageFromAsset(
          path: iconWeb,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        text: webVersionTitle,
      )
    ];

    return BackgroundImage(
        imageUrl: widget.personDetails.image?.original,
        mainWidget: StackTopContainer(
            topWidget: ToolbarForApp(
              backBtnAlpha: Ints.oneHundredFifty,
              endWidget: PopupMenuBorderIconButton(
                  iconPath: iconThreeDots,
                  iconColor: Theme.of(context).colorScheme.onBackground,
                  menuWidgets: menuWidgets,
                  callback: (index) {
                    navigateBrowser(url: widget.personDetails.url);
                  }),
            ),
            mainWidget: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                reverse: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpacerSized(height: 110),
                      _PersonHeader(personDetails: widget.personDetails),
                      if (widget.personDetails.rolesGrouped?.isNotEmpty == true)
                        _RolesGrouped(personDetails: widget.personDetails),
                      if (widget.seyuBestRoles.isNotEmpty)
                        _BestRoles(roles: widget.seyuBestRoles),
                      if (widget.personDetails.works?.isNotEmpty == true)
                        _BestWorks(
                            works: widget.personDetails.works.orEmptyList()),
                      const SpacerSized()
                    ],
                  ),
                ),
              ),
            )));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Верхняя часть экрана Информация о Человеке
////////////////////////////////////////////////////////////////////////////////
class _PersonHeader extends StatelessWidget {
  final PersonDetailsModel personDetails;

  const _PersonHeader({required this.personDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Center(
              child: ImageCard(imageUrl: personDetails.image?.original),
            )),
        Expanded(
            flex: 1,
            child: Center(
              child: Column(
                children: [
                  if (personDetails.nameRu.isNullOrEmpty().not())
                    LabelText(
                        labelText: nameOnRussianText,
                        text: personDetails.nameRu.orEmpty()),
                  if (personDetails.name.isNullOrEmpty().not())
                    LabelText(
                      labelText: nameOnEnglishText,
                      text: personDetails.name.orEmpty(),
                    ),
                  if (personDetails.nameJp.isNullOrEmpty().not())
                    LabelText(
                        labelText: nameOnJapaneseText,
                        text: personDetails.nameJp.orEmpty()),
                  if (personDetails.birthOn?.day != null)
                    LabelText(
                        labelText: birthDateText,
                        text: personDetails.birthOn?.year == null
                            ? "${personDetails.birthOn?.day} ${personDetails.birthOn?.month.toMonthName(infinitive: false)}"
                            : "${personDetails.birthOn?.day} ${personDetails.birthOn?.month.toMonthName(infinitive: false)} ${personDetails.birthOn?.year}"),
                  if (personDetails.deceasedOn?.day != null)
                    LabelText(
                        labelText: deceasedDateText,
                        text: personDetails.deceasedOn?.year == null
                            ? "${personDetails.deceasedOn?.day} ${personDetails.deceasedOn?.month.toMonthName(infinitive: false)}"
                            : "${personDetails.deceasedOn?.day} ${personDetails.deceasedOn?.month.toMonthName(infinitive: false)} ${personDetails.deceasedOn?.year}"),
                  if (personDetails.website.isNullOrEmpty().not())
                    InkWell(
                      onTap: () {
                        navigateBrowser(url: personDetails.website?.trim());
                      },
                      child: LabelText(
                        labelText: websiteText,
                        text: personDetails.website?.trim(),
                        textColor: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                ],
              ),
            ))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Роли Человека по группам и количеству участий
////////////////////////////////////////////////////////////////////////////////
class _RolesGrouped extends StatelessWidget {
  final PersonDetailsModel personDetails;

  const _RolesGrouped({required this.personDetails});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: rolesAnimeMangaTitle),
            for (var i in personDetails.rolesGrouped.orEmptyList())
              PaddingBySide(
                  start: Doubles.fourteen,
                  end: Doubles.fourteen,
                  top: Doubles.seven,
                  bottom: Doubles.seven,
                  child: MyText(text: "${i?.firstOrNull}: ${i?.lastOrNull}"))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Лучшие Роли Человека
////////////////////////////////////////////////////////////////////////////////
class _BestRoles extends StatelessWidget {
  final List<CharacterModel> roles;

  const _BestRoles({required this.roles});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: bestRolesTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (var i in roles)
                        ElementCard(
                          imageUrl: i.image?.original,
                          titleText: getEmptyIfBothNull(i.nameRu, i.name),
                          onImageClick: () {
                            navigateCharacterDetailsScreen(
                                id: i.id, context: context);
                          },
                        )
                    ],
                  ),
                ))
          ],
        ));
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Лучшие Работы Аниме
////////////////////////////////////////////////////////////////////////////////
class _BestWorks extends StatelessWidget {
  final List<WorkModel> works;

  const _BestWorks({required this.works});

  @override
  Widget build(BuildContext context) {
    return PaddingBySide(
        top: Doubles.fourteen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RowTitleText(text: bestWorksTitle),
            PaddingBySide(
                start: Doubles.seven,
                end: Doubles.seven,
                child: SizedBox(
                  height: ImageSizes.horizontalCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (var i in works)
                        if (i.anime != null) ...[
                          AnimeCard(anime: i.anime!)
                        ] else ...[
                          if (i.manga != null) MangaCard(manga: i.manga!)
                        ]
                    ],
                  ),
                ))
          ],
        ));
  }
}
