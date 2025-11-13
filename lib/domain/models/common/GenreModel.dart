import 'package:equatable/equatable.dart';

/// Модель с жанрами
///
/// [id] жанра
/// [name] название жанра
/// [nameRu] название жанра на рускком
/// [type] тип жанра
class GenreModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final String? type;

  const GenreModel(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.type});

  @override
  List<Object?> get props => [id, name, nameRu, type];
}