import 'dart:developer' as developer;
import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/api_interceptors.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/core/api/token_refresh_interceptor.dart';
import 'package:catalog_admin/core/errors/exceptions.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// ===================== DIO CONSUMER =====================
/// مسؤول عن إرسال الطلبات (GET / POST / PATCH / DELETE)
/// ويتعامل مع Interceptors + Exception Handling
class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    // ===================== Base Config =====================
    dio.options = BaseOptions(
      baseUrl: EndPoint.baseUrl,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 25),
      sendTimeout: const Duration(seconds: 25),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
    );

    // ===================== Interceptors =====================
    dio.interceptors.addAll([
      ApiInterceptor(), // attach token + log requests
      TokenRefreshInterceptor(dio: dio), // auto refresh expired token
    ]);

    // ===================== Debug Logging =====================
    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => developer.log(obj.toString(), name: '🧠 DIO'),
        ),
      );
    }
  }

  // ===================== GET =====================
  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ===================== POST =====================
  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData && data is Map<String, dynamic>
            ? FormData.fromMap(data)
            : data,
        queryParameters: queryParameters,
        options: Options(
          contentType: data is FormData || isFormData
              ? 'multipart/form-data'
              : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ===================== PATCH =====================
  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData && data is Map<String, dynamic>
            ? FormData.fromMap(data)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ===================== DELETE =====================
  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormData && data is Map<String, dynamic>
            ? FormData.fromMap(data)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ===================== PUT =====================
  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFormData && data is Map<String, dynamic>
            ? FormData.fromMap(data)
            : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ===================== ERROR HANDLER =====================
  void _handleError(DioException e) {
    developer.log(
      '❌ DioException: ${e.message} | Status: ${e.response?.statusCode}',
      name: 'DioConsumer',
    );
    handleDioExceptions(e);
  }
}
