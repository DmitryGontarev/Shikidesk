
/// Сущность со ссылками на ресурс произведения
///
/// [id] id ссылки
/// [name] название ресурса (например myanimelist, wikipedia)
/// [url] ссылка на ресурс
class LinkEntity {
  final int? id;
  final String? name;
  final String? url;

  const LinkEntity({required this.id, required this.name, required this.url});

  factory LinkEntity.fromJson(Map<String, dynamic> json) {
    return LinkEntity(
        id: json["id"],
        name: json["kind"],
        url: json["url"]
    );
  }
}
