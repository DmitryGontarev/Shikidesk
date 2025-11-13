
import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/MangaRepository.dart';

import '../models/common/Failure.dart';
import '../models/common/RelatedModel.dart';
import '../models/common/RolesModel.dart';
import '../models/manga/MangaDetailsModel.dart';
import '../models/manga/MangaModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс интерактора для получения данных о манге
////////////////////////////////////////////////////////////////////////////////
abstract class MangaInteractor {
  /// Получение списка манги по указанным параметрам
  ///
  /// [page] номер страницы, должно быть числом между 1 и 100000 (необязательно)
  /// [limit] лимит списка, число максимум 50 (необязательно)
  /// [order] порядок сортировки (id, id_desc, ranked, kind, popularity, name, aired_on, volumes, chapters, status, random, created_at, created_at_desc) (необязательно)
  /// [kind] тип манги (manga, manhwa, manhua, light_novel, novel, one_shot, doujin) (необязательно)
  /// [status] тип релиза (anons, ongoing, released, paused, discontinued) (необязательно)
  /// [season] сезон выхода манги (summer_2017, spring_2016,fall_2016, 2016,!winter_2016, 2016, 2014_2016, 199x) (необязательно)
  /// [score] минимальная оценка манги (необязательно)
  /// [genre] список с id жанров аниме  (необязательно)
  /// [publisher] список и издателями манги
  /// [franchise] список с названиями франшиз манги (необязательно)
  /// [censored] включить цензуру (Set to false to allow hentai, yaoi and yuri) (необязательно)
  /// [myList] статус манги в списке пользователя (planned, watching, rewatching, completed, on_hold, dropped) (необязательно)
  /// [ids] список id номеров манги (необязательно)
  /// [excludeIds] список id номеров манги (необязательно)
  /// [search] поисковая фраза для фильтрации манги по имени (name) (необязательно)
  Future<Either<Failure, List<MangaModel>>> getMangaListByParameters();

  /// Получить информацию о манге по ID
  ///
  /// [id] id номер манги
  Future<Either<Failure, MangaDetailsModel>> getMangaDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании манги по id
  ///
  /// [id] id номер манги
  Future<Either<Failure, List<RolesModel>>> getMangaRolesById(int id);

  /// Получить список похожих манги по ID
  ///
  /// [id] id номер манги
  Future<Either<Failure, List<MangaModel>>> getSimilarManga(int id);

  /// Получить список аниме, связанных с текущим
  ///
  /// [id] id номер манги
  Future<Either<Failure, List<RelatedModel>>> getRelatedManga(int id);
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация интерактора [MangaInteractor]
///
/// [repository] репозиторий для получения данных об аниме
////////////////////////////////////////////////////////////////////////////////
class MangaInteractorImpl implements MangaInteractor {
  final MangaRepository repository;

  MangaInteractorImpl({required this.repository});

  @override
  Future<Either<Failure, List<MangaModel>>> getMangaListByParameters() async {
    return await repository.getMangaListByParameters();
  }

  @override
  Future<Either<Failure, MangaDetailsModel>> getMangaDetailsById(int id) async {
    return await repository.getMangaDetailsById(id);
  }

  @override
  Future<Either<Failure, List<RolesModel>>> getMangaRolesById(int id) async {
    return await repository.getMangaRolesById(id);
  }

  @override
  Future<Either<Failure, List<RelatedModel>>> getRelatedManga(int id) async {
    return await repository.getRelatedManga(id);
  }

  @override
  Future<Either<Failure, List<MangaModel>>> getSimilarManga(int id) async {
    return await repository.getSimilarManga(id);
  }
}