
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';

import '../anime/AnimeModel.dart';

/// Сущность с данными о дате выхода аниме
///
/// [nextEpisode] номер следующего эпизода
/// [nextEpisodeDate] дата выхода следующего эпизода
/// [duration] длительность эпизода
/// [anime] сущность с данными об аниме
class CalendarModel extends Equatable {
  final int? nextEpisode;
  final String? nextEpisodeDate;
  final int? duration;
  final AnimeModel? anime;

  // статус пользовательского списка
  final RateStatus? status;

  const CalendarModel({
    required this.nextEpisode,
    required this.nextEpisodeDate,
    required this.duration,
    required this.anime,
    this.status
  });

  @override
  List<Object?> get props => [
    nextEpisode,
    nextEpisodeDate,
    duration,
    anime
  ];
}
