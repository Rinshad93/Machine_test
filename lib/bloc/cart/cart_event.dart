import 'package:flutter/cupertino.dart';

abstract class CartEvent{}

class CartCallEvent extends CartEvent{

  final String called;
  CartCallEvent({@required this.called}) : assert(String!=null);

}