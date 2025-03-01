import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RenterService {
  static const String baseURL =
      'https://locadora-joaopedro-back.altislabtech.com.br';

  // Função para criar um usuário
  Future<void> createRenter({
    required String name,
    required String email,
    required String telephone,
    required String address,
    required String cpf,
  }) async {
    final url = Uri.parse('$baseURL/renter');

    // Recupera o token salvo no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    // Verifica se o token existe
    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    // Configura o cabeçalho para a requisição com o token
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token adicionado no cabeçalho
    };

    final body = jsonEncode({
      "name": name,
      "email": email,
      "telephone": telephone,
      "address": address,
      "cpf": cpf,
    });

    try {
      // Realiza a requisição POST para criar um usuário
      final response = await http.post(url, headers: headers, body: body);

      // Verifica o status da resposta
      if (response.statusCode == 201) {
        print("Locatário criado com sucesso!");
      } else {
        print(
            "Erro ao criar locatário: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
    }
  }

  // Função para buscar usuários
  Future<List<RenterModel>> fetchRenter(String search, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print('AAAAAAAAA: $token');

    // Verifica se o token existe
    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final url = Uri.parse('$baseURL/renter?search=$search&page=$page');
    print('$baseURL/renter?search=$search&page=$page');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token adicionado no cabeçalho
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic>? content = jsonData["content"];

        if (content == null) {
          throw Exception("Nenhum renter encontrado.");
        }

        return content.map((value) => RenterModel.fromJson(value)).toList();
      } else {
        throw Exception(
            'Erro ao buscar renter: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<List<RenterModel>> fetchAllRenter(String search) async {
    final apiService = ApiService();
    final response = await apiService.fetchData('/renter?search=$search');

    final dynamic jsonData = jsonDecode(response.body);

    final List<dynamic> content =
        jsonData is List ? jsonData : jsonData["content"];

    return content.map((value) => RenterModel.fromJson(value)).toList();
  }

  Future<RenterModel?> getById({required int id}) async {
    final url = Uri.parse('$baseURL/renter/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    // Verifica se o token é nulo ou vazio
    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token adicionado no cabeçalho
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print("Sucesso");

        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(RenterModel.fromJson(jsonData)); // Exibe os dados para debug
        return RenterModel.fromJson(jsonData);
      } else {
        print('Erro: ${response.statusCode} - ${response.body}');
        return null; // Retorna null se a resposta não for 200
      }
    } catch (e) {
      print('Erro na requisição GET: $e');
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<void> updateRenter({
    required int id,
    required String name,
    required String email,
    required String telephone,
    required String cpf,
    required String address,
  }) async {
    final url = Uri.parse('$baseURL/renter/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token adicionado no cabeçalho
    };

    final body = jsonEncode({
      "name": name,
      "email": email,
      "telephone": telephone,
      "cpf": cpf,
      "address": address
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Locatário editado com sucesso");
      } else {
        print(
            'Erro ao editar locatário: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
    }
  }

  Future<bool> deleteRenter(
      {required int id, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/renter/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("O locatário foi excluída!"),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na requisição DELETE: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}
