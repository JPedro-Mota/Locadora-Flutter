import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teste/bloc.naviagation_bloc/navigation_bloc.dart';
import 'package:flutter_teste/components/sidebar.dart' as customSidebar;
import 'package:flutter_teste/views/publisher_view/publisher_page.dart';
import 'package:flutter_teste/views/renter_view/renter_page.dart';
import 'package:flutter_teste/views/user_view/user_page.dart';
import 'package:flutter_teste/pages/DashboardPage.dart';

class SidebarLayout extends StatefulWidget {
  const SidebarLayout({Key? key}) : super(key: key);

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                if (navigationState is DashboardState) {
                  return Dashboard();
                } else if (navigationState is UserState) {
                  return UsersPage();
                } else if (navigationState is PublisherState) {
                  return PublisherPage();
                }
                else if (navigationState is RenterState) {
                  return RenterPage();
                }
                
                return const Center(child: Text('Unknown State'));
              },
            ),
            customSidebar.SideBar(),
          ],
        ),
      ),
    );
  }
}
