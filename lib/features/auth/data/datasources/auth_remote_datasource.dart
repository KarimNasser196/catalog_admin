// lib/auth/data/datasources/auth_remote_datasource.dart

import 'package:catalog_admin/features/auth/data/models/auth_model.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String emailOrPhone,
    required String password,
  });
  Future<void> logout();
  Future<AuthModel?> getStoredAuth();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final CacheHelper cacheHelper;

  AuthRemoteDataSourceImpl({required this.cacheHelper});

  @override
  Future<AuthModel> login({
    required String emailOrPhone,
    required String password,
  }) async {
    // TODO: Replace with actual API call
    // Example:
    // final response = await dio.post(
    //   '$baseUrl/auth/login',
    //   data: {
    //     'email_or_phone': emailOrPhone,
    //     'password': password,
    //   },
    // );
    // return AuthModel.fromJson(response.data);

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Mock authentication - Accept any valid input
    if (emailOrPhone.isNotEmpty && password.length >= 6) {
      final authModel = AuthModel(
        id: 'admin_001',
        email: emailOrPhone,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        isAuthenticated: true,
      );

      // Store auth data locally
      await cacheHelper.saveData(key: 'auth_token', value: authModel.token);
      await cacheHelper.saveData(key: 'user_email', value: authModel.email);
      await cacheHelper.saveData(key: 'user_id', value: authModel.id);
      await cacheHelper.saveData(key: 'is_authenticated', value: true);

      return authModel;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<void> logout() async {
    // TODO: Replace with actual API call
    // await dio.post('$baseUrl/auth/logout');

    await Future.delayed(const Duration(milliseconds: 500));

    // Clear stored auth data
    await cacheHelper.removeData(key: 'auth_token');
    await cacheHelper.removeData(key: 'user_email');
    await cacheHelper.removeData(key: 'user_id');
    await cacheHelper.removeData(key: 'is_authenticated');
  }

  @override
  Future<AuthModel?> getStoredAuth() async {
    final isAuthenticated =
        cacheHelper.getData(key: 'is_authenticated') ?? false;

    if (isAuthenticated) {
      final token = cacheHelper.getDataString(key: 'auth_token');
      final email = cacheHelper.getDataString(key: 'user_email');
      final id = cacheHelper.getDataString(key: 'user_id');

      if (token != null && email != null && id != null) {
        return AuthModel(
          id: id,
          email: email,
          token: token,
          isAuthenticated: true,
        );
      }
    }

    return null;
  }
}
