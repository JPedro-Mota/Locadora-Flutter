class UsersModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UsersModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        role: map['role']);
  }
}
