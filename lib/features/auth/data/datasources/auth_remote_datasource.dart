// lib/auth/data/datasources/auth_remote_datasource.dart

import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/auth/data/models/auth_model.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/core/api/api_consumer.dart';
import 'dart:developer' as developer;

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String emailOrPhone,
    required String password,
  });

  Future<TokenModel> refreshToken();

  Future<void> logout();

  Future<AuthModel?> getStoredAuth();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final CacheHelper cacheHelper;
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({
    required this.cacheHelper,
    required this.apiConsumer,
  });

  @override
  Future<AuthModel> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      developer.log(
        '🔐 Attempting login for: $emailOrPhone',
        name: 'AuthRemoteDataSource',
      );

      final response = await apiConsumer.post(
        EndPoint.login,
        data: {ApiKey.email: emailOrPhone, ApiKey.password: password},
      );

      developer.log(
        '✅ Login response received: $response',
        name: 'AuthRemoteDataSource',
      );

      final authModel = AuthModel.fromJson(response);

      // Verify admin role
      if (!authModel.isAdmin) {
        developer.log(
          '❌ User is not admin. Role: ${authModel.role}',
          name: 'AuthRemoteDataSource',
        );
        throw Exception('Access denied. Admin role required.');
      }

      // Store auth data locally
      await _storeAuthData(authModel);

      developer.log(
        '✅ Admin logged in successfully: ${authModel.name}',
        name: 'AuthRemoteDataSource',
      );

      return authModel;
    } catch (e) {
      developer.log('❌ Login failed: $e', name: 'AuthRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<TokenModel> refreshToken() async {
    try {
      developer.log(
        '🔄 Attempting to refresh token',
        name: 'AuthRemoteDataSource',
      );

      final response = await apiConsumer.post(EndPoint.refreshToken);

      developer.log(
        '✅ Refresh token response: $response',
        name: 'AuthRemoteDataSource',
      );

      final tokenModel = TokenModel.fromJson(response);

      developer.log(
        '✅ Token refreshed successfully',
        name: 'AuthRemoteDataSource',
      );

      return tokenModel;
    } catch (e) {
      developer.log('❌ Refresh token failed: $e', name: 'AuthRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      developer.log('🚪 Attempting logout', name: 'AuthRemoteDataSource');

      // Call logout endpoint (if available)
      try {
        await apiConsumer.post(EndPoint.logout);
      } catch (e) {
        developer.log(
          '⚠️ Logout API call failed (continuing with local cleanup): $e',
          name: 'AuthRemoteDataSource',
        );
      }

      // Clear stored auth data
      await _clearAuthData();

      developer.log('✅ Logout successful', name: 'AuthRemoteDataSource');
    } catch (e) {
      developer.log('❌ Logout failed: $e', name: 'AuthRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<AuthModel?> getStoredAuth() async {
    try {
      final token = cacheHelper.getData(key: ApiKey.accessToken);

      if (token == null || token.isEmpty) {
        developer.log('⚪ No stored auth found', name: 'AuthRemoteDataSource');
        return null;
      }

      final id = cacheHelper.getData(key: ApiKey.userId) ?? '';
      final name = cacheHelper.getData(key: ApiKey.name) ?? '';
      final email = cacheHelper.getData(key: ApiKey.email) ?? '';
      final role = cacheHelper.getData(key: 'role') ?? '';
      final refreshToken = cacheHelper.getData(key: ApiKey.refreshToken);
      final expiresAtString = cacheHelper.getData(key: ApiKey.expiresAtUtc);

      final expiresAtUtc = expiresAtString != null
          ? DateTime.parse(expiresAtString)
          : DateTime.now();

      final authModel = AuthModel(
        id: id,
        name: name,
        email: email,
        token: token,
        refreshToken: refreshToken,
        role: role,
        expiresAtUtc: expiresAtUtc,
        isAuthenticated: true,
      );

      // Verify still admin
      if (!authModel.isAdmin) {
        developer.log(
          '❌ Stored user is not admin',
          name: 'AuthRemoteDataSource',
        );
        await _clearAuthData();
        return null;
      }

      developer.log(
        '✅ Stored auth loaded: ${authModel.name}',
        name: 'AuthRemoteDataSource',
      );

      return authModel;
    } catch (e) {
      developer.log(
        '❌ Error loading stored auth: $e',
        name: 'AuthRemoteDataSource',
      );
      return null;
    }
  }

  // ==================== Helper Methods ====================

  Future<void> _storeAuthData(AuthModel authModel) async {
    await cacheHelper.saveData(key: ApiKey.accessToken, value: authModel.token);
    await cacheHelper.saveData(key: ApiKey.userId, value: authModel.id);
    await cacheHelper.saveData(key: ApiKey.name, value: authModel.name);
    await cacheHelper.saveData(key: ApiKey.email, value: authModel.email);
    await cacheHelper.saveData(key: 'role', value: authModel.role);

    if (authModel.refreshToken != null) {
      await cacheHelper.saveData(
        key: ApiKey.refreshToken,
        value: authModel.refreshToken,
      );
    }

    await cacheHelper.saveData(
      key: ApiKey.expiresAtUtc,
      value: authModel.expiresAtUtc.toIso8601String(),
    );
  }

  Future<void> _clearAuthData() async {
    await cacheHelper.removeData(key: ApiKey.accessToken);
    await cacheHelper.removeData(key: ApiKey.refreshToken);
    await cacheHelper.removeData(key: ApiKey.userId);
    await cacheHelper.removeData(key: ApiKey.name);
    await cacheHelper.removeData(key: ApiKey.email);
    await cacheHelper.removeData(key: 'role');
    await cacheHelper.removeData(key: ApiKey.expiresAtUtc);
  }
}
