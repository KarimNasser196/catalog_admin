import 'dart:developer' as developer;
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:dio/dio.dart';


/// ===================== API INTERCEPTOR =====================
/// المسؤول عن:
/// 1. إضافة التوكن للطلبات المحمية.
/// 2. تسجيل كل الطلبات والاستجابات.
/// 3. إظهار أخطاء Dio بشكل منسق.
class ApiInterceptor extends Interceptor {
  final CacheHelper _cacheHelper = sl<CacheHelper>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _cacheHelper.getData(key: ApiKey.accessToken);

    // ✅ Attach token only for protected routes
    if (token != null &&
        !options.path.contains(EndPoint.login)
       ) {
      options.headers['Authorization'] = 'Bearer $token';
      developer.log(
        '🟢 Token attached to request: ${token.substring(0, 20)}...',
        name: 'ApiInterceptor',
      );
    } else {
      developer.log(
        '⚪ No token attached for ${options.path}',
        name: 'ApiInterceptor',
      );
    }

    developer.log('''
📤 REQUEST:
➡️ ${options.method} ${options.baseUrl}${options.path}
🔸 Headers: ${options.headers}
🔸 Data: ${options.data}
      ''', name: 'ApiInterceptor');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('''
✅ RESPONSE:
🔹 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}
🔹 Status: ${response.statusCode}
🔹 Data: ${response.data}
      ''', name: 'ApiInterceptor');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log('''
❌ ERROR:
🔹 URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}
🔹 Status: ${err.response?.statusCode}
🔹 Message: ${err.message}
🔹 Response: ${err.response?.data}
      ''', name: 'ApiInterceptor');

    super.onError(err, handler);
  }
}