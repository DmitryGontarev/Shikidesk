
import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/anime/AnimeModel.dart';
import '../manga/MangaModel.dart';

/// Модель с информацией о аниме/манге связанных с текущим
///
/// [relation] названия типа связи (например Адаптация)
/// [relationRu] названия связи на русском
/// [anime] связанное аниме, если есть
/// [manga] связанная манга, если есть
class RelatedModel extends Equatable {
  final String? relation;
  final String? relationRu;
  final AnimeModel? anime;
  final MangaModel? manga;

  const RelatedModel({
    required this.relation,
    required this.relationRu,
    required this.anime,
    required this.manga});

  @override
  List<Object?> get props => [
    relation,
    relationRu,
    anime,
    manga
  ];
}