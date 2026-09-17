import 'package:shared_preferences/shared_preferences.dart';

/// Handles persistent storage of the counter value using [SharedPreferences].
///
/// Isolates all read/write I/O from the UI layer, allowing the storage
/// backend to be swapped without touching any widget code.
class CounterStorageService {
  static const String _counterKey = 'counter_value';

  /// Reads the last saved counter value from persistent storage.
  ///
  /// Returns `0` if no value has been saved yet or if an error occurs.
  Future<int> loadCounter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_counterKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Persists [value] to storage and returns `true` on success.
  ///
  /// Returns `false` if an error occurs during the write operation.
  Future<bool> saveCounter(int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_counterKey, value);
    } catch (_) {
      return false;
    }
  }
}

