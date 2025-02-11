import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:flutter_teste/services/user_service.dart';
import 'package:flutter_teste/data/models/user_model.dart';

class UpdatePublisherPage extends StatefulWidget {
  final int publisherId;

  const UpdatePublisherPage({super.key, required this.publisherId});

  @override
  State<UpdatePublisherPage> createState() => _UpdatePublisherPageState();
}

class _UpdatePublisherPageState extends State<UpdatePublisherPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  TextEditingController _siteController =
      TextEditingController(); // Valor padrão

  final PublisherService publisherService = PublisherService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPublisherData();
  }

  Future<void> _loadPublisherData() async {
    try {
      PublisherModel? publisher =
          await publisherService.getById(id: widget.publisherId);
      if (publisher != null) {
        setState(() {
          _nameController.text = publisher.name;
          _emailController.text = publisher.email;
          _telephoneController.text = publisher.telephone.toString();
          _siteController.text = publisher.site.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do usuário: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePublisher() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final telephone = _telephoneController.text;
      final site = _siteController.text;

      try {
        await publisherService.updatePublisher(
            id: widget.publisherId,
            name: name,
            email: email,
            telephone: telephone,
            site: site);
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
          'Atualizar Usuário',
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
                controller: _siteController,
                decoration: const InputDecoration(labelText: 'Site'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updatePublisher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Atualizar Usuário'),
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
