import 'package:flutter/cupertino.dart';
import 'package:machine_test/pages/authenticationPage.dart';
import 'package:machine_test/pages/homePage.dart';
import 'package:machine_test/pages/orderSummaryPage.dart';
import 'package:page_transition/page_transition.dart';
class RouteGenerator{
  static const ROUTE_HOME = "login";
  static const ROUTE_AUTHENTICATION = "authentication";
  static const ROUTE_ORDER_SUMMARY = "orderSummary";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_AUTHENTICATION:

        return PageTransition(
            child: AuthenticationPage(), type: PageTransitionType.fade);
      case ROUTE_HOME:

        return PageTransition(
            child: HomePage(), type: PageTransitionType.fade);
      case ROUTE_ORDER_SUMMARY:

        return PageTransition(
            child: OrderSummary(), type: PageTransitionType.fade);
    }
  }

}