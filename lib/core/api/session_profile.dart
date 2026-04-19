import 'package:flutter/foundation.dart';

/// Identity of the currently signed-in worker.
///
/// Populated from the signin response payload (`data.id`, `data.role`, etc.).
/// The worker's [id] is required to call worker-scoped endpoints such as
/// `GET /api/workers/:workerId/job-cards`.
class SessionProfile extends ChangeNotifier {
  String? _id;
  String? _role;
  String? _firstName;
  String? _lastName;
  String? _email;

  String? get id => _id;
  String? get role => _role;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;

  int? get roleAsInt => int.tryParse(_role ?? '');

  String get displayName {
    final f = _firstName ?? '';
    final l = _lastName ?? '';
    final joined = '$f $l'.trim();
    return joined.isNotEmpty ? joined : (_email ?? '');
  }

  /// Tolerantly reads `data.id`, `data.role`, `data.firstName`, `data.lastName`,
  /// `data.email` from a signin / firebase-login response's `data` map.
  void setFromSigninData(dynamic data) {
    if (data is! Map) return;
    _id = _str(data['id']);
    _role = _str(data['role']);
    _firstName = _str(data['firstName']);
    _lastName = _str(data['lastName']);
    _email = _str(data['email']);
    notifyListeners();
  }

  void restore({
    String? id,
    String? role,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    _id = id;
    _role = role;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    notifyListeners();
  }

  void clear() {
    _id = null;
    _role = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    notifyListeners();
  }

  static String? _str(Object? v) {
    if (v == null) return null;
    final s = v.toString();
    return s.isEmpty ? null : s;
  }
}
