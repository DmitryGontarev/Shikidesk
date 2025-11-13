import 'package:equatable/equatable.dart';

/// Модель пользователя
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
class UserBriefModel extends Equatable {
  final int? id;
  final String? nickname;
  final String? avatar;
  final UserImageModel? image;
  final String? lastOnlineDate;
  final String? name;
  final String? sex;
  final String? website;
  final String? birthDate;
  final String? locale;

  const UserBriefModel(
      {required this.id,
      required this.nickname,
      required this.avatar,
      required this.image,
      required this.lastOnlineDate,
      required this.name,
      required this.sex,
      required this.website,
      required this.birthDate,
      required this.locale});

  @override
  List<Object?> get props => [
        id,
        nickname,
        avatar,
        image,
        lastOnlineDate,
        name,
        sex,
        website,
        birthDate,
        locale
      ];
}

/// Модель картинки страницы пользователя
///
/// [x160] картинка 160 пикселей
/// [x148] картинка 160 пикселей
/// [x80] картинка 80 пикселей
/// [x64] картинка 64 пикселей
/// [x48] картинка 48 пикселей
/// [x32] картинка 32 пикселей
/// [x16] картинка 16 пикселей
class UserImageModel extends Equatable {
  final String? x160;
  final String? x148;
  final String? x80;
  final String? x64;
  final String? x48;
  final String? x32;
  final String? x16;

  const UserImageModel(
      {this.x160, this.x148, this.x80, this.x64, this.x48, this.x32, this.x16});

  @override
  List<Object?> get props => [
        x160,
        x148,
        x80,
        x64,
        x48,
        x32,
        x16,
      ];
}

/// Модель ошибки авторизации
///
/// [error] причина ошибки
/// [errorDescription] описание ошибки
/// [state] состояние авторизации
class UserAuthorizationErrorModel extends Equatable {
  final String? error;
  final String? errorDescription;
  final String? state;

  const UserAuthorizationErrorModel(
      {this.error, this.errorDescription, this.state});

  @override
  List<Object?> get props => [error, errorDescription, state];
}
