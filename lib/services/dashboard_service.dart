import 'dart:convert';
import 'package:flutter_teste/data/models/books_more_rented.dart';
import 'package:flutter_teste/data/models/rents_per_renter.dart';
import 'package:flutter_teste/src/api.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl =
      'https://locadora-joaopedro-back.altislabtech.com.br/dashboard'; // Altere conforme necessário

  Future<int> getRentsQuantity({required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService
          .fetchData('/dashboard/rentsQuantity?numberMonths=$numberMonths');

      print('REQUIRED NUMBER: $numberMonths');

      if (response.statusCode == 200) {
        return int.tryParse(response.body) ?? 0;
      } else {
        throw Exception('Erro ao buscar a quantidade de aluguéis');
      }
    } catch (e) {
      print('Erro em getRentsQuantity: $e');
      return 0;
    }
  }

  Future<int> getDeliveredWithDelayQuantity({required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService.fetchData(
          '/dashboard/deliveredWithDelayQuantity?numberMonths=$numberMonths');

      if (response.statusCode == 200) {
        return int.tryParse(response.body) ?? 0;
      } else {
        throw Exception('Erro ao buscar aluguéis atrasados');
      }
    } catch (e) {
      print('Erro em getDeliveredWithDelayQuantity: $e');
      return 0;
    }
  }

  Future<int> getRentsInTime({required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService
          .fetchData('/dashboard/rentsInTime?numberMonths=$numberMonths');

      if (response.statusCode == 200) {
        return int.tryParse(response.body) ?? 0;
      } else {
        throw Exception('Erro ao buscar aluguéis dentro do prazo');
      }
    } catch (e) {
      print('Erro em getRentsInTime: $e');
      return 0;
    }
  }

  Future<int> getRentsLateQuantity({required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService
          .fetchData('/dashboard/rentsLateQuantity?numberMonths=$numberMonths');

      if (response.statusCode == 200) {
        return int.tryParse(response.body) ?? 0;
      } else {
        throw Exception('Erro ao buscar aluguéis atrasados');
      }
    } catch (e) {
      print('Erro em getRentsLateQuantity: $e');
      return 0;
    }
  }

  Future<List<RentsPerRenter>> getRentsPerRenter(
      {required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService
          .fetchData('/dashboard/rentsPerRenter?numberMonths=$numberMonths');

      if (response.statusCode == 200) {
        return RentsPerRenter.fromJsonList(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao buscar os locatários com mais aluguéis');
      }
    } catch (e) {
      print('Erro em getRentsPerRenter: $e');
      return [];
    }
  }

  Future<List<BooksMoreRented>> getBooksMoreRented(
      {required int numberMonths}) async {
    try {
      final apiService = ApiService();
      final response = await apiService
          .fetchData('/dashboard/bookMoreRented?numberMonths=$numberMonths');

      if (response.statusCode == 200) {
        return BooksMoreRented.fromJsonList(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao buscar os livros mais alugados');
      }
    } catch (e) {
      print('Erro em getBooksMoreRented: $e');
      return [];
    }
  }
}
