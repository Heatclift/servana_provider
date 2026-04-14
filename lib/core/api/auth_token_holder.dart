import 'package:flutter/foundation.dart';

/// Holds the JWT from [ServanaApi.signIn] / [ServanaApi.firebaseLogin] for authenticated calls.
///
/// Extends [ChangeNotifier] so the app router can refresh when the session changes.
class AuthTokenHolder extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  void setToken(String? value) {
    _token = value;
    notifyListeners();
  }

  void clear() {
    _token = null;
    notifyListeners();
  }
}
