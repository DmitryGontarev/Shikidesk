
import 'package:dartz/dartz.dart';
import '../models/calendar/CalendarModel.dart';
import '../models/common/Failure.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс репозитория получения графика выхода эпизодов
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarRepository {

  /// Получение списка с графиком выхода эпизодов
  Future<Either<ServerFailure, List<CalendarModel>?>> getCalendar();
}