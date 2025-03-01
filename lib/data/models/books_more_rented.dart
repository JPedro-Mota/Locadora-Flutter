import 'dart:convert';

class BooksMoreRented {
  final String name;
  final int totalRents;

  BooksMoreRented({
    required this.name,
    required this.totalRents
  });

  factory BooksMoreRented.fromJson(Map<String, dynamic> json){
    return BooksMoreRented(
      name: json['name'], 
      totalRents: json['totalRents'],
      );
  }

   static List<BooksMoreRented> fromJsonList(String jsonStr) {
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => BooksMoreRented.fromJson(json)).toList();
  }
}

