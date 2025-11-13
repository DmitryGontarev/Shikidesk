
import 'package:shikidesk/data/entity/common/ImageEntity.dart';

/// Сущность с информацией об аниме
///
/// [id] id номер аниме
/// [name] название аниме
/// [nameRu] название аниме на русском
/// [image] ссылка на постер аниме
/// [url] ссылка на страницу сайта с аниме
/// [type] тип релиза аниме (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48)
/// [score] оцена аниме по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [episodes] общее количество эпизодов
/// [episodesAired] количество вышедших эпизодов
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
class AnimeEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? type;
  final String? score;
  final String? status;
  final int? episodes;
  final int? episodesAired;
  final String? dateAired;
  final String? dateReleased;

  const AnimeEntity({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url,
    required this.type,
    required this.score,
    required this.status,
    required this.episodes,
    required this.episodesAired,
    required this.dateAired,
    required this.dateReleased,
  });

  factory AnimeEntity.fromJson(Map<String, dynamic> json) {
    return AnimeEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json ["image"] == null ? null : ImageEntity.fromJson(json ["image"]),
        url: json["url"],
        type: json["kind"],
        score: json["score"],
        status: json["status"],
        episodes: json["episodes"],
        episodesAired: json["episodes_aired"],
        dateAired: json["aired_on"],
        dateReleased: json["released_on"]
    );
  }
}