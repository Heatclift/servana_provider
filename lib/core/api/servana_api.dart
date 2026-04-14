import 'package:dio/dio.dart';

import 'auth_token_holder.dart';
import 'servana_api_exception.dart';

/// REST client aligned with [Servana.postman_collection.json].
///
/// After [signIn] or [firebaseLogin], set the token with [setSessionToken] if the
/// response does not do it automatically (signIn updates [AuthTokenHolder] when
/// parsing succeeds).
class ServanaApi {
  ServanaApi(this._dio, this._tokenHolder);

  final Dio _dio;
  final AuthTokenHolder _tokenHolder;

  /// Stores JWT for subsequent Bearer requests (same as Postman `{{token}}`).
  void setSessionToken(String? token) => _tokenHolder.setToken(token);

  void clearSession() => _tokenHolder.clear();

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ServanaApiException.fromDio(e);
    }
  }

  // --- Auth ---

  Future<Response<dynamic>> signUp(Map<String, dynamic> body) => _request(
        () => _dio.post<dynamic>('/api/auth/signup', data: body),
      );

  /// Password sign-in. On success, sets [AuthTokenHolder] from `data.token`.
  Future<Response<dynamic>> signIn(Map<String, dynamic> body) async {
    final res = await _request(
      () => _dio.post<dynamic>('/api/auth/signin', data: body),
    );
    _applyTokenFromSignIn(res.data);
    return res;
  }

  void _applyTokenFromSignIn(dynamic data) {
    if (data is Map && data['data'] is Map) {
      final d = data['data'] as Map;
      final t = d['token'];
      if (t is String && t.isNotEmpty) {
        _tokenHolder.setToken(t);
      }
    }
  }

  Future<Response<dynamic>> firebaseLogin(Map<String, dynamic> body) =>
      _request(
          () => _dio.post<dynamic>('/api/auth/firebase-login', data: body));

  Future<Response<dynamic>> resendVerification(String email) => _request(
        () => _dio.get<dynamic>(
          '/api/auth/resendverification',
          queryParameters: {'email': email},
        ),
      );

  // --- User ---

  Future<Response<dynamic>> addUserAddress(Map<String, dynamic> body) =>
      _request(
          () => _dio.post<dynamic>('/api/user/adduseraddress', data: body));

  Future<Response<dynamic>> makeAddressPrimary(String addressId) => _request(
        () => _dio.put<dynamic>(
          '/api/user/makeaddressprimary',
          queryParameters: {'addressId': addressId},
        ),
      );

  Future<Response<dynamic>> getAllUserAddresses({
    bool? isArchived,
    int? role,
  }) =>
      _request(() {
        final q = <String, dynamic>{};
        if (isArchived != null) q['isArchived'] = isArchived;
        if (role != null) q['role'] = role;
        return _dio.get<dynamic>(
          '/api/user/alluseraddresses',
          queryParameters: q.isEmpty ? null : q,
        );
      });

  Future<Response<dynamic>> getAddressById(String id) => _request(
        () => _dio.get<dynamic>(
          '/api/user/getaddressbyid',
          queryParameters: {'id': id},
        ),
      );

  Future<Response<dynamic>> deleteAddress(String addressId) => _request(
        () => _dio.delete<dynamic>(
          '/api/user/deleteaddress',
          queryParameters: {'addressId': addressId},
        ),
      );

  Future<Response<dynamic>> updateProfile(Map<String, dynamic> body) =>
      _request(() => _dio.put<dynamic>('/api/user/updateprofile', data: body));

  /// Postman had a malformed URL; uses `/api/user/archieve` (server spelling).
  Future<Response<dynamic>> archiveUser(String userId) => _request(
        () => _dio.put<dynamic>(
          '/api/user/archieve',
          queryParameters: {'userId': userId},
        ),
      );

  Future<Response<dynamic>> getUserProfile(String id) => _request(
        () => _dio.get<dynamic>(
          '/api/user/profile',
          queryParameters: {'id': id},
        ),
      );

  Future<Response<dynamic>> getRegisteredUsers({
    bool? isArchived,
    int? role,
  }) =>
      _request(() {
        final q = <String, dynamic>{};
        if (isArchived != null) q['isArchived'] = isArchived;
        if (role != null) q['role'] = role;
        return _dio.get<dynamic>(
          '/api/user/registereduser',
          queryParameters: q.isEmpty ? null : q,
        );
      });

  // --- Services ---

  Future<Response<dynamic>> getServiceBranches(String serviceId) => _request(
        () => _dio.get<dynamic>('/api/services/$serviceId/branches'),
      );

  Future<Response<dynamic>> getBranchSlots({
    required String branchId,
    required String date,
  }) =>
      _request(
        () => _dio.get<dynamic>(
          '/api/branches/$branchId/slots',
          queryParameters: {'date': date},
        ),
      );

  Future<Response<dynamic>> quote(Map<String, dynamic> body) => _request(
        () => _dio.post<dynamic>('/api/quote', data: body),
      );

  Future<Response<dynamic>> createCoverageGeo(
    String serviceId,
    Map<String, dynamic> body,
  ) =>
      _request(
        () => _dio.post<dynamic>(
          '/api/services/$serviceId/coverage-geo',
          data: body,
        ),
      );

  Future<Response<dynamic>> getCoverageGeo(String serviceId) => _request(
        () => _dio.get<dynamic>('/api/services/$serviceId/coverage-geo'),
      );

  Future<Response<dynamic>> getServices() => _request(
        () => _dio.get<dynamic>('/api/services'),
      );

  Future<Response<dynamic>> getLevel2Services(String serviceId) => _request(
        () => _dio.get<dynamic>('/api/services/$serviceId/level2'),
      );

  Future<Response<dynamic>> getOptionsWithAddons(String serviceId) => _request(
        () => _dio.get<dynamic>('/api/$serviceId/options-with-addons'),
      );

  // --- Workers ---

  Future<Response<dynamic>> getWorkersByRole(int role) => _request(
        () => _dio.get<dynamic>('/api/workers/role/$role'),
      );

  Future<Response<dynamic>> getWorker(String uid) => _request(
        () => _dio.get<dynamic>('/api/workers/$uid'),
      );

  Future<Response<dynamic>> getWorkerLocation(String uid) => _request(
        () => _dio.get<dynamic>('/api/workers/location/$uid'),
      );

  Future<Response<dynamic>> updateWorkerLocation(Map<String, dynamic> body) =>
      _request(() => _dio.post<dynamic>('/api/workers/location', data: body));

  // --- Bookings ---

  Future<Response<dynamic>> createBooking({
    required String userId,
    required Map<String, dynamic> body,
  }) =>
      _request(
        () => _dio.post<dynamic>(
          '/api/bookings',
          data: body,
          queryParameters: {'userId': userId},
        ),
      );

  Future<Response<dynamic>> confirmBookingOtp({
    required String bookingId,
    required String otp,
  }) =>
      _request(
        () => _dio.post<dynamic>(
          '/api/$bookingId/confirm-otp',
          queryParameters: {'otp': otp},
        ),
      );

  Future<Response<dynamic>> getBooking(String id) => _request(
        () => _dio.get<dynamic>('/api/$id'),
      );

  Future<Response<dynamic>> getBookingTracking(String id) => _request(
        () => _dio.get<dynamic>('/api/$id/tracking'),
      );

  // --- Payments ---

  Future<Response<dynamic>> gcashSubmit(
    String bookingId,
    Map<String, dynamic> body,
  ) =>
      _request(
        () => _dio.post<dynamic>('/api/$bookingId/gcash-submit', data: body),
      );

  Future<Response<dynamic>> approveGcash(String bookingId) => _request(
        () => _dio.post<dynamic>('/api/$bookingId/approve'),
      );

  Future<Response<dynamic>> markCashPaid(String bookingId) => _request(
        () => _dio.post<dynamic>('/api/$bookingId/mark-cash-paid'),
      );

  // --- Admin ---

  Future<Response<dynamic>> createBranchSlot(Map<String, dynamic> body) =>
      _request(() => _dio.post<dynamic>('/api/branches/slots', data: body));
}
