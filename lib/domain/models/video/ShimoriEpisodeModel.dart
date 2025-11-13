import 'package:equatable/equatable.dart';

/// Модель с информацией о эпизоде аниме
///
/// [id] идентификационный номер
/// [index] порядковый номер
/// [animeId] идентификационный номер аниме с сайта MyAnimeList
class ShimoriEpisodeModel extends Equatable {
  final int? id;
  final int? index;
  final int? animeId;

  const ShimoriEpisodeModel(
      {required this.id, required this.index, required this.animeId});

  @override
  List<Object?> get props => [id, index, animeId];
}
