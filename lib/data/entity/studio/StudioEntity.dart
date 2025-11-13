/// Сущность с информацией о студии аниме
///
/// [id] номер студии
/// [name] название
/// [nameFiltered]
/// [isReal]
/// [imageUrl] ссылка на логотип студии
class StudioEntity {
  final int? id;
  final String? name;
  final String? nameFiltered;
  final bool? isReal;
  final String? imageUrl;

  const StudioEntity({required this.id,
    required this.name,
    required this.nameFiltered,
    required this.isReal,
    required this.imageUrl});

  factory StudioEntity.fromJson(Map<String, dynamic> json) {
    return StudioEntity(
        id: json["id"],
        name: json["name"],
        nameFiltered: json["filtered_name"],
        isReal: json["real"],
        imageUrl: json["image"]
    );
  }
}
