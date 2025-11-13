import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../appconstants/BaseUrl.dart';

/// Регулярное выражение для парсинга ссылки
///
/// вида [character=177824]Ко Ямори[/character] или [url=https://ru.wikipedia.org/wiki/Гяру]Гяру[/url]
var shikimoriLinkRegex = RegExp(
    "(\\[{1})([a-z]{1,})(={1})([а-яА-яЁёa-zA-Z0-9:\\/\\\\\\\\.#_|@!?\$%^&;:*()+=<>\"№\\s-]{1,})(\\]{1})([а-яА-яЁёa-zA-Z0-9:\\/\\\\\\\\.#_|@!?\$%^&;:*()+=<>\"№\\s-]{1,})(\\[{1})(\\/{1})([a-z]{1,})(\\]{1})");

/// Регулярное выражние для парсинга спойлеров
var spoilerRegex = RegExp("(\\[spoiler=спойлер\\]{1})");

/// Строка идентификации спойлера в подстроке
var spoilerStartString = "[spoiler]";

/// Строка идентификации спойлера в подстроке
var spoilerEndString = "[/spoiler]";

/// Список цифры для проверки наличия их в строке
var digitsChars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

/// Удаляет все символы из строки кроме цифр
///
extension ToOnlyDigits on String? {
  String toOnlyDigits() {
    var s = "";

    for (var c in toCharList()) {
      for (var d in digitsChars) {
        if (c == d) {
          s += c;
        }
      }
    }

    return s;
  }
}

/// Возвращает список символов строки
extension ToCharList on String? {
  List<String> toCharList() {
    List<String> charList = [];

    if (this != null) {
      for (int i = 0; i < (this?.length ?? 0); i++) {
        charList.add(this?[i] ?? '');
      }
    }

    return charList;
  }
}

/// Функция для сравнения двух строк
bool equalsIgnoreCase(String? string1, String? string2) {
  return string1?.toLowerCase() == string2?.toLowerCase();
}

/// Возвращает [true], если часть первой строки совпадает со второй
bool containsIgnoreCase(String? string1, String? string2) {
  return string1?.toLowerCase().contains(string2?.toLowerCase() ?? "") == true;
}

/// Добавляет адрес хоста к ссылке, если его нет
/// [baseUrl] базовый адрес сервера
String appendHost(String? url, {String baseUrl = BaseUrl.shikimoriBaseUrl}) {
  final String currentUrl = url ?? " ";
  if (url?.contains("http") == true) {
    return currentUrl ?? " ";
  } else {
    return baseUrl + currentUrl;
  }
}

/// Добавляет адрес хоста к ссылке, если его нет
/// [baseUrl] базовый адрес сервера
extension AppendHost on String {
  String appendHost({String baseUrl = BaseUrl.shikimoriBaseUrl}) {
    final String currentUrl = this ?? " ";
    if (contains("http") == true) {
      return currentUrl ?? " ";
    } else {
      return baseUrl + currentUrl;
    }
  }
}

/// Убирает m3u8 из ссылки на видео часть для потоковой загрузки
extension ToDownloadLink on String {
  String toDownloadLink() {
    if (contains("m3u8")) {
      var index = lastIndexOf("mp4");
      if (index == -1) {
        return "";
      }
      return substring(0, index + "mp4".length);
    } else {
      return this;
    }
  }
}

/// Возвращает пустую строку, если текущая [null]
String orEmpty(String? str) {
  return str ?? "";
}

/// Возвращает пустую строку, если текущая [null]
extension OrEmpty on String? {
  String orEmpty() {
    return this ?? "";
  }
}

/// Возвращает одну из строк или пустую строку, если обе [null]
String getEmptyIfBothNull(String? one, String? two) {
  if (one != null && one.isNotEmpty) {
    return one.orEmpty();
  }
  if (two != null && two.isNotEmpty) {
    return two.orEmpty();
  }
  return "";
}

