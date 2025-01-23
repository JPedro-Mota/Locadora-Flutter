import 'package:flutter/material.dart';
import 'package:flutter_teste/main.dart';

class SideBar extends StatelessWidget {

  final bool isSidebarOpened = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return Positioned(
      top: 0,
      bottom: 0,
      left: isSidebarOpened ? 0 : 0,
      right: isSidebarOpened ? 0 : screenWidth - 45,
    child: Row(
      children: <Widget>[
        Expanded(
          child:Container(
            color: Color.fromRGBO(34, 1, 39, 1),
          ),
        ),
        Align(
          alignment: Alignment(0, -0.9),
          child:Container(
            width: 35,
            height: 110,
            color: Color.fromRGBO(34, 1, 39, 1),
          ),
        ),
      ],
      ),
    );
  }
}
