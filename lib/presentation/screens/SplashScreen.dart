import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens/mal/EnterMalScreen.dart';
import 'package:shikidesk/presentation/screens_bloc/SplashScreenBloc.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../ui/AssetsPath.dart';
import '../../ui/components/ImageFromAsset.dart';
import '../../ui/components/Paddings.dart';
import 'ErrorScreen.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер начального экрана загрузки с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class SplashContainer extends StatelessWidget {
  const SplashContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<SplashScreenBloc>(
        create: (context) => diProvider<SplashScreenBloc>(),
        child: const _SplashScreenBlocProvider(),
      ),
    );
  }
}

class _SplashScreenBlocProvider extends StatelessWidget {
  const _SplashScreenBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashScreenBloc splashBloc = context.read<SplashScreenBloc>();

    return _SplashScreen(
      splashBloc: splashBloc,
    );
  }
}

class _SplashScreen extends StatefulWidget {
  final SplashScreenBloc splashBloc;

  const _SplashScreen({super.key, required this.splashBloc});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<_SplashScreen> {
  String appName = "";

  bool showProgress = false;

  String textProgress = "";

  @override
  void initState() {
    super.initState();
    setAppName();
    widget.splashBloc.add(const LoadSplash());
  }

  void setAppName() async {
    for (var c in shikidroidLogoTitle.toCharList()) {
      setState(() {
        appName += c;
      });
      await Future.delayed(const Duration(milliseconds: 70));
    }
    setState(() {
      showProgress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.splashBloc,
      listener: (BuildContext context, SplashScreenState state) {

        if (state is LoadNewToken) {
          setState(() {
            textProgress = "Get New Token";
          });
          widget.splashBloc.add(const GetNewToken());
        }

        if (state is CheckMalAvailable) {
          setState(() {
            textProgress = "Connecting to My Anime List . .";
          });
          widget.splashBloc.add(const CheckMal());
        }

        if (state is NavigateShikimoriChoice) {
          navigateEnterScreen(context: context);
        }

        if (state is NavigateShikimori) {
          navigateAllScreensRail(context: context);
        }
      },
      child: BlocBuilder(bloc: widget.splashBloc, builder: (context, state) {

        if (state is SplashError) {
          return ErrorScreen(
            showBackButton: false,
            mainCallback: () {
              setState(() {
                textProgress = "";
              });
              widget.splashBloc.add(const LoadSplash());
            },
          );
        }

        if (state is NavigateMal) {
          return EnterMalScreen(mainCallback: () {
            widget.splashBloc.add(const LoadSplash());
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PaddingAll(
                        all: 25,
                        child: MyTextSemiBold(text: appName, fontSize: 50)),
                    PaddingAll(
                      child: ImageFromAsset(
                        size: 100,
                        path: shikimoriLogo,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  ],
                ),
                if (showProgress)
                  SizedBox(
                    width: 300,
                    child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                PaddingBySide(
                  top: Doubles.fourteen,
                    child: MyTextOnBackground(
                        text: textProgress
                    )
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
