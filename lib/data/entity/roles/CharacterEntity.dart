import 'package:shikidesk/data/entity/common/ImageEntity.dart';

/// Сущность с информацией о персонаже
///
/// [id] номер персонажа
/// [name] имя персонажа
/// [nameRu] имя персонажа на русском
/// [image] ссылки на картинки с персонажем
/// [url] ссылка на персонажа
class CharacterEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;

  const CharacterEntity(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.image,
      required this.url});

  factory CharacterEntity.fromJson(Map<String, dynamic> json) {
    return CharacterEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"]);
  }
}
