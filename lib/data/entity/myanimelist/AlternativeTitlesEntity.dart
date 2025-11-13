
/// Сущность с альтернативными названиями
///
/// [synonyms] список синонимов
/// [en] название на английском
/// [ja] название на японском
class AlternativeTitlesEntity {
  final List<String>? synonyms;
  final String? en;
  final String? ja;

  const AlternativeTitlesEntity(
      {required this.synonyms, required this.en, required this.ja});

  factory AlternativeTitlesEntity.fromJson(Map<String, dynamic> json) {
    return AlternativeTitlesEntity(
      synonyms: json["synonyms"] == null ? null : (json["synonyms"] as List<dynamic>).map((e) => e as String).toList(),
      en: json["en"],
      ja: json["ja"]
    );
  }
}
