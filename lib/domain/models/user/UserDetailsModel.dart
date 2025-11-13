import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/common/SectionType.dart';
import 'package:shikidesk/domain/models/rates/RateStatus.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';

/// Модель детальной информации о пользователе
///
/// [id] id пользователя
/// [nickname] ник пользлвателя
/// [image] ссылки на разные размеры аватара
/// [lastOnlineDate] дата, когда пользователь был последний раз онлайн
/// [url] ссылка на профиль на веб-сайте
/// [name] имя пользователя
/// [sex] пол пользователя
/// [fullYears] количество полных лет
/// [lastOnline] статус нахождения пользователя в сети ("сейчас на сайте")
/// [website] ссылка на указанный сайт пользователя
/// [location] местонахождение пользователя (город проживания)
/// [isBanned] есть ли бан у пользователя
/// [about] информация, которую указал о себе пользователь
/// [aboutHtml] информация о сайте, указанным пользователем
/// [commonInfo] общая информация о пользователе ("Нет личных данных","на сайте с 19 мая 2020 г.")
/// [isShowComments] показывать ли комментарии
/// [isFriend] в друзьях ли пользователь
/// [isIgnored] находиться ли пользователь в списке игнора
/// [stats] статистика пользователя (аниме, манга, жанры, студии и т.д.)
/// [styleId] id стиля страницы пользователя
class UserDetailsModel extends Equatable {
  final int? id;
  final String? nickname;
  final UserImageModel? image;
  final String? lastOnlineDate;
  final String? url;
  final String? name;
  final String? sex;
  final int? fullYears;
  final String? lastOnline;
  final String? website;
  final String? location;
  final bool? isBanned;
  final String? about;
  final String? aboutHtml;
  final List<String>? commonInfo;
  final bool? isShowComments;
  final bool? isFriend;
  final bool? isIgnored;
  final UserStatsModel? stats;
  final int? styleId;

  const UserDetailsModel(
      {this.id,
      this.nickname,
      this.image,
      this.lastOnlineDate,
      this.url,
      this.name,
      this.sex,
      this.fullYears,
      this.lastOnline,
      this.website,
      this.location,
      this.isBanned,
      this.about,
      this.aboutHtml,
      this.commonInfo,
      this.isShowComments,
      this.isFriend,
      this.isIgnored,
      this.stats,
      this.styleId});

  @override
  List<Object?> get props => [
        id,
        nickname,
        image,
        lastOnlineDate,
        url,
        name,
        sex,
        fullYears,
        lastOnline,
        website,
        location,
        isBanned,
        about,
        aboutHtml,
        commonInfo,
        isShowComments,
        isFriend,
        isIgnored,
        stats,
        styleId
      ];
}

/// Сущность статистики пользователя
///
/// [statuses] общие статусы по статистике (аниме, манга)
/// [fullStatuses] полные статусы по статистике (аниме, манга)
/// [scores] оценки (аниме, манга)
/// [types] типы (аниме, манга)
/// [ratings] рейтинг (аниме, манга)
/// [hasAnime] есть ли аниме в статистике пользователя
/// [hasManga] есть ли манга в статистике пользователя
class UserStatsModel extends Equatable {
  final StatusesModel? statuses;
  final StatusesModel? fullStatuses;
  final StatusesModel? scores;
  final StatusesModel? types;
  final StatusesModel? ratings;
  final bool? hasAnime;
  final bool? hasManga;

  const UserStatsModel({
    this.statuses,
    this.fullStatuses,
    this.scores,
    this.types,
    this.ratings,
    this.hasAnime,
    this.hasManga,
  });

  @override
  List<Object?> get props => [
        statuses,
        fullStatuses,
        scores,
        types,
        ratings,
        hasAnime,
        hasManga,
      ];
}

/// Модель каждого пунтка статистики пользователя
///
/// [anime] статистика по аниме
/// [manga] статистика по манге
class StatusesModel extends Equatable {
  final List<StatusModel>? anime;
  final List<StatusModel>? manga;

  const StatusesModel({this.anime, this.manga});

  @override
  List<Object?> get props => [anime, manga];
}

/// Модель подпункта статистики пункта пользователя
///
/// [id] id аниме или манги
/// [groupId] признак, по которму группируется аниме или манга (planned, watching, on_hold, rewatching, completed, dropped)
/// [name] название признака, по которму группируется аниме или манга
/// [size] количество серий или глав
/// [type] тип произведения (Anime, Manga)
class StatusModel extends Equatable {
  final int? id;
  final RateStatus? groupId;
  final RateStatus? name;
  final int? size;
  final SectionType? type;

  const StatusModel({this.id, this.groupId, this.name, this.size, this.type});

  @override
  List<Object?> get props => [
        id,
        groupId,
        name,
        size,
        type,
      ];
}
