
import 'package:shikidesk/data/entity/video/TrackEntity.dart';

class VideoEntity {
  final int? animeId;
  final int? episodeId;
  final String? player;
  final String? hosting;
  final List<TrackEntity?>? tracks;
  final String? subAss;
  final String? subVtt;

  const VideoEntity({
    required this.animeId,
    required this.episodeId,
    required this.player,
    required this.hosting,
    required this.tracks,
    required this.subAss,
    required this.subVtt
  });

  factory VideoEntity.fromJson(Map<String, dynamic> json) {
    return VideoEntity(
        animeId: json["animeId"],
        episodeId: json["episodeId"],
        player: json["player"],
        hosting: json["hosting"],
        tracks: json["tracks"] == null ? null : (json["tracks"] as List<dynamic>).map((e) => e == null ? null : TrackEntity.fromJson(e)).toList(),
        subAss: json["subtitlesUrl"],
        subVtt: json["subtitlesVttUrl"]
    );
  }
}