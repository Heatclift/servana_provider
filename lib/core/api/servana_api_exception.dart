import 'package:dio/dio.dart';

class ServanaApiException implements Exception {
  ServanaApiException({
    required this.message,
    this.statusCode,
    this.responseData,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final dynamic responseData;
  final DioException? cause;

  @override
  String toString() =>
      'ServanaApiException($statusCode): $message${responseData != null ? ' — $responseData' : ''}';

  static ServanaApiException fromDio(DioException e) {
    final code = e.response?.statusCode;
    final data = e.response?.data;
    String msg = e.message ?? 'Request failed';
    if (data is Map) {
      final serverMsg = data['message'] ?? data['error'];
      if (serverMsg != null && serverMsg.toString().isNotEmpty) {
        msg = serverMsg.toString();
      }
    } else if (data is String && data.isNotEmpty) {
      msg = data;
    }
    return ServanaApiException(
      message: msg,
      statusCode: code,
      responseData: data,
      cause: e,
    );
  }
}
