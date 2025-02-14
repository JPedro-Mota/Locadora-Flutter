import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/book_model.dart';
import 'package:flutter_teste/data/models/renter_model.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BooksService {
  static const String baseURL =
      'https://locadora-joaopedro-back.altislabtech.com.br';

  // Função para criar um usuário
  Future<void> createBook({
    required String name,
    required String publisherId,
    required String author,
    required String totalQuantity,
    required String launchDate,
  }) async {
    final url = Uri.parse('$baseURL/book');

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
      "publisherId": publisherId,
      "author": author,
      "totalQuantity": totalQuantity,
      "launchDate": launchDate,
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
  Future<List<BooksModel>> fetchBooks(String search, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print('AAAAAAAAA: $token');

    // Verifica se o token existe
    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final url = Uri.parse('$baseURL/book?search=$search&page=$page');
    print('$baseURL/book?search=$search&page=$page');

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
          throw Exception("Nenhum livro encontrado.");
        }

        return content.map((value) => BooksModel.fromJson(value)).toList();
      } else {
        throw Exception(
            'Erro ao buscar livro: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<List<BooksModel>> fetchAllBook(String search) async {
    final apiService = ApiService();
    final response = await apiService.fetchData('book?search=$search');

    final dynamic jsonData = jsonDecode(response.body);

    final List<dynamic> content =
        jsonData is List ? jsonData : jsonData["content"];

    return content.map((value) => BooksModel.fromJson(value)).toList();
  }

  Future<BooksModel?> getById({required int id}) async {
    final url = Uri.parse('$baseURL/book/$id');
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
        print(BooksModel.fromJson(jsonData)); // Exibe os dados para debug
        return BooksModel.fromJson(jsonData);
      } else {
        print('Erro: ${response.statusCode} - ${response.body}');
        return null; // Retorna null se a resposta não for 200
      }
    } catch (e) {
      print('Erro na requisição GET: $e');
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<void> updateBooks({
    required int id,
    required String name,
    required String publisherId,
    required String author,
    required String totalQuantity,
    required String launchDate,
  }) async {
    final url = Uri.parse('$baseURL/book/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Token adicionado no cabeçalho
    };

    final body = jsonEncode({
      "name": name,
      "publisherId": publisherId,
      "author": author,
      "totalQuantity": totalQuantity,
      "launchDate": launchDate,
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

  Future<bool> deleteBook(
      {required int id, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/book/$id');
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
            content: Text("O livro foi excluída!"),
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
