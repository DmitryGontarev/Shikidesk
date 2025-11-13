
import 'package:flutter/material.dart';
import 'package:shikidesk/domain/models/common/AgeRatingType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/manga/MangaType.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/rates/SortBy.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Colors.dart';

import '../../domain/models/anime/AnimeType.dart';

/// Конвертация статуса выхода [AiredStatus] в цвет
///
extension ToAiredStatusColor on AiredStatus? {
  Color toColor() {
    switch (this) {
      case (AiredStatus.anons): return ShikidroidColors.anonsColor;
      case (AiredStatus.ongoing): return ShikidroidColors.ongoingColor;
      case (AiredStatus.released): return ShikidroidColors.releasedColor;
      case (AiredStatus.paused): return ShikidroidColors.onHoldColor;
      case (AiredStatus.discontinued): return ShikidroidColors.droppedColor;
      default: return Colors.transparent;
    }
  }
}

/// Конвертация статуса выхода [AiredStatus] в строку для показа на экране
///
extension ToAiredStatusScreenString on AiredStatus? {
  String toScreenString() {
    switch (this) {
      case (AiredStatus.anons): return "Анонс";
      case (AiredStatus.ongoing): return "Онгоинг";
      case (AiredStatus.released): return "Релиз";
      case (AiredStatus.latest): return "Недавно вышедшее";
      case (AiredStatus.paused): return "Приостановлен";
      case (AiredStatus.discontinued): return "Прекращен";
      case (AiredStatus.none): return "";
      case (AiredStatus.unknown): return "";
      default: return "";
    }
  }
}

/// Конвертация статуса выхода [AgeRatingType] в строку для показа на экране
///
extension ToAgeRatingTypeScreenString on AgeRatingType? {
  String toScreenString() {
    switch (this) {
      case (AgeRatingType.g): return "0+";
      case (AgeRatingType.pg): return "7+";
      case (AgeRatingType.pg_13): return "13+";
      case (AgeRatingType.r): return "17+";
      case (AgeRatingType.r_plus): return "18+";
      case (AgeRatingType.rx): return "18++";
      default: return "";
    }
  }
}

/// Конвертация статуса выхода [AnimeType] в строку для показа на экране
///
extension ToAnimeTypeScreenString on AnimeType? {
  String toScreenString() {
    switch (this) {
      case (AnimeType.tv): return "TV";
      case (AnimeType.movie): return "Фильм";
      case (AnimeType.special): return "Спешл";
      case (AnimeType.music): return "Клип";
      case (AnimeType.ova): return "OVA";
      case (AnimeType.ona): return "ONA";
      case (AnimeType.tv_13): return "TV";
      case (AnimeType.tv_24): return "TV";
      case (AnimeType.tv_48): return "TV";
      case (AnimeType.none): return "";
      default: return "";
    }
  }
}

/// Конвертация статуса выхода [MangaType] в строку для показа на экране
///
extension ToMangaTypeScreenString on MangaType? {
  String toScreenString() {
    switch (this) {
      case (MangaType.manga): return "Манга";
      case (MangaType.manhwa): return "Манхва";
      case (MangaType.manhua): return "Маньхуа";
      case (MangaType.lightNovel): return "Ранобэ";
      case (MangaType.novel): return "Ранобэ";
      case (MangaType.oneShot): return "Ваншот";
      case (MangaType.doujin): return "Додзинси";
      default: return "";
    }
  }
}

/// Конвертация статуса просмотра [RateStatus] в строку для показа статус релиза аниме на экране
///
extension ToAnimePresentationString on RateStatus {
  String toAnimePresentationString() {
    switch (this) {
      case (RateStatus.watching): return "Смотрю";
      case (RateStatus.planned): return "Запланировано";
      case (RateStatus.rewatching): return "Пересматриваю";
      case (RateStatus.completed): return "Просмотрено";
      case (RateStatus.onHold): return "Отложено";
      case (RateStatus.dropped): return "Брошено";
      default: return "";
    }
  }
}

