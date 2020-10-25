import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:machine_test/bloc/home/home_bloc.dart';
import 'package:machine_test/bloc/home/home_event.dart';
import 'package:machine_test/bloc/home/home_state.dart';
import 'package:machine_test/db/database_helper.dart';

import 'package:machine_test/models/cartData.dart';
import 'package:machine_test/pages/orderSummaryPage.dart';
import 'package:machine_test/widget/DrawerWidget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../routeGenerator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

SharedPreferences sharedPreferences;
List<int> quantity = List();
int itemQuantity = 0;

List<Cart> carts = <Cart>[];

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc();
    _homeBloc.add(HomeCallEvent(called: "called"));

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          carts.add(Cart(
              dishId: element['dish_id'],
              itemName: element['item'],
              itemPrice: element["price"],
              quantity: element["quantity"],
              calories: element["calories"]));

          print(" cartsize${carts.length}");
        });
        itemQuantity = carts.length;
      });
    }).catchError((error) {
      print(error);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _homeBloc,
        child: Scaffold(
          body: HomeDetailState(),
        ));
  }
}

class HomeDetailState extends StatefulWidget {
  @override
  _HomeDetailStateState createState() => _HomeDetailStateState();
}

class _HomeDetailStateState extends State<HomeDetailState> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          print('state : ' + state.toString());
          if (state == null) {
            return buildLoading();
          }
          if (state is HomeErrorState) {
            print('error_messge : ' + state.errorMessage);
            return failedLoading();
          } else if (state is HomeFetchingState) {
            return buildLoading();
          } else {
            final stateAsHomeFetchedState = state as HomeFetchedState;
            final data = stateAsHomeFetchedState.data;
            return DefaultTabController(
              length: data.length,
              child: Scaffold(
                key: BlocProvider.of<HomeBloc>(context).scaffoldKey,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  leading: new IconButton(
                    icon: Image.asset(
                      "assets/img/hamburger.png",
                      scale: 2.1,
                      height: 18,
                      width: 18,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context)
                          .scaffoldKey
                          .currentState
                          .openDrawer();
                    },
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 10),
                      child: cartIcon(context, itemQuantity),
                    )
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final tab in data)
                        Tab(
                          text: tab.menuCategory,
                        ),
                    ],
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.red,
                    indicatorColor: Colors.red,
                  ),
                ),
                drawer: DrawerWidget(),
                body: TabBarView(
                  children: [
                    for (final ta in data)
                      Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                            thickness: 0.2,
                          ),
                          itemCount: ta.categoryDishes.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (quantity.length < ta.categoryDishes.length) {
                              quantity.add(0);
                            }
                            return Container(
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              ta.categoryDishes[index]
                                                      .dishAvailability
                                                  ? Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: Colors.red,
                                                    ),
                                              Expanded(
                                                child: Text(
                                                    ta.categoryDishes[index]
                                                        .dishName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 2),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 50,
                                                  child: Text(
                                                      "INR " +
                                                          ta
                                                              .categoryDishes[
                                                                  index]
                                                              .dishPrice
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Expanded(
                                                  flex: 50,
                                                  child: Text(
                                                      ta.categoryDishes[index]
                                                              .dishCalories
                                                              .toString() +
                                                          " calories",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              ta.categoryDishes[index]
                                                  .dishDescription,
                                              maxLines: 3,
                                              overflow: TextOverflow.visible,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      3.0, 1.0, 3.0, 1.0),
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  IconButton(
                                                    iconSize: 22,
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () async {
                                                      _decrementCounter(index);
                                                      if (quantity[index] > 0) {
                                                        var id = await DatabaseHelper
                                                            .instance
                                                            .update(Cart(
                                                                dishId: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishId,
                                                                itemName: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishName,
                                                                calories: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishCalories,
                                                                itemPrice: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishPrice,
                                                                quantity:
                                                                    quantity[
                                                                        index]));

                                                        setState(() {
                                                          quantity[index] =
                                                              quantity[index];
                                                        });
                                                      } else if (quantity[
                                                              index] <=
                                                          0) {
                                                        await DatabaseHelper.instance.delete(Cart(
                                                            dishId: ta
                                                                .categoryDishes[
                                                                    index]
                                                                .dishId,
                                                            itemName: ta
                                                                .categoryDishes[
                                                                    index]
                                                                .dishName,
                                                            calories: ta
                                                                .categoryDishes[
                                                                    index]
                                                                .dishCalories,
                                                            itemPrice: ta
                                                                .categoryDishes[
                                                                    index]
                                                                .dishPrice,
                                                            quantity: quantity[
                                                                index]));

                                                        setState(() {
                                                          quantity[index] =
                                                              quantity[index];
                                                          DatabaseHelper
                                                              .instance
                                                              .queryAllRows()
                                                              .then((value) {
                                                            setState(() {
                                                              itemQuantity =
                                                                  value.length;
                                                            });
                                                          }).catchError(
                                                                  (error) {
                                                            print(error);
                                                          });
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    quantity[index].toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      _incrementCounter(index);
                                                      if (quantity[index] ==
                                                          1) {
//    void _addToDb() async {

                                                        var id = await DatabaseHelper
                                                            .instance
                                                            .insert(Cart(
                                                                dishId: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishId,
                                                                itemName: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishName,
                                                                calories: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishCalories,
                                                                itemPrice: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishPrice,
                                                                quantity: 1));
                                                        DatabaseHelper.instance
                                                            .queryAllRows()
                                                            .then((value) {
                                                          setState(() {
                                                            itemQuantity =
                                                                value.length;
                                                          });
                                                        }).catchError((error) {
                                                          print(error);
                                                        });
                                                      } else if (quantity[
                                                              index] !=
                                                          1) {
                                                        var id = await DatabaseHelper
                                                            .instance
                                                            .update(Cart(
                                                                dishId: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishId,
                                                                itemName: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishName,
                                                                calories: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishCalories,
                                                                itemPrice: ta
                                                                    .categoryDishes[
                                                                        index]
                                                                    .dishPrice,
                                                                quantity:
                                                                    quantity[
                                                                        index]));

                                                        setState(() {
                                                          quantity[index] =
                                                              quantity[index];
                                                        });
                                                      }
                                                    },
                                                    iconSize: 22,
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ta.categoryDishes[index].addonCat
                                                      .length >
                                                  0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    "Customizations Available",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          ta.categoryDishes[index].dishImage,
                                          height: 80,
                                          width: 70,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                        ),
                      )
                  ],
                ),
              ),
            );
          }
        }));
  }

  void writeData() {}
}

Widget buildLoading() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.green,
    ),
  );
}

Widget failedLoading() {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {},
            child: Text("Retry",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ProductSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            color: Colors.green,
          )
        ],
      ),
    ),
  );
}

Widget cartIcon(BuildContext context, int itemQuantity) {
  return InkWell(
    onTap: () {
//      Navigator.of(context).pushReplacementNamed(
//          RouteGenerator.ROUTE_ORDER_SUMMARY);

      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return OrderSummary();
      }));
      //  Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: widget.page));
    },
    child: Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        Icon(
          Icons.shopping_cart,
          color: Colors.black54,
          size: 30,
        ),
        Container(
          child: Text(
            itemQuantity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          constraints: BoxConstraints(
              minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
        ),
      ],
    ),
  );
}

_incrementCounter(int i) {
  quantity[i]++;
  // _event.add(_counter[i]);
}

_decrementCounter(int i) {
  if (quantity[i] <= 0) {
    quantity[i] = 0;
  } else {
    quantity[i]--;
  }
  // _event.add(_counter[i]);
}
