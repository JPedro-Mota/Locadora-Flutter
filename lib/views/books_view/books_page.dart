import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/services/books_service.dart';
import 'package:flutter_teste/views/renter_view/renter_create.dart';
import 'package:flutter_teste/views/renter_view/renter_detail.dart';
import 'package:flutter_teste/views/renter_view/renter_edit.dart';


class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late Future<List<BooksModel>> futureBooks;
  final BooksService booksService = BooksService();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureBooks = booksService.fetchBooks('', 0);
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      futureBooks = booksService.fetchBooks(searchQuery, 0);
    });
  }

  void _showDeleteConfirmationDialog(BooksModel books) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: Text(
              "Tem certeza que deseja deletar esse locatário '${books.name}'?"),
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
                await booksService.deleteBook(
                    id: books.id, context: context);
                _fetchBooks(); // Atualiza a lista após exclusão
              },
              child: const Text("Sim", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showRenterOptions(BooksModel book) {
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
                      builder: (context) => BooksDetails(id: book.id),
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
                          UpdateRenterPage(renterId: book.id),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(renter);
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
          'Lista de Locatários',
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
                    builder: (context) => const CreateRenterPage()),
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
                    _fetchRenter();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Pesquisar locatário...',
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
      body: FutureBuilder<List<RenterModel>>(
        future: futureRenter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final renters = snapshot.data ?? [];
          if (renters.isEmpty) {
            return const Center(child: Text('Nenhum locatário encontrado.'));
          }
          return ListView.builder(
            itemCount: renters.length,
            itemBuilder: (context, index) {
              final renter = renters[index];
              return ListTile(
                title: Text(renter.name),
                subtitle: Text(renter.email),
                trailing: Text(renter.telephone),
                leading: const Icon(Icons.person),
                onTap: () => _showRenterOptions(renter),
              );
            },
          );
        },
      ),
    );
  }
}
