import 'package:flutter/material.dart';
import 'package:flutter_teste/services/publisher_service.dart';

class CreatePublisherPage extends StatefulWidget {
  const CreatePublisherPage({super.key});

  @override
  State<CreatePublisherPage> createState() => _CreatePublisherPageState();
}

class _CreatePublisherPageState extends State<CreatePublisherPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final PublisherService publisherService = PublisherService();

  Future<void> _createPublisher() async {
    if (_formKey.currentState!.validate()) {
      try {
        await publisherService.createPublisher(
          name: _nameController.text,
          email: _emailController.text,
          telephone: _telephoneController.text,
          site: _siteController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Editora criado com sucesso!')),
        );
        Navigator.pop(context); // Volta para a tela de usuários
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar editora: $e')),
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
          'Criar Editora',
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
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.number,
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
                    onPressed: _createPublisher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Criar Usuário'),
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
