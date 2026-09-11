import 'package:shared_preferences/shared_preferences.dart';

class CounterStorageService {
  static const String _counterKey = 'counter_value';

  Future<int> loadCounter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_counterKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<bool> saveCounter(int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_counterKey, value);
    } catch (_) {
      return false;
    }
  }
}
