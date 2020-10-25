import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/bloc/cart/cart_bloc.dart';
import 'package:machine_test/bloc/cart/cart_event.dart';
import 'package:machine_test/bloc/cart/cart_state.dart';

import 'package:machine_test/db/database_helper.dart';
import 'package:machine_test/models/cartData.dart';

class OrderSummary extends StatefulWidget {
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

List<int> qntity = List();

class _OrderSummaryState extends State<OrderSummary> {
  List<Cart> carts = <Cart>[];
  int totalQuantity = 0;
  double totalAmt = 0.0;
  bool available = true;

  @override
  void initState() {
    _updateList();

    // TODO: implement initState
    super.initState();
  }

  _updateList() {
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          carts.add(Cart(
              dishId: element['dish_id'],
              itemName: element['item'],
              itemPrice: element["price"],
              quantity: element["quantity"],
              calories: element["calories"]));
          totalQuantity = totalQuantity + element["quantity"];
          totalAmt = totalAmt + (element["quantity"] * element["price"]);
          print("item addeed ${element["quantity"]}  cartsize${carts.length}");
        });
        print("cartsize${carts.length}");
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Summary',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 80, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.all(10),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${carts.length.toString()} Dishes - ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${totalQuantity.toString()} Items",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    itemCount: carts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        available
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.radio_button_checked,
                                                color: Colors.red,
                                              ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: Text(carts[index].itemName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              overflow: TextOverflow.fade,
                                              maxLines: 2),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              3.0, 1.0, 3.0, 1.0),
                                          height: 30,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              color: Colors.green[800],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              IconButton(
                                                iconSize: 22,
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  if (carts[index].quantity <=
                                                      0) {
                                                    carts[index].quantity = 0;
                                                    await DatabaseHelper
                                                        .instance
                                                        .delete(Cart(
                                                            dishId: carts[index]
                                                                .dishId,
                                                            itemName:
                                                                carts[index]
                                                                    .itemName,
                                                            calories:
                                                                carts[index]
                                                                    .calories,
                                                            itemPrice:
                                                                carts[index]
                                                                    .itemPrice,
                                                            quantity:
                                                                carts[index]
                                                                    .quantity));
                                                    setState(() {
                                                      carts[index].quantity =
                                                          carts[index].quantity;

                                                      totalQuantity =
                                                          totalQuantity - 1;
                                                      totalAmt = totalAmt -
                                                          (carts[index]
                                                              .itemPrice);
                                                    });
                                                  } else {
                                                    carts[index].quantity--;
                                                    await DatabaseHelper
                                                        .instance
                                                        .update(Cart(
                                                            dishId: carts[index]
                                                                .dishId,
                                                            itemName:
                                                                carts[index]
                                                                    .itemName,
                                                            calories:
                                                                carts[index]
                                                                    .calories,
                                                            itemPrice:
                                                                carts[index]
                                                                    .itemPrice,
                                                            quantity:
                                                                carts[index]
                                                                    .quantity));

                                                    setState(() {
                                                      carts[index].quantity =
                                                          carts[index].quantity;
                                                      totalQuantity =
                                                          totalQuantity - 1;
                                                      totalAmt = totalAmt -
                                                          (carts[index]
                                                              .itemPrice);
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                carts[index]
                                                    .quantity
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                iconSize: 22,
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  if (carts.isNotEmpty) {
                                                    carts[index].quantity++;

                                                    await DatabaseHelper
                                                        .instance
                                                        .update(Cart(
                                                            dishId: carts[index]
                                                                .dishId,
                                                            itemName:
                                                                carts[index]
                                                                    .itemName,
                                                            calories:
                                                                carts[index]
                                                                    .calories,
                                                            itemPrice:
                                                                carts[index]
                                                                    .itemPrice,
                                                            quantity:
                                                                carts[index]
                                                                    .quantity));

                                                    setState(() {
                                                      carts[index].quantity =
                                                          carts[index].quantity;
                                                      totalQuantity =
                                                          totalQuantity + 1;
                                                      totalAmt = totalAmt +
                                                          (carts[index]
                                                              .itemPrice);
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: Text(
                                              "INR " +
                                                  _totalAmount(
                                                          carts[index].quantity,
                                                          carts[index]
                                                              .itemPrice)
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 28.0, top: 5),
                                        child: Text(
                                            "INR " +
                                                carts[index]
                                                    .itemPrice
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 28.0, top: 5),
                                        child: Text(
                                            carts[index].calories.toString() +
                                                " calories",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    primary: false,
                    shrinkWrap: false,
                  ),
                ),
                Container(
                  height: 0.3,
                  color: Colors.grey,
                ),
                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("Total Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Text(
                            "INR " + totalAmt.toStringAsFixed(2).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  DatabaseHelper.instance.clearTable();
                  carts.clear();
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Center(
                    child: Text('Place Order',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20))),
              ),
            ),
          )
        ],
      ),
    );
  }
}

_totalAmount(int quantity, double price) {
  var total = quantity * price;

  return total;
}

_incrementCounter(int i) {
  qntity[i]++;
  // _event.add(_counter[i]);
}

_decrementCounter(int i) {
  if (qntity[i] <= 0) {
    qntity[i] = 0;
  } else {
    qntity[i]--;
  }
  // _event.add(_counter[i]);
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
