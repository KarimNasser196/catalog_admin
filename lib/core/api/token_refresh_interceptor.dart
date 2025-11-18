import 'dart:developer' as developer;

import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<_QueuedRequest> _failedQueue = [];
  TokenRefreshInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ✅ CRITICAL: Don't intercept errors from refresh endpoint itself
    if (err.requestOptions.path.contains(EndPoint.refreshToken)) {
      developer.log(
        '⚠️ Refresh endpoint failed - clearing auth and rejecting',
        name: 'TokenRefreshInterceptor',
      );

      final cacheHelper = sl<CacheHelper>();
      await cacheHelper.clearData();

      return handler.next(err);
    }

    // ✅ فقط تعامل مع 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    developer.log(
      '⚠️ 401 Unauthorized detected',
      name: 'TokenRefreshInterceptor',
    );

    final cacheHelper = sl<CacheHelper>();
    final refreshToken = cacheHelper.getData(key: ApiKey.refreshToken);

    // ✅ إذا لا يوجد refresh token، أرجع الخطأ مباشرة
    if (refreshToken == null || refreshToken.isEmpty) {
      developer.log(
        '❌ No refresh token available',
        name: 'TokenRefreshInterceptor',
      );
      await cacheHelper.clearData();
      return handler.reject(err);
    }

    // ✅ إذا كان هناك refresh قيد التنفيذ، أضف الطلب للـ queue
    if (_isRefreshing) {
      developer.log(
        '⏳ Refresh in progress, queueing request...',
        name: 'TokenRefreshInterceptor',
      );
      _failedQueue.add(
        _QueuedRequest(requestOptions: err.requestOptions, handler: handler),
      );
      return;
    }

    // ✅ ابدأ عملية الـ refresh
    _isRefreshing = true;
    developer.log(
      '🔄 Starting token refresh...',
      name: 'TokenRefreshInterceptor',
    );

    try {
      final authRepository = sl<AuthRepository>();
      final result = await authRepository.refreshAccessToken();

      await result.fold(
        (failure) async {
          // ❌ فشل التحديث
          developer.log(
            '❌ Token refresh failed: $failure',
            name: 'TokenRefreshInterceptor',
          );

          await cacheHelper.clearData();

          // ✅ ارفض كل الطلبات في الـ queue
          for (final queuedRequest in _failedQueue) {
            queuedRequest.handler.reject(err);
          }
          _failedQueue.clear();

          handler.reject(err);
        },
        (tokens) async {
          // ✅ نجح التحديث
          developer.log(
            '✅ Token refreshed successfully',
            name: 'TokenRefreshInterceptor',
          );

          // حفظ التوكنات الجديدة
          await cacheHelper.saveData(
            key: ApiKey.accessToken,
            value: tokens.accessToken,
          );

          // Note: في بعض الـ APIs قد لا يتم إرجاع refresh token جديد
          // في هذه الحالة نستخدم القديم
          if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
            await cacheHelper.saveData(
              key: ApiKey.refreshToken,
              value: tokens.refreshToken,
            );
          }

          await cacheHelper.saveData(
            key: ApiKey.expiresAtUtc,
            value: tokens.expiresAtUtc.toIso8601String(),
          );

          // ✅ أعد محاولة الطلب الأصلي
          try {
            final response = await _retryRequest(
              err.requestOptions,
              tokens.accessToken,
            );
            handler.resolve(response);
            developer.log(
              '✅ Original request retried successfully',
              name: 'TokenRefreshInterceptor',
            );
          } catch (e) {
            developer.log(
              '❌ Failed to retry original request: $e',
              name: 'TokenRefreshInterceptor',
            );
            handler.reject(err);
          }

          // ✅ أعد محاولة كل الطلبات في الـ queue
          for (final queuedRequest in _failedQueue) {
            try {
              final response = await _retryRequest(
                queuedRequest.requestOptions,
                tokens.accessToken,
              );
              queuedRequest.handler.resolve(response);
              developer.log(
                '✅ Queued request retried: ${queuedRequest.requestOptions.path}',
                name: 'TokenRefreshInterceptor',
              );
            } catch (e) {
              developer.log(
                '❌ Failed to retry queued request: $e',
                name: 'TokenRefreshInterceptor',
              );
              queuedRequest.handler.reject(
                DioException(
                  requestOptions: queuedRequest.requestOptions,
                  error: e,
                ),
              );
            }
          }
          _failedQueue.clear();
        },
      );
    } catch (e) {
      developer.log(
        '❌ Unexpected error during refresh: $e',
        name: 'TokenRefreshInterceptor',
      );

      await cacheHelper.clearData();

      for (final queuedRequest in _failedQueue) {
        queuedRequest.handler.reject(err);
      }
      _failedQueue.clear();

      handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// إعادة محاولة الطلب مع التوكن الجديد
  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $newToken'},
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

/// ✅ Helper class لحفظ الطلبات المؤجلة
class _QueuedRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _QueuedRequest({required this.requestOptions, required this.handler});
}
