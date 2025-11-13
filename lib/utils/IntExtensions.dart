import 'package:shikidesk/utils/Extensions.dart';

/// Возвращает [true], если число больше переданного
extension IsMoreThan on int? {
  bool isMoreThan(int value) {
    bool flag = false;
    this?.let((that) => {
      flag = that > value
    });
    return flag;
  }
}

/// Возвращает [true], если число больше переданного
bool isMoreThan(int? value, int number) {
  bool flag = false;
  value?.let((it) => {
    flag = it > number
  });
  return flag;
}

/// Возвращает 0, если null
extension OrZero on int? {
  int orZero() {
    return this ?? 0;
  }
}

/// Возвращает строку со временем в виде "1 ч 22 мин"
extension ToEpisodeTime on int {
  String toEpisodeTime({bool isMal = false}) {
    if (isMal) {
      var time = this ~/ 60;
      var hours = time ~/ 60;
      var minutes = time % 60;
      if (this <= 0) {
        return "";
      } else {
        if (hours >= 1) {
          return "$hours ч $minutes мин";
        } else {
          return "$minutes мин";
        }
      }
    } else {
      var hours = this ~/ 60;
      var minutes = this % 60;
      if (this <= 0) {
        return "";
      } else {
        if (hours >= 1) {
          return "$hours ч $minutes мин";
        } else {
          return "$this мин";
        }
      }
    }
  }
}

/// Возвращает строку вида 07:57 или 01:07:57
/// передавать время в секундах
extension ToVideoTime on int {
  String toVideoTime() {
    var videoTime = "";

    // узнаём, есть ли часы (делим общее время в секундах на 60 секунд * 60 минут)
    var hours = this ~/ 3600;

    if (hours >= 1) {
      // находим остаток минут и секунда, отнимая количество часов
      var timeWithoutHours = this - hours * 3600;

      // находим минуты
      // делим оставшиеся секунды на 60
      var minutes = timeWithoutHours ~/ 60;

      // находим секунды
      var seconds = (timeWithoutHours - minutes * 60) % 60;

      var hourStr = hours < 10 ? "0$hours" : "$hours";

      var minuteStr = minutes < 10 ? "0$minutes" : "$minutes";

      var secondStr = seconds < 10 ? "0$seconds" : "$seconds";

      videoTime = "$hourStr:$minuteStr:$secondStr";
    } else {
      // находим минуты
      // делим оставшиеся секунды на 60
      var minutes = this ~/ 60;

      // находим секунды
      var seconds = this % 60;

      var minuteStr = minutes < 10 ? "0$minutes" : "$minutes";

      var secondStr = seconds < 10 ? "0$seconds" : "$seconds";

      videoTime = "$minuteStr:$secondStr";
    }
    return videoTime;
  }
}

/// Возвращает значение из диапазона, если переданное в него не входит
extension InRange on int {
  int inRange({int min = 0, required int max}) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }
}