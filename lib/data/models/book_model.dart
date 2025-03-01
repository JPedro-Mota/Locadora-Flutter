import 'package:flutter_teste/data/models/publisher_model.dart';

class BooksModel {
  final int id;
  final String name;
  final PublisherModel publisher;
  final String author;
  final int totalQuantity;
  final String launchDate;

  BooksModel({
    required this.id,
    required this.name,
    required this.publisher,
    required this.author,
    required this.totalQuantity,
    required this.launchDate,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      totalQuantity: json['totalQuantity'],
      launchDate: json['launchDate'] ?? '',
      publisher: PublisherModel.fromJson(json['publisher']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publisher': publisher,
      'author': author,
      'totalQuantity': totalQuantity,
      'launchDate': launchDate,
    };
  }
}
