import 'package:flutter/cupertino.dart';
import 'package:machine_test/models/cartData.dart';

abstract class HomeEvent{}

class HomeCallEvent extends HomeEvent{

  final String called;
  HomeCallEvent({@required this.called}) : assert(String!=null);

}
