import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.dob,
    super.photo,
    required super.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    return UserModel(
      id: userJson['id'],
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'],
      dob: userJson['dob'],
      photo: userJson['photo'],
      accessToken: json['access_token'] ?? '',
    );
  }
  factory UserModel.fromLocalBase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      dob: json['dob'],
      photo: json['photo'],
      accessToken: json['access_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "dob": dob,
      "photo": photo,
      "access_token": accessToken,
    };
  }
}
