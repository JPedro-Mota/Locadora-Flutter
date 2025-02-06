import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/user_model.dart';
import 'package:flutter_teste/services/user_service.dart';

class UserDetails extends StatefulWidget {
  final int id;
  const UserDetails({super.key, required this.id});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();
  bool _isLoading = true;
  UsersModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await _userService.getById(id: widget.id);
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = user.name;
          _emailController.text = user.email;
          _roleController.text = user.role;
          _passwordController.text =
              '******'; // Não exibindo a senha por segurança
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
          : _user == null
              ? const Center(child: Text('Erro ao carregar os dados'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nome', _nameController),
                      _buildTextField('E-mail', _emailController),
                      _buildTextField('Função', _roleController),
                      _buildTextField('Senha', _passwordController),
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
