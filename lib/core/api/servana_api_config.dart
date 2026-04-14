import 'package:dio/dio.dart';

import 'auth_token_holder.dart';

/// Base URL for the Servana REST API (Postman variable `{{api_url}}`).
///
/// Override at build time: `--dart-define=SERVANA_API_URL=https://your-host.com`
abstract final class ServanaApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'SERVANA_API_URL',
    defaultValue: 'https://api.servana.com.ph',
  );

  static Dio createDio(AuthTokenHolder tokenHolder) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final t = tokenHolder.token;
          if (t != null && t.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $t';
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  }
}
