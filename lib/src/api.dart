import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseURL = 'https://locadora-joaopedro-back.altislabtech.com.br/';

  Future<void> authenticate(String email, String password) async {
    final url = Uri.parse('$baseURL/auth/login'); // Corrigido Uri.parse
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    try {
      // Envia a requisição POST
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Decodifica a resposta em JSON
        final data = jsonDecode(response.body);
        final String? token = data['token'];
        final String? role = data['role'];

        if (token != null && role != null) {
          // Salva o token e a role localmente
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('role', role);
          debugPrint('Autenticação bem-sucedida!');
        } else {
          throw Exception('Resposta inválida: token ou role ausentes.');
        }
      } else {
        // Lança uma exceção em caso de erro de autenticação
        throw Exception('Erro ao autenticar: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Trata erros de rede ou lógica
      debugPrint('Algo deu errado: $e');
      rethrow; // Propaga o erro para ser tratado no chamador
    }
  }
}
