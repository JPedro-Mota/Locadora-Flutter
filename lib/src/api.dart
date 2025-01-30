import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiService {
  static const String baseURL = 'https://locadora-joaopedro-back.altislabtech.com.br';

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

      // Adicionando logs para resposta da API
      debugPrint('Resposta da API: ${response.body}');
      debugPrint('Código de Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? token = data['token'];
        final String? role = data['role'];

        if (token != null && role != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('role', role);
          debugPrint('Autenticação bem-sucedida! Token e role salvos.');
        } else {
          throw Exception('Resposta inválida: token ou role ausentes.');
        }
      } else {
        throw Exception('Erro ao autenticar: ${response.statusCode} - ${response.body}');
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

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Erro na requisição GET: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }
}