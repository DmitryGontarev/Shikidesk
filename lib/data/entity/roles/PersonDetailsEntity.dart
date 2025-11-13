import 'package:shikidesk/data/entity/common/ImageEntity.dart';
import 'package:shikidesk/data/entity/roles/RoleDateEntity.dart';
import 'package:shikidesk/data/entity/roles/SeyuRoleEntity.dart';
import 'package:shikidesk/data/entity/roles/WorkEntity.dart';

/// Сущность с детельной информацией о человеке
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
class PersonDetailsEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageEntity? image;
  final String? url;
  final String? nameJp;
  final String? jobTitle;
  final RoleDateEntity? birthOn;
  final RoleDateEntity? deceasedOn;
  final String? website;
  final List<List<String?>?>? rolesGrouped;
  final List<SeyuRoleEntity>? roles;
  final List<WorkEntity>? works;
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
  final RoleDateEntity? birthday;

  const PersonDetailsEntity(
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

  factory PersonDetailsEntity.fromJson(Map<String, dynamic> json) {
    return PersonDetailsEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        image: json["image"] == null ? null : ImageEntity.fromJson(json["image"]),
        url: json["url"],
        nameJp: json["japanese"],
        jobTitle: json["job_title"],
        birthOn: json["birth_on"] == null ? null : RoleDateEntity.fromJson(json["birth_on"]),
        deceasedOn: json["deceased_on"] == null ? null : RoleDateEntity.fromJson(json["deceased_on"]),
        website: json["website"],
        rolesGrouped: json["groupped_roles"] == null ? null : (json["groupped_roles"] as List<dynamic>?)?.map((list) => (list as List<dynamic>?)?.map((e) => e.toString()).toList()).toList(),
        roles: json["roles"] == null ? null : (json["roles"] as List<dynamic>).map((e) => SeyuRoleEntity.fromJson(e)).toList(),
        works: json["works"] == null ? null : (json["works"] as List<dynamic>).map((e) => WorkEntity.fromJson(e)).toList(),
        topicId: json["topic_id"],
        isFavoritePerson: json["person_favoured"],
        isProducer: json["producer"],
        isFavoriteProducer: json["producer_favoured"],
        isMangaka: json["mangaka"],
        isFavoriteMangaka: json["mangaka_favoured"],
        isSeyu: json["seyu"],
        isFavoriteSeyu: json["seyu_favoured"],
        updatedAt: json["updated_at"],
        threadId: json["thread_id"],
        birthday: json["birthday"] == null ? null : RoleDateEntity.fromJson(json["birthday"]));
  }
}