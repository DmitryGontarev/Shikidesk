import 'package:dartz/dartz.dart';
import 'package:shikidesk/domain/repository/CalendarRepository.dart';
import '../models/calendar/CalendarModel.dart';
import '../models/common/Failure.dart';

/// Интерфейс интерактора получения графика выхода эпизодов
abstract class CalendarInteractor {

  /// Получение списка с графиком выхода эпизодов
  Future<Either<ServerFailure, List<CalendarModel>?>> getCalendar();
}

/// Реализация интерактора [CalendarInteractor]
///
/// [repository] репозитория для получения графика выхода эпизодов
class CalendarInteractorImpl implements CalendarInteractor {
  final CalendarRepository repository;

  CalendarInteractorImpl({required this.repository});

  @override
  Future<Either<ServerFailure, List<CalendarModel>?>> getCalendar() async {
    return await repository.getCalendar();
  }
}