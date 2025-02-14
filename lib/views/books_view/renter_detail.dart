import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/renter_service.dart';

class RenterDetails extends StatefulWidget {
  final int id;
  const RenterDetails({super.key, required this.id});

  @override
  State<RenterDetails> createState() => _RenterDetailsState();
}

class _RenterDetailsState extends State<RenterDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  final RenterService _renterService = RenterService();
  bool _isLoading = true;
  RenterModel? _renter;

  @override
  void initState() {
    super.initState();
    _fetchRenter();
  }

  Future<void> _fetchRenter() async {
    try {
      final renter = await _renterService.getById(id: widget.id);
      if (renter != null) {
        setState(() {
          _renter = renter;
          _nameController.text = renter.name;
          _emailController.text = renter.email;
          _telephoneController.text = renter.telephone;
          _addressController.text = renter.address;
          _cpfController.text = renter.cpf;
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
          'Lista de Locatário',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, // Altere a cor aqui
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _renter == null
              ? const Center(child: Text('Erro ao carregar os dados'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nome', _nameController),
                      _buildTextField('E-mail', _emailController),
                      _buildTextField('Telephone', _telephoneController),
                      _buildTextField('address', _addressController),
                      _buildTextField('CPF', _cpfController),
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
