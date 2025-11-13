import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/EntityToDomainEnum.dart';
import 'package:shikidesk/data/converters/UserEntityToDomain.dart';
import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';
import 'package:shikidesk/data/entity/anime/AnimeVideoEntity.dart';
import 'package:shikidesk/data/entity/anime/ScreenshotEntity.dart';
import 'package:shikidesk/domain/models/anime/AnimeDetailsModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeVideoModel.dart';
import 'package:shikidesk/domain/models/anime/ScreenshotModel.dart';
import 'package:shikidesk/domain/models/studio/StudioModel.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';
import '../entity/anime/AnimeDetailsEntity.dart';
import '../entity/studio/StudioEntity.dart';

/// конвертация [AnimeEntity] в модель domain слоя
///
extension AnimeEntityToDomainModel on AnimeEntity {
  AnimeModel toDomainModel() {
    return AnimeModel(
        id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url,
        type: type?.toDomainEnumAnimeType(),
        score: score,
        status: status?.toDomainEnumAiredStatus(),
        episodes: episodes,
        episodesAired: episodesAired,
        dateAired: dateAired,
        dateReleased: dateReleased);
  }
}

/// конвертация [AnimeDetailsEntity] в модель domain слоя
///
extension AnimeDetailsEntityToDomainModel on AnimeDetailsEntity {
  AnimeDetailsModel toDomainModel() {
    return AnimeDetailsModel(
        id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url?.appendHost(),
        type: type?.toDomainEnumAnimeType(),
        score: score,
        status: status?.toDomainEnumAiredStatus(),
        episodes: episodes,
        episodesAired: episodesAired,
        dateAired: dateAired,
        dateReleased: dateReleased,
        ageRating: ageRating?.toDomainEnumAgeRating(),
        namesEnglish: namesEnglish,
        namesJapanese: namesJapanese,
        synonyms: synonyms,
        duration: duration,
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
        rateScoresStats:
            rateScoresStats?.map((e) => e.toDomainModel()).toList(),
        rateStatusesStats:
            rateStatusesStats?.map((e) => e.toDomainModel()).toList(),
        updatedAt: updatedAt,
        nextEpisodeDate: nextEpisodeDate,
        genres: genres?.map((e) => e.toDomainModel()).toList(),
        studios: studios?.map((e) => e.toDomainModel()).toList(),
        videos: videos?.map((e) => e.toDomainModel()).toList(),
        screenshots: screenshots?.map((e) => e.toDomainModel()).toList(),
        userRate: userRate?.toDomainModel());
  }
}

/// конвертация [StudioEntity] в модель domain слоя
///
extension StudioEntityToDomainModel on StudioEntity {
  StudioModel toDomainModel() {
    return StudioModel(
        id: id,
        name: name,
        nameFiltered: nameFiltered,
        isReal: isReal,
        imageUrl: imageUrl);
  }
}

/// конвертация [AnimeVideoEntity] в модель domain слоя
///
extension AnimeVideoEntityToDomainModel on AnimeVideoEntity {
  AnimeVideoModel toDomainModel() {
    return AnimeVideoModel(
        id: id,
        url: url,
        imageUrl: imageUrl?.appendHost(),
        playerUrl: playerUrl,
        name: name,
        type: type?.toDomainEnumAnimeVideoType(),
        hosting: hosting);
  }
}

/// конвертация [ScreenshotEntity] в модель domain слоя
///
extension ScreenshotEntityToDomainModel on ScreenshotEntity {
  ScreenshotModel toDomainModel() {
    return ScreenshotModel(
        original: original?.appendHost(),
        preview: preview?.appendHost()
    );
  }
}
