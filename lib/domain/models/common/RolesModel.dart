import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/roles/CharacterModel.dart';
import 'package:shikidesk/domain/models/roles/PersonModel.dart';

/// Сущность с информацией о роли принимавшего участие в создании аниме
///
/// [roles] список с названием ролей
/// [rolesRu] список с названием ролей на руссколм
/// [character] информация о персонаже
/// [person] информация о персоне
class RolesModel extends Equatable {
  final List<String>? roles;
  final List<String>? rolesRu;
  final CharacterModel? character;
  final PersonModel? person;

  const RolesModel(
      {required this.roles,
      required this.rolesRu,
      required this.character,
      required this.person});

  @override
  List<Object?> get props => [roles, rolesRu, character, person];
}
