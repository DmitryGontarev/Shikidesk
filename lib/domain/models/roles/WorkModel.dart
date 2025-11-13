import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import 'package:shikidesk/domain/models/manga/MangaModel.dart';

/// Модель с информацией об аниме/манги, в создании которого принимал участие человек
///
/// [anime] аниме
/// [manga] манга
/// [role] роль в создании
class WorkModel extends Equatable {
  final AnimeModel? anime;
  final MangaModel? manga;
  final String? role;

  const WorkModel(
      {required this.anime, required this.manga, required this.role});

  @override
  List<Object?> get props => [anime, manga, role];
}
