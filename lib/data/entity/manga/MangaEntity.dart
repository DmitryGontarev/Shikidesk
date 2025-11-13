
import '../common/ImageEntity.dart';

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
/// [volumes] общее количество эпизодов
/// [chapters] количество вышедших эпизодов
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
class MangaEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? type;
  final String? score;
  final String? status;
  final int? volumes;
  final int? chapters;
  final String? dateAired;
  final String? dateReleased;

  const MangaEntity({
    required this.id,
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
    required this.dateReleased});

  factory MangaEntity.fromJson(Map<String, dynamic> json) {
    return MangaEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"],
        type: json["kind"],
        score:json["score"],
        status: json["status"],
        volumes: json["volumes"],
        chapters: json["chapters"],
        dateAired: json["aired_on"],
        dateReleased: json["released_on"]
    );
  }
}