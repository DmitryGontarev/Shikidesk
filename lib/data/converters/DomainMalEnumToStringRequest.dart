
import 'package:shikidesk/domain/models/myanimelist/RankingType.dart';

/// Конвертация [RankinType] в строку для передачи в запрос
extension RankingTypeToStringRequest on RankingType {
  String toStringRequest() {
    switch (this) {
      case (RankingType.all): return "all";
      case (RankingType.airing): return "airing";
      case (RankingType.upcoming): return "upcoming";
      case (RankingType.tv): return "tv";
      case (RankingType.ova): return "ova";
      case (RankingType.movie): return "movie";
      case (RankingType.special): return "special";
      case (RankingType.bypopularity): return "bypopularity";
      case (RankingType.favorite): return "favorite";
    }
  }
}