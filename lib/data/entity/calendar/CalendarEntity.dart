import 'package:shikidesk/data/entity/anime/AnimeEntity.dart';

class CalendarEntity {
  final int? nextEpisode;
  final String? nextEpisodeDate;
  final int? duration;
  final AnimeEntity? anime;

  const CalendarEntity(
      {required this.nextEpisode,
      required this.nextEpisodeDate,
      required this.duration,
      required this.anime});

  factory CalendarEntity.fromJson(Map<String, dynamic> json) {
    return CalendarEntity(
        nextEpisode: json["next_episode"],
        nextEpisodeDate: json["next_episode_at"],
        duration: json["duration"],
        anime: AnimeEntity.fromJson(json["anime"]));
  }
}
