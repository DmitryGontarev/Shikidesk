import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shikidesk/presentation/screens/SplashScreen.dart';
import 'package:shikidesk/ui/ThemeDarkLight.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shikidesk/di/DiProvider.dart' as di;

////////////////////////////////////////////////////////////////////////////////
/// Функция для входа в программу
////////////////////////////////////////////////////////////////////////////////
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    // await windowManager.setBackgroundColor(Colors.black);
    await windowManager.setTitle(shikidroidTitle);
    await windowManager.show();
  });
  if (Platform.isWindows) {
    /// По умолчанию окно всегда открывается по координатам x=10, y=10
    WindowManager.instance.setPosition(const Offset(10, 10));

    /// Максимальное разрешение 720p (HD)
    WindowManager.instance.setMinimumSize(const Size(1280, 720));

    /// Максимальное разрешение 8K
    WindowManager.instance.setMaximumSize(const Size(7680, 4320));
  }
  MediaKit.ensureInitialized();
  runApp(const ShikidroidDesktop());
}

/// Основной UI контейнер программы
class ShikidroidDesktop extends StatefulWidget {

  const ShikidroidDesktop({super.key});

  static ShikidroidDesktopState? of(BuildContext context) =>
      context.findAncestorStateOfType<ShikidroidDesktopState>();

  @override
  State<StatefulWidget> createState() {
    return ShikidroidDesktopState();
  }
}

/// Состояние основного UI контейнера программы
class ShikidroidDesktopState extends State<ShikidroidDesktop> with WindowListener {

  /// Переменная, хранящая выбранную тему
  ThemeMode _themeMode = ThemeMode.dark;

  final FocusNode _focusNode = FocusNode();

  ThemeMode getTheme() {
    return _themeMode;
  }

  /// Функция, для изменения темы
  void changeTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void onWindowMinimize() {
    super.onWindowMinimize();
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {

          }
        },
        child: MaterialApp(
          title: shikidroidTitle,
          scrollBehavior: DesktopScrollBehaviour(),
          themeMode: _themeMode,
          darkTheme: createDarkTheme(),
          theme: createLightTheme(),
          home: const SplashContainer(),
        )
    );
  }
}

/// Класс для отслеживания курсора мыши
class DesktopScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

/// Класс для отключения проверки сертификатов для разнных URL-ов,
/// нужен для загрузки видео, которые находятся на разных серверах с разными адресами
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}