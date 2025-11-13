/// Сущность с информацией о видеоматериалах к аниме
///
/// [id] номер в списке
/// [url] ссылка
/// [imageUrl] ссылка на картинку превью
/// [playerUrl] ссылка на плеер
/// [name] название видео
/// [type] тип видео
/// [hosting] название видеохостинга
class AnimeVideoEntity {
  final int? id;
  final String? url;
  final String? imageUrl;
  final String? playerUrl;
  final String? type;
  final String? name;
  final String? hosting;

  const AnimeVideoEntity({
    required this.id,
    required this.url,
    required this.imageUrl,
    required this.playerUrl,
    required this.name,
    required this.type,
    required this.hosting});

  factory AnimeVideoEntity.fromJson(Map<String, dynamic> json) {
    return AnimeVideoEntity(
        id: json["id"],
        url: json["url"],
        imageUrl: json["image_url"],
        playerUrl: json["player_url"],
        name: json["name"],
        type: json["kind"],
        hosting: json["hosting"]
    );
  }
}
