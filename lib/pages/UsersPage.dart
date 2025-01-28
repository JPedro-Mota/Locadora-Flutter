// dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_teste/components/sidebar_layout.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Página do Usuário"), // Adicionado um título no AppBar
          backgroundColor: Colors.purple, // Exemplo de customização
        ),
        body: Column(
          children: [
            Text(
              "Bem-vindo à página do usuário!", // Texto adicionado
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SideBarLayout(),
            ),
          ],
        ),
      ),
    );
  }
}
