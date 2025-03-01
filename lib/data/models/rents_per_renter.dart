import 'dart:convert';

class RentsPerRenter {
  final String name;
  final int rentsQuantity;
  final int rentsActive;

  RentsPerRenter({
    required this.name,
    required this.rentsActive,
    required this.rentsQuantity,
  });

  factory RentsPerRenter.fromJson(Map<String, dynamic> json) {
    return RentsPerRenter(
      name: json['name'],
      rentsQuantity: json[
          'rentsQuantity'], // Fixed typo 'renstQuantity' to 'rentsQuantity'
      rentsActive: json['rentsActive'],
    );
  }

  static List<RentsPerRenter> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RentsPerRenter.fromJson(json)).toList();
  }
}
