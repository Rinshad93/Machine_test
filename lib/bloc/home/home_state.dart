
import 'package:flutter/cupertino.dart';
import 'package:machine_test/models/menuList.dart';

abstract class HomeState {}

class HomeUninitializedState extends HomeState {}

class HomeFetchingState extends HomeState {}

class HomeErrorState extends HomeState {
  String errorMessage;
  HomeErrorState({@required this.errorMessage});
}

class HomeFetchedState extends HomeState {
  final List<TableMenuList>data;
//final Menu data;
  HomeFetchedState({@required this.data});
}