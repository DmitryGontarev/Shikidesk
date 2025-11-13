import 'package:equatable/equatable.dart';

import '../anime/AnimeModel.dart';
import '../common/ImageModel.dart';
import '../manga/MangaModel.dart';
import 'PersonModel.dart';

/// Модель с детельной информацией о персонаже
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
class CharacterDetailsModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
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
  final List<PersonModel>? seyu;
  final List<AnimeModel>? animes;
  final List<MangaModel>? mangas;

  const CharacterDetailsModel(
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

  @override
  List<Object?> get props => [
        id,
        name,
        nameRu,
        image,
        url,
        nameAlt,
        nameJp,
        description,
        descriptionHtml,
        descriptionSource,
        favoured,
        threadId,
        topicId,
        dateUpdate,
        seyu,
        animes,
        mangas
      ];
}
