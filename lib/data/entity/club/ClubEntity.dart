
import 'package:shikidesk/data/entity/common/ImageEntity.dart';

/// Сущность данных клуба
///
/// [id] id клуба
/// [name] название клуба
/// [image] логотип клуба
/// [isCensored] есть ли ограничение по возрасту
/// [policyJoin] политика вступления в клуб
/// [policyComment] политика возможности оставлять комментарии
class ClubEntity {
  final int? id;
  final String? name;
  final ImageEntity? image;
  final bool? isCensored;
  final String? policyJoin;
  final String? policyComment;

  const ClubEntity({
    this.id,
    this.name,
    this.image,
    this.isCensored,
    this.policyJoin,
    this.policyComment
  });

  factory ClubEntity.fromJson(Map<String, dynamic> json) {
    return ClubEntity(
      id: json["id"],
      name: json["name"],
      image: json["logo"] == null ? null : ImageEntity.fromJson(json["logo"]),
      isCensored: json["is_censored"],
      policyJoin: json["join_policy"],
      policyComment: json["comment_policy"]
    );
  }
}
