
/// Сущность с ссылками на картинки
///
/// [original] ссылка на оригинальный размер картинки
/// [preview] ссылка на картинку для превью
/// [x96] ссылка на картинку размером 96 пикселей
/// [x48] ссылка на картинку размером 48 пикселей
class ImageEntity{
  final String? original;
  final String? preview;
  final String? x96;
  final String? x48;

  const ImageEntity({
    required this.original,
    required this.preview,
    required this.x96,
    required this.x48,
});

  factory ImageEntity.fromJson(Map<String, dynamic> json) {
    return ImageEntity(
        original: json["original"],
        preview: json["preview"],
        x96: json["x96"],
        x48: json["x48"]
    );
  }
}