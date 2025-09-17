import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? dob;
  final String? photo;
  final String accessToken;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.dob,
    this.photo,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [id, name, email, phone, dob, photo, accessToken];
}
