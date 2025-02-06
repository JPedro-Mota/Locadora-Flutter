import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiService {
  static const String baseURL =
      'https://locadora-joaopedro-back.altislabtech.com.br';

  Future<void> authenticate(String email, String password) async {
    final url = Uri.parse('$baseURL/auth/login');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      debugPrint('Resposta da API: ${response.body}');
      debugPrint('Código de Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? token = data['token'];
        final String? role = data['role'];

        if (token != null && role != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          final token2 = prefs.getString('authToken');
          print('Token salvo AAAAAAAAAAAAAAAAAAA: $token2');
          await prefs.setString('role', role);
          print('Autenticação bem-sucedida! Token e role salvos.');
        } else {
          throw Exception('Resposta inválida: token ou role ausentes.');
        }
      } else {
        throw Exception(
            'Erro ao autenticar: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro na autenticação: $e');
      rethrow;
    }
  }

  Future<http.Response> fetchData(String endpoint) async {
    final url = Uri.parse('$baseURL$endpoint');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('Token não encontrado, favor logar novamente.');
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      print('Resposta da API: ${response.body}');
      print('AAAAAAAAAAAAAAAAAAAAAA: $token');
      print('Código de Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 403) {
        debugPrint('Resposta 403: ${response.body}');
        throw Exception('Acesso negado: Token inválido ou sem permissão.');
      } else {
        throw Exception(
            'Erro na requisição GET: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }
}
