import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/user_model.dart';
import 'package:flutter_teste/services/user_service.dart';
import 'package:flutter_teste/views/user_view/user_create_view.dart';
import 'package:flutter_teste/views/user_view/user_detail_view.dart';
import 'package:flutter_teste/views/user_view/user_edit_view.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<UsersModel>> futureUsers;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    futureUsers = userService.fetchUsers('', 0);
  }

  void _showUserOptions(UsersModel user) {
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
                      builder: (context) => UserDetails(id: user.id),
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
                      builder: (context) => UpdateUserPage(userId: user.id),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir'),
                onTap: () {
                  // Lógica para excluir usuário
                  Navigator.pop(context);
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
          'Lista de Usuários',
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
                MaterialPageRoute(builder: (context) => const CreateUserPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UsersModel>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.role),
                leading: const Icon(Icons.person),
                onTap: () => _showUserOptions(user),
              );
            },
          );
        },
      ),
    );
  }
}
