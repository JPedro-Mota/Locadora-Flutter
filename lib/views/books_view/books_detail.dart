import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/services/renter_service.dart';

class BookDetails extends StatefulWidget {
  final int id;
  const BookDetails({super.key, required this.id});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _launchDateController = TextEditingController();
  final TextEditingController _totalQuantityController =
      TextEditingController();

  final TextEditingController _publisher = TextEditingController();
  final BooksService _bookService = BooksService();
  bool _isLoading = true;
  // ignore: unused_field
  BooksModel? _book;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final book = await _bookService.getById(id: widget.id);
      if (book != null) {
        setState(() {
          _book = book;
          _nameController.text = book.name;
          _authorController.text = book.author;
          _totalQuantityController.text = book.totalQuantity.toString();
          _launchDateController.text = book.launchDate;
          _publisher.text = book.publisher.name;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar os detalhes do livro: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do livro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, // Altere a cor aqui
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _book == null
              ? const Center(child: Text('Erro ao carregar os dados'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nome', _nameController),
                      _buildTextField('Autor', _authorController),
                      _buildTextField('Editora', _publisher),
                      _buildTextField(
                          'Quantidade Total', _totalQuantityController),
                      _buildTextField(
                          'Data de lançamento', _launchDateController),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true, // Deixa o campo somente leitura
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
