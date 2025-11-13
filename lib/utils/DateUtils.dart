
import 'package:intl/intl.dart';
import 'package:shikidesk/utils/Extensions.dart';

const String yyyy_MM_dd = 'yyyy/MM/dd';
const String yyyy_MM_dd_HH_mm_ss = 'yyyy/MM/dd HH:mm:ss';
const String HH_mm = 'HH:mm';
const String DD_MM_YYYY = "dd.MM.yyyy";
const String EEEE_D_MMMM = 'EEEE, d MMMM';

/// Возвращает текущее время устройства
DateTime getCurrentTime() {
  return DateTime.now().toLocal();
}

/// Функция перевода строки в дату
extension FromString on String? {
  DateTime? fromString() {
    if (this == null || this?.isEmpty == true) return null;
    try {
      DateTime dt = DateTime.parse(this ?? '').toLocal();
      return dt;
    } catch (e) {
      return null;
    }
  }
}

/// Функция перевода даты на начало дня
extension ToStartDay on DateTime {
  DateTime toStartDay() {
    return subtract(Duration(hours: hour, minutes: minute, seconds: second));
  }
}

/// Функция форматирования даты по шаблону из Даты
extension FormatDate on DateTime {
  String formatDate({String pattern = DD_MM_YYYY}) {
    return DateFormat(pattern).format(this);
  }
}

/// Функция форматирования даты по шаблону из Строки
extension FormateStringDate on String? {
  String formatDate({String pattern = DD_MM_YYYY}) {
    try {
      DateTime dt = DateTime.parse(this ?? '').toLocal();
      return DateFormat(pattern).format(dt);
    } catch (e) {
      return "";
    }
  }
}

/// Метод возвращает строку вида "22 мин" / "7 ч 15 мин" / "7 дней"
/// количество времени от текущей до будущей даты
extension GetDateBeforeCurrent on String? {
  String? getDateBeforeCurrent() {

    String? dateString;

    // текущая дата
    var currentDate = DateTime.now().toLocal();

    // дата от которой считается разница
    DateTime? calendarDate = fromString();

    calendarDate?.let((date) {

      var difference =
          date.difference(currentDate);

      var days = difference.inDays;
      var hours = difference.inHours;
      var minutes = difference.inMinutes;

      if (days >= 1) {
        dateString = "$days ${getDayEndingString(days)}";
      }

      if (days < 1 && hours >= 1) {
        dateString = "$hours ч ${minutes - hours * 60} мин";
      }

      if (days < 1 && hours < 1) {
        dateString = "$minutes мин";
      }
    });
    return dateString;
  }
}

/// Метод возвращает строку с годом выхода
String getYearString(String? dateString) {
  String year = "";
  var date = dateString.fromString();
  date?.let((it) {
    year = "${it.year}";
  });
  return year;
}

/// Метод возвращает строку для подстановки к количеству дней
String getDayEndingString(int days) {

  if (days % 10 == 1 && days % 100 != 11) {
    return "день";
  }

  if ((days % 10 >= 2 && days % 10 <= 4) && (days < 11 || days > 14)) {
    return "дня";
  }

  return "дней";
}

/// Обёртка над [getDatePeriod]
/// возвращает строку с датами сразу из строк
///
/// [dateStart] дата начала периода
/// [dateEnd] дата конца периода
/// [isNextLine] переносить ли на следующую строку
String getDatePeriodFromString({String? dateStart, String? dateEnd, bool isNextLine = false}) {
  DateTime? start = dateStart.fromString();
  DateTime? end = dateEnd.fromString();
  return getDatePeriod(start, dateEnd: end, isNextLine: isNextLine);
}

