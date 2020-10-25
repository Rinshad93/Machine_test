import 'package:flutter/cupertino.dart';
import 'package:machine_test/models/cartData.dart';

abstract class CartState {}

class CartUninitializedState extends CartState {}

class CartFetchingState extends CartState {}

class CartErrorState extends CartState {
  String errorMessage;
  CartErrorState({@required this.errorMessage});
}

class CartFetchedState extends CartState {
  final List<Cart>carts;
   double totalAmount=0.0;
   int totalQuantity=0;

  CartFetchedState({@required this.carts,@required this.totalQuantity,@required this.totalAmount});
}