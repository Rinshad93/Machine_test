


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/db/database_helper.dart';
import 'package:machine_test/models/cartData.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {


  CartBloc(): super(null) {


    print('in');
  }

  @override
  void onTransition(Transition<CartEvent, CartState> transition)  {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async*{
    yield CartFetchingState();
    List<Cart> carts =<Cart>[];
    int totalQuantity =0;
    double totalAmt;
    if (event is CartCallEvent) {
      print('inside_call_event');
      DatabaseHelper.instance.queryAllRows().then((value) {



        value.forEach((element) {
          carts.add(Cart(dishId: element['dish_id'],itemName: element['item'], itemPrice: element["price"],quantity:element["quantity"],calories: element["calories"]));
          totalQuantity = totalQuantity+ element["quantity"];
          totalAmt =totalAmt+(element["quantity"]*element["price"]);

        });
//        print("item addeed ${totalQuantity}  cartsize${totalAmt}");
        print("cartsize${carts.length}");

      }).catchError((error) {
        print(error);
      });
print("ammmmmt $totalAmt");
      yield CartFetchedState(carts:carts,totalAmount: totalAmt,totalQuantity: totalQuantity);

    }

    try { } catch (_) {
      print('inside_error');
      yield CartErrorState(errorMessage:"Catch error");
    }
  }

}