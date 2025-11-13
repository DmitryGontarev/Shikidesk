import 'package:equatable/equatable.dart';

/// Модель со оценками
///
/// [name] название
/// [value] значение
class RateScoresModel extends Equatable {
  final int? name;
  final int? value;

  const RateScoresModel({required this.name, required this.value});

  @override
  List<Object?> get props => [name, value];
}

/// Модель со статистикой
///
/// [name] название
/// [value] значение
class RateStatusesModel extends Equatable {
  final String? name;
  final int? value;

  const RateStatusesModel({required this.name, required this.value});


  @override
  List<Object?> get props => [name, value];
}