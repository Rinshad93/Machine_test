


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/bloc/home/home_event.dart';
import 'package:machine_test/models/cartData.dart';

import 'package:machine_test/models/menuList.dart';
import 'package:machine_test/repository/menu_repository.dart';

import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: '_homeScreenkey');
  MenuRepository menuRepository;

 HomeBloc(): super(null) {

   menuRepository = MenuRepository();
    print('in');
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
    print(transition);
  }


  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HomeFetchingState();
    List<TableMenuList> data;

      if (event is HomeCallEvent) {
        print('inside_call_event');
        var home = await menuRepository.getMenuDetails();


        data =home.tableMenuList;
        yield HomeFetchedState(data:data);
//        if(data.length>0){
//
//        }
//     else{
//          print('error');
//
//        }
      }

    try { } catch (_) {
      print('inside_error');
      yield HomeErrorState(errorMessage:"Catch error");
    }
  }

}