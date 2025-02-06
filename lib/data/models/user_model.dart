class UsersModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

    factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      password: json['password'] ?? '******', // Se não vier, define '******'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      
    };
  }
}
