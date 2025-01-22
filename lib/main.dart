import 'package:flutter/material.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:flutter_teste/pages/dashboard.dart'; // Certifique-se de que esta página existe.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Alteração para usar a tela LoginPage
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
      // Chamando o serviço de autenticação da API
      await _apiService.authenticate(
        _emailController.text,
        _passwordController.text,
      );
      
      // Se a autenticação for bem-sucedida, navega para a tela Dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()), // Substituindo PublisherFlutter por Dashboard
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
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
            // Campo de Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Campo de Senha
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a senha';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Botão de Login
            ElevatedButton(
              onPressed: _isLoading ? null : _login, // Desabilita o botão se estiver carregando
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(34, 1, 39, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("CONFIRMAR"),
            ),
            const SizedBox(height: 16.0),
            // Mensagem de erro (se houver)
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            // Botão de Esqueci minha Senha
            TextButton(
              onPressed: () {
                // Lógica para recuperação de senha
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Função não implementada!")),
                );
              },
              child: const Text("Esqueci minha senha"),
            ),
          ],
        ),
      ),
    );
  }
}
