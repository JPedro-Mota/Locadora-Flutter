import 'package:flutter/material.dart';
import 'package:flutter_teste/main.dart';
import 'package:flutter_teste/pages/dashboard.dart';
import 'sidebar.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
        children: <Widget> [
          Dashboard(),
          SideBar(),
        ],
      ),
    );
  }
}
