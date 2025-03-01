import 'dart:convert';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';


class RentsModel {
  final int id;
  final BooksModel book;
  final RenterModel renter;
  final String deadLine;
  final String rentDate;
  final String status;

  RentsModel(
      {required this.id,
      required this.book,
      required this.renter,
      required this.deadLine,
      required this.rentDate,
      required this.status});

  factory RentsModel.fromJson(Map<String, dynamic> json) {
    return RentsModel(
      id: json['id'],
      renter: RenterModel.fromJson(json['renter']),
      book: BooksModel.fromJson(json['book']),
      deadLine: json['deadLine'],
      rentDate: json['rentDate'],
      status: json['status'],
    );
  }

  static List<RentsModel> fromJsonList(String jsonStr) {
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => RentsModel.fromJson(json)).toList();
  }
}
