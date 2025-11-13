
import 'package:shikidesk/appconstants/BaseUrl.dart';
import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/EntityToDomainEnum.dart';
import 'package:shikidesk/data/entity/myanimelist/AnimeMalEntity.dart';
import 'package:shikidesk/domain/models/myanimelist/AnimeMalModel.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/myanimelist/AlternativeTitlesModel.dart';
import '../../domain/models/myanimelist/BroadcastModel.dart';
import '../entity/myanimelist/AlternativeTitlesEntity.dart';
import '../entity/myanimelist/BroadcastEntity.dart';

/// конвертация [AnimeMalEntity] в модель domain слоя
///
extension AnimeMalEntityToDomainModel on AnimeMalEntity {
  AnimeMalModel toDomainModel() {
    return AnimeMalModel(
      id: id,
      title: title,
      synopsys: synopsis,
      image: image?.toDomainModel(),
      alternativeTitles: alternativeTitles?.toDomainModel(),
      dateAired: dateAired,
      dateReleased: dateReleased,
      genres: genres?.map((e) => e.toDomainModel()).toList(),
      type: type.toDomainEnumAnimeType(),
      status: status.toDomainEnumAiredStatus(),
      episodes: episodes,
      broadcast: broadcast?.toDomainModel(),
      episodeDuration: episodeDuration,
      ageRating: ageRating.toDomainEnumAgeRating(),
      pictures: pictures?.map((e) => e.toDomainModel()).toList(),
      backgroundInfo: backgroundInfo,
      relatedAnime: relatedAnime?.map((e) => e.toDomainModel()).toList(),
      recommendations: recommendations?.map((e) => e.animeMalEntity?.toDomainModel()).toList(),
      studios: studios?.map((e) => e.toDomainModel()).toList(),
      score: score ?? 0.0,
    );
  }
}

/// конвертация [RelatedAnimeEntity] в модель domain слоя
///
extension RelatedAnimeEntityToDomainModel on RelatedAnimeEntity {
  RelatedAnimeModel toDomainModel() {
    return RelatedAnimeModel(
        anime: anime?.toDomainModel(),
        relationType: relationType,
        relationTypeFormatted: relationTypeFormatted
    );
  }
}

/// конвертация [MainPictureEntity] в модель domain слоя
///
extension MainPictureEntityToDomainModel on MainPictureEntity {
  MainPictureModel toDomainModel() {
    return MainPictureModel(
        medium: medium?.appendHost(baseUrl: BaseUrl.myAnimeListBaseUrl),
        large: large?.appendHost(baseUrl: BaseUrl.myAnimeListBaseUrl));
  }
}

/// конвертация [AlternativeTitlesEntity] в модель domain слоя
///
extension AlternativeTitlesEntityToDomainModel on AlternativeTitlesEntity {
  AlternativeTitlesModel toDomainModel() {
    return AlternativeTitlesModel(synonyms: synonyms, en: en, ja: ja);
  }
}

/// конвертация [BroadcastEntity] в модель domain слоя
///
extension BroadcastEntityToDomainModel on BroadcastEntity {
  BroadcastModel toDomainModel() {
    return BroadcastModel(dayOfTheWeek: dayOfTheWeek, startTime: startTime);
  }
}
