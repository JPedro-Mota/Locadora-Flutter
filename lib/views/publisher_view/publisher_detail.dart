import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/services/publisher_service.dart';


class PublisherDetails extends StatefulWidget {
  final int id;
  const PublisherDetails({super.key, required this.id});

  @override
  State<PublisherDetails> createState() => _PublisherDetailsState();
}

class _PublisherDetailsState extends State<PublisherDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();

  final PublisherService _publisherService = PublisherService();
  bool _isLoading = true;
  PublisherModel? _publisher;

  @override
  void initState() {
    super.initState();
    _fetchPublisher();
  }

  Future<void> _fetchPublisher() async {
    try {
      final publisher = await _publisherService.getById(id: widget.id);
      if (publisher != null) {
        setState(() {
          _publisher = publisher;
          _nameController.text = publisher.name;
          _emailController.text = publisher.email;
          _telephoneController.text = publisher.telephone;
          _siteController.text = publisher.site ?? 'Nenhum site foi registrado'; // Garantir que não seja nulo
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar os detalhes do usuário: $e');
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
          'Lista de Usuários',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, // Altere a cor aqui
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _publisher == null
              ? const Center(child: Text('Erro ao carregar os dados'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nome', _nameController),
                      _buildTextField('E-mail', _emailController),
                      _buildTextField('telephone', _telephoneController),
                      _buildTextField('Site', _siteController),
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
