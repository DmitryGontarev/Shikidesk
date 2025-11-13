import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/appconstants/NetworkConstants.dart';
import 'package:shikidesk/domain/interactors/AuthInteractor.dart';
import 'package:shikidesk/domain/interactors/TokenLocalInteractor.dart';
import 'package:shikidesk/domain/interactors/UserInteractor.dart';
import 'package:shikidesk/domain/interactors/UserLocalInteractor.dart';
import 'package:shikidesk/domain/models/auth/TokenModel.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';
import 'package:shikidesk/domain/models/user/UserAuthStatus.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/interactors/MyAnimeListInteractor.dart';

////////////////////////////////////////////////////////////////////////////////
/// СОБЫТИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SplashScreenEvent {
  const SplashScreenEvent();
}

/// Событие старта загрузки
class LoadSplash extends SplashScreenEvent {
  const LoadSplash();
}

/// Событие получения нового токена
class GetNewToken extends SplashScreenEvent {
  const GetNewToken();
}

/// Событие получения нового токена
class CheckMal extends SplashScreenEvent {
  const CheckMal();
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class SplashScreenState {
  const SplashScreenState();
}

/// Загрузка данных
class SplashLoading extends SplashScreenState {
  const SplashLoading();
}

/// Обновление токена
class LoadNewToken extends SplashScreenState {
  const LoadNewToken();
}

/// Навигация на экран выбора входа Shikimori
class NavigateShikimoriChoice extends SplashScreenState {
  const NavigateShikimoriChoice();
}

/// Навигация на экран Shikimori при успешной авторизации
class NavigateShikimori extends SplashScreenState {
  const NavigateShikimori();
}

/// Проверка доступности MyAnimeList
class CheckMalAvailable extends SplashScreenState {
  const CheckMalAvailable();
}

/// Навигация на MyAnimeList
class NavigateMal extends SplashScreenState {
  const NavigateMal();
}

/// Ошибка загрузки данных
class SplashError extends SplashScreenState {
  const SplashError();
}

////////////////////////////////////////////////////////////////////////////////
/// БЛоК
////////////////////////////////////////////////////////////////////////////////
class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final AuthInteractor authInteractor;
  final TokenLocalInteractor tokenLocalInteractor;
  final UserInteractor userInteractor;
  final UserLocalInteractor userLocalInteractor;
  final MyAnimeListInteractor malInteractor;

  SplashScreenBloc(
      {required this.authInteractor,
      required this.tokenLocalInteractor,
      required this.userInteractor,
      required this.userLocalInteractor,
      required this.malInteractor})
      : super(const SplashLoading()) {

    on<LoadSplash>((event, emit) async {
      emit(const SplashLoading());
      await Future.delayed(const Duration(seconds: 2), () async {
        await _loadData((state) {
          emit(state);
        });
      });
    });

    on<GetNewToken>((event, emit) async {
      emit(const SplashLoading());
      await _loadNewToken((state) {
        emit(state);
      });
    });

    on<CheckMal>((event, emit) async {
      emit(const SplashLoading());
      await _checkMal((state) {
        emit(state);
      });
    });
  }

  /// Загрузка данных
  Future<void> _loadData(Function(SplashScreenState state) state) async {
    if (await tokenLocalInteractor.isTokenExists()) {
      /// Ветка при наличии токена
      try {
        final user = await userInteractor.getCurrentUserBriefInfo();
        user.fold((failure) {
          state(const CheckMalAvailable());
        }, (userBrief) async {
          // если пришли данные пользователя, то сохраняем ID и ставим статус авторизации
          userLocalInteractor.setUserId(id: userBrief.id ?? noId);
          userLocalInteractor.setUserAuthStatus(
              userAuthStatus: UserAuthStatus.authorized);
          state(const NavigateShikimori());

        });
      } catch (e) {
        if (e.toString().contains("${HttpCodes.http401}")) {
          state(const LoadNewToken());
        } else {
          state(const CheckMalAvailable());
        }
      }
    } else {
      /// Ветка, если токена нет
      userLocalInteractor.setUserAuthStatus(
          userAuthStatus: UserAuthStatus.guest);
      try {
        final response = await userInteractor.getCurrentUserBriefInfo();

        response.fold((failure) {
          state(const NavigateShikimoriChoice());
        }, (userBrief) {
          state(const NavigateShikimoriChoice());
        });
      } catch (e) {
        if ((e as ServerException).code == HttpCodes.http200 ||
            (e).body == null) {
          state(const NavigateShikimoriChoice());
        } else {
          state(const CheckMalAvailable());
        }
      }
    }
  }

  /// Получение нового токена
  Future<void> _loadNewToken(Function(SplashScreenState state) state) async {
    TokenModel? token = await tokenLocalInteractor.getToken();
    String? refreshToken = token?.refreshToken;
    tokenLocalInteractor.removeToken();

    // если есть Refresh Token
    if (refreshToken.isNullOrEmpty().not()) {
      try {
        final response =
            await authInteractor.refreshToken(refreshToken ?? "");
        response.fold((failure) {

        }, (newToken) async {
          // сохраняем новый токен
          tokenLocalInteractor.saveToken(newToken);

          // запрашиваем информацию о пользователе
          try {
            final response = await userInteractor.getCurrentUserBriefInfo();

            response.fold((failure) {
              state(const CheckMalAvailable());
            }, (userBrief) {
              userLocalInteractor.setUserId(id: userBrief.id ?? noId);
              userLocalInteractor.setUserAuthStatus(
                  userAuthStatus: UserAuthStatus.authorized);
              state(const NavigateShikimori());
            });
          } catch (e) {
            state(const CheckMalAvailable());
          }
        });
      } catch (e) {
        state(const CheckMalAvailable());
      }
    } else {
      state(const CheckMalAvailable());
    }
  }

  /// Провекра доступности My Anime List
  Future<void> _checkMal(Function(SplashScreenState state) state) async {
    try {
      final response = await malInteractor.getAnimeRankingList(
          rankingType: RankingType.all,
          limit: 1,
          offset: null,
          fields: "start_date, end_date, media_type, status, num_episodes, mean"
      );

      response.fold((failure) {
        state(const SplashError());
      }, (anime) {
        state(const NavigateMal());
      });
    } catch (e) {
      state(const SplashError());
    }
  }
}