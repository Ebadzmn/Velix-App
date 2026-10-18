import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../routes/app_routes.dart';
import '../services/storage_service.dart';
import 'package:get/get.dart' as getx;

class ApiInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 90,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Attach authorization token if available
    try {
      if (getx.Get.isRegistered<StorageService>()) {
        final token = getx.Get.find<StorageService>().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (_) {
      // StorageService might not be initialized yet
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      final logMessage = StringBuffer();
      logMessage.writeln('🚀 [HTTP REQUEST]');
      logMessage.writeln('➡️ Method: ${options.method.toUpperCase()}');
      logMessage.writeln('🌐 URL: ${options.uri}');
      if (options.headers.isNotEmpty) {
        logMessage.writeln('📋 Headers: ${options.headers}');
      }
      if (options.queryParameters.isNotEmpty) {
        logMessage.writeln('🔍 Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        if (options.data is FormData) {
          final formData = options.data as FormData;
          final fields = formData.fields.map((e) => '${e.key}: ${e.value}').toList();
          final files = formData.files.map((e) => '${e.key}: ${e.value.filename}').toList();
          logMessage.writeln('📦 Form Fields: $fields');
          logMessage.writeln('📁 Form Files: $files');
        } else {
          logMessage.writeln('📦 Body: ${options.data}');
        }
      }
      _logger.i(logMessage.toString());
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final logMessage = StringBuffer();
      logMessage.writeln('✅ [HTTP RESPONSE]');
      logMessage.writeln('⬅️ Status Code: ${response.statusCode}');
      logMessage.writeln('🌐 URL: ${response.requestOptions.uri}');
      logMessage.writeln('📥 Response Body: ${response.data}');
      _logger.d(logMessage.toString());
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final logMessage = StringBuffer();
      logMessage.writeln('❌ [HTTP ERROR]');
      logMessage.writeln('⬅️ Method: ${err.requestOptions.method.toUpperCase()}');
      logMessage.writeln('🌐 URL: ${err.requestOptions.uri}');
      logMessage.writeln('⚠️ Status Code: ${err.response?.statusCode ?? 'N/A'}');
      logMessage.writeln('💬 Error Message: ${err.message}');
      if (err.response?.data != null) {
        logMessage.writeln('📥 Error Response: ${err.response?.data}');
      }
      _logger.e(logMessage.toString(), error: err.error);
    }

    _handleAuthExpiration(err);

    super.onError(err, handler);
  }

  static bool _isLoggingOut = false;

  void _handleAuthExpiration(DioException err) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;

    // Check if error response indicates an expired or invalid token
    bool isExpiredToken = false;

    final isUnauthorizedMessage = responseData != null &&
        _extractErrorMessage(responseData).toLowerCase().contains('not authorized');

    if (statusCode == 401 || statusCode == 403 || isUnauthorizedMessage) {
      isExpiredToken = true;
    } else if (statusCode == 500 && responseData != null) {
      final message = _extractErrorMessage(responseData).toLowerCase();
      if (message.contains('jwt expired') ||
          message.contains('token expired') ||
          message.contains('invalid token') ||
          message.contains('jwt malformed') ||
          message.contains('unauthorized')) {
        isExpiredToken = true;
      }
    }

    if (isExpiredToken && !_isLoggingOut) {
      _isLoggingOut = true;

      // Clear stored credentials
      try {
        if (getx.Get.isRegistered<StorageService>()) {
          getx.Get.find<StorageService>().clearAuth();
        }
      } catch (_) {}

      // Ensure redirection runs smoothly on the UI thread
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Redirect user to login screen and clear navigation history
        getx.Get.offAllNamed(Routes.login);

        // Inform user of session expiry
        getx.Get.snackbar(
          'Session Expired',
          'You are not authorized or your session has expired. Please log in again.',
          snackPosition: getx.SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
      });

      // Reset guard after delay
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggingOut = false;
      });
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
      if (responseData['error'] != null) {
        return responseData['error'].toString();
      }
      if (responseData['errorMessages'] is List && (responseData['errorMessages'] as List).isNotEmpty) {
        final firstError = responseData['errorMessages'][0];
        if (firstError is Map && firstError['message'] != null) {
          return firstError['message'].toString();
        }
        return firstError.toString();
      }
    } else if (responseData is String) {
      return responseData;
    }
    return '';
  }
}
