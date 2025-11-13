import 'package:shikidesk/domain/models/anime/AnimeSearchType.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';

import '../../domain/models/anime/AnimeVideoType.dart';
import '../../domain/models/common/AgeRatingType.dart';

/// Конвертация [AnimeSearchType] в строку для передачи в запрос
extension AnimeSearchTypeToStringRequest on AnimeSearchType {
  String toStringRequest() {
    switch (this) {
      case (AnimeSearchType.id): return "id";
      case (AnimeSearchType.idDesc): return "id_desc";
      case (AnimeSearchType.ranked): return "ranked";
      case (AnimeSearchType.kind): return "kind";
      case (AnimeSearchType.popularity): return "popularity";
      case (AnimeSearchType.name): return "name";
      case (AnimeSearchType.airedOn): return "aired_on";
      case (AnimeSearchType.episodes): return "episodes";
      case (AnimeSearchType.status): return "status";
      case (AnimeSearchType.random): return "random";
    }
  }
}

/// Конвертация [AnimeType] в строку для передачи в запрос
extension AnimeTypeToStringRequest on AnimeType {
  String toStringRequest() {
    switch (this) {
      case (AnimeType.tv): return "tv";
      case (AnimeType.movie): return "movie";
      case (AnimeType.ova): return "ova";
      case (AnimeType.ona): return "ona";
      case (AnimeType.special): return "special";
      case (AnimeType.music): return "music";
      case (AnimeType.tv_13): return "tv_13";
      case (AnimeType.tv_24): return "tv_24";
      case (AnimeType.tv_48): return "tv_48";
      case (AnimeType.none): return "";
      case (AnimeType.unknown): return "";
    }
  }
}

/// Конвертация [AnimeDurationType] в строку для передачи в запрос
extension AnimeDurationTypeToStringRequest on AnimeDurationType {
  String toStringRequest() {
    switch (this) {
      case (AnimeDurationType.s): return "S";
      case (AnimeDurationType.d): return "D";
      case (AnimeDurationType.f): return "F";
    }
  }
}

/// Конвертация [AnimeVideoType] в строку для передачи в запрос
extension AnimeVideoTypeToStringRequest on AnimeVideoType {
  String toStringRequest() {
    switch (this) {
      case (AnimeVideoType.opening): return "op";
      case (AnimeVideoType.ending): return "ed";
      case (AnimeVideoType.promo): return "pv";
      case (AnimeVideoType.commercial): return "cm";
      case (AnimeVideoType.episodePreview): return "episode_preview";
      case (AnimeVideoType.opEdClip): return "op_ed_clip";
      case (AnimeVideoType.characterTrailer): return "character_trailer";
      case (AnimeVideoType.other): return "other";
      case (AnimeVideoType.unknown): return "";
    }
  }
}

/// Конвертация [RateStatus] в строку для передачи в запрос
extension RateStatusToStringRequest on RateStatus {
  String toStringRequest() {
    switch (this) {
      case (RateStatus.planned): return "planned";
      case (RateStatus.watching): return "watching";
      case (RateStatus.rewatching): return "rewatching";
      case (RateStatus.completed): return "completed";
      case (RateStatus.onHold): return "on_hold";
      case (RateStatus.dropped): return "dropped";
      case (RateStatus.unknown): return "";
    }
  }
}

/// Конвертация [AiredStatus] в строку для передачи в запрос
extension AiredStatusToStringRequest on AiredStatus {
  String toStringRequest() {
    switch (this) {
      case (AiredStatus.anons): return "anons";
      case (AiredStatus.ongoing): return "ongoing";
      case (AiredStatus.released): return "released";
      case (AiredStatus.latest): return "latest";
      case (AiredStatus.paused): return "paused";
      case (AiredStatus.discontinued): return "discontinued";

      case (AiredStatus.finishedAiring): return "finished_airing";
      case (AiredStatus.currentlyAiring): return "currently_airing";
      case (AiredStatus.notYetAired): return "not_yet_aired";

      case (AiredStatus.none): return "";
      case (AiredStatus.unknown): return "";
    }
  }
}

/// Конвертация [AgeRatingType] в строку для передачи в запрос
extension AgeRatingTypeToStringRequest on AgeRatingType {
  String toStringRequest() {
    switch (this) {
      case (AgeRatingType.none): return "none";
      case (AgeRatingType.g): return "g";
      case (AgeRatingType.pg): return "pg";
      case (AgeRatingType.pg_13): return "pg_13";
      case (AgeRatingType.r): return "r";
      case (AgeRatingType.r_plus): return "r_plus";
      case (AgeRatingType.rx): return "rx";
      case (AgeRatingType.unknown): return "";
    }
  }
}

/// Конвертация [TranslationType] в строку для передачи в запрос
extension TranslationTypeToStringRequest on TranslationType {
  String toStringRequest() {
    switch (this) {
      case (TranslationType.subRu): return "subs";
      case (TranslationType.voiceRu): return "dub";
      case (TranslationType.raw): return "raw";
      case (TranslationType.all): return "all";
    }
  }
}