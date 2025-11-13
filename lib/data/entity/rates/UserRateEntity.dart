/// Сущность элемента списка пользовательского рейтинга
///
/// [id] id номер элемента
/// [userId] id номер пользователя
/// [targetId] id номер элемента списка
/// [targetType] тип произведения (Anime, Manga, Ranobe)
/// [score] оценка
/// [status] в каком статусе (watched, planned)
/// [rewatches] количество повторных просмотров
/// [episodes] количество эпизодов
/// [volumes] количестов томов
/// [chapters] количество глав
/// [text] описание
/// [textHtml] описание в виде HTML
/// [dateCreated] дата добавления в пользовательский список
/// [dateUpdated] дата обновления
class UserRateEntity {
  final int? id;
  final int? userId;
  final int? targetId;
  final String? targetType;
  final int? score;
  final String? status;
  final int? rewatches;
  final int? episodes;
  final int? volumes;
  final int? chapters;
  final String? text;
  final String? textHtml;
  final String? dateCreated;
  final String? dateUpdated;

  const UserRateEntity({
    this.id,
    this.userId,
    this.targetId,
    this.targetType,
    this.score,
    this.status,
    this.rewatches,
    this.episodes,
    this.volumes,
    this.chapters,
    this.text,
    this.textHtml,
    this.dateCreated,
    this.dateUpdated,
  });

  factory UserRateEntity.fromJson(Map<String, dynamic> json) {
    return UserRateEntity(
        id: json["id"],
        userId: json["user_id"],
        targetId: json["target_id"],
        targetType: json["target_type"],
        score: json["score"],
        status: json["status"],
        rewatches: json["rewatches"],
        episodes: json["episodes"],
        volumes: json["volumes"],
        chapters: json["chapters"],
        text: json["text"],
        textHtml: json["text_html"],
        dateCreated: json["created_at"],
        dateUpdated: json["updated_at"]
    );
  }
}
