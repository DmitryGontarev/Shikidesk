
/// Параметры, по которым нужно получить список аниме
enum AnimeSearchType {

  /// по id
  id,

  /// по убыванию id
  idDesc,

  /// ранжировать
  ranked,

  /// по типу (tv, movie, ova, ona, special, music, tv_13, tv_24, tv_48)
  kind,

  /// по популярности
  popularity,

  /// по порядку алфавита
  name,

  /// по дате релиза
  airedOn,

  /// по количеству эпизодов
  episodes,

  /// по статусу выхода (anons, ongoing, released)
  status,

  /// рандомно
  random
}


/// Параметры длительности аниме
enum AnimeDurationType {

  /// меньше 10 минут
  s,

  /// меньше 30 минут
  d,

  /// больше 30 минут
  f
}