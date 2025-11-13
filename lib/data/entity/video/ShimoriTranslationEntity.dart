
/// Сущность с информацией типа трансляции эипозда аниме (оригинал, субтитры, озвучка)
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
class ShimoriTranslationEntity {
  final int? id;
  final String? kind;
  final int? targetId;
  final int? episode;
  final String? url;
  final String? hosting;
  final String? language;
  final String? author;
  final String? quality;
  final int? episodesTotal;

  const ShimoriTranslationEntity({
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

  factory ShimoriTranslationEntity.fromJson(Map<String, dynamic> json) {
    return ShimoriTranslationEntity(
      id: json["id"],
      kind: json["kind"],
      targetId: json["targetId"],
      episode: json["episode"],
      url: json["url"],
      hosting: json["hosting"],
      language: json["language"],
      author: json["author"],
      quality: json["quality"],
      episodesTotal: json["episodesTotal"]
    );
  }
}
