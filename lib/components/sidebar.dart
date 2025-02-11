import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teste/bloc.naviagation_bloc/navigation_bloc.dart';
import 'package:flutter_teste/components/menu_item.dart';
import 'package:flutter_teste/views/user_view/user_page.dart';
import 'package:flutter_teste/pages/DashboardPage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_teste/main.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSideBarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;

  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final isAnimationCompleted =
        _animationController.status == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        final isSidebarOpened = isSideBarOpenedAsync.data ?? false;

        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpened ? 0 : -screenWidth + 100,
          right: isSidebarOpened ? 0 : screenWidth - 38,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color.fromRGBO(34, 1, 39, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      ListTile(
                        title: const Text(
                          "Admin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          "admin@gmail.com",
                          style: TextStyle(
                            color: Colors.white.withAlpha(150),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        leading: const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white54,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),

                      MenuItem(
                        icon: Icons.dashboard,
                        title: "Dashboard",
                        onTap: () {
                          onIconPressed();
                          context
                              .read<NavigationBloc>()
                              .add(NavigationEvents.DashboardClickedEvent);
                        },
                      ),

                      MenuItem(
                        icon: Icons.local_library,
                        title: "Biblioteca",
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      MenuItem(
                        icon: Icons.sell,
                        title: "Alugueis",
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      MenuItem(
                        icon: Icons.group,
                        title: "Usuários",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.UsersClickedEvent);
                        },
                      ),

                      MenuItem(
                        icon: Icons.person,
                        title: "Locatários",
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      MenuItem(
                        icon: Icons.edit,
                        title: "Editora",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.PublisherClickedEvent);
                        },
                      ),

                      Spacer(),

                      MenuItem(
                        icon: Icons.logout,
                        title: "Desconectar",
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                      // Adicione outros itens do menu aqui
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.88),
                child: GestureDetector(
                  onTap: onIconPressed,
                  child: ClipPath(
                    child: Container(
                      width: 30,
                      height: 60,
                      color: const Color.fromRGBO(34, 1, 39, 1),
                      alignment: Alignment.centerLeft,
                      child: Tooltip(
                        message: isSidebarOpened ? "Fechar Menu" : "Abrir Menu",
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: const Color(0xFF1BB5FD),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

@override
bool shouldReclip(CustomClipper<Path> oldClipper) {
  return true;
}
