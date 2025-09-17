class RegisterDto {
  String email;
  String password;
  String name;
  String phone;
  String birthDate;

  RegisterDto({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.birthDate,
  });
  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
      birthDate: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = phone;
    data['dob'] = birthDate;
    return data;
  }
}
