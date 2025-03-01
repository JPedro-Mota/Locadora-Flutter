import 'package:flutter/material.dart';
import 'package:flutter_teste/components/bar_chart_component.dart';
import 'package:flutter_teste/data/models/books_more_rented.dart';
import 'package:flutter_teste/data/models/rents_per_renter.dart';
import 'package:flutter_teste/services/dashboard_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _dashboardService = DashboardService();
  late Future<int> rentsQuantity;
  late Future<int> rentsLateQuantity;
  late Future<int> rentsInTime;
  late Future<int> deliveredWithDelayQuantity;
  late Future<List<BooksMoreRented>> bookMoreRented;
  late Future<List<RentsPerRenter>> rentsPerRenter;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    rentsQuantity = _dashboardService.getRentsQuantity(numberMonths: 1);
    rentsLateQuantity = _dashboardService.getRentsLateQuantity(numberMonths: 1);
    rentsInTime = _dashboardService.getRentsInTime(numberMonths: 1);
    deliveredWithDelayQuantity =
        _dashboardService.getDeliveredWithDelayQuantity(numberMonths: 1);
    bookMoreRented = _dashboardService.getBooksMoreRented(numberMonths: 1);
    rentsPerRenter = _dashboardService.getRentsPerRenter(numberMonths: 1).then(
          (data) => RentsPerRenter.fromJsonList(data),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<int>>(
              future: Future.wait([
                rentsQuantity,
                rentsLateQuantity,
                rentsInTime,
                deliveredWithDelayQuantity,
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  // Assuming the data is returned in the same order as Future.wait
                  List<int> data = snapshot.data!;
                  return BarChartComponent(data: data);
                }
              },
            ),
            FutureBuilder<List<RentsPerRenter>>(
              future: rentsPerRenter,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  List<RentsPerRenter> renters = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Locatários com mais aluguéis:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...renters.map((renter) {
                        return Text(
                            '${renter.name}: ${renter.rentsQuantity} aluguéis');
                      }).toList(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
