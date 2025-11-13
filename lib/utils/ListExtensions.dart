/// Возвращает пустой список, если null
extension ListEmpty<T> on List<T>? {
  List<T> orEmptyList() {
    return this ?? [];
  }
}

/// Возвращает список элементов по заданному условию, аналог Kotlin .filter { }
extension FilterList<T> on List<T>? {
  List<T> filter(bool Function(T item) predicate) {
    List<T> predicateList = [];
    for (var i in this ?? []) {
      if (predicate(i)) {
        predicateList.add(i);
      }
    }
    return predicateList;
  }
}

/// Возвращает элемент из списка по заданному условию, аналог Kotlin .find { }
extension FindInList<T> on List<T>? {
  T? find(bool Function(T item) predicate) {
    List<T> list = this ?? [];
    for (var i in list) {
      if (predicate(i)) {
        return i;
      }
    }
    return null;
  }
}

/// Сортирует список по заданному ключу, аналог Kotlin sortBy { }
extension MySortedBy<E> on List<E> {
  List<E> sortedBy(Comparable Function(E e) key) =>
      toList()..sort((a, b) => key(a).compareTo(key(b)));
}

/// Сортирует список по заданному ключу, аналог Kotlin sortBy { }
extension MySortedByDescending<E> on List<E> {
  List<E> sortedByDescending(Comparable Function(E e) key) =>
      (toList()..sort((a, b) => key(a).compareTo(key(b)))).reversed.toList();
}

/// Сортирует список по заданному ключу, аналог Kotlin sortBy { }
extension MySortedAscendDescend<E> on List<E> {
  List<E> sortedByAscendDescend({bool ascending = true, required Comparable Function(E e) key}) {
    if (ascending) {
      return toList()..sort((a, b) => key(a).compareTo(key(b)));
    } else {
      return (toList()..sort((a, b) => key(a).compareTo(key(b)))).reversed.toList();
    }
  }
}

/// Возвращает список в обратном порядке
extension ReversedList<E> on List<E> {
  List<E> reversedList() {
    return reversed.toList();
  }
}