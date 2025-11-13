
import 'package:dartz/dartz.dart';

import '../models/common/Failure.dart';
import '../models/common/RelatedModel.dart';
import '../models/common/RolesModel.dart';
import '../models/manga/MangaDetailsModel.dart';
import '../models/manga/MangaModel.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория для получения данных о ранобэ
////////////////////////////////////////////////////////////////////////////////
abstract class RanobeRepository {
  /// Получение списка ранобэ по указанным параметрам
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
  Future<Either<Failure, List<MangaModel>>> getRanobeListByParameters();

  /// Получить информацию о ранобэ по ID
  ///
  /// [id] id номер ранобэ
  Future<Either<Failure, MangaDetailsModel>> getRanobeDetailsById(int id);

  /// Получить информацию о людях, принимавших участие в создании ранобэ по id
  ///
  /// [id] id номер манги
  Future<Either<Failure, List<RolesModel>>> getRanobeRolesById(int id);

  /// Получить список похожих ранобэ по ID
  ///
  /// [id] id номер ранобэ
  Future<Either<Failure, List<MangaModel>>> getSimilarRanobe(int id);

  /// Получить список ранобэ, связанным с текущим
  ///
  /// [id] id номер ранобэ
  Future<Either<Failure, List<RelatedModel>>> getRelatedRanobe(int id);
}