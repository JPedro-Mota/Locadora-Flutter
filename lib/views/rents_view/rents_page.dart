import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/rents_model.dart';
import 'package:flutter_teste/enum/enum_role.dart';
import 'package:flutter_teste/services/rents_service.dart';
import 'package:flutter_teste/views/rents_view/rents_create.dart';
import 'package:flutter_teste/views/rents_view/rents_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentsPage extends StatefulWidget {
  const RentsPage({super.key});

  @override
  State<RentsPage> createState() => _RentsPageState();
}

class _RentsPageState extends State<RentsPage> {
  String role = '';
  late Future<List<RentsModel>> futureRents;
  int page = 0;
  String search = "";
  final TextEditingController _searchController = TextEditingController();
  Map<int, bool> expandedState = {};

  @override
  void initState() {
    super.initState();
    _fetchRents();
    _fetchRole();
  }

  void _fetchRents() {
    setState(() {
      futureRents = RentsService().fetchRents(search, page);
    });
  }

  Future<void> _fetchRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role =
          prefs.getString('role') ?? EnumRole.USER.toString().split('.').last;
    });
  }

  void _showDeliveryConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Entrega"),
          content: Text("Tem certeza de que deseja entregar este livro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await RentsService().deliveryRent(id: id, context: context);
                  Navigator.of(context).pop();
                  _fetchRents();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text("Entregar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showRentsOptions(RentsModel rent) {
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
                leading: const Icon(Icons.check, color: Colors.green),
                title: const Text('Devolver'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeliveryConfirmationDialog(context, rent.id);
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
                      builder: (context) => UpdateRentPage(rentId: rent.id),
                    ),
                  );
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
          'Lista de Livros',
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
                    builder: (context) => const CreateRentsPage()),
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
                    search = value;
                    _fetchRents();
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
      body: FutureBuilder<List<RentsModel>>(
        future: futureRents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final rents = snapshot.data ?? [];
          if (rents.isEmpty) {
            return const Center(child: Text('Nenhum aluguel encontrado.'));
          }
          return ListView.builder(
            itemCount: rents.length,
            itemBuilder: (context, index) {
              final rent = rents[index];
              return ListTile(
                title: Text('${rent.book.name}'),
                subtitle: Text('${rent.renter.name}'),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${_translateStatus(rent.status)}"),
                      Text(rent.deadLine.toString())
                    ]),
                leading: const Icon(Icons.person),
                onTap: () => _showRentsOptions(rent),
              );
            },
          );
        },
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'RENTED':
        return 'Alugado';
      case 'IN_TIME':
        return 'Devolvido no prazo';
      case 'LATE':
        return 'Atrasado';
      case 'DELIVERED_WITH_DELAY':
        return 'Devolvido fora do prazo';
      default:
        return status;
    }
  }
}
