import 'package:flutter/material.dart';
import 'package:shikidesk/main.dart';
import 'package:shikidesk/presentation/screens/RateScreen.dart';
import 'package:shikidesk/presentation/screens/mal/CalendarMalScreen.dart';
import 'package:shikidesk/presentation/screens/CalendarScreen.dart';
import 'package:shikidesk/presentation/screens/mal/SearchMalScreen.dart';
import 'package:shikidesk/presentation/screens/SearchScreen.dart';
import 'package:shikidesk/presentation/screens/SelectFileScreen.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/components/HorizontalDrawer.dart';
import 'package:shikidesk/ui/components/RailButton.dart';
import 'package:window_manager/window_manager.dart';

const double drawerAllWidth = 180;
const double drawerButtonWidth = 120;
const double leftMainWidgetPosition = 77;

////////////////////////////////////////////////////////////////////////////////
/// Контейнер со всеми экранами при авторизации в систему
////////////////////////////////////////////////////////////////////////////////
class AuthRail extends StatefulWidget {
  const AuthRail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllScreensRail();
  }
}

class _AllScreensRail extends State<AuthRail> {
  final _rateScreen = GlobalKey<NavigatorState>();
  final _calendarScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _videoPlayerScreen = GlobalKey<NavigatorState>();

  static const int _rateScreenNumber = 0;
  static const int _calendarScreenNumber = 1;
  static const int _searchScreenNumber = 2;
  static const int _videoPlayerScreenNumber = 3;

  static const List<Widget> screenList = [
    RateContainer(),
    CalendarContainer(),
    SearchContainer(),
    SelectFileContainer()
  ];

  int _selectedScreen = 0;

  bool isExpand = false;

  bool isMenuHide = false;

  String icon = iconFullscreen;

  String iconText = enterFullscreenText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: HorizontalRailDrawer(
          isExpand: isExpand,
          hideDrawer: isMenuHide,
          leftMainWidgetPosition: leftMainWidgetPosition,
          mainWidget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: IndexedStack(
              index: _selectedScreen,
              children: screenList,
            ),
          ),
          drawerWidget: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: drawerAllWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// кнопки Списки, Календарь, Поиск
                Column(
                  children: [
                    /// Списки
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _rateScreenNumber,
                        btnImage: iconList,
                        btnText: rateTitle,
                        color: _selectedScreen == _rateScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen == _rateScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_rateScreenNumber, context);
                        }),

                    /// Календарь
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _calendarScreenNumber,
                        btnImage: iconCalendar,
                        btnText: calendarTitle,
                        color: _selectedScreen == _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen ==
                                _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_calendarScreenNumber, context);
                        }),

                    /// Поиск
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _searchScreenNumber,
                        btnImage: iconSearch,
                        btnText: searchTitle,
                        color: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_searchScreenNumber, context);
                        })
                  ],
                ),

                /// Плеер
                RailButton(
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    },
                    isSelected: _selectedScreen == _videoPlayerScreenNumber,
                    btnImage: iconVideo,
                    btnText: playerTitle,
                    color: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Colors.transparent,
                    onClick: () {
                      _onTap(_videoPlayerScreenNumber, context);
                    }),

                /// Сменить тему
                RailButton(
                    isSelected: false,
                    btnImage: ShikidroidDesktop.of(context)?.getTheme() ==
                            ThemeMode.light
                        ? iconDarkTheme
                        : iconLightTheme,
                    btnText: changeThemeText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      ShikidroidDesktop.of(context)?.changeTheme();
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Скрыть боковую панель навигации
                RailButton(
                    isSelected: false,
                    btnImage: isMenuHide ? iconPinMenu : iconHideMenu,
                    btnText: isMenuHide ? pinMenuText : hideMenuText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      setState(() {
                        isMenuHide = !isMenuHide;
                      });
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Полный экран
                RailButton(
                    isSelected: false,
                    btnImage: icon,
                    btnText: iconText,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                    backgroundColor: Colors.transparent,
                    onClick: () async {
                      if (await windowManager.isFullScreen()) {
                        await windowManager.setFullScreen(false);
                        setState(() {
                          icon = iconFullscreen;
                          iconText = enterFullscreenText;
                        });
                      } else {
                        await windowManager.setFullScreen(true);
                        setState(() {
                          icon = iconLeaveFullscreen;
                          iconText = leaveFullscreenText;
                        });
                      }
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int val, BuildContext context) {
    if (_selectedScreen == val) {
      switch (val) {
        case (_rateScreenNumber):
          _rateScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_calendarScreenNumber):
          _calendarScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_searchScreenNumber):
          _searchScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_videoPlayerScreenNumber):
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        default:
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedScreen = val;
        });
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Контейнер с экранами, доступными в режиме "Гость"
////////////////////////////////////////////////////////////////////////////////
class GuestRail extends StatefulWidget {
  const GuestRail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GuestRail();
  }
}

