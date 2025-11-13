import 'package:equatable/equatable.dart';

import 'AnimeVideoType.dart';

/// Сущность с информацией о видеоматериалах к аниме
///
/// [id] номер в списке
/// [url] ссылка
/// [imageUrl] ссылка на картинку превью
/// [playerUrl] ссылка на плеер
/// [name] название видео
/// [type] тип видео
/// [hosting] название видеохостинга
class AnimeVideoModel extends Equatable {
  final int? id;
  final String? url;
  final String? imageUrl;
  final String? playerUrl;
  final String? name;
  final AnimeVideoType? type;
  final String? hosting;

  const AnimeVideoModel({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.playerUrl,
    required this.type,
    required this.hosting,
  });

  @override
  List<Object?> get props =>
      [id, name, url, imageUrl, playerUrl, type, hosting];
}
