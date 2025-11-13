import 'package:equatable/equatable.dart';

/// Модель с информацией о дате, связанной с человеком
///
/// [day] день
/// [year] год
/// [month] месяц
class RoleDateModel extends Equatable {
  final int? day;
  final int? year;
  final int? month;

  const RoleDateModel(
      {required this.day, required this.year, required this.month});

  @override
  List<Object?> get props => [day, year, month];
}