/// Конвертация строки статуса чтения манги в [RateStatus]
///
extension ToAnimeRateStatus on String {
  RateStatus toAnimeRateStatus() {
    switch (this) {
      case ("Смотрю"): return RateStatus.watching;
      case ("Запланировано"): return RateStatus.planned;
      case ("Пересматриваю"): return RateStatus.rewatching;
      case ("Просмотрено"): return RateStatus.completed;
      case ("Отложено"): return RateStatus.onHold;
      case ("Брошено"): return RateStatus.dropped;
      default: return RateStatus.planned;
    }
  }
}

/// Конвертация статуса просмотра [RateStatus] в цвет
///
extension ToRateColor on RateStatus {
  Color toColor() {
    switch (this) {
      case (RateStatus.watching): return ShikidroidColors.watchingColor;
      case (RateStatus.planned): return ShikidroidColors.plannedColor;
      case (RateStatus.rewatching): return ShikidroidColors.reWatchingColor;
      case (RateStatus.completed): return ShikidroidColors.completedColor;
      case (RateStatus.onHold): return ShikidroidColors.onHoldColor;
      case (RateStatus.dropped): return ShikidroidColors.droppedColor;
      default: return Colors.transparent;
    }
  }
}

/// Конвертация статуса просмотра [RateStatus] в цвет заднего фона
///
extension ToRateBackgroudnColor on RateStatus {
  Color toBackgroundColor() {
    switch (this) {
      case (RateStatus.watching): return ShikidroidColors.backgroundWatchingColor;
      case (RateStatus.planned): return ShikidroidColors.backgroundPlannedColor;
      case (RateStatus.rewatching): return ShikidroidColors.backgroundReWatchingColor;
      case (RateStatus.completed): return ShikidroidColors.backgroundCompletedColor;
      case (RateStatus.onHold): return ShikidroidColors.backgroundOnHoldColor;
      case (RateStatus.dropped): return ShikidroidColors.backgroundDroppedColor;
      default: return Colors.transparent;
    }
  }
}

/// Конвертация статуса просмотра [RateStatus] в ссылку на иконку
///
extension ToRateIconPath on RateStatus {
  String toRateIconPath() {
    switch (this) {
      case (RateStatus.watching): return iconWatching;
      case (RateStatus.planned): return iconPlanned;
      case (RateStatus.rewatching): return iconReWatching;
      case (RateStatus.completed): return iconDone;
      case (RateStatus.onHold): return iconOnHold;
      case (RateStatus.dropped): return iconDropped;
      default: return iconWatching;
    }
  }
}

/// Конвертация типа поиска [SortBy] в строку
///
extension SortByToScreenString on SortBy {
  String toScreenString() {
    switch (this) {
      case (SortBy.byName): return "По названию";
      case (SortBy.byProgress): return "По прогрессу";
      case (SortBy.byReleaseDate): return "По дате выхода";
      case (SortBy.byAddDate): return "По дате добавления";
      case (SortBy.byRefreshDate): return "По дате обновления";
      case (SortBy.byScore): return "По оценке";
      case (SortBy.byEpisodes): return "По эпизодам";
      case (SortBy.byChapters): return "По главам";
    }
  }
}

/// Конвертация строки в тип поиска [SortBy]
///
extension SortByStringToSortBy on String {
  SortBy toSortBy() {
    switch (this) {
      case ("По названию"): return SortBy.byName;
      case ("По прогрессу"): return SortBy.byProgress;
      case ("По дате выхода"): return SortBy.byReleaseDate;
      case ("По дате добавления"): return SortBy.byAddDate;
      case ("По дате обновления"): return SortBy.byRefreshDate;
      case ("По оценке"): return SortBy.byScore;
      case ("По эпизодам"): return SortBy.byEpisodes;
      case ("По главам"): return SortBy.byChapters;
      default: return SortBy.byName;
    }
  }
}

/// Конвертация неизвестного качества видео в строку "src" (source - источник)
///
extension ToSourceResolution on String? {
  String? toSourceResolution() {
    if (this == "unknown") {
      return "src";
    } else {
      return this;
    }
  }
}