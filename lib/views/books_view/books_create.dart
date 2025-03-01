import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:flutter_teste/services/renter_service.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateBooksPage extends StatefulWidget {
  const CreateBooksPage({super.key});

  @override
  State<CreateBooksPage> createState() => _CreateBooksPageState();
}

class _CreateBooksPageState extends State<CreateBooksPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _totalQuantityController =
      TextEditingController();
  final MaskedTextController _launchDateController =
      MaskedTextController(mask: '00/00/0000');

  bool _isLoading = false;

  final BooksService bookService = BooksService();
  final PublisherService publisherService = PublisherService();

  PublisherModel? _selectedPublisher;
  final List<PublisherModel> _publishers = [];

  void _loadPublishers() async {
    try {
      final publishers = await publisherService.fetchAllPublisher('');

      debugPrint("Editoras carregadas: ${publishers.length}");

      setState(() {
        _publishers.clear(); // Evita duplicação
        _publishers.addAll(publishers);
      });
    } catch (e) {
      debugPrint('Erro ao carregar editoras: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar editoras')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPublishers();
  }

  Future<void> _createBook() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPublisher == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma editora')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text;
      final author = _authorController.text;
      final totalQuantity = int.tryParse(_totalQuantityController.text) ?? 0;
      final rawLaunchDate = _launchDateController.text;
      final publisherId = _selectedPublisher?.id;

      if (publisherId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma editora')),
        );
        return;
      }

      try {
        final parsedDate = DateFormat("dd/MM/yyyy").parse(rawLaunchDate);
        final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

        await bookService.createBook(
          name: name,
          author: author,
          publisherId: publisherId,
          totalQuantity: totalQuantity,
          launchDate: formattedDate,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Editora criado com sucesso!')),
        );
        Navigator.pop(context); // Volta para a tela de usuários
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar locatário: $e')),
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
          'Criar Livro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'O autor não pode estar vazio' : null,
              ),
              DropdownButtonFormField<PublisherModel>(
                decoration: const InputDecoration(labelText: 'Editora'),
                value: _selectedPublisher,
                isExpanded: true,
                items: _publishers.map((publisher) {
                  return DropdownMenuItem<PublisherModel>(
                    value: publisher,
                    child: Text(publisher.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPublisher = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione uma editora' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _totalQuantityController,
                decoration:
                    const InputDecoration(labelText: 'Quantidade Total'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'A quantidade não pode estar vazia' : null,
              ),
              TextFormField(
                controller: _launchDateController,
                decoration:
                    const InputDecoration(labelText: 'Data ded lançamente'),
                validator: (value) =>
                    value!.isEmpty ? 'A data não pode estar vazia' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _createBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cadastra Livro'),
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
