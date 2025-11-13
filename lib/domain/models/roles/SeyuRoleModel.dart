import 'package:equatable/equatable.dart';

import '../anime/AnimeModel.dart';
import '../manga/MangaModel.dart';
import 'CharacterModel.dart';

/// Модель со списком персонажей, которых озвучивал актёр
///
/// [characters] список персонажей
/// [animes] список аниме
/// [mangas] список манги
class SeyuRoleModel extends Equatable {
  final List<CharacterModel>? characters;
  final List<AnimeModel>? animes;
  final List<MangaModel>? mangas;

  const SeyuRoleModel({
    required this.characters,
    required this.animes,
    required this.mangas});

  @override
  List<Object?> get props => [characters, animes, mangas];
}