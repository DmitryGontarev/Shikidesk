
import 'package:shikidesk/data/converters/DomainEnumToStringRequest.dart';
import 'package:shikidesk/domain/models/anime/AnimeSearchType.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../../domain/models/common/AgeRatingType.dart';
import '../../domain/models/common/AiredStatus.dart';
import '../../domain/models/rates/RateStatus.dart';

/// Возвращает строку из элементов, разделённых запятой, или [null], если список пустой
extension ToStringOrNull<T> on List<T> {
  String? toStringOrNull() {
    if (isNotEmpty) {
      String listString = "";
      for (var i in this) {
        if (i != last) {
          listString += ("$i,");
        } else {
          listString += i.toString();
        }
      }
      return listString;
    } else {
      return null;
    }
  }
}

/// Возвращает список, если он не пустой, или [null]
extension ToNullIfEmpty<T> on List<T> {
  List<T>? toNullIfEmpty() {
    if (isNotEmpty) {
      return this;
    } else {
      return null;
    }
  }
}

/// Конвертация списка типов аниме в строку запроса
extension ToStringRequestAnimeType on List<AnimeType> {
  String? toStringRequestAnimeType() {
    List<String> animeTypes = [];
    for (var i in this) {
      animeTypes.add(i.toStringRequest());
    }
    return animeTypes.toStringOrNull();
  }
}

/// Конвертация списка [AiredStatus] в строку запроса
extension ToStringRequestAiredStatuses on List<AiredStatus> {
  String? toStringRequestAiredStatuses() {
    List<String> airedStatus = [];
    for (var i in this) {
      airedStatus.add(i.toStringRequest());
    }
    return airedStatus.toStringOrNull();
  }
}

/// Конвертация списка [AnimeDurationType] в строку запроса
extension ToStringRequestDuration on List<AnimeDurationType> {
  String? toStringRequestDuration() {
    List<String> durations = [];
    for (var i in this) {
      durations.add(i.toStringRequest());
    }
    return durations.toStringOrNull();
  }
}

/// Конвертация списка [AgeRatingType] в строку запроса
extension ToStringRequestAgeRatingType on List<AgeRatingType> {
  String? toStringRequestAgeRatingType() {
    List<String> ageType = [];
    for (var i in this) {
      ageType.add(i.toStringRequest());
    }
    return ageType.toStringOrNull();
  }
}

/// Конвертация списка [RateStatus] в строку запроса
extension ToStringRequestRateStatus on List<RateStatus> {
  String? toStringRequestRateStatus() {
    List<String> rateStatuses = [];
    for (var i in this) {
      rateStatuses.add(i.toStringRequest());
    }
    return rateStatuses.toStringOrNull();
  }
}

/// Конвертация сезонов выхода аниме в строку запроса
extension ToStringRequestSeason on List<(String?, String?)> {
  String? toStringRequestSeason() {
    List<String> seasons = [];
    for (var i in this) {

      if (i.$1.isNullOrEmpty().not() && i.$2.isNullOrEmpty()) {
        i.$1?.let((it) {
          seasons.add(it);
        });
      }

      if (i.$1.isNullOrEmpty() && i.$2.isNullOrEmpty().not()) {
        i.$2?.let((it) {
          seasons.add(it);
        });
      }

      if (i.$1.isNullOrEmpty().not() && i.$2.isNullOrEmpty().not()) {
        seasons.add(
          "${i.$1!}_${i.$2!}"
        );
      }
    }
    return seasons.toStringOrNull();
  }
}