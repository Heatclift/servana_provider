import 'package:shared_preferences/shared_preferences.dart';

import 'auth_token_holder.dart';

/// Persists the Servana JWT so [AuthTokenHolder] is repopulated after app restart.
abstract final class AuthSessionBootstrap {
  static const _key = 'servana_jwt';

  static Future<void> restore(AuthTokenHolder holder) async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_key);
    if (t != null && t.isNotEmpty) {
      holder.setToken(t);
    }
  }

  static Future<void> persist(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      await prefs.setString(_key, token);
    } else {
      await prefs.remove(_key);
    }
  }

  static Future<void> clear(AuthTokenHolder holder) async {
    holder.clear();
    await persist(null);
  }
}