class _GuestRail extends State<GuestRail> {
  final _calendarScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _videoPlayerScreen = GlobalKey<NavigatorState>();

  static const int _calendarScreenNumber = 0;
  static const int _searchScreenNumber = 1;
  static const int _videoPlayerScreenNumber = 2;

  static const List<Widget> screenList = [
    CalendarContainer(),
    SearchContainer(),
    SelectFileContainer()
  ];

  int _selectedScreen = 0;

  bool isExpand = false;

  bool isMenuHide = false;

  String icon = iconFullscreen;

  String iconText = enterFullscreenText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: HorizontalRailDrawer(
          isExpand: isExpand,
          hideDrawer: isMenuHide,
          leftMainWidgetPosition: leftMainWidgetPosition,
          mainWidget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: IndexedStack(
              index: _selectedScreen,
              children: screenList,
            ),
          ),
          drawerWidget: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: drawerAllWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// кнопки Календарь, Поиск
                Column(
                  children: [
                    /// Календарь
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _calendarScreenNumber,
                        btnImage: iconCalendar,
                        btnText: calendarTitle,
                        color: _selectedScreen == _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen ==
                                _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_calendarScreenNumber, context);
                        }),

                    /// Поиск
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _searchScreenNumber,
                        btnImage: iconSearch,
                        btnText: searchTitle,
                        color: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_searchScreenNumber, context);
                        })
                  ],
                ),

                /// Плеер
                RailButton(
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    },
                    isSelected: _selectedScreen == _videoPlayerScreenNumber,
                    btnImage: iconVideo,
                    btnText: playerTitle,
                    color: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Colors.transparent,
                    onClick: () {
                      _onTap(_videoPlayerScreenNumber, context);
                    }),

                /// Сменить тему
                RailButton(
                    isSelected: false,
                    btnImage: ShikidroidDesktop.of(context)?.getTheme() ==
                            ThemeMode.light
                        ? iconDarkTheme
                        : iconLightTheme,
                    btnText: changeThemeText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      ShikidroidDesktop.of(context)?.changeTheme();
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Скрыть боковую панель навигации
                RailButton(
                    isSelected: false,
                    btnImage: isMenuHide ? iconPinMenu : iconHideMenu,
                    btnText: isMenuHide ? pinMenuText : hideMenuText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      setState(() {
                        isMenuHide = !isMenuHide;
                      });
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Полный экран
                RailButton(
                    isSelected: false,
                    btnImage: icon,
                    btnText: iconText,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                    backgroundColor: Colors.transparent,
                    onClick: () async {
                      if (await windowManager.isFullScreen()) {
                        await windowManager.setFullScreen(false);
                        setState(() {
                          icon = iconFullscreen;
                          iconText = enterFullscreenText;
                        });
                      } else {
                        await windowManager.setFullScreen(true);
                        setState(() {
                          icon = iconLeaveFullscreen;
                          iconText = leaveFullscreenText;
                        });
                      }
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int val, BuildContext context) {
    if (_selectedScreen == val) {
      switch (val) {
        case (_calendarScreenNumber):
          _calendarScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_searchScreenNumber):
          _searchScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_videoPlayerScreenNumber):
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        default:
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedScreen = val;
        });
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Контейнер с экранами MyAnimeList
////////////////////////////////////////////////////////////////////////////////
class MalRail extends StatefulWidget {
  const MalRail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MalRail();
  }
}

class _MalRail extends State<MalRail> {
  final _calendarScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _videoPlayerScreen = GlobalKey<NavigatorState>();

  static const int _calendarScreenNumber = 0;
  static const int _searchScreenNumber = 1;
  static const int _videoPlayerScreenNumber = 2;

  static const List<Widget> screenList = [
    CalendarMalContainer(),
    SearchMalContainer(),
    SelectFileContainer()
  ];

  int _selectedScreen = 0;

  bool isExpand = false;

  bool isMenuHide = false;

  String icon = iconFullscreen;

  String iconText = enterFullscreenText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: HorizontalRailDrawer(
          isExpand: isExpand,
          hideDrawer: isMenuHide,
          leftMainWidgetPosition: leftMainWidgetPosition,
          mainWidget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: IndexedStack(
              index: _selectedScreen,
              children: screenList,
            ),
          ),
          drawerWidget: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: drawerAllWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    /// Календарь
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _calendarScreenNumber,
                        btnImage: iconCalendar,
                        btnText: calendarTitle,
                        color: _selectedScreen == _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen ==
                                _calendarScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_calendarScreenNumber, context);
                        }),

                    /// Поиск
                    RailButton(
                        focus: (f) {
                          setState(() {
                            isExpand = f;
                          });
                        },
                        isSelected: _selectedScreen == _searchScreenNumber,
                        btnImage: iconSearch,
                        btnText: searchTitle,
                        color: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: _selectedScreen == _searchScreenNumber
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Colors.transparent,
                        onClick: () {
                          _onTap(_searchScreenNumber, context);
                        })
                  ],
                ),

                /// Плеер
                RailButton(
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    },
                    isSelected: _selectedScreen == _videoPlayerScreenNumber,
                    btnImage: iconVideo,
                    btnText: playerTitle,
                    color: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: _selectedScreen == _videoPlayerScreenNumber
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Colors.transparent,
                    onClick: () {
                      _onTap(_videoPlayerScreenNumber, context);
                    }),

                /// Сменить тему
                RailButton(
                    isSelected: false,
                    btnImage: ShikidroidDesktop.of(context)?.getTheme() ==
                            ThemeMode.light
                        ? iconDarkTheme
                        : iconLightTheme,
                    btnText: changeThemeText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      ShikidroidDesktop.of(context)?.changeTheme();
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Скрыть боковую панель навигации
                RailButton(
                    isSelected: false,
                    btnImage: isMenuHide ? iconPinMenu : iconHideMenu,
                    btnText: isMenuHide ? pinMenuText : hideMenuText,
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Colors.transparent,
                    onClick: () {
                      setState(() {
                        isMenuHide = !isMenuHide;
                      });
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    }),

                /// Полный экран
                RailButton(
                    isSelected: false,
                    btnImage: icon,
                    btnText: iconText,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                    backgroundColor: Colors.transparent,
                    onClick: () async {
                      if (await windowManager.isFullScreen()) {
                        await windowManager.setFullScreen(false);
                        setState(() {
                          icon = iconFullscreen;
                          iconText = enterFullscreenText;
                        });
                      } else {
                        await windowManager.setFullScreen(true);
                        setState(() {
                          icon = iconLeaveFullscreen;
                          iconText = leaveFullscreenText;
                        });
                      }
                    },
                    focus: (f) {
                      setState(() {
                        isExpand = f;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int val, BuildContext context) {
    if (_selectedScreen == val) {
      switch (val) {
        case (_calendarScreenNumber):
          _calendarScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_searchScreenNumber):
          _searchScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case (_videoPlayerScreenNumber):
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        default:
          _videoPlayerScreen.currentState?.popUntil((route) => route.isFirst);
          break;
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedScreen = val;
        });
      }
    }
  }
}
