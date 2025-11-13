import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/video/TranslationType.dart';

/// Модель с информацией типа трансляции эипозда аниме (оригинал, субтитры, озвучка)
///
/// [id] идентификационный номер эпизода
/// [kind] тип трансляции
/// [targetId] идентификационный номер
/// [episode] порядковый номер эпизода
/// [url] ссылка на эпизод
/// [hosting] навзание хостинга
/// [language] язык трансляции
/// [author] автор загрузки
/// [quality] качество видео
/// [episodesTotal] количество эпизодов
class ShimoriTranslationModel extends Equatable {
  final int? id;
  final TranslationType? kind;
  final int? targetId;
  final int? episode;
  final String? url;
  final String? hosting;
  final String? language;
  final String? author;
  final String? quality;
  final int? episodesTotal;

  const ShimoriTranslationModel({
    required this.id,
    required this.kind,
    required this.targetId,
    required this.episode,
    required this.url,
    required this.hosting,
    required this.language,
    required this.author,
    required this.quality,
    required this.episodesTotal
  });

  @override
  List<Object?> get props => [
    id,
    kind,
    targetId,
    episode,
    url,
    hosting,
    language,
    author,
    quality,
    episodesTotal
  ];
}