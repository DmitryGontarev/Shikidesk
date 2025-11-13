import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/common/ImageEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';

import 'PersonEntity.dart';

/// Сущность с детельной информацией о персонаже
///
/// [id] номер персонажа
/// [name] имя персонажа
/// [nameRu] имя персонажа на русском
/// [image] ссылки на картинки с персонажем
/// [url] ссылка на персонажа
/// [nameAlt] альтернативное имя
/// [nameJp] имя на японском
/// [description] описание
/// [descriptionSource] источник описания
/// [favoured] флаг есть ли в списке избранного
/// [threadId] идентификацонный номер треда
/// [topicId] идентификацонный номер топика
/// [dateUpdate]d дата обновления
/// [seyu] акётр озвучивания
/// [animes] список аниме с персонажем
/// [mangas] список манги с персонажем
class CharacterDetailsEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? nameAlt;
  final String? nameJp;
  final String? description;
  final String? descriptionHtml;
  final String? descriptionSource;
  final bool? favoured;
  final int? threadId;
  final int? topicId;
  final String? dateUpdate;
  final List<PersonEntity>? seyu;
  final List<AnimeEntity>? animes;
  final List<MangaEntity>? mangas;

  const CharacterDetailsEntity(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.image,
      required this.url,
      required this.nameAlt,
      required this.nameJp,
      required this.description,
      required this.descriptionHtml,
      required this.descriptionSource,
      required this.favoured,
      required this.threadId,
      required this.topicId,
      required this.dateUpdate,
      required this.seyu,
      required this.animes,
      required this.mangas});

  factory CharacterDetailsEntity.fromJson(Map<String, dynamic> json) {
    return CharacterDetailsEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image:
            json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"],
        nameAlt: json["altname"],
        nameJp: json["japanese"],
        description: json["description"],
        descriptionHtml: json["description_html"],
        descriptionSource: json["description_source"],
        favoured: json["favoured"],
        threadId: json["thread_id"],
        topicId: json["topic_id"],
        dateUpdate: json["updated_at"],
        seyu: json["seyu"] == null ? null : (json["seyu"] as List<dynamic>).map((e) => PersonEntity.fromJson(e)).toList(),
        animes: json["animes"] == null
            ? null
            : (json["animes"] as List<dynamic>)
                .map((e) => AnimeEntity.fromJson(e))
                .toList(),
        mangas: json["mangas"] == null
            ? null
            : (json["mangas"] as List<dynamic>)
                .map((e) => MangaEntity.fromJson(e))
                .toList());
  }
}
