// ========== user_remote_datasource.dart ==========
import 'package:catalog_admin/features/users/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({
    required String country,
    String? searchQuery,
    int page = 1,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // TODO: Add Dio instance when backend is ready

  @override
  Future<List<UserModel>> getUsers({
    required String country,
    String? searchQuery,
    int page = 1,
  }) async {
    // TODO: Replace with actual API call
    // final response = await _dio.get('/users', queryParameters: {
    //   'country': country,
    //   if (searchQuery != null) 'search': searchQuery,
    //   'page': page,
    // });

    await Future.delayed(const Duration(seconds: 1));
    return [
      const UserModel(
        id: '1',
        name: 'Mohamed Mahran',
        username: '@mahran',
        phone: '01091992001',
        email: 'ceo@goo-gnow.com',
        country: 'Egypt',
      ),
      const UserModel(
        id: '2',
        name: 'Ahmed Ali',
        username: '@ahmed',
        phone: '01234567890',
        email: 'ahmed@example.com',
        country: 'Egypt',
      ),
    ];
  }
}
