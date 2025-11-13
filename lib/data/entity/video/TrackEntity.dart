
/// Сущность с информацией о качестве видео
///
/// [quality] разрешение видеофайла
/// [url] ссылка на видеофайл
class TrackEntity {
  final String? quality;
  final String? url;

  const TrackEntity({required this.quality, required this.url});

  factory TrackEntity.fromJson(Map<String, dynamic> json) {
    return TrackEntity(
        quality: json["quality"],
        url: json["url"]
    );
  }
}
