import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents {
  DashboardClickedEvent,
  UsersClickedEvent,
  PublisherClickedEvent,
  RenterClickedEvent,
  BooksClickedEvent,
  RentsClickedEvent,
}

abstract class NavigationStates {}

class DashboardState extends NavigationStates {}

class UserState extends NavigationStates {}

class PublisherState extends NavigationStates {}

class RenterState extends NavigationStates{}

class BooksState extends NavigationStates{}

class RentsState extends NavigationStates{}



class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(DashboardState()) {
    on<NavigationEvents>((event, emit) {
      if (event == NavigationEvents.DashboardClickedEvent) {
        emit(DashboardState());
      } else if (event == NavigationEvents.UsersClickedEvent) {
        emit(UserState());
      }
      else if (event == NavigationEvents.PublisherClickedEvent) {
        emit(PublisherState());
      }
      else if (event == NavigationEvents.RenterClickedEvent) {
        emit(RenterState());
      }
      else if (event == NavigationEvents.BooksClickedEvent) {
        emit(BooksState());
      }
      else if (event == NavigationEvents.RentsClickedEvent){
        emit(RentsState());
      }
     
    });
  }
}
