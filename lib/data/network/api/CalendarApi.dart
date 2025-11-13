
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shikidesk/appconstants/HttpStatusCode.dart';
import 'package:shikidesk/data/entity/calendar/CalendarEntity.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';

////////////////////////////////////////////////////////////////////////////////
/// Интерфейс API для получения данных о дате выпуска аниме
////////////////////////////////////////////////////////////////////////////////
abstract class CalendarApi {

  /// Получение списка с графиком выхода эпизодов
  Future<List<CalendarEntity>?>getCalendar();
}

////////////////////////////////////////////////////////////////////////////////
/// Реализация API для получения данных о дате выпуска аниме
////////////////////////////////////////////////////////////////////////////////
class CalendarApiImpl implements CalendarApi {

  final Dio dio;

  CalendarApiImpl({required this.dio});

  @override
  Future<List<CalendarEntity>?> getCalendar() async {
    final response = await dio.get("/api/calendar");

    if (response.statusCode == HttpCodes.http200) {
      List<CalendarEntity> items = [];
      final calendarJson = json.decode(json.encode(response.data));
      for (dynamic i in calendarJson) {
        items.add(CalendarEntity.fromJson(i));
      }
      return items;
    } else {
      throw ServerException(code: response.statusCode);
    }
  }
}