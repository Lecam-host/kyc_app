import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.token,
  });

  /// Factory pour créer à partir d’un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  /// Conversion en JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }
}
