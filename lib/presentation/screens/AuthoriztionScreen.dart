import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/appconstants/BaseUrl.dart';
import 'package:shikidesk/di/DiProvider.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/presentation/screens_bloc/AuthorizationScreenBloc.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/components/BaseTextFrom.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/MyButton.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/StackTopContainer.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../ui/AssetsPath.dart';
import '../../ui/Colors.dart';
import '../../ui/Strings.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Авторизации с BlocProvider
////////////////////////////////////////////////////////////////////////////////
class AuthorizationContainer extends StatelessWidget {
  const AuthorizationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthorizationScreenBloc>(
      create: (context) => diProvider<AuthorizationScreenBloc>(),
      child: _AuthorizationScreen(),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран Авторизации
////////////////////////////////////////////////////////////////////////////////
class _AuthorizationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthorizationScreenState();
  }
}

class _AuthorizationScreenState extends State<_AuthorizationScreen> {
  String authCode = "";

  bool isError = false;

  String errorText = "";

  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    final AuthorizationScreenBloc authBloc =
        context.read<AuthorizationScreenBloc>();

    return BlocConsumer<AuthorizationScreenBloc, AuthorizationScreenState>(
        listener: (BuildContext context, state) {
      if (state is AuthCodeChecking) {
        setState(() {
          showLoader = true;
        });
      }

      if (state is AuthCodeError) {
        setState(() {
          isError = true;

          if (state.code == null && state.text.isNullOrEmpty()) {
            errorText = "Код авторизации введён неверно";
          }

          if (state.code == null && state.text != null) {
            errorText = state.text.orEmpty();
          }

          if (state.code != null && state.text.isNullOrEmpty().not()) {
            errorText = "${state.code} | ${state.text}";
          }

          showLoader = false;
        });
      }

      if (state is AuthCodeSuccess) {
        setState(() {
          isError = false;
          errorText = "";
          showLoader = false;
        });
        navigateAllScreensRail(context: context);
      }
    }, builder: (BuildContext context, state) {
      return Scaffold(
        body: StackTopContainer(
            topWidget: const ToolbarForApp(),
            mainWidget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PaddingBySide(
                      bottom: Doubles.fourteen,
                      child: MyText(text: "1. Нажмите \"Получить код\"")),
                  const PaddingBySide(
                      bottom: Doubles.fourteen,
                      child: MyText(text: "2. Введите логин и пароль")),
                  const PaddingBySide(
                      bottom: Doubles.fourteen,
                      child: MyText(
                          text: "3. Скопируйте код авторизации в поле ниже")),
                  const PaddingBySide(
                      bottom: Doubles.fourteen,
                      child: MyText(text: "4. Нажмите \"Продолжить\"")),
                  PaddingBySide(
                      top: Doubles.fifty,
                      bottom: Doubles.fifty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageFromAsset(
                                path: iconWeb,
                                size: 100,
                                color: isError
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                              PaddingBySide(
                                  start: Doubles.fifty,
                                  child: MyButton(
                                      btnText: "Получить код",
                                      btnColor: Theme.of(context).primaryColor,
                                      borderColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onClick: () {
                                        navigateBrowser(url: BaseUrl.authUrl, useWebView: false);
                                      }))
                            ],
                          ),
                          if (showLoader) ...{
                            const SizedLoader()
                          }else...{
                            PaddingBySide(
                                top: Doubles.fourteen,
                                child: MyTextOnBackground(text: errorText))
                          }
                        ],
                      )),
                  PaddingBySide(
                      bottom: Doubles.fifty,
                      child: SizedBox(
                        width: 300,
                        child: ShikiTextField(
                            isError: isError,
                            labelText: isError
                                ? "Неправильный код"
                                : "Код авторизации",
                            clearText: false,
                            changedCallback: (text) {
                              setState(() {
                                isError = false;
                                errorText = "";
                              });
                              authCode = text;
                            },
                            submitCallback: (text) {
                              authBloc.add(CheckAuthCode(authCode: text));
                            }),
                      )
                  ),
                  MyButton(
                      btnText: continueTitle,
                      btnColor: ShikidroidColors.darkColorSecondary,
                      borderColor: Colors.transparent,
                      onClick: () {
                        authBloc.add(CheckAuthCode(authCode: authCode));
                      })
                ],
              ),
            )),
      );
    });
  }
}
