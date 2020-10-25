
class Cart {

  String itemName,dishId;
  double calories,itemPrice;
  int quantity;


  Cart({this.dishId,this.itemName, this.calories, this.quantity,this.itemPrice});



  Map<String, dynamic> toMap(){
    return {
      'dish_id':this.dishId,
      'item': this.itemName,
      'calories': this.calories,
      'quantity': this.quantity,
      'price': this.itemPrice,
    };
  }
}
