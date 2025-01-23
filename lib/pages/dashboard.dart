// dashboard.dart
import 'package:flutter/material.dart';

import 'package:flutter_teste/components/sidebar_layout.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
      scaffoldBackgroundColor: Color.fromRGBO(34, 1, 39, 1),
      primaryColor: Colors.white
     ),
      
      home: SideBarLayout(),
    );
  }
}
