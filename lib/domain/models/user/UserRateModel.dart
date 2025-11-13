
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/common/SectionType.dart';
import '../rates/RateStatus.dart';

/// Модель элемента списка пользовательского рейтинга
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
class UserRateModel extends Equatable {
  final int? id;
  final int? userId;
  final int? targetId;
  final SectionType? targetType;
  final int? score;
  final RateStatus? status;
  final int? rewatches;
  final int? episodes;
  final int? volumes;
  final int? chapters;
  final String? text;
  final String? textHtml;
  final String? dateCreated;
  final String? dateUpdated;

  const UserRateModel(
      {required this.id,
      required this.userId,
      required this.targetId,
      required this.targetType,
      required this.score,
      required this.status,
      required this.rewatches,
      required this.episodes,
      required this.volumes,
      required this.chapters,
      required this.text,
      required this.textHtml,
      required this.dateCreated,
      required this.dateUpdated});

  @override
  List<Object?> get props => [
        id,
        userId,
        targetId,
        targetType,
        score,
        status,
        rewatches,
        episodes,
        volumes,
        chapters,
        text,
        textHtml,
        dateCreated,
        dateUpdated
      ];
}
