import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:flutter_teste/services/renter_service.dart';
import 'package:flutter_teste/services/rents_service.dart';
import 'package:intl/intl.dart';

class UpdateRentPage extends StatefulWidget {
  final int rentId;

  const UpdateRentPage({super.key, required this.rentId});

  @override
  State<UpdateRentPage> createState() => _UpdateRentPageState();
}

class _UpdateRentPageState extends State<UpdateRentPage> {
  final _formKey = GlobalKey<FormState>();

  final BooksService _bookService = BooksService();
  final RenterService _renterService = RenterService();
  final RentsService _rentService = RentsService();
  final MaskedTextController _deadLineController =
      MaskedTextController(mask: '00/00/0000');

  RenterModel? _selectedRenter;
  BooksModel? _selectedBook;
  bool _isLoading = true;

  Future<void> _fetchRent() async {
    try {
      final rent = await _rentService.getById(id: widget.rentId);
      if (rent != null) {
        setState(() {
          _deadLineController.text = DateFormat("dd/MM/yyyy")
              .format(DateFormat("yyyy-MM-dd").parse(rent.deadLine));
          _selectedRenter = rent.renter;
          _selectedBook = rent.book;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar aluguel: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<RenterModel>> _fetchRenters(String filter) async {
    return await _renterService.fetchAllRenter(filter);
  }

  Future<List<BooksModel>> _fetchBooks(String filter) async {
    return await _bookService.fetchAllBook(filter);
  }

  @override
  void initState() {
    super.initState();
    _fetchRent();
  }

  @override
  void dispose() {
    _deadLineController.dispose();
    super.dispose();
  }

  Future<void> _updateRent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final rawLaunchDate = _deadLineController.text;
      final renterId = _selectedRenter?.id;
      final bookId = _selectedBook?.id;

      if (renterId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um locatário')),
        );
        return;
      }

      if (bookId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um livro')),
        );
        return;
      }

      try {
        final parsedDate = DateFormat("dd/MM/yyyy").parse(rawLaunchDate);
        final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

        await _rentService.updateRent(
          id: widget.rentId,
          renterId: renterId,
          bookId: bookId,
          deadLine: formattedDate,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aluguel atualizado com sucesso!')),
        );
        Navigator.pop(context); // Voltar para a tela anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar aluguel: $e')),
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
          'Atualizar Aluguel',
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
                    DropdownSearch<RenterModel>(
                      asyncItems: (String filter) => _fetchRenters(filter),
                      itemAsString: (RenterModel renter) => renter.name,
                      selectedItem: _selectedRenter,
                      onChanged: (RenterModel? renter) {
                        setState(() {
                          _selectedRenter = renter;
                        });
                      },
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Locatário",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? "Selecione um locatário" : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownSearch<BooksModel>(
                      asyncItems: (String filter) => _fetchBooks(filter),
                      itemAsString: (BooksModel book) => book.name,
                      selectedItem: _selectedBook,
                      onChanged: (BooksModel? book) {
                        setState(() {
                          _selectedBook = book;
                        });
                      },
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Livro", // Alterado para "Livro"
                          border: OutlineInputBorder(),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? "Selecione um livro" : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _deadLineController,
                      decoration: const InputDecoration(
                        labelText: 'Devolução',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty
                          ? ' Por favor, insira uma data.'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _updateRent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirmar'),
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
