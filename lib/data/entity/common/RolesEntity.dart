import '../roles/CharacterEntity.dart';
import '../roles/PersonEntity.dart';

/// Сущность с информацией о роли принимавшего участие в создании аниме
///
/// [roles] список с названием ролей
/// [rolesRu] список с названием ролей на руссколм
/// [character] информация о персонаже
/// [person] информация о персоне
class RolesEntity {
  final List<String>? roles;
  final List<String>? rolesRu;
  final CharacterEntity? character;
  final PersonEntity? person;

  const RolesEntity({required this.roles,
    required this.rolesRu,
    required this.character,
    required this.person});

  factory RolesEntity.fromJson(Map<String, dynamic> json) {
    return RolesEntity(
        roles: json["roles"] == null ? null : (json["roles"] as List<dynamic>).map((e) => e as String).toList(),
        rolesRu: json["roles_russian"] == null ? null : (json["roles_russian"] as List<dynamic>).map((e) => e as String).toList(),
        character: json["character"] == null ? null : CharacterEntity.fromJson(json["character"]),
        person: json["person"] == null ? null : PersonEntity.fromJson(json["person"])
    );
  }
}
