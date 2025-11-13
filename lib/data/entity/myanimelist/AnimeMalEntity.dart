
import 'package:shikidesk/utils/Extensions.dart';

import '../common/GenreEntity.dart';
import '../studio/StudioEntity.dart';
import 'AlternativeTitlesEntity.dart';
import 'BroadcastEntity.dart';

/// Сущность с данным списка узлов аниме
///
/// [data] список с узлами списка
class DataMalEntity {
  final List<NodeEntity>? data;

  const DataMalEntity({required this.data});

  factory DataMalEntity.fromJson(Map<String, dynamic> json) {
    return DataMalEntity(
        data: json["data"] == null ? null : (json["data"] as List<dynamic>).map((e) => NodeEntity.fromJson(e)).toList());
  }
}

/// Сущность узла списка с информацией об аниме
///
/// [animeMalEntity] сущность данных аниме
class NodeEntity {
  final AnimeMalEntity? animeMalEntity;

  const NodeEntity({required this.animeMalEntity});

  factory NodeEntity.fromJson(Map<String, dynamic> json) {
    return NodeEntity(
        animeMalEntity: json["node"] == null ? null : AnimeMalEntity.fromJson(json["node"]));
  }
}

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
class AnimeMalEntity {
  final int? id;
  final String? title;
  final String? synopsis;
  final MainPictureEntity? image;
  final AlternativeTitlesEntity? alternativeTitles;
  final String? dateAired;
  final String? dateReleased;
  final List<GenreEntity>? genres;
  final String? type;
  final String? status;
  final int? episodes;
  final BroadcastEntity? broadcast;
  final int? episodeDuration;
  final String? ageRating;
  final List<MainPictureEntity>? pictures;
  final String? backgroundInfo;
  final List<RelatedAnimeEntity>? relatedAnime;
  final List<NodeEntity>? recommendations;
  final List<StudioEntity>? studios;
  final double? score;

  const AnimeMalEntity(
      {required this.id,
      required this.title,
      required this.synopsis,
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

  factory AnimeMalEntity.fromJson(Map<String, dynamic> json) {
    return AnimeMalEntity(
        id: json["id"],
        title: json["title"],
        synopsis: json["synopsis"],
        image: json["main_picture"] == null ? null : MainPictureEntity.fromJson(json["main_picture"]),
        alternativeTitles: json["alternative_titles"] == null ? null : AlternativeTitlesEntity.fromJson(json["alternative_titles"]),
        dateAired: json["start_date"],
        dateReleased: json["end_date"],
        genres: json["genres"] == null ? null : (json["genres"] as List<dynamic>).map((e) => GenreEntity.fromJson(e)).toList(),
        type: json["media_type"],
        status: json["status"],
        episodes: json["num_episodes"],
        broadcast: json["broadcast"] == null ? null : BroadcastEntity.fromJson(json["broadcast"]),
        episodeDuration: json["average_episode_duration"],
        ageRating: json["rating"],
        pictures: json["pictures"] == null ? null : (json["pictures"] as List<dynamic>).map((e) => MainPictureEntity.fromJson(e)).toList(),
        backgroundInfo: json["background"],
        relatedAnime: json["related_anime"] == null ? null : (json["related_anime"] as List<dynamic>).map((e) => RelatedAnimeEntity.fromJson(e)).toList(),
        recommendations: json["recommendations"] == null ? null : (json["recommendations"] as List<dynamic>).map((e) => NodeEntity.fromJson(e)).toList(),
        studios: json["studios"] == null ? null : (json["studios"] as List<dynamic>).map((e) => StudioEntity.fromJson(e)).toList(),
        score: json.containsKey("mean") ? double.parse(json["mean"].toString()) : null
    );
  }
}

/// Сущность с картинкой аниме
///
/// [medium] средняя картинка
/// [large] большая картинка
class MainPictureEntity {
  final String? medium;
  final String? large;

  const MainPictureEntity({required this.medium, required this.large});

  factory MainPictureEntity.fromJson(Map<String, dynamic> json) {
    return MainPictureEntity(medium: json["medium"], large: json["large"]);
  }
}

/// Сущность с информацией о связанном аниме
///
/// [anime] узел
/// [relationType] тип связи с аниме
/// [relationTypeFormatted] готовая строка типа связи для показа на экране
class RelatedAnimeEntity {
  final AnimeMalEntity? anime;
  final String? relationType;
  final String? relationTypeFormatted;

  const RelatedAnimeEntity(
      {required this.anime,
      required this.relationType,
      required this.relationTypeFormatted});

  factory RelatedAnimeEntity.fromJson(Map<String, dynamic> json) {
    return RelatedAnimeEntity(
        anime: json["node"] == null ? null : AnimeMalEntity.fromJson(json["node"]),
        relationType: json["relation_type"],
        relationTypeFormatted: json["relation_type_formatted"]);
  }
}
