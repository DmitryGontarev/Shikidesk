import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shikidesk/appconstants/BaseUrl.dart';
import 'package:shikidesk/appconstants/NetworkConstants.dart';
import 'package:shikidesk/data/TokenInterceptor.dart';
import 'package:shikidesk/data/network/api/AnimeApi.dart';
import 'package:shikidesk/data/network/api/AuthApi.dart';
import 'package:shikidesk/data/network/api/CalendarApi.dart';
import 'package:shikidesk/data/network/api/CharacterApi.dart';
import 'package:shikidesk/data/network/api/MangaApi.dart';
import 'package:shikidesk/data/network/api/MyAnimeListApi.dart';
import 'package:shikidesk/data/network/api/RanobeApi.dart';
import 'package:shikidesk/data/network/api/ShimoriVideoApi.dart';
import 'package:shikidesk/data/network/api/UserApi.dart';
import 'package:shikidesk/data/network/repository/AuthRepositoryImpl.dart';
import 'package:shikidesk/data/network/repository/CalendarRepositoryImpl.dart';
import 'package:shikidesk/data/network/repository/MangaRepositoryImpl.dart';
import 'package:shikidesk/data/network/repository/MyAnimeListRepositoryImpl.dart';
import 'package:shikidesk/data/network/repository/RanobeRepositoryImpl.dart';
import 'package:shikidesk/data/network/repository/ShimoriVideoRepositoryImpl.dart';
import 'package:shikidesk/data/local/TokenLocalRepositoryImpl.dart';
import 'package:shikidesk/domain/interactors/AuthInteractor.dart';
import 'package:shikidesk/domain/interactors/CalendarInteractor.dart';
import 'package:shikidesk/domain/interactors/MangaInteractor.dart';
import 'package:shikidesk/domain/interactors/MyAnimeListInteractor.dart';
import 'package:shikidesk/domain/interactors/RanobeIneractor.dart';
import 'package:shikidesk/domain/interactors/ShimoriVideoInteractor.dart';
import 'package:shikidesk/domain/interactors/TokenLocalInteractor.dart';
import 'package:shikidesk/domain/interactors/UserInteractor.dart';
import 'package:shikidesk/domain/repository/AuthRepository.dart';
import 'package:shikidesk/domain/repository/CalendarRepository.dart';
import 'package:http/http.dart' as http;
import 'package:shikidesk/domain/repository/MangaRepository.dart';
import 'package:shikidesk/domain/repository/MyAnimeListRepository.dart';
import 'package:shikidesk/domain/repository/RanobeRepository.dart';
import 'package:shikidesk/domain/repository/TokenLocalRepository.dart';
import 'package:shikidesk/domain/repository/UserRepository.dart';
import 'package:shikidesk/presentation/screens_bloc/CharacterPeopleScreenBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/mal/DetailsMalBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/DetailsScreenBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/EpisodeScreenBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/mal/SearchMalBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/SearchScreenBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/SplashScreenBloc.dart';
import 'package:shikidesk/presentation/screens_bloc/VideoScreenBloc.dart';
import 'package:shikidesk/utils/sharedprefs/SharedPreferencesProvider.dart';

import '../data/network/api/PeopleApi.dart';
import '../data/network/repository/AnimeRepositoryImpl.dart';
import '../data/network/repository/CharacterRepositoryImpl.dart';
import '../data/network/repository/PeopleRepositoryImpl.dart';
import '../data/network/repository/UserLocalRepositoryImpl.dart';
import '../data/network/repository/UserRepositoryImpl.dart';
import '../domain/interactors/AnimeInteractor.dart';
import '../domain/interactors/CharacterInteractor.dart';
import '../domain/interactors/PeopleInteractor.dart';
import '../domain/interactors/UserLocalInteractor.dart';
import '../domain/repository/AnimeRepository.dart';
import '../domain/repository/CharacterRepository.dart';
import '../domain/repository/PeopleRepository.dart';
import '../domain/repository/ShimoriVideoRepository.dart';
import '../domain/repository/UserLocalRepository.dart';
import '../presentation/screens_bloc/AuthorizationScreenBloc.dart';
import '../presentation/screens_bloc/RateScreenBloc.dart';
import '../presentation/screens_bloc/mal/CalendarMalBloc.dart';
import '../presentation/screens_bloc/CalendarScreenBloc.dart';

final diProvider = GetIt.instance;

const baseDio = "baseDio";
const videoDio = "videoDio";
const malDio = "malDio";
const tokenInterceptor = "tokenInterceptor";

