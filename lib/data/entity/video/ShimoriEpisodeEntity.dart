
/// Сущность с информацией о эпизоде аниме
///
/// [id] идентификационный номер
/// [index] порядковый номер
/// [animeId] идентификационный номер аниме с сайта MyAnimeList
class ShimoriEpisodeEntity {
  final int? id;
  final int? index;
  final int? animeId;

  const ShimoriEpisodeEntity(
      {required this.id,
        required this.index,
        required this.animeId});

  factory ShimoriEpisodeEntity.fromJson(Map<String, dynamic> json) {
    return ShimoriEpisodeEntity(
        id: json["id"],
        index: json["index"],
        animeId: json["animeId"]
    );
  }
}