import 'package:equatable/equatable.dart';

/// Модель с информацией о качестве видео
///
/// [quality] разрешение видеофайла
/// [url] ссылка на видеофайл
class TrackModel extends Equatable {
  final String? quality;
  final String? url;

  const TrackModel({required this.quality, required this.url});

  @override
  List<Object?> get props => [
    quality,
    url
  ];
}
