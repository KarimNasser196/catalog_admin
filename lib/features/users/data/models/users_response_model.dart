import 'package:catalog_admin/features/users/data/models/user_model.dart';

class UsersResponseModel {
  final bool success;
  final int count;
  final List<UserModel> users;

  UsersResponseModel({
    required this.success,
    required this.count,
    required this.users,
  });

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    return UsersResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      users:
          (json['data'] as List<dynamic>?)
              ?.map((user) => UserModel.fromJson(user as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
