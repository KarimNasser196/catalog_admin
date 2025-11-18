import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/users/data/models/users_response_model.dart';

abstract class UserRemoteDataSource {
  Future<UsersResponseModel> getUsers({
    String? country,
    String? searchQuery,
    int page = 1,
    int perPage = 20,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiConsumer apiConsumer;

  UserRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UsersResponseModel> getUsers({
    String? country,
    String? searchQuery,
    int page = 1,
    int perPage = 20,
  }) async {
    // Build query parameters
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'per_page': perPage,
    };

    // ✅ تأكد من إضافة الـ filters بشكل صحيح
    if (country != null && country.isNotEmpty && country != 'All') {
      queryParameters['country'] = country;
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters['search'] = searchQuery;
    }

    // ✅ اطبع الـ query parameters عشان تتأكد
    print('🔍 Fetching users with params: $queryParameters');

    final response = await apiConsumer.get(
      EndPoint.adminUsers,
      queryParameters: queryParameters,
    );

    return UsersResponseModel.fromJson(response);
  }
}
