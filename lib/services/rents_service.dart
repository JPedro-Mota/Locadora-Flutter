import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_teste/data/models/rents_model.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RentsService {
  static const String baseURL =
      'https://locadora-joaopedro-back.altislabtech.com.br';

  // Função para criar um aluguel
  Future<void> createRents({
    required int bookId,
    required int renterId,
    required String deadLine,
  }) async {
    final url = Uri.parse('$baseURL/rents');

    // Recupera o token salvo no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "bookId": bookId,
      "renterId": renterId,
      "deadLine": deadLine,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print("Aluguel criado com sucesso!");
      } else {
        print(
            "Erro ao criar aluguel: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
    }
  }

  // Função para buscar aluguéis
  Future<List<RentsModel>> fetchRents(String search, int page) async {
    final apiService = ApiService();
    final response =
        await apiService.fetchData('/rents?search=$search&page=$page');
    print('Resposta da API: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (!jsonData.containsKey("content") || jsonData["content"] == null) {
        throw Exception("Nenhum aluguel encontrado.");
      }

      final List<dynamic> content = jsonData["content"];
      return content.map((value) => RentsModel.fromJson(value)).toList();
    } else {
      throw Exception(
          'Erro ao buscar aluguéis: ${response.statusCode} - ${response.body}');
    }
  }

  Future<RentsModel?> getById({required int id}) async {
    final url = Uri.parse('$baseURL/rents/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado.");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return RentsModel.fromJson(jsonData);
      } else {
        throw Exception(
            'Erro ao buscar aluguel: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição GET: $e');
    }
  }

  Future<void> updateRent({
    required int id,
    required int bookId,
    required int renterId,
    required String deadLine,
  }) async {
    final url = Uri.parse('$baseURL/rents/update/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token não encontrado. Faça o login novamente.");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "bookId": bookId,
      "renterId": renterId,
      "deadLine": deadLine,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Aluguel atualizado com sucesso!");
      } else {
        print(
            'Erro ao atualizar aluguel: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição PUT: $e');
    }
  }

  Future<void> deliveryRent(
      {required int id, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/rents/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    print("Chave: $token");
    print("Id: $url");

    if (token == null || token.isEmpty) {
      print("Token não encontrado!");
      return;
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final now = DateTime.now();
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(now); // Formato "yyyy-MM-dd"

    final body = jsonEncode({
      "status": "DELIVERED",
      "deadLine": formattedDate // Adicionando o campo "deadLine"
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Aluguel devolvido com sucesso!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status atualizado com sucesso!")),
        );
      } else {
        if (response.body.isNotEmpty) {
          final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
          print(
              "Erro ao devolver aluguel: ${response.statusCode} - $responseBody");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro: ${responseBody['message']}")),
          );
        } else {
          print(
              "Erro ao devolver aluguel: ${response.statusCode} - Resposta vazia.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro inesperado ao devolver aluguel.")),
          );
        }
      }
    } catch (e) {
      print("Erro inesperado: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado ao devolver aluguel.")),
      );
    }
  }
}
