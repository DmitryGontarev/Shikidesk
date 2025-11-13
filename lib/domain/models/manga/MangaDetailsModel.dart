import 'package:equatable/equatable.dart';

import '../common/AiredStatus.dart';
import '../common/GenreModel.dart';
import '../common/ImageModel.dart';
import '../user/StatisticModel.dart';
import '../user/UserRateModel.dart';
import 'MangaType.dart';

/// Модель с детальной информацией по выбранной манге
///
/// [id] id номер манги
/// [name] название манги
/// [nameRu] название манги на русском
/// [image] ссылка на постер манги
/// [url] ссылка на страницу сайта с аниме
/// [type] тип релиза манги (manga, manhwa, manhua, light_novel, novel, one_shot, doujin)
/// [score] оценка манги по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [volumes] количество томов
/// [chapters] количество глав
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
/// [namesEnglish] название на английском
/// [namesJapanese] название на японском
/// [synonyms] синонимы
/// [description] описание
/// [descriptionHtml] описание в HTML
/// [descriptionSource] название источника описания
/// [franchise] название франшизы
/// [favoured] в избранном (true or false)
/// [anons] в статусе анонса (true or false)
/// [ongoing] в статусе онгоинга (true or false)
/// [threadId] номер треда
/// [topicId] номер топика
/// [myAnimeListId] номер в списке пользователя, если есть
/// [rateScoresStats] статистика по оценкам
/// [rateStatusesStats] статистика по статусам
/// [genres] список жанров
/// [userRate] пользовательский рейтинг манги
class MangaDetailsModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;
  final MangaType? type;
  final String? score;
  final AiredStatus? status;
  final int? volumes;
  final int? chapters;
  final String? dateAired;
  final String? dateReleased;
  final List<String?>? namesEnglish;
  final List<String?>? namesJapanese;
  final List<String?>? synonyms;
  final String? description;
  final String? descriptionHtml;
  final String? descriptionSource;
  final String? franchise;
  final bool? favoured;
  final bool? anons;
  final bool? ongoing;
  final int? threadId;
  final int? topicId;
  final int? myAnimeListId;
  final List<RateScoresModel>? rateScoresStats;
  final List<RateStatusesModel>? rateStatusesStats;
  final List<GenreModel>? genres;
  final UserRateModel? userRate;

  const MangaDetailsModel(
      {required this.id,
        required this.name,
        required this.nameRu,
        required this.image,
        required this.url,
        required this.type,
        required this.score,
        required this.status,
        required this.volumes,
        required this.chapters,
        required this.dateAired,
        required this.dateReleased,
        required this.namesEnglish,
        required this.namesJapanese,
        required this.synonyms,
        required this.description,
        required this.descriptionHtml,
        required this.descriptionSource,
        required this.franchise,
        required this.favoured,
        required this.anons,
        required this.ongoing,
        required this.threadId,
        required this.topicId,
        required this.myAnimeListId,
        required this.rateScoresStats,
        required this.rateStatusesStats,
        required this.genres,
        required this.userRate});

  @override
  List<Object?> get props => [
    id,
    name,
    nameRu,
    image,
    url,
    type,
    score,
    status,
    volumes,
    chapters,
    dateAired,
    dateReleased,
    namesEnglish,
    namesJapanese,
    synonyms,
    description,
    descriptionHtml,
    descriptionSource,
    franchise,
    favoured,
    anons,
    ongoing,
    threadId,
    topicId,
    myAnimeListId,
    rateScoresStats,
    rateStatusesStats,
    genres,
    userRate
  ];
}