import '../anime/AnimeEntity.dart';
import '../manga/MangaEntity.dart';
import 'CharacterEntity.dart';

/// Сущность со списком персонажей, которых озвучивал актёр
///
/// [characters] список персонажей
/// [animes] список аниме
/// [mangas] список манги
class SeyuRoleEntity {
  final List<CharacterEntity>? characters;
  final List<AnimeEntity>? animes;
  final List<MangaEntity>? mangas;

  const SeyuRoleEntity({
    required this.characters,
    required this.animes,
    required this.mangas
  });

  factory SeyuRoleEntity.fromJson(Map<String, dynamic> json) {
    return SeyuRoleEntity(
        characters: json["characters"] == null ? null : (json["characters"] as List<dynamic>).map((e) => CharacterEntity.fromJson(e)).toList(),
        animes: json["animes"] == null ? null : (json["animes"] as List<dynamic>).map((e) => AnimeEntity.fromJson(e)).toList(),
        mangas: json["animes"] == null ? null : (json["animes"] as List<dynamic>).map((e) => MangaEntity.fromJson(e)).toList()
    );
  }
}