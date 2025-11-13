import 'package:equatable/equatable.dart';

/// Сущность постера аниме
///
/// [original] ссылка на оригинальный размер картинки
/// [preview] ссылка на картинку для превью
/// [x96] ссылка на картинку размером 96 пикселей
/// [x48] ссылка на картинку размером 48 пикселей
class ImageModel extends Equatable {
  final String? original;
  final String? preview;
  final String? x96;
  final String? x48;

  const ImageModel({
    required this.original,
    required this.preview,
    required this.x96,
    required this.x48,
  });

  @override
  List<Object?> get props => [
    original,
    preview,
    x96,
    x48,
  ];
}
