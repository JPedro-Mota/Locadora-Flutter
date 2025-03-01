import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:intl/intl.dart';

class UpdateBookPage extends StatefulWidget {
  final int bookId;

  const UpdateBookPage({super.key, required this.bookId});

  @override
  State<UpdateBookPage> createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _totalQuantityController =
      TextEditingController();
  final MaskedTextController _launchDateController =
      MaskedTextController(mask: '00/00/0000');
  final BooksService bookService = BooksService();
  final PublisherService _publisherService = PublisherService();
  PublisherModel? _selectedPublisher;

  bool _isLoading = true;
  List<PublisherModel> _publishers = [];

  @override
  void initState() {
    super.initState();
    _loadBooksData();
    _loadPublishersData();
  }

  Future<void> _loadBooksData() async {
    try {
      BooksModel? book = await bookService.getById(id: widget.bookId);
      if (book != null) {
        setState(() {
          _nameController.text = book.name;
          _authorController.text = book.author;
          _launchDateController.text = DateFormat("dd/MM/yyyy")
              .format(DateFormat("yyyy-MM-dd").parse(book.launchDate));
          _totalQuantityController.text = book.totalQuantity.toString();
          _selectedPublisher = book.publisher;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do livro: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPublishersData() async {
    try {
      List<PublisherModel> publishers =
          await _publisherService.fetchAllPublisher('');
      setState(() {
        _publishers = publishers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar editoras: $e')),
      );
    }
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final author = _authorController.text;
      final totalQuantity = int.tryParse(_totalQuantityController.text) ?? 0;
      final launchDate = _launchDateController.text;
      final publisherId = _selectedPublisher?.id;

      if (publisherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma editora')),
        );
        return;
      }

      try {
        await bookService.updateBooks(
          id: widget.bookId,
          name: name,
          publisherId: publisherId,
          author: author,
          totalQuantity: totalQuantity,
          launchDate: launchDate,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro atualizado com sucesso!')),
        );
        Navigator.pop(context); // Voltar para a tela anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar livro: $e')),
        );
      }
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atualizar Livro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) =>
                          value!.isEmpty ? 'Nome não pode estar vazio' : null,
                    ),
                    TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(labelText: 'Autor'),
                      validator: (value) =>
                          value!.isEmpty ? 'Autor não pode estar vazio' : null,
                    ),
                    TextFormField(
                      controller: _totalQuantityController,
                      decoration:
                          const InputDecoration(labelText: 'Quantidade Total'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Quantidade não pode estar vazia'
                          : null,
                    ),
                    TextFormField(
                      controller: _launchDateController,
                      decoration: const InputDecoration(
                          labelText: 'Data de Lançamento'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) => value!.isEmpty
                          ? 'Data de lançamento não pode estar vazia'
                          : null,
                    ),
                    DropdownButtonFormField<int>(
                      // Use the unique 'id' here
                      value: _selectedPublisher?.id,
                      decoration: const InputDecoration(labelText: 'Editora'),
                      items: _publishers.map((PublisherModel publisher) {
                        return DropdownMenuItem<int>(
                          value: publisher.id, // Use publisher id as the value
                          child: Text(publisher.name),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedPublisher = _publishers.firstWhere(
                              (publisher) => publisher.id == newValue);
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione uma editora' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _updateBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Atualizar Livro'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _cancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
