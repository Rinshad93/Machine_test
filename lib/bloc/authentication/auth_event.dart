import 'package:flutter/cupertino.dart';

abstract class AuthEvent{}

class AuthenticationEvent extends AuthEvent{

  final String called;
  AuthenticationEvent({@required this.called}) : assert(String!=null);

}

class AuthenticationInitialEvent extends AuthEvent{}
class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}