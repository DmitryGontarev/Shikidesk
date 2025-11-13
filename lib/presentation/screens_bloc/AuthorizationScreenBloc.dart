import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/appconstants/NetworkConstants.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/user/UserAuthStatus.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../domain/interactors/AuthInteractor.dart';
import '../../domain/interactors/TokenLocalInteractor.dart';
import '../../domain/interactors/UserInteractor.dart';
import '../../domain/interactors/UserLocalInteractor.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class AuthorizationScreenEvent {
  const AuthorizationScreenEvent();
}

/// Событие проверки кода авторизации
class CheckAuthCode extends AuthorizationScreenEvent {
  final String? authCode;

  const CheckAuthCode({required this.authCode});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class AuthorizationScreenState {
  const AuthorizationScreenState();
}

/// Открытие экрана авторизации
class AuthScreenOpen extends AuthorizationScreenState {
  const AuthScreenOpen();
}

/// Проверка кода авторизации
class AuthCodeChecking extends AuthorizationScreenState {
  const AuthCodeChecking();
}

/// Ошибка кода авторизации
class AuthCodeError extends AuthorizationScreenState {
  final int? code;
  final String? text;

  const AuthCodeError({this.code, this.text});
}

/// Код авторизации верный
class AuthCodeSuccess extends AuthorizationScreenState {
  const AuthCodeSuccess();
}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК экрана Авторизации
///
////////////////////////////////////////////////////////////////////////////////
class AuthorizationScreenBloc
    extends Bloc<AuthorizationScreenEvent, AuthorizationScreenState> {
  final AuthInteractor authInteractor;
  final TokenLocalInteractor tokenLocalInteractor;
  final UserInteractor userInteractor;
  final UserLocalInteractor userLocalInteractor;

  AuthorizationScreenBloc(
      {required this.authInteractor,
      required this.tokenLocalInteractor,
      required this.userInteractor,
      required this.userLocalInteractor}) : super(const AuthScreenOpen()) {

    /// Проверка кода авторизации
    on<CheckAuthCode>((event, emit) async {
      emit(const AuthCodeChecking());

      await _signIn(
          authCode: event.authCode,
          state: (state) {
            emit(state);
          });
    });
  }

  /// Метод для входа в систему
  Future<void> _signIn(
      {String? authCode,
      required Function(AuthorizationScreenState state) state}) async {
    if (authCode != null && authCode != "") {
      try {

        final response = await authInteractor.signIn(authCode.trim());


        await response.fold((failure) {
          state(AuthCodeError(
            code: (failure as ServerException).code,
            text: (failure as ServerException).body
          ));
        }, (token) async {
          await tokenLocalInteractor.removeToken();
          await tokenLocalInteractor.saveToken(token);

          try {
            final response = await userInteractor.getCurrentUserBriefInfo();

            await response.fold((failure) async {
              state(AuthCodeError(
                  code: (failure as ServerException).code,
                  text: (failure as ServerException).body
              ));
            }, (user) async {
              await userLocalInteractor.setUserId(id: user.id ?? noId);
              await userLocalInteractor.setUserAuthStatus(
                  userAuthStatus: UserAuthStatus.authorized);

              state(const AuthCodeSuccess());
            });
          } catch (e) {
            await tokenLocalInteractor.removeToken();
            state(const AuthCodeError());
          }
        });
      } catch (e) {
        await tokenLocalInteractor.removeToken();
        state(const AuthCodeError());
      }
    } else {
      await tokenLocalInteractor.removeToken();
      state(const AuthCodeError());
    }
  }
}