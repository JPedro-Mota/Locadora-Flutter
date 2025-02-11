import 'package:flutter/material.dart';
import 'package:flutter_teste/components/sidebar_layout.dart';
import 'package:flutter_teste/views/user_view/user_page.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:flutter_teste/pages/DashboardPage.dart'; // Certifique-se de que este arquivo existe.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _apiService.authenticate(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        debugPrint('Navegando para a tela Dashboard...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SidebarLayout()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro ao autenticar: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.network(
                'https://locadora-joaopedro.altislabtech.com.br/assets/altislab.e1599872.png',
                width: 300.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Insira seu email' : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Insira sua senha' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(34, 1, 39, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("CONFIRMAR"),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // Adicione a lógica de recuperação de senha aqui
                    },
              child: const Text("Esqueci minha senha"),
            ),
          ],
        ),
      ),
    );
  }
}
