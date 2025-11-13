
/// Сущность с данными о времени трансляции
///
/// [dayOfTheWeek] день недель трансляции
/// [startTime] время трансляции (Японское время)
class BroadcastEntity {
  final String? dayOfTheWeek;
  final String? startTime;

  const BroadcastEntity({required this.dayOfTheWeek, required this.startTime});

  factory BroadcastEntity.fromJson(Map<String, dynamic> json) {
    return BroadcastEntity(
        dayOfTheWeek: json["day_of_the_week"], startTime: json["start_time"]);
  }
}
