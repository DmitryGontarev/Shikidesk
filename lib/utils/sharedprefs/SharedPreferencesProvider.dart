
import 'package:shared_preferences/shared_preferences.dart';

/// Обёртка над стандартным [SharedPreferences]
/// поддерживает все основные возможности по добавлени/удалению/поиску значений в локальном хранилище
///
abstract class SharedPreferencesProvider {

  /// Удаляем запрашиваемый ключ из хранилища
  /// [key] ключ который хотим удалить
  Future<bool> remove ({required String key});

  /// Проверяет наличие значение по ключу в хранилише [SharedPreferences]
  /// [key] ключ значения
  Future<bool> contains ({required String key});

  //////////////////////////////////////////////////////////////////////////////
  //// Установка значения
  //////////////////////////////////////////////////////////////////////////////

  /// Помещает строку в хранилище
  /// [key] ключ для сохранения
  /// [string] строка которую сохраняем
  Future<bool> putString({required String key, required String string});

  /// Помещает int в хранилище
  /// [key] ключ для сохранения
  /// [int] значение для сохранения
  Future<bool> putInt({required String key, required int int});

  /// Помещает double в хранилище
  /// [key] ключ для сохранения
  /// [int] значение для сохранения
  Future<bool> putFloat({required String key, required double double});

  /// Помещает строку в хранилище
  /// [key] ключ для сохранения
  /// [boolean] значение для сохранения
  Future<bool> putBoolean({required String key, required bool boolean});

  //////////////////////////////////////////////////////////////////////////////
  //// Получение значения
  //////////////////////////////////////////////////////////////////////////////

  /// Получить значение [String] из хранилища
  /// [key] ключ по которому ищем значение
  /// [defaultValue] дефолтное значение, возвращаемое в случае если по ключу ничего не найдено(по умолчанию "")
  Future<String> getString({required String key, String? defaultValue = ""});

  /// Получить значение [int] из хранилища
  /// [key] ключ по которому ищем значение
  /// [defaultValue] дефолтное значение, возвращаемое в случае если по ключу ничего не найдено(по умолчанию 0)
  Future<int> getInt({required String key, int defaultValue = 0});

  /// Получить значение [double] из хранилища
  /// [key] ключ по которому ищем значение
  /// [defaultValue] дефолтное значение, возвращаемое в случае если по ключу ничего не найдено(по умолчанию 0)
  Future<double> getFloat({required String key, double defaultValue = 0.0});

  /// Получить значение [bool] из хранилища
  /// [key] ключ по которому ищем значение
  /// [defaultValue] дефолтное значение, возвращаемое в случае если по ключу ничего не найдено(по умолчанию 0)
  Future<bool> getBoolean({required String key, bool defaultValue = false});
}


////////////////////////////////////////////////////////////////////////////////
/// Реализация [SharedPreferencesProvider]
////////////////////////////////////////////////////////////////////////////////
class SharedPreferencesProviderImpl implements SharedPreferencesProvider {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<bool> remove({required String key}) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.remove(key);
  }

  @override
  Future<bool> contains({required String key}) async {
    final SharedPreferences prefs = await _prefs;
    var value = prefs.containsKey(key);
    return value;
  }

  //////////////////////////////////////////////////////////////////////////////
  //// Установка значения
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<bool> putString({required String key, required String string}) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(key, string);
  }

  @override
  Future<bool> putFloat({required String key, required double double}) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setDouble(key, double);
  }

  @override
  Future<bool> putInt({required String key, required int int}) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setInt(key, int);
  }

  @override
  Future<bool> putBoolean({required String key, required bool boolean}) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setBool(key, boolean);
  }

  //////////////////////////////////////////////////////////////////////////////
  //// Получение значения
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<String> getString({required String key, String? defaultValue = ""}) async {
    final SharedPreferences prefs = await _prefs;
    var string = prefs.getString(key);
    return string ?? (defaultValue ?? "");
  }

  @override
  Future<int> getInt({required String key, int defaultValue = 0}) async {
    final SharedPreferences prefs = await _prefs;
    var value = prefs.getInt(key);
    return value ?? defaultValue;
  }

  @override
  Future<double> getFloat({required String key, double defaultValue = 0}) async {
    final SharedPreferences prefs = await _prefs;
    var value = prefs.getDouble(key);
    return value ?? defaultValue;
  }

  @override
  Future<bool> getBoolean({required String key, bool defaultValue = false}) async {
    final SharedPreferences prefs = await _prefs;
    var value = prefs.getBool(key);
    return value ?? defaultValue;
  }
}