import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents {
  DashboardClickedEvent,
  UsersPageClickedEvent,
}

abstract class NavigationStates {}

class DashboardState extends NavigationStates {}

class UsersPageState extends NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(DashboardState()) {
    on<NavigationEvents>((event, emit) {
      if (event == NavigationEvents.DashboardClickedEvent) {
        emit(DashboardState());
      } else if (event == NavigationEvents.UsersPageClickedEvent) {
        emit(UsersPageState());
      }
    });
  }
}