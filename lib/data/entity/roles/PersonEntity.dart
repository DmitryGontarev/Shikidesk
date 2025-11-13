import 'package:shikidesk/data/entity/common/ImageEntity.dart';

/// Сущность с информацией о человеке, принимавшем участиве в создании аниме
///
/// [id] номер
/// [name] имя
/// [nameRu] имя на русском
/// [image] ссылки на фото
/// [url] ссылка
class PersonEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;

  const PersonEntity({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url
  });

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"]
    );
  }
}