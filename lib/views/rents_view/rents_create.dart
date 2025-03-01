import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/services/renter_service.dart';
import 'package:flutter_teste/services/rents_service.dart';
import 'package:intl/intl.dart';

class CreateRentsPage extends StatefulWidget {
  const CreateRentsPage({super.key});

  @override
  State<CreateRentsPage> createState() => _CreateRentsPageState();
}

class _CreateRentsPageState extends State<CreateRentsPage> {
  final _formKey = GlobalKey<FormState>();
  final MaskedTextController _deadLineController =
      MaskedTextController(mask: '00/00/0000');

  bool _isLoading = false;
  final BooksService _bookService = BooksService();
  final RenterService _renterService = RenterService();
  final RentsService _rentService = RentsService();

  RenterModel? _selectedRenter;
  BooksModel? _selectedBook;

  List<RenterModel> _renters = [];
  List<BooksModel> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchRenters();
    _fetchBooks();
  }

  Future<void> _fetchRenters() async {
    try {
      List<RenterModel> renters = await _renterService.fetchRenter("", 0);
      setState(() => _renters = renters);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar locatários: $e')),
      );
    }
  }

  Future<void> _fetchBooks() async {
    try {
      List<BooksModel> books = await _bookService.fetchBooks("", 0);
      setState(() => _books = books);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar livros: $e')),
      );
    }
  }

  Future<void> _createRent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBook == null || _selectedRenter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um locatário e um livro')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final parsedDate =
          DateFormat("dd/MM/yyyy").parse(_deadLineController.text);
      final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      await _rentService.createRents(
        bookId: _selectedBook!.id,
        renterId: _selectedRenter!.id,
        deadLine: formattedDate,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluguel criado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar aluguel: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar Aluguel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<RenterModel>(
                decoration: const InputDecoration(labelText: 'Locatário'),
                value: _selectedRenter,
                items: _renters
                    .map((renter) => DropdownMenuItem(
                          value: renter,
                          child: Text(renter.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRenter = value),
                validator: (value) =>
                    value == null ? 'Selecione um locatário' : null,
              ),
              DropdownButtonFormField<BooksModel>(
                decoration: const InputDecoration(labelText: 'Livro'),
                value: _selectedBook,
                items: _books
                    .map((book) => DropdownMenuItem(
                          value: book,
                          child: Text(book.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedBook = value),
                validator: (value) =>
                    value == null ? 'Selecione um livro' : null,
              ),
              TextFormField(
                controller: _deadLineController,
                decoration:
                    const InputDecoration(labelText: 'Data de Devolução'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a data de devolução' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createRent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Cadastrar'),
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
