import 'package:dio/dio.dart';
import '../utils/app_constants.dart';
import 'api_interceptor.dart';

/// Global Network Caller / HTTP Client using Dio
class ApiClient {
  late final Dio _dio;
  final String baseUrl;

  ApiClient({this.baseUrl = AppConstants.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: AppConstants.timeoutDuration),
        receiveTimeout: Duration(seconds: AppConstants.timeoutDuration),
        sendTimeout: Duration(seconds: AppConstants.timeoutDuration),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptor with logger and token handler
    _dio.interceptors.add(ApiInterceptor());
  }

  /// Expose Dio instance if custom configuration is needed
  Dio get dio => _dio;

  // ==========================================
  // GET REQUEST
  // ==========================================
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // POST REQUEST
  // ==========================================
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // PUT REQUEST
  // ==========================================
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // PATCH REQUEST
  // ==========================================
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // DELETE REQUEST
  // ==========================================
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // MULTIPART / FILE UPLOAD REQUEST
  // ==========================================
  Future<Response<T>> uploadFile<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(
          contentType: 'multipart/form-data',
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // ==========================================
  // DOWNLOAD FILE
  // ==========================================
  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}
