
/// Аналог let{ } из Kotlin
extension ObjectExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

/// Функция для печати логов в консоль
void consolePrint(String string) {
  print(string);
}