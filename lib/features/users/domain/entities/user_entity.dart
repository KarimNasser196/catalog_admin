import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String? image;
  final String? provider;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    this.image,
    this.provider,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    phone,
    email,
    image,
    provider,
  ];
}
