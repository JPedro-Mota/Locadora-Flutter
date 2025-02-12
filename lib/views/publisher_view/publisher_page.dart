import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/data/models/user_model.dart';
import 'package:flutter_teste/services/publisher_service.dart';
import 'package:flutter_teste/views/publisher_view/publisher_create.dart';
import 'package:flutter_teste/views/publisher_view/publisher_detail.dart';
import 'package:flutter_teste/views/publisher_view/publisher_edit.dart';

import 'package:flutter_teste/views/user_view/user_create_view.dart';
import 'package:flutter_teste/views/user_view/user_detail_view.dart';
import 'package:flutter_teste/views/user_view/user_edit_view.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({super.key});

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  late Future<List<PublisherModel>> futurePublisher;
  final PublisherService publisherService = PublisherService();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futurePublisher = publisherService.fetchPublisher('', 0);
    _fetchPublisher();
  }

  void _fetchPublisher() {
    setState(() {
      futurePublisher = publisherService.fetchPublisher(searchQuery, 0);
    });
  }

  void _showDeleteConfirmationDialog(PublisherModel publisher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: Text(
              "Tem certeza que deseja deletar a editora '${publisher.name}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Fecha o diálogo antes de excluir
                await publisherService.deletePublisher(
                    id: publisher.id, context: context);
                _fetchPublisher(); // Atualiza a lista após exclusão
              },
              child: const Text("Sim", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showPublisherOptions(PublisherModel publisher) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Reduz o tamanho do menu
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.visibility, color: Colors.deepPurple),
                title: const Text('Detalhes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublisherDetails(id: publisher.id),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar'),
                onTap: () {
                  // Lógica para editar usuário
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdatePublisherPage(publisherId: publisher.id),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(publisher);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Editoras',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Criar", style: TextStyle(color: Colors.white)),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePublisherPage()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 8.0, 8.0, 12.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _fetchPublisher();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Pesquisar usuário...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            )),
      ),
      body: FutureBuilder<List<PublisherModel>>(
        future: futurePublisher,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final publishers = snapshot.data ?? [];
          if (publishers.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }
          return ListView.builder(
            itemCount: publishers.length,
            itemBuilder: (context, index) {
              final publisher = publishers[index];
              return ListTile(
                title: Text(publisher.name),
                subtitle: Text(publisher.email),
                trailing: Text(publisher.telephone),
                leading: const Icon(Icons.person),
                onTap: () => _showPublisherOptions(publisher),
              );
            },
          );
        },
      ),
    );
  }
}
