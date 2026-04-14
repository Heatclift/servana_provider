/// Holds the JWT from [ServanaApi.signIn] / [ServanaApi.firebaseLogin] for authenticated calls.
class AuthTokenHolder {
  String? _token;

  String? get token => _token;

  void setToken(String? value) => _token = value;

  void clear() => _token = null;
}
