import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/converters/CommonEntityToDomain.dart';
import 'package:shikidesk/data/converters/MangaEntityToDomain.dart';
import 'package:shikidesk/data/entity/roles/CharacterDetailsEntity.dart';
import 'package:shikidesk/data/entity/roles/PersonDetailsEntity.dart';
import 'package:shikidesk/data/entity/roles/RoleDateEntity.dart';
import 'package:shikidesk/data/entity/roles/SeyuRoleEntity.dart';
import 'package:shikidesk/domain/models/roles/CharacterDetailsModel.dart';
import 'package:shikidesk/domain/models/roles/CharacterModel.dart';
import 'package:shikidesk/domain/models/roles/PersonDetailsModel.dart';
import 'package:shikidesk/domain/models/roles/PersonModel.dart';
import 'package:shikidesk/domain/models/roles/RoleDateModel.dart';
import 'package:shikidesk/domain/models/roles/SeyuRoleModel.dart';
import 'package:shikidesk/domain/models/roles/WorkModel.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../entity/roles/CharacterEntity.dart';
import '../entity/roles/PersonEntity.dart';
import '../entity/roles/WorkEntity.dart';

/// конвертация [CharacterDetailsEntity] в модель domain слоя
///
extension CharacterDetailsEntityToDomainModel on CharacterDetailsEntity {
  CharacterDetailsModel toDomainModel() {
    return CharacterDetailsModel(id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url?.appendHost(),
        nameAlt: nameAlt,
        nameJp: nameJp,
        description: description,
        descriptionHtml: descriptionHtml,
        descriptionSource: descriptionSource,
        favoured: favoured,
        threadId: threadId,
        topicId: topicId,
        dateUpdate: dateUpdate,
        seyu: seyu?.map((e) => e.toDomainModel()).toList(),
        animes: animes?.map((e) => e.toDomainModel()).toList(),
        mangas: mangas?.map((e) => e.toDomainModel()).toList()
    );
  }
}

/// конвертация [CharacterEntity] в модель domain слоя
///
extension CharacterEntityToDomainModel on CharacterEntity {
  CharacterModel toDomainModel() {
    return CharacterModel(id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url);
  }
}

/// конвертация [PersonDetailsEntity] в модель domain слоя
///
extension PersonDetailsEntityToDomainModel on PersonDetailsEntity {
  PersonDetailsModel toDomainModel() {
    return PersonDetailsModel(
        id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url?.appendHost(),
        nameJp: nameJp,
        jobTitle: jobTitle,
        birthOn: birthOn?.toDomainModel(),
        deceasedOn: deceasedOn?.toDomainModel(),
        website: website,
        rolesGrouped: rolesGrouped,
        roles: roles?.map((e) => e.toDomainModel()).toList(),
        works: works?.map((e) => e.toDomainModel()).toList(),
        topicId: topicId,
        isFavoritePerson: isFavoritePerson,
        isProducer: isProducer,
        isFavoriteProducer: isFavoriteProducer,
        isMangaka: isMangaka,
        isFavoriteMangaka: isFavoriteMangaka,
        isSeyu: isSeyu,
        isFavoriteSeyu: isFavoriteSeyu,
        updatedAt: updatedAt,
        threadId: threadId,
        birthday: birthday?.toDomainModel()
    );
  }
}

/// конвертация [PersonEntity] в модель domain слоя
///
extension PersonEntityToDomainModel on PersonEntity {
  PersonModel toDomainModel() {
    return PersonModel(id: id,
        name: name,
        nameRu: nameRu,
        image: image?.toDomainModel(),
        url: url);
  }
}

/// конвертация [SeyuRoleEntity] в модель domain слоя
///
extension SeyuRoleEntitytToDomainModel on SeyuRoleEntity {
  SeyuRoleModel toDomainModel() {
    return SeyuRoleModel(
        characters: characters?.map((e) => e.toDomainModel()).toList(),
        animes: animes?.map((e) => e.toDomainModel()).toList(),
        mangas: mangas?.map((e) => e.toDomainModel()).toList()
    );
  }
}

/// конвертация [WorkEntity] в модель domain слоя
///
extension WorkEntityToDomainModel on WorkEntity {
  WorkModel toDomainModel() {
    return WorkModel(
        anime: anime?.toDomainModel(),
        manga: manga?.toDomainModel(),
        role: role
    );
  }
}

/// конвертация [RoleDateEntity] в модель domain слоя
///
extension RoleDateEntityToDomainModel on RoleDateEntity {
  RoleDateModel toDomainModel() {
    return RoleDateModel(
        day: day,
        year: year,
        month: month
    );
  }
}