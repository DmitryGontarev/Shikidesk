/// Сущность с ссылками на скриншоты из аниме
///
/// [original] оригинальный размер
/// [preview] размер для превью
class ScreenshotEntity {
  final String? original;
  final String? preview;

  const ScreenshotEntity({
    required this.original,
    required this.preview
  });

  factory ScreenshotEntity.fromJson(Map<String, dynamic> json) {
    return ScreenshotEntity(
        original: json["original"],
        preview: json["preview"]
    );
  }
}
