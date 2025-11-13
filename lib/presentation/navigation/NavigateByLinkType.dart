import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/utils/StringExtensions.dart';

/// Метод для навигации на следующий экран в зависимости от типа ссылки
///
/// используется для клика по аннотации в описании
///
/// [link] ссылка
/// [linkType] тип ссылки (anime, manga, ranobe, character, url)
/// [context] контекст
void navigateByLinkType(
    {required String linkType,
    required String link,
    String? imageUrl,
    required BuildContext context}) {
  switch (linkType) {
    case ("anime"):
      navigateAnimeDetailsScreen(
          id: int.tryParse(link.toOnlyDigits()), context: context);

    case ("manga"):
      navigateMangaDetailsScreen(
          id: int.tryParse(link.toOnlyDigits()), context: context);

    case ("ranobe"):
      navigateRanobeDetailsScreen(
          id: int.tryParse(link.toOnlyDigits()), context: context);

    case ("character"):
      navigateCharacterDetailsScreen(
          id: int.tryParse(link.toOnlyDigits()),
          context: context);

    case ("person"):
      navigatePeopleDetailsScreen(
          id: int.tryParse(link.toOnlyDigits()), context: context);

    case ("url"):
      {
        navigateBrowser(url: link);
      }
  }
}
