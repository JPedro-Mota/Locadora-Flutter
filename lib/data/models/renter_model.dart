class RenterModel {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final String address;
  final String cpf;

RenterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.address,
    required this.cpf,
  });

  factory RenterModel.fromJson(Map<String, dynamic> json) {
    return RenterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      address: json['address'] ?? '',
      cpf: json['cpf'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'address': address,
      'cpf': cpf,
    };
  }
}
