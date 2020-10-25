import 'package:flutter/cupertino.dart';

abstract class AuthState {}

class AuthenticatingState extends AuthState {}
class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthState {
  final String displayName;

  Authenticated({this.displayName});

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';
}