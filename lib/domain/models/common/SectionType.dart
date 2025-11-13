
/// Типы разделов
enum SectionType {

  /// Аниме
  anime,

  /// Манга
  manga,

  /// Ранобэ
  ranobe,

  /// Персонаж
  character,

  /// Реальный человек (автор, режиссёр, мангака, сценарит)
  person,

  /// Пользователь
  user,

  /// Клуб
  club,

  /// Страница клуба
  clubPage,

  /// Коллекция
  collection,

  /// Рецензия
  review,

  /// Косплэй
  cosplay,

  /// Конкурс
  contest,

  // Those last used only in App

  /// Топик обсуждения
  topic,

  /// Комментарии
  comment,

  /// Неизвестный тип (если придёт что-то не из списка)
  unknown
}