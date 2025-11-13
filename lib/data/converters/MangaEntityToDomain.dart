import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/EntityToDomainEnum.dart';
import 'package:shikidesk/data/converters/UserEntityToDomain.dart';
import 'package:shikidesk/data/entity/manga/MangaDetailsEntity.dart';
import 'package:shikidesk/data/entity/manga/MangaEntity.dart';
import 'package:shikidesk/utils/StringExtensions.dart';
import '../../domain/models/manga/MangaDetailsModel.dart';
import '../../domain/models/manga/MangaModel.dart';

/// конвертация [MangaEntity] в модель domain слоя
///
extension MangaEntityToDomainModel on MangaEntity {
  MangaModel toDomainModel() {
    return MangaModel(id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url,
        type: type?.toDomainEnumMangaType(),
        score: score,
        status: status?.toDomainEnumAiredStatus(),
        volumes: volumes,
        chapters: chapters,
        dateAired: dateAired,
        dateReleased: dateReleased);
  }
}

/// конвертация [MangaDetailsEntity] в модель domain слоя
///
extension MangaDetailsEntityToDomainModel on MangaDetailsEntity {
  MangaDetailsModel toDomainModel() {
    return MangaDetailsModel(id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url?.appendHost(),
        type: type?.toDomainEnumMangaType(),
        score: score,
        status: status?.toDomainEnumAiredStatus(),
        volumes: volumes,
        chapters: chapters,
        dateAired: dateAired,
        dateReleased: dateReleased,
        namesEnglish: namesEnglish,
        namesJapanese: namesJapanese,
        synonyms: synonyms,
        description: description,
        descriptionHtml: descriptionHtml,
        descriptionSource: descriptionSource,
        franchise: franchise,
        favoured: favoured,
        anons: anons,
        ongoing: ongoing,
        threadId: threadId,
        topicId: topicId,
        myAnimeListId: myAnimeListId,
        rateScoresStats: rateScoresStats?.map((e) => e.toDomainModel()).toList(),
        rateStatusesStats: rateStatusesStats?.map((e) => e.toDomainModel()).toList(),
        genres: genres?.map((e) => e.toDomainModel()).toList(),
        userRate: userRate?.toDomainModel());
  }
}