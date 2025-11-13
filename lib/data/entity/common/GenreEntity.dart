/// Сущность с жанрами
///
/// [id] жанра
/// [name] название жанра
/// [nameRu] название жанра на рускком
/// [type] тип жанра
class GenreEntity {
  final int? id;
  final String? name;
  final String? nameRu;
  final String? type;

  const GenreEntity({required this.id,
    required this.name,
    required this.nameRu,
    required this.type});

  factory GenreEntity.fromJson(Map<String, dynamic> json) {
    return GenreEntity(
        id: json["id"],
        name: json["name"],
        nameRu: json["russian"],
        type: json["kind"]
    );
  }
}
