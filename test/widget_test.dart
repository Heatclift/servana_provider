import 'package:flutter_test/flutter_test.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';

void main() {
  test('AuthTokenHolder isLoggedIn tracks token', () {
    final h = AuthTokenHolder();
    expect(h.isLoggedIn, false);
    h.setToken('jwt');
    expect(h.isLoggedIn, true);
    h.clear();
    expect(h.isLoggedIn, false);
  });
}
