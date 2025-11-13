import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';

/// Сущность с информацией о аниме/манге связанных с текущим
///
/// [relation] названия типа связи (например Адаптация)
/// [relationRu] названия связи на русском
/// [anime] связанное аниме, если есть
/// [manga] связанная манга, если есть
class RelatedEntity {
  final String? relation;
  final String? relationRu;
  final AnimeEntity? anime;
  final MangaEntity? manga;

  const RelatedEntity({
    required this.relation,
    required this.relationRu,
    required this.anime,
    required this.manga
  });

  factory RelatedEntity.fromJson(Map<String, dynamic> json) {
    return RelatedEntity(
        relation: json["relation"],
        relationRu: json["relation_russian"],
        anime: json["anime"] == null ? null : AnimeEntity.fromJson(json["anime"]),
        manga: json["manga"] == null ? null : MangaEntity.fromJson(json["manga"])
    );
  }
}
