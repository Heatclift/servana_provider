import 'package:shared_preferences/shared_preferences.dart';

import 'auth_token_holder.dart';
import 'session_profile.dart';

/// Persists the Servana JWT and signed-in worker identity so the session
/// survives app restarts.
abstract final class AuthSessionBootstrap {
  static const _tokenKey = 'servana_jwt';
  static const _uidKey = 'servana_uid';
  static const _roleKey = 'servana_role';
  static const _firstNameKey = 'servana_first_name';
  static const _lastNameKey = 'servana_last_name';
  static const _emailKey = 'servana_email';

  static Future<void> restore(
    AuthTokenHolder holder,
    SessionProfile profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_tokenKey);
    if (t != null && t.isNotEmpty) {
      holder.setToken(t);
    }
    profile.restore(
      id: prefs.getString(_uidKey),
      role: prefs.getString(_roleKey),
      firstName: prefs.getString(_firstNameKey),
      lastName: prefs.getString(_lastNameKey),
      email: prefs.getString(_emailKey),
    );
  }

  static Future<void> persist(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  static Future<void> persistProfile(SessionProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await _writeOrRemove(prefs, _uidKey, profile.id);
    await _writeOrRemove(prefs, _roleKey, profile.role);
    await _writeOrRemove(prefs, _firstNameKey, profile.firstName);
    await _writeOrRemove(prefs, _lastNameKey, profile.lastName);
    await _writeOrRemove(prefs, _emailKey, profile.email);
  }

  static Future<void> clear(
    AuthTokenHolder holder,
    SessionProfile profile,
  ) async {
    holder.clear();
    profile.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_uidKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_firstNameKey);
    await prefs.remove(_lastNameKey);
    await prefs.remove(_emailKey);
  }

  static Future<void> _writeOrRemove(
    SharedPreferences prefs,
    String key,
    String? value,
  ) async {
    if (value != null && value.isNotEmpty) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }
}
