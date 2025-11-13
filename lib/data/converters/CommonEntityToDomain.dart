import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/converters/MangaEntityToDomain.dart';
import 'package:shikidesk/data/converters/RolesEntityToDomain.dart';
import 'package:shikidesk/data/entity/common/ImageEntity.dart';
import 'package:shikidesk/data/entity/common/LinkEntity.dart';
import 'package:shikidesk/data/entity/common/RelatedEntity.dart';
import 'package:shikidesk/data/entity/common/RolesEntity.dart';
import 'package:shikidesk/domain/models/common/GenreModel.dart';
import 'package:shikidesk/domain/models/common/ImageModel.dart';
import 'package:shikidesk/domain/models/common/LinkModel.dart';
import 'package:shikidesk/domain/models/common/RelatedModel.dart';
import 'package:shikidesk/domain/models/common/RolesModel.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

import '../entity/common/GenreEntity.dart';

/// конвертация [ImageEntity] в модель domain слоя
///
extension ImageEntityToDomainModel on ImageEntity {
  ImageModel toDomainModel() {
    return ImageModel(
        original: original?.appendHost(),
        preview: preview?.appendHost(),
        x96: x96?.appendHost(),
        x48: x48?.appendHost()
    );
  }
}

/// конвертация [GenreEntity] в модель domain слоя
///
extension GenreEntityToDomainModel on GenreEntity {
  GenreModel toDomainModel() {
    return GenreModel(
        id: id,
        name: name,
        nameRu: nameRu,
        type: type
    );
  }
}

/// конвертация [RelatedEntity] в модель domain слоя
///
extension RelatedEntityToDominModel on RelatedEntity {
  RelatedModel toDomainModel() {
    return RelatedModel(
        relation: relation,
        relationRu: relationRu,
        anime: anime?.toDomainModel(),
        manga: manga?.toDomainModel()
    );
  }
}

/// конвертация [RolesEntity] в модель domain слоя
///
extension RolesEntityToDomainModel on RolesEntity {
  RolesModel toDomainModel() {
    return RolesModel(
        roles: roles,
        rolesRu: rolesRu,
        character: character?.toDomainModel(),
        person: person?.toDomainModel()
    );
  }
}

/// конвертация [LinkEntity] в модель domain слоя
///
extension LinkEntityToDomainModel on LinkEntity {
  LinkModel toDomainModel() {
    return LinkModel(
        id: id,
        name: name,
        url: url
    );
  }
}