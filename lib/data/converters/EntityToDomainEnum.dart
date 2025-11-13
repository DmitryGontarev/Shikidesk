import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/anime/AnimeVideoType.dart';
import 'package:shikidesk/domain/models/common/AgeRatingType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';
import '../../domain/models/common/SectionType.dart';
import '../../domain/models/manga/MangaType.dart';
import '../../domain/models/video/TranslationResolution.dart';

/// Конвертация строки ответа в значение domain слоя [AnimeType]
///
extension AnimeTypeToDomainEnum on String? {
  AnimeType toDomainEnumAnimeType() {
    switch (this) {
      case "tv": return AnimeType.tv;
      case "tv_special": return AnimeType.special;
      case "movie": return AnimeType.movie;
      case "special": return AnimeType.special;
      case "music": return AnimeType.music;
      case "ova": return AnimeType.ova;
      case "ona": return AnimeType.ona;
      case "tv_13": return AnimeType.tv_13;
      case "tv_24": return AnimeType.tv_24;
      case "tv_48": return AnimeType.tv_48;
      case "none": return AnimeType.none;
      default: return AnimeType.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [MangaType]
///
extension MangaTypeToDomainEnum on String? {
  MangaType toDomainEnumMangaType() {
    switch (this) {
      case "manga": return MangaType.manga;
      case "manhwa": return MangaType.manhwa;
      case "manhua": return MangaType.manhua;
      case "light_novel": return MangaType.lightNovel;
      case "novel": return MangaType.novel;
      case "one_shot": return MangaType.oneShot;
      case "doujin": return MangaType.doujin;
      default: return MangaType.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [AiredStatus]
///
extension AiredStatusToDomainEnum on String? {
  AiredStatus toDomainEnumAiredStatus() {
    switch (this) {
      case "anons": return AiredStatus.anons;
      case "ongoing": return AiredStatus.ongoing;
      case "released": return AiredStatus.released;
      case "latest": return AiredStatus.latest;
      case "paused": return AiredStatus.paused;
      case "discontinued": return AiredStatus.discontinued;
      case "none": return AiredStatus.none;

      case "finished_airing": return AiredStatus.released;
      case "currently_airing": return AiredStatus.ongoing;
      case "not_yet_aired": return AiredStatus.anons;

      default: return AiredStatus.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [AgeRatingType]
///
extension AgeRatingToDomainEnum on String? {
  AgeRatingType toDomainEnumAgeRating() {
    switch (this) {
      case ("none"): return AgeRatingType.none;
      case ("g"): return AgeRatingType.g;
      case ("pg"): return AgeRatingType.pg;
      case ("pg_13"): return AgeRatingType.pg_13;
      case ("r"): return AgeRatingType.r;
      case ("r_plus"): return AgeRatingType.r_plus;
      case ("r+"): return AgeRatingType.r_plus;
      case ("rx"): return AgeRatingType.rx;
      default: return AgeRatingType.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [AgeRatingType]
///
extension AnimeVideoTypeToDomainEnum on String? {
  AnimeVideoType toDomainEnumAnimeVideoType() {
    switch (this) {
      case ("op"): return AnimeVideoType.opening;
      case ("ed"): return AnimeVideoType.ending;
      case ("pv"): return AnimeVideoType.promo;
      case ("cm"): return AnimeVideoType.commercial;
      case ("episode_preview"): return AnimeVideoType.episodePreview;
      case ("op_ed_clip"): return AnimeVideoType.opEdClip;
      case ("character_trailer"): return AnimeVideoType.characterTrailer;
      case ("other"): return AnimeVideoType.other;
      default: return AnimeVideoType.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [RateStatus]
///
extension RateStatusToDomainEnum on String? {
  RateStatus toDomainEnumRateStatus() {
    switch (this) {
      case ("watching"): return RateStatus.watching;
      case ("planned"): return RateStatus.planned;
      case ("rewatching"): return RateStatus.rewatching;
      case ("completed"): return RateStatus.completed;
      case ("on_hold"): return RateStatus.onHold;
      case ("dropped"): return RateStatus.dropped;
      default: return RateStatus.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [SectionType]
///
extension SectionTypeToDomainEnum on String? {
  SectionType toDomainEnumSectionType() {
    switch (this) {
      case ("Anime"): return SectionType.anime;
      case ("Manga"): return SectionType.manga;
      case ("Ranobe"): return SectionType.ranobe;
      case ("Character"): return SectionType.character;
      case ("Person"): return SectionType.person;
      case ("User"): return SectionType.user;
      case ("Club"): return SectionType.club;
      case ("ClubPage"): return SectionType.clubPage;
      case ("Collection"): return SectionType.collection;
      case ("Review"): return SectionType.review;
      case ("CosplayGallery"): return SectionType.cosplay;
      case ("Contest"): return SectionType.contest;
      case ("Topic"): return SectionType.topic;
      case ("Comment"): return SectionType.comment;
      default: return SectionType.unknown;
    }
  }
}

/// Конвертация строки ответа в значение domain слоя [TranslationType]
///
extension TranslationTypeToDomainEnum on String? {
  TranslationType toDomainEnumTranslationType() {
    switch (this) {
      case ("subs"): return TranslationType.subRu;
      case ("dub"): return TranslationType.voiceRu;
      default: return TranslationType.raw;
    }
  }
}