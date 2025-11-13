
/// Сущность с данными пользователя
///
/// [id] id пользователя
/// [nickname] ник пользователя
/// [avatar] ссылка на аватар пользователя
/// [image] ссылки на разные размеры аватара
/// [lastOnlineDate] дата, когда пользователь был последний раз онлайн
/// [name] имя пользователя
/// [sex] пол пользователя
/// [website] ссылка на сайт, который указал пользователь
/// [birthDate] день рождения пользователя
/// [locale] регион пользователя (ru)
class UserBriefEntity {
  final int? id;
  final String? nickname;
  final String? avatar;
  final UserImageEntity? image;
  final String? lastOnlineDate;
  final String? name;
  final String? sex;
  final String? website;
  final String? birthDate;
  final String? locale;

  const UserBriefEntity(
      {this.id,
      this.nickname,
      this.avatar,
      this.image,
      this.lastOnlineDate,
      this.name,
      this.sex,
      this.website,
      this.birthDate,
      this.locale});

  factory UserBriefEntity.fromJson(Map<String, dynamic> json) {
    return UserBriefEntity(
      id: json["id"],
      nickname: json["nickname"],
      avatar: json["avatar"],
      image: json["image"] == null ? null : UserImageEntity.fromJson(json["image"]),
      lastOnlineDate: json["last_online_at"],
      name: json["name"],
      sex: json["sex"],
      website: json["website"],
      birthDate: json["birth_on"],
      locale: json["locale"]
    );
  }
}

/// Сущность картинки страницы пользователя
///
/// [x160] картинка 160 пикселей
/// [x148] картинка 160 пикселей
/// [x80] картинка 80 пикселей
/// [x64] картинка 64 пикселей
/// [x48] картинка 48 пикселей
/// [x32] картинка 32 пикселей
/// [x16] картинка 16 пикселей
class UserImageEntity {
  final String? x160;
  final String? x148;
  final String? x80;
  final String? x64;
  final String? x48;
  final String? x32;
  final String? x16;

  const UserImageEntity(
      {this.x160, this.x148, this.x80, this.x64, this.x48, this.x32, this.x16});

  factory UserImageEntity.fromJson(Map<String, dynamic> json) {
    return UserImageEntity(
      x160: json["x160"],
      x148: json["x148"],
      x80: json["x80"],
      x64: json["x64"],
      x48: json["x48"],
      x32: json["x32"],
      x16: json["x16"]
    );
  }
}

/// Модель ошибки авторизации
///
/// [error] причина ошибки
/// [errorDescription] описание ошибки
/// [state] состояние авторизации
class UserAuthorizationErrorEntity {
  final String? error;
  final String? errorDescription;
  final String? state;

  const UserAuthorizationErrorEntity(
      {this.error, this.errorDescription, this.state});

  factory UserAuthorizationErrorEntity.fromJson(Map<String, dynamic> json) {
    return UserAuthorizationErrorEntity(
      error: json["error"],
      errorDescription: json["error_description"],
      state: json["state"]
    );
  }
}