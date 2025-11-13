import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';

/// Модель с информацией об аниме/манги, в создании которого принимал участие человек
///
/// [anime] аниме
/// [manga] манга
/// [role] роль в создании
class WorkEntity {
  final AnimeEntity? anime;
  final MangaEntity? manga;
  final String? role;

  const WorkEntity(
      {required this.anime, required this.manga, required this.role});

  factory WorkEntity.fromJson(Map<String, dynamic> json) {
    return WorkEntity(
        anime: json["anime"] == null ? null : AnimeEntity.fromJson(json["anime"]),
        manga: json["manga"] == null ? null : MangaEntity.fromJson(json["manga"]),
        role: json["role"]);
  }
}
