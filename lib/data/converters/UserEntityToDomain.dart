import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/converters/EntityToDomainEnum.dart';
import 'package:shikidesk/data/converters/MangaEntityToDomain.dart';
import 'package:shikidesk/data/entity/auth/TokenEntity.dart';
import 'package:shikidesk/data/entity/rates/RateEntity.dart';
import 'package:shikidesk/data/entity/user/StatisticEntity.dart';
import 'package:shikidesk/data/entity/user/UserBriefEntity.dart';
import 'package:shikidesk/data/entity/user/UserDetailsEntity.dart';
import 'package:shikidesk/domain/models/auth/TokenModel.dart';
import 'package:shikidesk/domain/models/rates/RateModel.dart';
import 'package:shikidesk/domain/models/user/StatisticModel.dart';
import 'package:shikidesk/domain/models/user/UserBriefModel.dart';
import 'package:shikidesk/domain/models/user/UserDetailsModel.dart';

import '../../domain/models/user/UserRateModel.dart';
import '../entity/rates/UserRateEntity.dart';

/// конвертация [TokenEntity] в модель domain слоя
///
extension TokenEntityToDomainModel on TokenEntity {
  TokenModel toDomainModel() {
    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }
}

/// конвертация [UserBriefEntity] в модель domain слоя
///
extension UserBriefEntityToDomainModel on UserBriefEntity {
  UserBriefModel toDomainModel() {
    return UserBriefModel(id: id,
        nickname: nickname,
        avatar: avatar,
        image: image?.toDomainModel(),
        lastOnlineDate: lastOnlineDate,
        name: name,
        sex: sex,
        website: website,
        birthDate: birthDate,
        locale: locale
    );
  }
}

/// конвертация [UserAuthorizationErrorEntity] в модель domain слоя
///
extension UserAuthorizationErrorEntityToDomainModel on UserAuthorizationErrorEntity {
  UserAuthorizationErrorModel toDomainModel() {
    return UserAuthorizationErrorModel(
        error: error,
        errorDescription: errorDescription,
        state: state
    );
  }
}

/// конвертация [UserImageEntity] в модель domain слоя
///
extension UserImageEntityToDomainModel on UserImageEntity {
  UserImageModel toDomainModel() {
    return UserImageModel(
        x160: x160,
        x148: x148,
        x80: x80,
        x64: x64,
        x48: x48,
        x32: x32,
        x16: x16);
  }
}

/// конвертация [UserDetailsEntity] в модель domain слоя
///
extension UserDetailsEntityToDomainModel on UserDetailsEntity {
  UserDetailsModel toDomainModel() {
    return UserDetailsModel(
        id: id,
        nickname: nickname,
        lastOnlineDate: lastOnlineDate,
        url: url,
        name: name,
        sex: sex,
        fullYears: fullYears,
        lastOnline: lastOnline,
        website: website,
        location: location,
        isBanned: isBanned,
        about: about,
        aboutHtml: aboutHtml,
        commonInfo: commonInfo,
        isShowComments: isShowComments,
        isFriend: isFriend,
        isIgnored: isIgnored,
        stats: stats?.toDomainModel(),
        styleId: styleId
    );
  }
}

/// конвертация [UserStatsEntity] в модель domain слоя
///
extension UserStatsEntityToDomainModel on UserStatsEntity {
  UserStatsModel toDomainModel() {
    return UserStatsModel(
        statuses: statuses?.toDomainModel(),
        fullStatuses: fullStatuses?.toDomainModel(),
        scores: scores?.toDomainModel(),
        types: types?.toDomainModel(),
        ratings: ratings?.toDomainModel(),
        hasAnime: hasAnime,
        hasManga: hasManga
    );
  }
}

/// конвертация [StatusesEntity] в модель domain слоя
///
extension StatusesEntityToDomainModel on StatusesEntity {
  StatusesModel toDomainModel() {
    return StatusesModel(
        anime: anime?.map((e) => e.toDomainModel()).toList(),
        manga: manga?.map((e) => e.toDomainModel()).toList()
    );
  }
}

/// конвертация [StatusEntity] в модель domain слоя
///
extension StatusEntityToDomainModel on StatusEntity {
  StatusModel toDomainModel() {
    return StatusModel(
        id: id,
        groupId: groupId?.toDomainEnumRateStatus(),
        name: name?.toDomainEnumRateStatus(),
        size: size,
        type: type?.toDomainEnumSectionType()
    );
  }
}

/// конвертация [RateStatusesEntity] в модель domain слоя
///
extension RateStatusesEntityToDomainModel on RateStatusesEntity {
  RateStatusesModel toDomainModel() {
    return RateStatusesModel(name: name, value: value);
  }
}

/// конвертация [UserRateEntity] в модель domain слоя
///
extension UserRateEntityToDomainModel on UserRateEntity {
  UserRateModel toDomainModel() {
    return UserRateModel(
        id: id,
        userId: userId,
        targetId: targetId,
        targetType: targetType?.toDomainEnumSectionType(),
        score: score,
        status: status?.toDomainEnumRateStatus(),
        rewatches: rewatches,
        episodes: episodes,
        volumes: volumes,
        chapters: chapters,
        text: text,
        textHtml: textHtml,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated);
  }
}

/// конвертация [RateEntity] в модель domain слоя
///
extension RateEntityToDomainModel on RateEntity {
  RateModel toDomainModel() {
    return RateModel(id: id,
        score: score,
        status: status?.toDomainEnumRateStatus(),
        text: text,
        episodes: episodes,
        chapters: chapters,
        volumes: volumes,
        textHtml: textHtml,
        rewatches: rewatches,
        createdDateTime: createdDateTime,
        updatedDateTime: updatedDateTime,
        user: user?.toDomainModel(),
        anime: anime?.toDomainModel(),
        manga: manga?.toDomainModel()
    );
  }
}

/// конвертация [RateScoresEntity] в модель domain слоя
///
extension RateScoresEntityToDomainModel on RateScoresEntity {
  RateScoresModel toDomainModel() {
    return RateScoresModel(name: name, value: value);
  }
}