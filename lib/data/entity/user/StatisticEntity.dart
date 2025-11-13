
/// Сущность со оценками
///
/// [name] название
/// [value] значение
class RateScoresEntity {
  final int? name;
  final int? value;

  const RateScoresEntity({
    required this.name,
    required this.value
  });

  factory RateScoresEntity.fromJson(Map<String, dynamic> json) {
    return RateScoresEntity(
        name: json["name"],
        value: json["value"]
    );
  }
}

/// Сущность со статистикой
///
/// [name] название
/// [value] значение
class RateStatusesEntity {
  final String? name;
  final int? value;

  const RateStatusesEntity({
    required this.name,
    required this.value
  });

  factory RateStatusesEntity.fromJson(Map<String, dynamic> json) {
    return RateStatusesEntity(
        name: json["name"],
        value: json["value"]
    );
  }
}