/// Возвращает [true], если строка пустая или [null]
extension IsNullOrEmpty on String? {
  bool isNullOrEmpty() {
    return this == null || this == "";
  }
}

/// Возвращает null, если строка пустая
extension GetNullIfEmpty on String? {
  String? getNullIfEmpty() {
    if (isNullOrEmpty()) {
      return null;
    } else {
      return this;
    }
  }
}

/// Возвращает обратное значение [bool]
extension Not on bool {
  bool not() {
    return !this;
  }
}

/// Метод для возврата строки с аннотациями
///
/// [text] строка текста
/// [textSize] размер текста
/// [primaryColor] цвет основного текста
/// [descriptionColor] цвет аннотации
/// [spoilerColor] второй цвет аннотации
/// [navigateCallback] обратный вызов с возвратом типа ссылки и id для загрузки данных
RichText getAnnotationString(
    {required String? text,
    required double textSize,
    required Color primaryColor,
    required Color annotationColor,
    required Function(String linkType, String id, String name)
        navigateCallback}) {
  // список TextSpan для соединения в строку RichText
  List<TextSpan> spans = [];

  String outText = "";

  if (text?.trim().isNullOrEmpty().not() == true) {
    text?.let((str) {

      int spoilerIndex = -1;

      if (str.contains(spoilerRegex)) {
        spoilerIndex = str.indexOf(spoilerRegex);
      }

      if (str.contains(spoilerStartString)) {
        spoilerIndex = str.indexOf(spoilerStartString);
      }

      String string = spoilerIndex != -1 ? str.substring(0, spoilerIndex) : str;

      outText = string;

      final match = shikimoriLinkRegex.allMatches(string);

      // список типа Ссылок 2-ой группы регулярного выражения
      List<String> groupTwoTypes = [];

      // список ID 4-ой группы регулярного выражения
      List<String> groupFourId = [];

      // список Имён 6-ой группы регулярного выражения
      List<String> groupSixNames = [];

      // Добавляем совпадения из нужных групп в их списки
      for (var m in match) {
        m.group(2)?.let((that) => groupTwoTypes.add(that));

        m.group(4)?.let((that) => groupFourId.add(that));

        m.group(6)?.let((that) => groupSixNames.add(that));
      }

      if (string.contains(shikimoriLinkRegex)) {
        var stringList = string.split(shikimoriLinkRegex);

        for (int i = 0; i != (stringList.length - 1); i++) {
          // обычная строка текста
          spans.add(TextSpan(
              text: stringList[i],
              style: TextStyle(color: primaryColor, fontSize: textSize)));

          // аннотация
          spans.add(TextSpan(
              text: groupSixNames[i],
              style: TextStyle(color: annotationColor, fontSize: textSize),
              mouseCursor: MaterialStateMouseCursor.clickable,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  navigateCallback(
                      groupTwoTypes[i], groupFourId[i], groupSixNames[i]);
                }));

          if (i == (groupFourId.length - 1) &&
              stringList[i] != stringList.last) {
            spans.add(TextSpan(
                text: stringList.last,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: textSize,
                )));
          }
        }
      }
    });
  }

  var richText = RichText(
    text: spans.isNotEmpty
        ? TextSpan(children: [...spans])
        : TextSpan(
            text: outText.orEmpty(),
            style: TextStyle(color: primaryColor, fontSize: textSize)),
    textAlign: TextAlign.start,
  );

  return richText;
}

/// Метод для возврата строки с спойлера из описания
///
/// [text] строка текста
String getSpoilerText(
  String? text,
) {
  String spoiler = "";

  if (text?.contains(spoilerRegex) == true) {
    var descSpoil = text?.split(spoilerRegex);
    spoiler = descSpoil?.last ?? "";
  }

  if (text?.contains(spoilerStartString) == true) {
    var descSpoil = text?.split(spoilerStartString);
    spoiler = descSpoil?.last ?? "";
  }

  return spoiler.replaceAll(spoilerEndString, "");
}
