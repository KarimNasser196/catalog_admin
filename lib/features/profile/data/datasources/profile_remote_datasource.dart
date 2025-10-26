// lib/profile/data/datasources/profile_remote_datasource.dart

import 'package:catalog_admin/core/database/cache/cache_helper.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile({required String email, required String password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final CacheHelper cacheHelper;

  ProfileRemoteDataSourceImpl({required this.cacheHelper});

  @override
  Future<void> updateProfile({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with actual API call
    // Example:
    // await dio.put(
    //   '$baseUrl/profile/update',
    //   data: {
    //     'email': email,
    //     'password': password,
    //   },
    // );

    await Future.delayed(const Duration(milliseconds: 800));

    // Update local cache
    await cacheHelper.saveData(key: 'user_email', value: email);
  }
}
