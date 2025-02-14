class BooksModel {
  final int id;
  final String name;
  final String publisherId;
  final String author;
  final String totalQuantity;
  final String launchDate;

  BooksModel({
    required this.id,
    required this.name,
    required this.publisherId,
    required this.author,
    required this.totalQuantity,
    required this.launchDate,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      publisherId: json['publisherId'] ?? '',
      author: json['author'] ?? '',
      totalQuantity: json['totalQuantity'] ?? '',
      launchDate: json['launchDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publisherId': publisherId,
      'author': author,
      'totalQuantity': totalQuantity,
      'launchDate': launchDate,
    };
  }
}