/// Метод возвращает строку вида "17 сен 2022" / "17 сен - 20 окт 2022" / "17 сен 2022 - 20 окт 2023",
/// если переданы две даты
///
/// [dateStart] дата начала периода
/// [dateEnd] дата конца периода
/// [isNextLine] переносить ли на следующую строку
String getDatePeriod(DateTime? dateStart, {DateTime? dateEnd, bool isNextLine = false}) {
  List<String> periodList = [];

  dateStart?.let((dStart) {
    DateTime calendarDateStart = dStart.toStartDay();
    String date = calendarDateStart.day.toString();
    String month = calendarDateStart.toMonthName(infinitive: dStart.month != 4).substring(0, 3);
    String year = calendarDateStart.year.toString();
    periodList.add(date);
    periodList.add(" $month");
    periodList.add(" $year");
  });

  dateEnd?.let((dEnd) {
    DateTime calendarDateEnd = dEnd.toStartDay();
    String date = calendarDateEnd.day.toString();
    String month = calendarDateEnd.toMonthName(infinitive: dEnd.month != 4).substring(0, 3);
    String year = calendarDateEnd.year.toString();

    periodList.map((e) {
      if (e == " $year") {
        periodList.remove(e);
      }
    });

    if (isNextLine) {
      periodList.add(" -\n");
      periodList.add(date);
    } else {
      periodList.add(" -");
      periodList.add(" $date");
    }
    periodList.add(" $month");
    periodList.add(" $year");
  });

  return periodList.join();
}

/// Возвращает строку с названием дня недели
extension ToDayName on DateTime {
  String toDayName() {
    switch (weekday) {
      case 1 : return "Понедельник";
      case 2 : return "Вторник";
      case 3 : return "Среда";
      case 4 : return "Четверг";
      case 5 : return "Пятница";
      case 6 : return "Суббота";
      case 7 : return "Воскресенье";
      default: return " ";
    }
  }
}

/// Возвращает строку с названием дня недели
extension IntToDayName on int {
  String toDayName() {
    switch (this) {
      case 1 : return "Понедельник";
      case 2 : return "Вторник";
      case 3 : return "Среда";
      case 4 : return "Четверг";
      case 5 : return "Пятница";
      case 6 : return "Суббота";
      case 7 : return "Воскресенье";
      default: return " ";
    }
  }
}

/// Возвращает строку с названием месяца
extension ToMonthName on DateTime {
  String toMonthName({bool infinitive = true}) {
    switch (month) {
      case 1 : return infinitive ? "январь" : "января";
      case 2 : return infinitive ? "февраль" : "февраля";
      case 3 : return infinitive ? "марта" : "марта";
      case 4 : return infinitive ? "апрель" : "апреля";
      case 5 : return infinitive ? "май" : "мая";
      case 6 : return infinitive ? "июнь" : "июня";
      case 7 : return infinitive ? "июль" : "июля";
      case 8 : return infinitive ? "август" : "августа";
      case 9 : return infinitive ? "сентябрь" : "сентября";
      case 10 : return infinitive ? "октябрь" : "октября";
      case 11 : return infinitive ? "ноябрь" : "ноября";
      case 12 : return infinitive ? "декабрь" : "декабря";
      default: return " ";
    }
  }
}

/// Возвращает строку с названием месяца
extension FromIntToMonthName on int? {
  String toMonthName({bool infinitive = true}) {
    switch (this) {
      case 1 : return infinitive ? "январь" : "января";
      case 2 : return infinitive ? "февраль" : "февраля";
      case 3 : return infinitive ? "марта" : "марта";
      case 4 : return infinitive ? "апрель" : "апреля";
      case 5 : return infinitive ? "май" : "мая";
      case 6 : return infinitive ? "июнь" : "июня";
      case 7 : return infinitive ? "июль" : "июля";
      case 8 : return infinitive ? "август" : "августа";
      case 9 : return infinitive ? "сентябрь" : "сентября";
      case 10 : return infinitive ? "октябрь" : "октября";
      case 11 : return infinitive ? "ноябрь" : "ноября";
      case 12 : return infinitive ? "декабрь" : "декабря";
      default: return " ";
    }
  }
}