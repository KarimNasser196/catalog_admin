// lib/profile/data/datasources/profile_remote_datasource.dart

import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile({required String email, required String password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final CacheHelper cacheHelper;
  final ApiConsumer apiConsumer;
  final AuthRepository authRepository;

  ProfileRemoteDataSourceImpl({
    required this.cacheHelper,
    required this.apiConsumer,
    required this.authRepository,
  });

  @override
  Future<void> updateProfile({
    required String email,
    required String password,
  }) async {
    try {
      // ✅ بيانات JSON مع _method
      final data = {'_method': 'PUT', 'login': email, 'password': password};

      // ✅ استخدام POST (ليس PUT) مع JSON (ليس FormData)
      await apiConsumer.post(
        EndPoint.userProfile,
        data: data,
        isFormData: false, // ← مهم جداً: JSON وليس FormData
      );

      // تحديث الكاش
      await cacheHelper.saveData(key: 'user_email', value: email);

      // تسجيل الخروج بعد التحديث
      await authRepository.logout();
    } catch (e) {
      rethrow;
    }
  }
}
