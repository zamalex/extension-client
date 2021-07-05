import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:salon/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> items = [];

  void init()async{
    print('initiated');
    List<CartModel> fake = [
      CartModel(id:1,name: 'product name',salon: 'salon name',quantity:1,price: 10),
      CartModel(id:2,name: 'product name',salon: 'salon name',quantity:2,price: 10)
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', CartModel.encode(fake));

    String json = await prefs.getString('cart');
    items = CartModel.decode(json);
    notifyListeners();

  }

  double price = 0;

  double get  getPrice{
    double total =0;
    items.forEach((element) {
      total+=(element.price*element.quantity);
    });
    return total;
  }


  void addItem(CartModel item) async{
    var existing = items.firstWhere((element) => element.id==item.id);

    if(existing==null)
      items.add(item);
    else{
      items[items.indexWhere((element) => element.id==item.id)].quantity++;

    }
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', CartModel.encode(items));
  }

  void removeItem(CartModel item) async{

    if(items[items.indexWhere((element) => element.id==item.id)].quantity>1){
      items[items.indexWhere((element) => element.id==item.id)].quantity--;

    }
    else{
      items.removeWhere((element) => element.id==item.id);
    }

    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', CartModel.encode(items));
  }
}