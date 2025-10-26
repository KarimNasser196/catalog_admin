import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String? country;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    this.country,
  });

  @override
  List<Object?> get props => [id, name, username, phone, email, country];
}
