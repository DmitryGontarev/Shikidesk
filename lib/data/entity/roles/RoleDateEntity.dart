/// Сущность с информацией о дате, связанной с человеком
///
/// [day] день
/// [year] год
/// [month] месяц
class RoleDateEntity {
  final int? day;
  final int? year;
  final int? month;

  const RoleDateEntity(
      {required this.day, required this.year, required this.month});

  factory RoleDateEntity.fromJson(Map<String, dynamic> json) {
    return RoleDateEntity(
        day: json["day"],
        year: json["year"],
        month: json["month"]
    );
  }
}
