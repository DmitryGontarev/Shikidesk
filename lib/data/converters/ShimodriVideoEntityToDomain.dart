import 'package:shikidesk/data/converters/EntityToDomainEnum.dart';
import 'package:shikidesk/data/entity/video/ShimoriEpisodeEntity.dart';
import 'package:shikidesk/data/entity/video/ShimoriTranslationEntity.dart';
import 'package:shikidesk/data/entity/video/TrackEntity.dart';
import 'package:shikidesk/data/entity/video/VideoEntity.dart';
import 'package:shikidesk/domain/models/video/ShimoriEpisodeModel.dart';
import 'package:shikidesk/domain/models/video/ShimoriTranslationModel.dart';
import 'package:shikidesk/domain/models/video/TrackModel.dart';
import 'package:shikidesk/domain/models/video/VideoModel.dart';

/// конвертация [ShimoriEpisodeEntity] в модель domain слоя
///
extension ShimoriEpisodeEntityToDomainModel on ShimoriEpisodeEntity {
  ShimoriEpisodeModel toDomainModel() {
    return ShimoriEpisodeModel(id: id, index: index, animeId: animeId);
  }
}

/// конвертация [ShimoriTranslationEntity] в модель domain слоя
///
extension ShimoriTranslationEntityToDomainModel on ShimoriTranslationEntity {
  ShimoriTranslationModel toDomainModel() {
    return ShimoriTranslationModel(
        id: id,
        kind: kind.toDomainEnumTranslationType(),
        targetId: targetId,
        episode: episode,
        url: url,
        hosting: hosting,
        language: language,
        author: author,
        quality: quality,
        episodesTotal: episodesTotal);
  }
}

/// конвертация [VideoEntity] в модель domain слоя
///
extension VideoEntityToDomainModel on VideoEntity {
  VideoModel toDomianModel() {
    return VideoModel(animeId: animeId,
        episodeId: episodeId,
        player: player,
        hosting: hosting,
        tracks: tracks?.map((e) => e?.toDomainModel()).toList(),
        subAss: subAss,
        subVtt: subVtt);
  }
}

/// конвертация [TrackEntity] в модель domain слоя
///
extension TrackEntityToDomainModel on TrackEntity {
  TrackModel toDomainModel() {
    return TrackModel(
        quality: quality,
        url: url
    );
  }
}