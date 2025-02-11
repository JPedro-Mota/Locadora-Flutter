class PublisherModel {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final String? site;

  PublisherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    this.site,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      site: json['site'] ?? 'Nenhum site registrado', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'site': site,
    };
  }
}
