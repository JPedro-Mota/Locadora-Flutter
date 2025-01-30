import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents {
  DashboardClickedEvent,
  UsersClickedEvent,
}

abstract class NavigationStates {}

class DashboardState extends NavigationStates {}

class UserState extends NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(DashboardState()) {
    on<NavigationEvents>((event, emit) {
      if (event == NavigationEvents.DashboardClickedEvent) {
        emit(DashboardState());
      } else if (event == NavigationEvents.UsersClickedEvent) {
        emit(UserState());
      }
    });
  }
}
