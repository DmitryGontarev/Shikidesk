
import 'package:equatable/equatable.dart';

import 'TrackModel.dart';

class VideoModel extends Equatable {
  final int? animeId;
  final int? episodeId;
  final String? player;
  final String? hosting;
  final List<TrackModel?>? tracks;
  final String? subAss;
  final String? subVtt;

  const VideoModel({
    required this.animeId,
    required this.episodeId,
    required this.player,
    required this.hosting,
    required this.tracks,
    required this.subAss,
    required this.subVtt
  });

  @override
  List<Object?> get props => [
    animeId,
    episodeId,
    player,
    hosting,
    tracks,
    subAss,
    subVtt
  ];
}