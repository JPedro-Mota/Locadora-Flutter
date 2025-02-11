import 'dart:convert';
import 'package:flutter_teste/data/models/publisher_model.dart';
import 'package:flutter_teste/data/models/user_model.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PublisherService {
  static const String baseURL =
      'https://locadora-joaopedro-back.altislabtech.com.br';

  // Função para criar um usuário
  Future<void> createPublisher({
    required String name,
    required String email,
    required String telephone,
     String? site,
  }) async {
    final url = Uri.parse('$baseURL/publisher');

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
      "site": site,
    });

    try {
      // Realiza a requisição POST para criar um usuário
      final response = await http.post(url, headers: headers, body: body);

      // Verifica o status da resposta
      if (response.statusCode == 201) {
        print("Publisher criado com sucesso!");
      } else {
        print(
            "Erro ao criar usuário: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
    }
  }

  // Função para buscar usuários
  Future<List<PublisherModel>> fetchPublisher(String search, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print('AAAAAAAAA: $token');

    // Verifica se o token existe
    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final url = Uri.parse('$baseURL/publisher?search=$search&page=$page');
    print('$baseURL/publisher?search=$search&page=$page');

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
          throw Exception("Nenhum usuário encontrado.");
        }

        return content.map((value) => PublisherModel.fromJson(value)).toList();
      } else {
        throw Exception(
            'Erro ao buscar usuários: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<List<PublisherModel>> fetchAllPublisher(String search) async {
    final apiService = ApiService();
    final response = await apiService.fetchData('publisher?search=$search');

    final dynamic jsonData = jsonDecode(response.body);

    final List<dynamic> content =
        jsonData is List ? jsonData : jsonData["content"];

    return content.map((value) => PublisherModel.fromJson(value)).toList();
  }

  Future<PublisherModel?> getById({required int id}) async {
    final url = Uri.parse('$baseURL/publisher/$id');
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

        if (!jsonData.containsKey('id') ||
            !jsonData.containsKey('name') ||
            !jsonData.containsKey('email') ||
            !jsonData.containsKey('telephone')) {
          throw Exception("Dados inválidos recebidos da API.");
        }

        print(UsersModel.fromJson(jsonData)); // Exibe os dados para debug
        return PublisherModel.fromJson(jsonData);
      } else {
        print('Erro: ${response.statusCode} - ${response.body}');
        return null; // Retorna null se a resposta não for 200
      }
    } catch (e) {
      print('Erro na requisição GET: $e');
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<void> updatePublisher({
    required int id,
    required String name,
    required String email,
    required String telephone,
    String? site,
  }) async {
    final url = Uri.parse('$baseURL/publisher/$id');
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
      "site": site,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Editora editado com sucesso");
      } else {
        print(
            'Erro ao editar usuario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
    }
  }
}
