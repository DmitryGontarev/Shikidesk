
import 'package:equatable/equatable.dart';

/// Сущность с данными о времени трансляции
///
/// [dayOfTheWeek] день недель трансляции
/// [startTime] время трансляции (Японское время)
class BroadcastModel extends Equatable {
  final String? dayOfTheWeek;
  final String? startTime;

  const BroadcastModel({required this.dayOfTheWeek, required this.startTime});

  @override
  List<Object?> get props => [
    dayOfTheWeek,
    startTime
  ];
}