init() {
  //////////////////////////////////////////////////////////////////////////////
  /// Others
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerLazySingleton<SharedPreferencesProvider>(
      () => SharedPreferencesProviderImpl());

  //////////////////////////////////////////////////////////////////////////////
  /// Http
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerLazySingleton(() => http.Client());

  //////////////////////////////////////////////////////////////////////////////
  /// Dio
  //////////////////////////////////////////////////////////////////////////////

  /// Dio для всего приложения и авторизации
  diProvider.registerLazySingleton<Interceptor>(() {
    return TokenInterceptor(tokenLocalRepository: diProvider());
  }, instanceName: tokenInterceptor);

  diProvider.registerLazySingleton(() {
    final dio = Dio();

    // final dioInterceptor = AwesomeDioInterceptor();
    // dio.interceptors.add(dioInterceptor);

    dio.options.baseUrl = BaseUrl.shikimoriBaseUrl;
    dio.interceptors.add(diProvider.get(instanceName: tokenInterceptor));
    dio.options.connectTimeout = const Duration(seconds: defaultTimeout);
    dio.options.receiveTimeout = const Duration(seconds: defaultTimeout);
    return dio;
  }, instanceName: baseDio);

  /// Dio для видео
  diProvider.registerLazySingleton(() {
    final dio = Dio();

    // final dioInterceptor = AwesomeDioInterceptor();
    // dio.interceptors.add(
    //     dioInterceptor
    // );

    dio.options.baseUrl = BaseUrl.shimoriVideoUrl;
    dio.options.connectTimeout = const Duration(seconds: longTimeout);
    dio.options.receiveTimeout = const Duration(seconds: longTimeout);
    return dio;
  }, instanceName: videoDio);

  /// Dio для MyAnimeList
  diProvider.registerLazySingleton(() {
    final dio = Dio();

    // final dioInterceptor = AwesomeDioInterceptor();
    // dio.interceptors.add(dioInterceptor);

    dio.options.baseUrl = BaseUrl.myAnimeListBaseUrl;
    dio.options.headers['X-MAL-CLIENT-ID'] = BaseUrl.myAnimeListClientId;
    dio.options.connectTimeout = const Duration(seconds: defaultTimeout);
    dio.options.receiveTimeout = const Duration(seconds: defaultTimeout);
    return dio;
  }, instanceName: malDio);

  //////////////////////////////////////////////////////////////////////////////
  /// BloC
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerFactory(() => SplashScreenBloc(
      authInteractor: diProvider(),
      tokenLocalInteractor: diProvider(),
      userInteractor: diProvider(),
      userLocalInteractor: diProvider(),
      malInteractor: diProvider()));

  diProvider.registerFactory(() => AuthorizationScreenBloc(
      authInteractor: diProvider(),
      tokenLocalInteractor: diProvider(),
      userInteractor: diProvider(),
      userLocalInteractor: diProvider()));

  diProvider.registerLazySingleton<RateScreenBloc>(() => RateScreenBloc(
      userInteractor: diProvider(),
      userLocalInteractor: diProvider(),
      prefs: diProvider()));

  diProvider.registerFactory(
      () => CalendarScreenBloc(calendarInteractor: diProvider()));

  diProvider.registerFactory(() => DetailsScreenBloc(
      animeInteractor: diProvider(),
      mangaInteractor: diProvider(),
      ranobeInteractor: diProvider()));

  diProvider.registerFactory(() => CharacterPeopleScreenBloc(
      characterInteractor: diProvider(), peopleInteractor: diProvider()));

  diProvider
      .registerFactory(() => SearchScreenBloc(animeInteractor: diProvider()));

  diProvider.registerFactory(
      () => EpisodeScreenBloc(shimoriVideoInteractor: diProvider()));

  diProvider.registerFactory(() => VideoScreenBloc(
      shimoriVideoInteractor: diProvider(), prefs: diProvider()));

  diProvider.registerFactory(
      () => CalendarMalScreenBloc(calendarInteractor: diProvider()));

  diProvider
      .registerFactory(() => SearchMalScreenBloc(malInteractor: diProvider()));

  diProvider
      .registerFactory(() => DetailsMalScreenBloc(malInteractor: diProvider()));

  //////////////////////////////////////////////////////////////////////////////
  /// Interactors
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerLazySingleton<TokenLocalInteractor>(
      () => TokenLocalInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<AuthInteractor>(
      () => AuthInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<CalendarInteractor>(
      () => CalendarInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<AnimeInteractor>(
      () => AnimeInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<MangaInteractor>(
      () => MangaInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<RanobeInteractor>(
      () => RanobeInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<CharacterInteractor>(
      () => CharacterInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<PeopleInteractor>(
      () => PeopleInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<UserInteractor>(
      () => UserInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<UserLocalInteractor>(
      () => UserLocalInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<MyAnimeListInteractor>(
      () => MyAnimeListInteractorImpl(repository: diProvider()));

  diProvider.registerLazySingleton<ShimoriVideoInteractor>(
      () => ShimoriVideoInteractorImpl(repository: diProvider()));

  //////////////////////////////////////////////////////////////////////////////
  /// Repository
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerLazySingleton<TokenLocalRepository>(
      () => TokenLocalRepositoryImpl(prefs: diProvider()));

  diProvider.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<AnimeRepository>(
      () => AnimeRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<MangaRepository>(
      () => MangaRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<RanobeRepository>(
      () => RanobeRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<CharacterRepository>(
      () => CharacterRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<PeopleRepository>(
      () => PeopleRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<UserLocalRepository>(
      () => UserLocalRepositoryImpl(prefs: diProvider()));

  diProvider.registerLazySingleton<MyAnimeListRepository>(
      () => MyAnimeListRepositoryImpl(api: diProvider()));

  diProvider.registerLazySingleton<ShimoriVideoRepository>(
      () => ShimoriVideoRepositoryImpl(api: diProvider()));

  //////////////////////////////////////////////////////////////////////////////
  /// API
  //////////////////////////////////////////////////////////////////////////////
  diProvider.registerLazySingleton<AuthApi>(
      () => AuthApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<CalendarApi>(
      () => CalendarApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<AnimeApi>(
      () => AnimeApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<MangaApi>(
      () => MangaApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<RanobeApi>(
      () => RanobeApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<CharacterApi>(
      () => CharacterApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<PeopleApi>(
      () => PeopleApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<UserApi>(
      () => UserApiImpl(dio: diProvider.get(instanceName: baseDio)));

  diProvider.registerLazySingleton<MyAnimeListApi>(
      () => MyAnimeListApiImpl(dio: diProvider.get(instanceName: malDio)));

  diProvider.registerLazySingleton<ShimoriVideoApi>(
      () => ShimoriVideoApiImpl(dio: diProvider.get(instanceName: videoDio)));
}
