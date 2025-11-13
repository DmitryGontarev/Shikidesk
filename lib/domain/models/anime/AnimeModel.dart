
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeType.dart';
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import '../common/ImageModel.dart';

/// Сущность с информацией об аниме
///
/// [id] id номер аниме
/// [name] название аниме
/// [nameRu] название аниме на русском
/// [image] ссылка на постер аниме
/// [url] ссылка на страницу сайта с аниме
/// [type] тип релиза аниме (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48)
/// [score] оцена аниме по 10-тибалльной шкале
/// [status] статус релиза (anons, ongoing, released)
/// [episodes] общее количество эпизодов
/// [episodesAired] количество вышедших эпизодов
/// [dateAired] дата начала трансляции
/// [dateReleased] дата выхода
class AnimeModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;
  final AnimeType? type;
  final String? score;
  final AiredStatus? status;
  final int? episodes;
  final int? episodesAired;
  final String? dateAired;
  final String? dateReleased;

  const AnimeModel({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url,
    required this.type,
    required this.score,
    required this.status,
    required this.episodes,
    required this.episodesAired,
    required this.dateAired,
    required this.dateReleased,
  });

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
    episodes,
    episodesAired,
    dateAired,
    dateReleased,
  ];
}