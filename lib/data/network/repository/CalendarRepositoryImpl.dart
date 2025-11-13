
import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/CalendarEntityToDomain.dart';
import 'package:shikidesk/data/network/api/CalendarApi.dart';
import 'package:shikidesk/domain/repository/CalendarRepository.dart';
import 'package:shikidesk/utils/Extensions.dart';
import '../../../domain/models/calendar/CalendarModel.dart';
import '../../../domain/models/common/Failure.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [CalendarRepository]
/// [api] для получения графика выхода эпизодов
////////////////////////////////////////////////////////////////////////////////
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarApi api;

  CalendarRepositoryImpl({required this.api});

  @override
  Future<Either<ServerFailure, List<CalendarModel>?>> getCalendar() async {
    try {
      final response = await api.getCalendar();
      List<CalendarModel>? items = [];
      response?.let((calendarModel) {
        for (var model in calendarModel) {
          items.add(model.toDomainModel());
        }
      });
      return Right(items);
    } on ServerException catch(e) {
      return Left(ServerFailure(code: e.code));
    }
  }
}