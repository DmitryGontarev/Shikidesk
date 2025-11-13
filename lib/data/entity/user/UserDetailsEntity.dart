import 'package:shikidesk/data/entity/user/UserBriefEntity.dart';

/// Сущность детальной информации о пользователе
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
class UserDetailsEntity {
  final int? id;
  final String? nickname;
  final UserImageEntity? image;
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
  final UserStatsEntity? stats;
  final int? styleId;

  const UserDetailsEntity(
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

  factory UserDetailsEntity.fromJson(Map<String, dynamic> json) {
    return UserDetailsEntity(
        id: json["id"],
        nickname: json["nickname"],
        image: json["image"] == null
            ? null
            : UserImageEntity.fromJson(json["image"]),
        lastOnlineDate: json["last_online_at"],
        url: json["url"],
        name: json["name"],
        sex: json["sex"],
        fullYears: json["full_years"],
        lastOnline: json["last_online"],
        website: json["website"],
        location: json["location"],
        isBanned: json["banned"],
        about: json["about"],
        aboutHtml: json["about_html"],
        commonInfo: json["common_info"] == null
            ? null
            : (json["common_info"] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
        isShowComments: json["show_comments"],
        isFriend: json["in_friends"],
        isIgnored: json["is_ignored"],
        stats: json["stats"] == null
            ? null
            : UserStatsEntity.fromJson(json["stats"]),
        styleId: json["style_id"]);
  }
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
class UserStatsEntity {
  final StatusesEntity? statuses;
  final StatusesEntity? fullStatuses;
  final StatusesEntity? scores;
  final StatusesEntity? types;
  final StatusesEntity? ratings;
  final bool? hasAnime;
  final bool? hasManga;

  const UserStatsEntity(
      {this.statuses,
      this.fullStatuses,
      this.scores,
      this.types,
      this.ratings,
      this.hasAnime,
      this.hasManga});

  factory UserStatsEntity.fromJson(Map<String, dynamic> json) {
    return UserStatsEntity(
        statuses: json["statuses"] == null
            ? null
            : StatusesEntity.fromJson(json["statuses"]),
        fullStatuses: json["full_statuses"] == null
            ? null
            : StatusesEntity.fromJson(json["full_statuses"]),
        scores: json["scores"] == null
            ? null
            : StatusesEntity.fromJson(json["scores"]),
        types: json["types"] == null
            ? null
            : StatusesEntity.fromJson(json["types"]),
        ratings: json["ratings"] == null
            ? null
            : StatusesEntity.fromJson(json["ratings"]),
        hasAnime: json["has_anime?"],
        hasManga: json["has_manga?"]);
  }
}

/// Сущность каждого пунтка статистики пользователя
///
/// [anime] статистика по аниме
/// [manga] статистика по манге
class StatusesEntity {
  final List<StatusEntity>? anime;
  final List<StatusEntity>? manga;

  const StatusesEntity({this.anime, this.manga});

  factory StatusesEntity.fromJson(Map<String, dynamic> json) {
    return StatusesEntity(
        anime: json["anime"] == null
            ? null
            : (json["anime"] as List<dynamic>)
                .map((e) => StatusEntity.fromJson(e))
                .toList(),
        manga: json["manga"] == null
            ? null
            : (json["manga"] as List<dynamic>)
                .map((e) => StatusEntity.fromJson(e))
                .toList());
  }
}

/// Сущность подпункта статистики пункта пользователя
///
/// [id] id аниме или манги
/// [groupId] признак, по которму группируется аниме или манга (planned, watching, on_hold, rewatching, completed, dropped)
/// [name] название признака, по которму группируется аниме или манга
/// [size] количество серий или глав
/// [type] тип произведения (Anime, Manga)
class StatusEntity {
  final int? id;
  final String? groupId;
  final String? name;
  final int? size;
  final String? type;

  const StatusEntity({this.id, this.groupId, this.name, this.size, this.type});

  factory StatusEntity.fromJson(Map<String, dynamic> json) {
    return StatusEntity(
        id: json["id"],
        groupId: json["grouped_id"],
        name: json["name"],
        size: json["size"],
        type: json["type"]);
  }
}
