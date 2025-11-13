
/// Типы шторки редактирования списка
enum EditRateListType {

  /// Шторка для перемещения элемента пользовательского рейтинга между списками
  rateListEdit,

  /// Шторка для редактирования элемента пользовательского списка по параметрам
  rateModelEdit
}

/// Типы экрана детальной информации [DetailsScreen]
enum DetailsScreenType {

  /// Тип экрана для показа информации об аниме
  anime,

  /// Тип экрана для показа информации о манге
  manga,

  /// Тип экрана для показа информации о ранобэ
  ranobe
}

/// Типы меню экрана детальной информации [DetailsScreen]
enum DetailsScreenDrawerType {

  /// Создатели
  roles,

  /// Персонажи
  character,

  /// Связанное
  related,

  /// Кадры
  screenshots,

  /// Похожее Аниме
  similarAnime,

  /// Похожее Манга
  similarManga,

  /// Хронология
  chronology,

  /// Ссылки
  externalLinks,

  /// Статистика
  statistics,

  /// Комментарии
  comments
}

/// Типы экрана информации о персонаже или человеке
enum CharacterPeopleScreenType {

  /// Тип экрана для показа информации о персонаже
  character,

  /// Тип экрана для показа информации о человеке
  people
}

/// Типы меню экрана информации о человеке или персонаже [CharacterPeopleScreen]
enum CharacterPeopleScreenDrawerType {

  // CHARACTER SCREEN

  seyu,

  anime,

  manga,

  // PEOPLE SCREEN

  bestRoles,

  bestWorks
}