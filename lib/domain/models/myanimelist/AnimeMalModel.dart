
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AgeRatingType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';

import '../common/GenreModel.dart';
import '../studio/StudioModel.dart';
import 'AlternativeTitlesModel.dart';
import 'BroadcastModel.dart';

/// Сущность с информацией об аниме
///
/// [id] id номер аниме
/// [title] название аниме
/// [image] ссылка на постер аниме
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
/// [type] тип релиза аниме (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48)
/// [status] статус релиза (anons, ongoing, released)
/// [episodes] общее количество эпизодов
/// [score] оцена аниме по 10-тибалльной шкале
class AnimeMalModel extends Equatable {
  final int? id;
  final String? title;
  final String? synopsys;
  final MainPictureModel? image;
  final AlternativeTitlesModel? alternativeTitles;
  final String? dateAired;
  final String? dateReleased;
  final List<GenreModel>? genres;
  final AnimeType? type;
  final AiredStatus? status;
  final int? episodes;
  final BroadcastModel? broadcast;
  final int? episodeDuration;
  final AgeRatingType? ageRating;
  final List<MainPictureModel>? pictures;
  final String? backgroundInfo;
  final List<RelatedAnimeModel>? relatedAnime;
  final List<AnimeMalModel?>? recommendations;
  final List<StudioModel>? studios;
  final double? score;

  const AnimeMalModel(
      {required this.id,
      required this.title,
      required this.synopsys,
      required this.image,
      required this.alternativeTitles,
      required this.dateAired,
      required this.dateReleased,
      required this.genres,
      required this.type,
      required this.status,
      required this.episodes,
      required this.broadcast,
      required this.episodeDuration,
      required this.ageRating,
      required this.pictures,
      required this.backgroundInfo,
      required this.relatedAnime,
      required this.recommendations,
      required this.studios,
      required this.score});

  @override
  List<Object?> get props => [
        id,
        title,
        synopsys,
        image,
        alternativeTitles,
        dateAired,
        dateReleased,
        genres,
        type,
        status,
        episodes,
        broadcast,
        episodeDuration,
        ageRating,
        pictures,
        backgroundInfo,
        relatedAnime,
        recommendations,
        studios,
        score
      ];
}

/// Модель с картинкой аниме
///
/// [medium] средняя картинка
/// [large] большая картинка
class MainPictureModel extends Equatable {
  final String? medium;
  final String? large;

  const MainPictureModel({required this.medium, required this.large});

  @override
  List<Object?> get props => [medium, large];
}

/// Модель с информацией о связанном аниме
///
/// [anime] модель информации аниме
/// [relationType] тип связи с аниме
/// [relationTypeFormatted] готовая строка типа связи для показа на экране
class RelatedAnimeModel extends Equatable {
  final AnimeMalModel? anime;
  final String? relationType;
  final String? relationTypeFormatted;

  const RelatedAnimeModel(
      {required this.anime,
      required this.relationType,
      required this.relationTypeFormatted});

  @override
  List<Object?> get props => [anime, relationType, relationTypeFormatted];
}
