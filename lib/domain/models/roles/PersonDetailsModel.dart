import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/common/ImageModel.dart';
import 'package:shikidesk/domain/models/roles/RoleDateModel.dart';

import 'SeyuRoleModel.dart';
import 'WorkModel.dart';

/// Модель с детельной информацией о человеке
///
/// [id] номер человека
/// [name] имя человека
/// [nameRu] имя человека на русском
/// [image] ссылки на фото с человеком
/// [url] ссылка на человека
/// [nameJp] имя на японском
/// [jobTitle] название работы
/// [birthOn] дата рождения
/// [deceasedOn] дата смерти
/// [website] ссылка на сайт
/// [rolesGrouped] список групповых ролей
/// [roles] список ролей
/// [works] список работ
/// [topicId] идентификацонный номер топика
/// [isFavoritePerson]
/// [isProducer]
/// [isFavoriteProducer]
/// [isMangaka]
/// [isFavoriteMangaka]
/// [isSeyu]
/// [isFavoriteSeyu]
/// [updatedAt]
/// [threadId] идентификацонный номер треда
/// [birthday]
class PersonDetailsModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;
  final String? nameJp;
  final String? jobTitle;
  final RoleDateModel? birthOn;
  final RoleDateModel? deceasedOn;
  final String? website;
  final List<List<String?>?>? rolesGrouped;
  final List<SeyuRoleModel>? roles;
  final List<WorkModel>? works;
  final int? topicId;
  final bool? isFavoritePerson;
  final bool? isProducer;
  final bool? isFavoriteProducer;
  final bool? isMangaka;
  final bool? isFavoriteMangaka;
  final bool? isSeyu;
  final bool? isFavoriteSeyu;
  final String? updatedAt;
  final int? threadId;
  final RoleDateModel? birthday;

  const PersonDetailsModel(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.image,
      required this.url,
      required this.nameJp,
      required this.jobTitle,
      required this.birthOn,
      required this.deceasedOn,
      required this.website,
      required this.rolesGrouped,
      required this.roles,
      required this.works,
      required this.topicId,
      required this.isFavoritePerson,
      required this.isProducer,
      required this.isFavoriteProducer,
      required this.isMangaka,
      required this.isFavoriteMangaka,
      required this.isSeyu,
      required this.isFavoriteSeyu,
      required this.updatedAt,
      required this.threadId,
      required this.birthday});

  @override
  List<Object?> get props => [
        id,
        name,
        nameRu,
        image,
        url,
        nameJp,
        jobTitle,
        birthOn,
        deceasedOn,
        website,
        rolesGrouped,
        roles,
        works,
        topicId,
        isFavoritePerson,
        isProducer,
        isFavoriteProducer,
        isMangaka,
        isFavoriteMangaka,
        isSeyu,
        isFavoriteSeyu,
        updatedAt,
        threadId,
        birthday
      ];
}
