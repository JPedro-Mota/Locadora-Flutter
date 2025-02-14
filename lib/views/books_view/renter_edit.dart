import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:flutter_teste/services/renter_service.dart';
import 'package:flutter_teste/services/user_service.dart';
import 'package:flutter_teste/data/models/user_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpdateRenterPage extends StatefulWidget {
  final int renterId;

  const UpdateRenterPage({super.key, required this.renterId});

  @override
  State<UpdateRenterPage> createState() => _UpdateRenterPageState();
}

class _UpdateRenterPageState extends State<UpdateRenterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')}, // Permite apenas números
  );

  final RenterService renterService = RenterService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRenterData();
  }

  Future<void> _loadRenterData() async {
    try {
      RenterModel? renter = await renterService.getById(id: widget.renterId);
      if (renter != null) {
        setState(() {
          _nameController.text = renter.name;
          _emailController.text = renter.email;
          _telephoneController.text = renter.telephone.toString();
          _addressController.text = renter.address;
          _cpfController.text = renter.cpf.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do locatário: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateRenter() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final telephone = _telephoneController.text;
      final address = _addressController.text;
      final cpf = _cpfController.text;

      try {
        await renterService.updateRenter(
            id: widget.renterId,
            name: name,
            email: email,
            telephone: telephone,
            address: address,
            cpf: cpf);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário atualizado com sucesso!')),
        );
        Navigator.pop(context); // Voltar para a tela anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário: $e')),
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
          'Atualizar Editora',
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Email não pode estar vazio' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Telephone'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Telephone não pode estar vazio' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) =>
                    value!.isEmpty ? 'Endereço não pode estar vazio' : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updateRenter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Atualizar Locatário'),
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
