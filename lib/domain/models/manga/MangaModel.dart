import 'package:equatable/equatable.dart';

import '../common/AiredStatus.dart';
import '../common/ImageModel.dart';
import 'MangaType.dart';

/// Модель с информацией о манге
///
/// [id] id номер манги
/// [name] название манги
/// [nameRu] название аниме на русском
/// [image] ссылка на обложку манги
/// [url] ссылка на страницу сайта манги
/// [type] тип манги (manga, manwha, manhua, novel, oneshot, doujin)
/// [score] оцена манги по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [volumes] количество томов
/// [chapters] количество глав
/// [dateAired] дата начала выпуска
/// [dateReleased] дата окончания выпуска
class MangaModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;
  final MangaType? type;
  final String? score;
  final AiredStatus? status;
  final int? volumes;
  final int? chapters;
  final String? dateAired;
  final String? dateReleased;

  const MangaModel(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.image,
      required this.url,
      required this.type,
      required this.score,
      required this.status,
      required this.volumes,
      required this.chapters,
      required this.dateAired,
      required this.dateReleased});

  @override
  List<Object?> get props => [
    id,
    name,
    nameRu,
    image,
    url,
    type,
    score,
    status,
    volumes,
    chapters,
    dateAired,
    dateReleased
  ];
}
